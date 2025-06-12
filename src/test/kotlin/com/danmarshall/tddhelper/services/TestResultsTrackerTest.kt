package com.danmarshall.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.openapi.application.ApplicationManager
import com.intellij.testFramework.fixtures.BasePlatformTestCase
import org.mockito.kotlin.mock
import org.mockito.kotlin.whenever

class TestResultsTrackerTest : BasePlatformTestCase() {

    private lateinit var tracker: TestResultsTracker

    override fun setUp() {
        super.setUp()
        tracker = ApplicationManager.getApplication().getService(TestResultsTracker::class.java)
    }

    fun testInitialStateHasNoFailures() {
        assertFalse(tracker.hasFailures())
        assertTrue(tracker.getFailedTests().isEmpty())
    }

    fun testUpdateTestResultsWithFailedTests() {
        val failingTest = mock<AbstractTestProxy>()
        whenever(failingTest.isDefect).thenReturn(true)
        whenever(failingTest.isInProgress).thenReturn(false)
        whenever(failingTest.getAllTests()).thenReturn(listOf(failingTest))

        val root = mock<AbstractTestProxy>()
        whenever(root.isDefect).thenReturn(true)
        whenever(root.getAllTests()).thenReturn(listOf(failingTest))

        // Directly call updateTestResults since we simplified the implementation
        tracker.updateTestResults(root)

        assertTrue(tracker.hasFailures())
        assertEquals(listOf(failingTest), tracker.getFailedTests())
    }

    fun testAddFailedTest() {
        val failingTest = mock<AbstractTestProxy>()
        whenever(failingTest.isDefect).thenReturn(true)

        tracker.addFailedTest(failingTest)

        assertTrue(tracker.hasFailures())
        assertEquals(listOf(failingTest), tracker.getFailedTests())
    }

    fun testClearResults() {
        val failingTest = mock<AbstractTestProxy>()
        whenever(failingTest.isDefect).thenReturn(true)

        tracker.addFailedTest(failingTest)
        assertTrue(tracker.hasFailures())

        tracker.clearResults()
        assertFalse(tracker.hasFailures())
        assertTrue(tracker.getFailedTests().isEmpty())
    }
}
