# TddHelper Implementation Notes

This document provides technical implementation details for the TddHelper Rider plugin, focusing on key components, code examples, and integration points with the JetBrains Platform.

## Project Status (Updated December 2025)

### ✅ Recently Resolved Issues

1. **Java 17 Compatibility** - Fixed JVM target compatibility issues in build configuration
2. **IntelliJ Platform API Compatibility** - Resolved compilation errors with TestStatusListener API
3. **Gradle Build Configuration** - Updated to use proper IntelliJ Platform plugin structure
4. **Core Service Implementation** - Simplified TestResultsTracker for better API compatibility

### 🔧 Current Implementation State

- **Main source code**: Compiles successfully with Java 17
- **Core services**: TestResultsTracker and GotoNextFailedTestAction are functional
- **Test compilation**: Some unit test dependencies need resolution
- **Build system**: Gradle build works with `-x test` flag

### 🚧 Known Issues to Address

1. **Unit Test Dependencies** - Test compilation fails due to missing test framework imports
2. **Test Environment Setup** - IntelliJ Platform test framework integration needs refinement
3. **API Access Patterns** - Some IntelliJ Platform APIs require reflection-based access

## Project Structure (Actual)

```
com.danmarshall.tddhelper/
├── actions/
│   └── GotoNextFailedTestAction.kt              ✅ Implemented
├── services/
│   ├── TestResultsTracker.kt                    ✅ Implemented (simplified)
│   ├── TestStatusChangeListener.kt              🔧 Interface defined
│   └── UIDecorator.kt                          📝 Placeholder
└── test/
    └── services/
        └── TestResultsTrackerTest.kt            🚧 Needs dependency fixes
```

## Key Components Implementation

### 1. Test Results Tracker

The `TestResultsTracker` is a core service that monitors test execution and maintains the state of test results.

```kotlin
package com.yourname.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.execution.testframework.TestStatusListener
import com.intellij.openapi.components.Service
import com.intellij.openapi.application.ApplicationManager
import com.intellij.util.messages.Topic
import java.util.EventListener

// Custom event for test status changes
interface TestStatusChangeListener : EventListener {
    fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>)
}

// Topic for the event bus
val TEST_STATUS_TOPIC = Topic.create("TddHelper Test Status", TestStatusChangeListener::class.java)

@Service
class TestResultsTracker {
    private var failedTests = listOf<AbstractTestProxy>()
    private var hasFailures = false
    
    // MessageBus for publishing events
    private val messageBus = ApplicationManager.getApplication().messageBus
    
    init {
        // Subscribe to test events
        ApplicationManager.getApplication().messageBus
            .connect()
            .subscribe(TestStatusListener.TEST_STATUS, object : TestStatusListener {
                override fun testSuiteFinished(root: AbstractTestProxy) {
                    updateTestResults(root)
                }
            })
    }
    
    private fun updateTestResults(root: AbstractTestProxy) {
        hasFailures = root.isDefect
        failedTests = if (hasFailures) {
            collectFailedTests(root)
        } else {
            emptyList()
        }
        
        // Notify listeners
        messageBus.syncPublisher(TEST_STATUS_TOPIC).onTestStatusChanged(hasFailures, failedTests)
    }
    
    private fun collectFailedTests(root: AbstractTestProxy): List<AbstractTestProxy> {
        return root.getAllTests().filter { it.isDefect && !it.isInProgress }
    }
    
    fun getFailedTests(): List<AbstractTestProxy> = failedTests
    
    fun hasFailures(): Boolean = hasFailures
}
```

### 2. UI Decorator

The `UIDecorator` handles the visual indication of test status by modifying the IDE window border.

```kotlin
package com.yourname.tddhelper.services

import com.intellij.openapi.components.Service
import com.intellij.openapi.application.ApplicationManager
import javax.swing.BorderFactory
import javax.swing.JFrame
import java.awt.Color

@Service
class UIDecorator {
    init {
        // Subscribe to test status changes
        ApplicationManager.getApplication().messageBus
            .connect()
            .subscribe(TEST_STATUS_TOPIC, object : TestStatusChangeListener {
                override fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>) {
                    updateTitleBar(hasFailures)
                }
            })
    }
    
    private fun updateTitleBar(hasFailures: Boolean) {
        val frame = ApplicationManager.getApplication().getComponent(JFrame::class.java)
        if (frame != null) {
            if (hasFailures) {
                frame.rootPane.border = BorderFactory.createLineBorder(Color.RED, 4)
            } else {
                frame.rootPane.border = null
            }
        }
    }
}
```

### 3. Title Manager (Phase 2)

The `TitleManager` will handle displaying failed test names in the title bar.

```kotlin
package com.yourname.tddhelper.services

import com.intellij.openapi.components.Service
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.wm.WindowManager
import com.intellij.openapi.project.Project
import com.intellij.openapi.project.ProjectManager

@Service
class TitleManager {
    private val maxTestNames = 3 // Configurable in the future
    
    init {
        // Subscribe to test status changes
        ApplicationManager.getApplication().messageBus
            .connect()
            .subscribe(TEST_STATUS_TOPIC, object : TestStatusChangeListener {
                override fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>) {
                    updateTitleWithTestNames(hasFailures, failedTests)
                }
            })
    }
    
    private fun updateTitleWithTestNames(hasFailures: Boolean, failedTests: List<AbstractTestProxy>) {
        if (!hasFailures) {
            // Reset titles to default
            resetTitles()
            return
        }
        
        // Format test names for display
        val formattedNames = formatTestNames(failedTests)
        
        // Update all open project frames
        for (project in ProjectManager.getInstance().openProjects) {
            val frame = WindowManager.getInstance().getFrame(project)
            if (frame != null) {
                val currentTitle = frame.title
                val baseTitle = currentTitle.split(" - ").last() // Get project name part
                frame.title = "$formattedNames - $baseTitle"
            }
        }
    }
    
    private fun formatTestNames(failedTests: List<AbstractTestProxy>): String {
        if (failedTests.isEmpty()) return ""
        
        val displayedTests = failedTests.take(maxTestNames)
        val remaining = failedTests.size - displayedTests.size
        
        val names = displayedTests.joinToString(", ") { it.name }
        
        return if (remaining > 0) {
            "$names (+$remaining more)"
        } else {
            names
        }
    }
    
    private fun resetTitles() {
        for (project in ProjectManager.getInstance().openProjects) {
            val frame = WindowManager.getInstance().getFrame(project)
            if (frame != null) {
                // Reset to default title format
                val baseTitle = frame.title.split(" - ").last()
                frame.title = baseTitle
            }
        }
    }
}
```

### 4. Navigation Action

The `GotoNextFailedTestAction` implements navigation to failed tests.

```kotlin
package com.yourname.tddhelper.actions

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.execution.testframework.TestTreeView
import com.intellij.execution.testframework.ui.TestResultsPanel
import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.project.Project
import com.intellij.openapi.wm.ToolWindowManager
import com.yourname.tddhelper.services.TestResultsTracker
import com.intellij.openapi.application.ApplicationManager
import javax.swing.tree.TreePath

class GotoNextFailedTestAction : AnAction() {
    private var lastSelectedTestIndex = -1
    
    override fun actionPerformed(e: AnActionEvent) {
        val project = e.project ?: return
        val tracker = ApplicationManager.getApplication().getService(TestResultsTracker::class.java)
        val failedTests = tracker.getFailedTests()
        
        if (failedTests.isEmpty()) return
        
        // Find next test to select
        lastSelectedTestIndex = (lastSelectedTestIndex + 1) % failedTests.size
        val testToSelect = failedTests[lastSelectedTestIndex]
        
        // Navigate to the test
        navigateToTest(project, testToSelect)
    }
    
    override fun update(e: AnActionEvent) {
        val tracker = ApplicationManager.getApplication().getService(TestResultsTracker::class.java)
        e.presentation.isEnabled = tracker.hasFailures()
    }
    
    private fun navigateToTest(project: Project, test: AbstractTestProxy) {
        val toolWindow = ToolWindowManager.getInstance(project).getToolWindow("Unit Tests") ?: return
        
        if (!toolWindow.isVisible) {
            toolWindow.show()
        }
        
        val content = toolWindow.contentManager.selectedContent ?: return
        val component = content.component
        
        if (component is TestResultsPanel) {
            val treeView = component.treeView
            val path = treeView.getPathForTest(test) ?: return
            
            treeView.selectionPath = path
            treeView.scrollPathToVisible(path)
        }
    }
}
```

### 5. Document Listener (Phase 3)

The `DocumentChangeListener` will monitor document changes and detect idle periods.

```kotlin
package com.yourname.tddhelper.listeners

import com.intellij.openapi.editor.event.DocumentEvent
import com.intellij.openapi.editor.event.DocumentListener
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.project.Project
import java.util.Timer
import java.util.TimerTask

class DocumentChangeListener(private val project: Project) : DocumentListener {
    private var timer: Timer? = null
    private val idleTimeMs = 2000 // 2 seconds, will be configurable
    
    override fun documentChanged(event: DocumentEvent) {
        // Cancel existing timer
        timer?.cancel()
        
        // Create new timer
        timer = Timer().apply {
            schedule(object : TimerTask() {
                override fun run() {
                    // Run on UI thread
                    ApplicationManager.getApplication().invokeLater {
                        runTests()
                    }
                }
            }, idleTimeMs)
        }
    }
    
    private fun runTests() {
        // Implementation will trigger test execution
        // This will be implemented in Phase 3
    }
}
```

## Plugin Registration

The plugin is registered in `plugin.xml`:

```xml
<idea-plugin>
    <id>com.yourname.tddhelper</id>
    <name>TddHelper</name>
    <vendor>YourName</vendor>
    <description>Enhances Test-Driven Development workflows in Rider</description>

    <depends>com.intellij.modules.rider</depends>

    <extensions defaultExtensionNs="com.intellij">
        <!-- Services -->
        <applicationService serviceImplementation="com.yourname.tddhelper.services.TestResultsTracker"/>
        <applicationService serviceImplementation="com.yourname.tddhelper.services.UIDecorator"/>
        
        <!-- Phase 2 -->
        <!-- <applicationService serviceImplementation="com.yourname.tddhelper.services.TitleManager"/> -->
        
        <!-- Phase 3 -->
        <!-- <projectService serviceImplementation="com.yourname.tddhelper.services.AutoTestRunner"/> -->
        
        <!-- Phase 4 -->
        <!-- <applicationConfigurable instance="com.yourname.tddhelper.settings.TddHelperConfigurable"/> -->
    </extensions>

    <actions>
        <action id="TddHelper.GotoNextFailedTest"
                class="com.yourname.tddhelper.actions.GotoNextFailedTestAction"
                text="Go to Next Failed Test"
                description="Navigate to the next failed test">
            <add-to-group group-id="ToolsMenu" anchor="last"/>
            <!-- Default keyboard shortcut -->
            <keyboard-shortcut first-keystroke="alt F12" keymap="$default"/>
        </action>
    </actions>
</idea-plugin>
```

## Integration Points

### Test Framework Integration

The plugin integrates with Rider's test framework through:

1. `TestStatusListener` - Subscribes to test execution events
2. `AbstractTestProxy` - Represents test items and their status
3. `TestTreeView` - Provides access to the test explorer UI

### UI Integration

The plugin integrates with Rider's UI through:

1. JFrame decoration - Modifies the window border
2. Title bar manipulation - Updates the window title
3. Tool window access - Interacts with the test explorer tool window

### Document Integration (Phase 3)

The plugin will integrate with the document system through:

1. `DocumentListener` - Monitors document changes
2. `EditorFactory` - Provides access to all editors

## Testing Strategy

The plugin should be tested using:

1. **Unit Tests** - Test individual components in isolation
2. **Integration Tests** - Test interaction between components
3. **UI Tests** - Test UI modifications and interactions
4. **Manual Testing** - Verify behavior in different scenarios

## Performance Considerations

1. **Event Handling** - Use efficient event processing to avoid UI lag
2. **Test Result Processing** - Optimize for large test suites
3. **UI Updates** - Minimize UI thread operations
4. **Document Listening** - Ensure typing performance is not affected

## Future Extension Mechanisms

The plugin will support extension through:

1. **Service Interfaces** - Allow alternative implementations
2. **Event System** - Allow subscribing to plugin events
3. **Extension Points** - Define formal extension points

This implementation plan provides a solid foundation for the TddHelper plugin while allowing for future expansion and customization.
