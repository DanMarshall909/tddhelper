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
            // Use reflection or alternative approach to access tree view since it's protected
            try {
                val treeViewField = TestResultsPanel::class.java.getDeclaredField("myTreeView")
                treeViewField.isAccessible = true
                val treeView = treeViewField.get(component) as? TestTreeView ?: return
                
                // Find the tree path for the test
                val path = findPathForTest(treeView, test)
                if (path != null) {
                    treeView.selectionPath = path
                    treeView.scrollPathToVisible(path)
                }
            } catch (e: Exception) {
                // Fallback: just show the tool window
            }
        }
    }
    
    private fun findPathForTest(treeView: TestTreeView, targetTest: AbstractTestProxy): javax.swing.tree.TreePath? {
        val model = treeView.model
        val root = model.root as? AbstractTestProxy ?: return null
        return searchForTest(root, targetTest, javax.swing.tree.TreePath(root))
    }
    
    private fun searchForTest(node: AbstractTestProxy, target: AbstractTestProxy, currentPath: javax.swing.tree.TreePath): javax.swing.tree.TreePath? {
        if (node == target) {
            return currentPath
        }
        for (child in node.children) {
            val childPath = currentPath.pathByAddingChild(child)
            val result = searchForTest(child, target, childPath)
            if (result != null) {
                return result
            }
        }
        return null
    }
}
