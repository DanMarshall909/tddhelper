package com.danmarshall.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.openapi.components.Service

/**
 * Service that tracks test results.
 */
@Service
class TestResultsTracker {
    private var failedTests = mutableListOf<AbstractTestProxy>()
    private var hasFailures = false
    
    /**
     * Manually update test results - can be called from external listeners
     */
    fun updateTestResults(root: AbstractTestProxy) {
        hasFailures = root.isDefect
        failedTests.clear()
        if (hasFailures) {
            failedTests.addAll(collectFailedTests(root))
        }
    }
    
    /**
     * Add a failed test to the tracker
     */
    fun addFailedTest(test: AbstractTestProxy) {
        if (test.isDefect && !failedTests.contains(test)) {
            failedTests.add(test)
            hasFailures = true
        }
    }
    
    /**
     * Clear all tracked test results
     */
    fun clearResults() {
        failedTests.clear()
        hasFailures = false
    }
    
    private fun collectFailedTests(root: AbstractTestProxy): List<AbstractTestProxy> {
        return root.getAllTests().filter { it.isDefect && !it.isInProgress }
    }
    
    fun getFailedTests(): List<AbstractTestProxy> = failedTests.toList()
    fun hasFailures(): Boolean = hasFailures
}
