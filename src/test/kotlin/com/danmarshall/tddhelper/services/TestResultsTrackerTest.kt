package com.danmarshall.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.execution.testframework.TestStatusListener
import com.intellij.openapi.application.ApplicationManager
import com.intellij.testFramework.fixtures.BasePlatformTestCase
import org.mockito.Mockito.*

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
        val failingTest = mock(AbstractTestProxy::class.java)
        `when`(failingTest.isDefect).thenReturn(true)
        `when`(failingTest.isInProgress).thenReturn(false)
        `when`(failingTest.getAllTests()).thenReturn(listOf(failingTest))

        val root = mock(AbstractTestProxy::class.java)
        `when`(root.isDefect).thenReturn(true)
        `when`(root.getAllTests()).thenReturn(listOf(failingTest))

        myFixture.project.messageBus.syncPublisher(TestStatusListener.TEST_STATUS).testSuiteFinished(root)

        assertTrue(tracker.hasFailures())
        assertEquals(listOf(failingTest), tracker.getFailedTests())
    }
}
