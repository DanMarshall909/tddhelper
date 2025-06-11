package com.danmarshall.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.util.messages.Topic
import java.util.EventListener

/**
 * Listener for test status changes.
 */
interface TestStatusChangeListener : EventListener {
    /**
     * Called when test status changes.
     * @param hasFailures Whether any tests have failed
     * @param failedTests List of failed tests
     */
    fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>)
}

/**
 * Topic for the event bus.
 */
val TEST_STATUS_TOPIC = Topic.create("TddHelper Test Status", TestStatusChangeListener::class.java)
