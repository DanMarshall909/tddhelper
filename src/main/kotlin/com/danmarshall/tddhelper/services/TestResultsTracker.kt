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
ECHO is off.
    // MessageBus for publishing events
    private val messageBus = ApplicationManager.getApplication().messageBus
ECHO is off.
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
ECHO is off.
    private fun updateTestResults(root: AbstractTestProxy) {
        hasFailures = root.isDefect
        failedTests = if (hasFailures) {
            collectFailedTests(root)
        } else {
            emptyList()
        }
ECHO is off.
        // Notify listeners
        messageBus.syncPublisher(TEST_STATUS_TOPIC).onTestStatusChanged(hasFailures, failedTests)
    }
ECHO is off.
    private fun collectFailedTests(root: AbstractTestProxy): List<AbstractTestProxy> {
        return root.getAllTests().filter { it.isDefect && !it.isInProgress }
    }
ECHO is off.
    fun getFailedTests(): List<AbstractTestProxy> = failedTests
ECHO is off.
    fun hasFailures(): Boolean = hasFailures
}
