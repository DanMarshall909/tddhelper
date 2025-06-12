package com.danmarshall.tddhelper.services

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

/**
 * Basic unit tests for TestResultsTracker
 * Note: Full integration tests with IntelliJ Platform APIs will be added in future iterations
 */
class TestResultsTrackerTest {

    private lateinit var tracker: TestResultsTracker

    @BeforeEach
    fun setUp() {
        tracker = TestResultsTracker()
    }

    @Test
    fun testInitialStateHasNoFailures() {
        assertFalse(tracker.hasFailures())
        assertTrue(tracker.getFailedTests().isEmpty())
    }

    @Test
    fun testClearResults() {
        tracker.clearResults()
        assertFalse(tracker.hasFailures())
        assertTrue(tracker.getFailedTests().isEmpty())
    }

    @Test
    fun testTrackerExistsAndCanBeInstantiated() {
        val newTracker = TestResultsTracker()
        assertNotNull(newTracker)
        assertFalse(newTracker.hasFailures())
    }
}
