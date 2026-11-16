// Copyright 2026 Skip
package skip.ui

import androidx.compose.foundation.ScrollState
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performTouchInput
import androidx.compose.ui.test.swipe
import androidx.compose.ui.test.swipeUp
import androidx.compose.ui.unit.dp
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertSame
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

/** Exercises scroll handoff through the public boundary, including its setContent update path. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class AndroidCompositionBoundaryScrollTests {
    @get:Rule val rule = createAndroidComposeRule<SheetTestActivity>()
    private val presented = mutableStateOf(true)
    private val inputs = mutableStateOf("A")
    private lateinit var scrollState: ScrollState
    private var boundaryHost: Any? = null
    private var dismissals = 0

    private fun install(disabled: Boolean = false) {
        rule.setContent {
            MaterialTheme {
                SheetPresentation(
                    Binding(get = { presented.value }, set = { presented.value = it }),
                    false, ComposeContext(), {
                        ComposeView { context ->
                            val label = inputs.value
                            AndroidCompositionBoundary(id = "scroll-boundary", inputs = label, content = {
                                ComposeView {
                                    val state = rememberScrollState()
                                    val host = LocalView.current.parent
                                    SideEffect { scrollState = state; boundaryHost = host }
                                    Column(Modifier.fillMaxSize().verticalScroll(state).testTag("boundary-rows")) {
                                        repeat(60) { row ->
                                            Text("$label row $row", modifier = Modifier.height(48.dp))
                                        }
                                    }
                                }
                            }).Compose(context)
                        }.presentationDetents(skip.lib.setOf(PresentationDetent.large))
                            .interactiveDismissDisabled(disabled)
                    }, { dismissals++ }
                )
            }
        }
        rule.onNodeWithText("A row 0").assertIsDisplayed()
    }

    /** Start inside content, away from the sheet's drag handle. */
    private fun pullDown() {
        rule.onNodeWithTag("boundary-rows").performTouchInput {
            swipe(Offset(center.x, height * 0.15f), Offset(center.x, height * 0.9f), 350)
        }
        rule.waitForIdle()
    }

    @Test fun pullAtTopDismissesAndReopens() {
        install()
        pullDown()
        rule.runOnIdle {
            assertFalse("Unconsumed downward scrolling must reach the sheet", presented.value)
            assertEquals(1, dismissals)
            presented.value = true
        }
        rule.onNodeWithText("A row 0").assertIsDisplayed()
        pullDown()
        rule.runOnIdle { assertFalse(presented.value); assertEquals(2, dismissals) }
    }

    @Test fun updatedInputsKeepScrollHandoffAndHost() {
        install()
        val originalHost = boundaryHost
        rule.runOnIdle { inputs.value = "B" }
        rule.onNodeWithText("B row 0").assertIsDisplayed()
        rule.runOnIdle { assertSame("Updating inputs must retain the host", originalHost, boundaryHost) }
        pullDown()
        rule.runOnIdle { assertFalse(presented.value); assertEquals(1, dismissals) }
    }

    @Test fun contentConsumesScrollingBeforeReachingTop() {
        install()
        rule.onNodeWithTag("boundary-rows").performTouchInput { swipeUp() }
        var scrolled = 0
        rule.runOnIdle {
            scrolled = scrollState.value
            assertTrue("Content must scroll upward normally", scrolled > 300)
            assertTrue(presented.value)
        }
        rule.onNodeWithTag("boundary-rows").performTouchInput {
            swipe(center, center + Offset(0f, 100f), 600)
        }
        rule.runOnIdle {
            assertTrue("A downward drag must first scroll the content", scrollState.value in 1 until scrolled)
            assertTrue("Scrolling away from the top must not dismiss the sheet", presented.value)
            assertEquals(0, dismissals)
        }
    }

    @Test fun disabledDismissalStillAllowsContentScrolling() {
        install(disabled = true)
        pullDown()
        rule.runOnIdle { assertTrue(presented.value); assertEquals(0, dismissals) }
        rule.onNodeWithTag("boundary-rows").performTouchInput { swipeUp() }
        rule.runOnIdle { assertTrue(scrollState.value > 0); assertTrue(presented.value) }
    }
}
