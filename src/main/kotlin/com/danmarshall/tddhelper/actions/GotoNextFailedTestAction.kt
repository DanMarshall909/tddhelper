package com.danmarshall.tddhelper.actions

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.execution.testframework.TestTreeView
import com.intellij.execution.testframework.ui.TestResultsPanel
import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.project.Project
import com.intellij.openapi.wm.ToolWindowManager
import com.danmarshall.tddhelper.services.TestResultsTracker
import com.intellij.openapi.application.ApplicationManager

/**
 * Action to navigate to the next failed test.
 */
class GotoNextFailedTestAction : AnAction() {
    private var lastSelectedTestIndex = -1
ECHO is off.
    override fun actionPerformed(e: AnActionEvent) {
        val project = e.project ?: return
        val tracker = ApplicationManager.getApplication().getService(TestResultsTracker::class.java)
        val failedTests = tracker.getFailedTests()
ECHO is off.
        if (failedTests.isEmpty()) return
ECHO is off.
        // Find next test to select
        lastSelectedTestIndex = (lastSelectedTestIndex + 1) % failedTests.size
        val testToSelect = failedTests[lastSelectedTestIndex]
ECHO is off.
        // Navigate to the test
        navigateToTest(project, testToSelect)
    }
ECHO is off.
    override fun update(e: AnActionEvent) {
        val tracker = ApplicationManager.getApplication().getService(TestResultsTracker::class.java)
        e.presentation.isEnabled = tracker.hasFailures()
    }
ECHO is off.
    private fun navigateToTest(project: Project, test: AbstractTestProxy) {
        val toolWindow = ToolWindowManager.getInstance(project).getToolWindow("Unit Tests") ?: return
ECHO is off.
        if (!toolWindow.isVisible) {
            toolWindow.show()
        }
ECHO is off.
        val content = toolWindow.contentManager.selectedContent ?: return
        val component = content.component
ECHO is off.
        if (component is TestResultsPanel) {
            val treeView = component.treeView
            val path = treeView.getPathForTest(test) ?: return
ECHO is off.
            treeView.selectionPath = path
            treeView.scrollPathToVisible(path)
        }
    }
}
