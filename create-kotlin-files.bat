@echo off
REM Create Kotlin source files for TddHelper plugin

REM Create TestStatusChangeListener and Topic
echo Creating TestStatusChangeListener.kt
(
echo package com.danmarshall.tddhelper.services
echo.
echo import com.intellij.execution.testframework.AbstractTestProxy
echo import com.intellij.util.messages.Topic
echo import java.util.EventListener
echo.
echo /**
echo  * Listener for test status changes.
echo  */
echo interface TestStatusChangeListener : EventListener {
echo     /**
echo      * Called when test status changes.
echo      * @param hasFailures Whether any tests have failed
echo      * @param failedTests List of failed tests
echo      */
echo     fun onTestStatusChanged^(hasFailures: Boolean, failedTests: List^<AbstractTestProxy^>^)
echo }
echo.
echo /**
echo  * Topic for the event bus.
echo  */
echo val TEST_STATUS_TOPIC = Topic.create^("TddHelper Test Status", TestStatusChangeListener::class.java^)
) > src\main\kotlin\com\danmarshall\tddhelper\services\TestStatusChangeListener.kt

REM Create TestResultsTracker service
echo Creating TestResultsTracker.kt
(
echo package com.danmarshall.tddhelper.services
echo.
echo import com.intellij.execution.testframework.AbstractTestProxy
echo import com.intellij.execution.testframework.TestStatusListener
echo import com.intellij.openapi.components.Service
echo import com.intellij.openapi.application.ApplicationManager
echo.
echo /**
echo  * Service that tracks test results.
echo  */
echo @Service
echo class TestResultsTracker {
echo     private var failedTests = listOf^<AbstractTestProxy^>^(^)
echo     private var hasFailures = false
echo     
echo     // MessageBus for publishing events
echo     private val messageBus = ApplicationManager.getApplication^(^).messageBus
echo     
echo     init {
echo         // Subscribe to test events
echo         ApplicationManager.getApplication^(^).messageBus
echo             .connect^(^)
echo             .subscribe^(TestStatusListener.TEST_STATUS, object : TestStatusListener {
echo                 override fun testSuiteFinished^(root: AbstractTestProxy^) {
echo                     updateTestResults^(root^)
echo                 }
echo             }^)
echo     }
echo     
echo     private fun updateTestResults^(root: AbstractTestProxy^) {
echo         hasFailures = root.isDefect
echo         failedTests = if ^(hasFailures^) {
echo             collectFailedTests^(root^)
echo         } else {
echo             emptyList^(^)
echo         }
echo         
echo         // Notify listeners
echo         messageBus.syncPublisher^(TEST_STATUS_TOPIC^).onTestStatusChanged^(hasFailures, failedTests^)
echo     }
echo     
echo     private fun collectFailedTests^(root: AbstractTestProxy^): List^<AbstractTestProxy^> {
echo         return root.getAllTests^(^).filter { it.isDefect ^&^& !it.isInProgress }
echo     }
echo     
echo     fun getFailedTests^(^): List^<AbstractTestProxy^> = failedTests
echo     
echo     fun hasFailures^(^): Boolean = hasFailures
echo }
) > src\main\kotlin\com\danmarshall\tddhelper\services\TestResultsTracker.kt

REM Create UIDecorator service
echo Creating UIDecorator.kt
(
echo package com.danmarshall.tddhelper.services
echo.
echo import com.intellij.execution.testframework.AbstractTestProxy
echo import com.intellij.openapi.components.Service
echo import com.intellij.openapi.application.ApplicationManager
echo import javax.swing.BorderFactory
echo import javax.swing.JFrame
echo import java.awt.Color
echo.
echo /**
echo  * Service that decorates the UI based on test status.
echo  */
echo @Service
echo class UIDecorator {
echo     init {
echo         // Subscribe to test status changes
echo         ApplicationManager.getApplication^(^).messageBus
echo             .connect^(^)
echo             .subscribe^(TEST_STATUS_TOPIC, object : TestStatusChangeListener {
echo                 override fun onTestStatusChanged^(hasFailures: Boolean, failedTests: List^<AbstractTestProxy^>^) {
echo                     updateTitleBar^(hasFailures^)
echo                 }
echo             }^)
echo     }
echo     
echo     private fun updateTitleBar^(hasFailures: Boolean^) {
echo         val frame = ApplicationManager.getApplication^(^).getComponent^(JFrame::class.java^)
echo         if ^(frame != null^) {
echo             if ^(hasFailures^) {
echo                 frame.rootPane.border = BorderFactory.createLineBorder^(Color.RED, 4^)
echo             } else {
echo                 frame.rootPane.border = null
echo             }
echo         }
echo     }
echo }
) > src\main\kotlin\com\danmarshall\tddhelper\services\UIDecorator.kt

REM Create GotoNextFailedTestAction
echo Creating GotoNextFailedTestAction.kt
(
echo package com.danmarshall.tddhelper.actions
echo.
echo import com.intellij.execution.testframework.AbstractTestProxy
echo import com.intellij.execution.testframework.TestTreeView
echo import com.intellij.execution.testframework.ui.TestResultsPanel
echo import com.intellij.openapi.actionSystem.AnAction
echo import com.intellij.openapi.actionSystem.AnActionEvent
echo import com.intellij.openapi.project.Project
echo import com.intellij.openapi.wm.ToolWindowManager
echo import com.danmarshall.tddhelper.services.TestResultsTracker
echo import com.intellij.openapi.application.ApplicationManager
echo.
echo /**
echo  * Action to navigate to the next failed test.
echo  */
echo class GotoNextFailedTestAction : AnAction^(^) {
echo     private var lastSelectedTestIndex = -1
echo     
echo     override fun actionPerformed^(e: AnActionEvent^) {
echo         val project = e.project ?: return
echo         val tracker = ApplicationManager.getApplication^(^).getService^(TestResultsTracker::class.java^)
echo         val failedTests = tracker.getFailedTests^(^)
echo         
echo         if ^(failedTests.isEmpty^(^)^) return
echo         
echo         // Find next test to select
echo         lastSelectedTestIndex = ^(lastSelectedTestIndex + 1^) %% failedTests.size
echo         val testToSelect = failedTests[lastSelectedTestIndex]
echo         
echo         // Navigate to the test
echo         navigateToTest^(project, testToSelect^)
echo     }
echo     
echo     override fun update^(e: AnActionEvent^) {
echo         val tracker = ApplicationManager.getApplication^(^).getService^(TestResultsTracker::class.java^)
echo         e.presentation.isEnabled = tracker.hasFailures^(^)
echo     }
echo     
echo     private fun navigateToTest^(project: Project, test: AbstractTestProxy^) {
echo         val toolWindow = ToolWindowManager.getInstance^(project^).getToolWindow^("Unit Tests"^) ?: return
echo         
echo         if ^(!toolWindow.isVisible^) {
echo             toolWindow.show^(^)
echo         }
echo         
echo         val content = toolWindow.contentManager.selectedContent ?: return
echo         val component = content.component
echo         
echo         if ^(component is TestResultsPanel^) {
echo             val treeView = component.treeView
echo             val path = treeView.getPathForTest^(test^) ?: return
echo             
echo             treeView.selectionPath = path
echo             treeView.scrollPathToVisible^(path^)
echo         }
echo     }
echo }
) > src\main\kotlin\com\danmarshall\tddhelper\actions\GotoNextFailedTestAction.kt

echo Kotlin source files created successfully!
