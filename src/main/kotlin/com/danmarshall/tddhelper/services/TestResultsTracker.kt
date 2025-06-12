package com.danmarshall.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.execution.testframework.TestStatusListener
import com.intellij.openapi.components.Service
import com.intellij.openapi.application.ApplicationManager

/**
 * Service that tracks test results.
 */
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
