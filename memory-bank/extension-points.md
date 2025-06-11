# TddHelper Extension Points

This document outlines the extension mechanisms that will be implemented in the TddHelper Rider plugin. These extension points will allow for customization and enhancement of the plugin's functionality.

## Extension Philosophy

The TddHelper plugin is designed with extensibility in mind, following these principles:

1. **Interface-Based Design:** All key components are defined by interfaces, allowing for alternative implementations.
2. **Service-Oriented Architecture:** Functionality is encapsulated in services that can be replaced or extended.
3. **Event-Based Communication:** Components communicate through events, allowing for observers without modifying core code.
4. **Explicit Extension Points:** Formal extension points are defined for key customization areas.

## Core Extension Points

### 1. Test Detection Strategies

**Purpose:** Define how and when tests should be automatically executed.

**Interface:**
```kotlin
interface TestDetectionStrategy {
    /**
     * Initialize the strategy with the given project.
     */
    fun initialize(project: Project)
    
    /**
     * Start monitoring for test execution triggers.
     * @param listener Callback to invoke when tests should be run
     */
    fun startMonitoring(listener: () -> Unit)
    
    /**
     * Stop monitoring.
     */
    fun stopMonitoring()
    
    /**
     * Get the display name of this strategy.
     */
    fun getDisplayName(): String
    
    /**
     * Get the settings component for this strategy, if any.
     */
    fun getSettingsComponent(): JComponent?
}
```

**Default Implementation:** `IdleTimeDetectionStrategy`

**Extension Registration:**
```kotlin
// In plugin.xml
<extensions defaultExtensionNs="com.yourname.tddhelper">
    <testDetectionStrategy implementation="com.example.CustomDetectionStrategy"/>
</extensions>

// In plugin code
val EP_TEST_DETECTION_STRATEGY = ExtensionPointName.create<TestDetectionStrategy>(
    "com.yourname.tddhelper.testDetectionStrategy"
)
```

**Usage Example:**
```kotlin
// Getting all registered strategies
val strategies = EP_TEST_DETECTION_STRATEGY.extensions.toList()

// Using a specific strategy
val strategy = strategies.first { it.getDisplayName() == "Idle Time Detection" }
strategy.initialize(project)
strategy.startMonitoring { 
    // Run tests
}
```

### 2. UI Notification Methods

**Purpose:** Define how test status is visually indicated to the user.

**Interface:**
```kotlin
interface UINotificationService {
    /**
     * Initialize the notification service.
     */
    fun initialize()
    
    /**
     * Update the UI based on test status.
     * @param hasFailures Whether any tests have failed
     * @param failedTests List of failed tests
     */
    fun updateUI(hasFailures: Boolean, failedTests: List<AbstractTestProxy>)
    
    /**
     * Clean up any UI modifications when the plugin is unloaded.
     */
    fun cleanup()
    
    /**
     * Get the display name of this notification service.
     */
    fun getDisplayName(): String
    
    /**
     * Get the settings component for this service, if any.
     */
    fun getSettingsComponent(): JComponent?
}
```

**Default Implementations:** 
- `TitleBarDecorator` - Changes the title bar/window border color
- `TestNameDisplayService` - Shows failed test names in the title bar

**Extension Registration:**
```kotlin
// In plugin.xml
<extensions defaultExtensionNs="com.yourname.tddhelper">
    <uiNotificationService implementation="com.example.CustomNotificationService"/>
</extensions>

// In plugin code
val EP_UI_NOTIFICATION_SERVICE = ExtensionPointName.create<UINotificationService>(
    "com.yourname.tddhelper.uiNotificationService"
)
```

**Usage Example:**
```kotlin
// Notifying all registered services
EP_UI_NOTIFICATION_SERVICE.extensions.forEach { service ->
    service.updateUI(hasFailures, failedTests)
}
```

### 3. Test Result Processors

**Purpose:** Process and transform test results before they are used by other components.

**Interface:**
```kotlin
interface TestResultProcessor {
    /**
     * Process test results.
     * @param root The root test proxy containing all test results
     * @return Processed test results
     */
    fun processResults(root: AbstractTestProxy): ProcessedTestResults
    
    /**
     * Get the priority of this processor. Higher priority processors run first.
     */
    fun getPriority(): Int
    
    /**
     * Get the display name of this processor.
     */
    fun getDisplayName(): String
}

/**
 * Processed test results.
 */
data class ProcessedTestResults(
    val hasFailures: Boolean,
    val failedTests: List<AbstractTestProxy>,
    val metadata: Map<String, Any> = emptyMap()
)
```

**Default Implementation:** `DefaultTestResultProcessor`

**Extension Registration:**
```kotlin
// In plugin.xml
<extensions defaultExtensionNs="com.yourname.tddhelper">
    <testResultProcessor implementation="com.example.CustomTestResultProcessor"/>
</extensions>

// In plugin code
val EP_TEST_RESULT_PROCESSOR = ExtensionPointName.create<TestResultProcessor>(
    "com.yourname.tddhelper.testResultProcessor"
)
```

**Usage Example:**
```kotlin
// Processing results through all registered processors in priority order
val processors = EP_TEST_RESULT_PROCESSOR.extensions.sortedByDescending { it.getPriority() }
var results = ProcessedTestResults(root.isDefect, emptyList())

for (processor in processors) {
    results = processor.processResults(root)
}

// Use the processed results
updateUI(results.hasFailures, results.failedTests)
```

### 4. Navigation Strategies

**Purpose:** Define how navigation to failed tests is performed.

**Interface:**
```kotlin
interface NavigationStrategy {
    /**
     * Navigate to a specific test.
     * @param project The current project
     * @param test The test to navigate to
     * @return True if navigation was successful
     */
    fun navigateToTest(project: Project, test: AbstractTestProxy): Boolean
    
    /**
     * Get the display name of this strategy.
     */
    fun getDisplayName(): String
}
```

**Default Implementation:** `TestExplorerNavigationStrategy`

**Extension Registration:**
```kotlin
// In plugin.xml
<extensions defaultExtensionNs="com.yourname.tddhelper">
    <navigationStrategy implementation="com.example.CustomNavigationStrategy"/>
</extensions>

// In plugin code
val EP_NAVIGATION_STRATEGY = ExtensionPointName.create<NavigationStrategy>(
    "com.yourname.tddhelper.navigationStrategy"
)
```

**Usage Example:**
```kotlin
// Finding a strategy that can navigate to the test
val strategies = EP_NAVIGATION_STRATEGY.extensions.toList()
for (strategy in strategies) {
    if (strategy.navigateToTest(project, test)) {
        break
    }
}
```

## Service Extension

In addition to formal extension points, the plugin uses a service-based architecture that allows for extension through service replacement.

### Service Registration

```kotlin
// In plugin.xml
<extensions defaultExtensionNs="com.intellij">
    <applicationService serviceInterface="com.yourname.tddhelper.services.TestResultsTracker"
                        serviceImplementation="com.example.CustomTestResultsTracker"/>
</extensions>
```

### Service Retrieval

```kotlin
// Getting the service (will return the custom implementation if registered)
val tracker = ApplicationManager.getApplication().getService(TestResultsTracker::class.java)
```

## Event-Based Extension

The plugin uses an event system that allows components to observe and react to changes without modifying core code.

### Event Topics

```kotlin
// Test status change event
interface TestStatusChangeListener : EventListener {
    fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>)
}

val TEST_STATUS_TOPIC = Topic.create("TddHelper Test Status", TestStatusChangeListener::class.java)
```

### Event Subscription

```kotlin
// Subscribing to events
ApplicationManager.getApplication().messageBus
    .connect()
    .subscribe(TEST_STATUS_TOPIC, object : TestStatusChangeListener {
        override fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>) {
            // Custom handling of test status changes
        }
    })
```

## Creating Custom Extensions

### Step 1: Implement the Extension Interface

```kotlin
class CustomNotificationService : UINotificationService {
    override fun initialize() {
        // Custom initialization
    }
    
    override fun updateUI(hasFailures: Boolean, failedTests: List<AbstractTestProxy>) {
        // Custom UI update logic
    }
    
    override fun cleanup() {
        // Custom cleanup
    }
    
    override fun getDisplayName(): String = "Custom Notification"
    
    override fun getSettingsComponent(): JComponent? = null
}
```

### Step 2: Register the Extension

```xml
<!-- In plugin.xml of your extension plugin -->
<idea-plugin>
    <id>com.example.tddhelper.extension</id>
    <name>TddHelper Extension</name>
    
    <depends>com.yourname.tddhelper</depends>
    
    <extensions defaultExtensionNs="com.yourname.tddhelper">
        <uiNotificationService implementation="com.example.CustomNotificationService"/>
    </extensions>
</idea-plugin>
```

### Step 3: Package and Distribute

Package your extension as a separate plugin that depends on the TddHelper plugin.

## Extension Best Practices

1. **Follow Interface Contracts:** Adhere to the documented behavior of interfaces.
2. **Handle Errors Gracefully:** Don't let exceptions in your extension affect the core plugin.
3. **Respect Performance:** Be mindful of performance impact, especially for frequently called methods.
4. **Clean Up Resources:** Properly dispose of resources in cleanup methods.
5. **Provide User Settings:** If your extension has configurable behavior, provide a settings component.

## Future Extension Points

As the plugin evolves, additional extension points may be added:

1. **Test Execution Strategies:** Different ways to execute tests
2. **Test Selection Strategies:** Different ways to select which tests to run
3. **Test Result Visualization:** Different ways to visualize test results
4. **Integration Points:** Integration with other tools and plugins

## Extension Point Stability

Extension points will follow semantic versioning:

- **Stable:** Interface will not change in incompatible ways within the same major version
- **Experimental:** Interface may change in minor versions
- **Internal:** Not intended for extension, may change at any time

Each extension point will be clearly marked with its stability level in the documentation.

This extension system provides a flexible framework for customizing and enhancing the TddHelper plugin to meet specific needs and workflows.
