package com.danmarshall.tddhelper.services

import com.intellij.execution.testframework.AbstractTestProxy
import com.intellij.openapi.components.Service
import com.intellij.openapi.application.ApplicationManager
import javax.swing.BorderFactory
import javax.swing.JFrame
import java.awt.Color

/**
 * Service that decorates the UI based on test status.
 */
@Service
class UIDecorator {
    init {
        // Subscribe to test status changes
        ApplicationManager.getApplication().messageBus
            .connect()
            .subscribe(TEST_STATUS_TOPIC, object : TestStatusChangeListener {
                override fun onTestStatusChanged(hasFailures: Boolean, failedTests: List<AbstractTestProxy>) {
                    updateTitleBar(hasFailures)
                }
            })
    }
    private fun updateTitleBar(hasFailures: Boolean) {
        val frame = ApplicationManager.getApplication().getComponent(JFrame::class.java)
        if (frame != null) {
            if (hasFailures) {
                frame.rootPane.border = BorderFactory.createLineBorder(Color.RED, 4)
            } else {
                frame.rootPane.border = null
            }
        }
    }
}
