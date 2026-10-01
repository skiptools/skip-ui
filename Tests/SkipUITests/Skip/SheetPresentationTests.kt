// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import android.graphics.Bitmap
import android.webkit.WebView
import androidx.compose.foundation.clickable
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.TextField
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.ui.test.*
import java.util.concurrent.atomic.AtomicInteger
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import androidx.activity.ComponentActivity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color as ComposeColor
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.unit.dp
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.test.platform.app.InstrumentationRegistry
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import java.io.File
import java.io.FileOutputStream

/** Retains its Compose tree during real device rotation; declared only in the test manifest. */
class SheetTestActivity : ComponentActivity()

/** Library-only coverage: no app code or measured-content sizing participates in these tests. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class SheetPresentationTests {
    @get:Rule val rule = createAndroidComposeRule<SheetTestActivity>()
    private val presented = mutableStateOf(true)
    private val detent = mutableStateOf(PresentationDetent.height(260.0))
    private var headerBounds = Rect.Zero
    private val mode = mutableStateOf("plain")
    private val query = mutableStateOf("")
    private val rowCount = mutableStateOf(4)
    private val nested = mutableStateOf(false)
    private val ticks = mutableStateOf(0)
    private val clicks = AtomicInteger()
    private val compositions = AtomicInteger()
    private val draws = AtomicInteger()
    private val dismissals = AtomicInteger()
    private var webView: WebView? = null

    @org.junit.Before fun requireInstrumentedDisplay() {
        // These tests sample compositor pixels; Robolectric cannot supply that evidence.
        org.junit.Assume.assumeFalse(android.os.Build.FINGERPRINT.contains("robolectric"))
    }

    private fun install(fullScreen: Boolean = false) {
        rule.setContent {
            MaterialTheme {
                Box(Modifier.fillMaxSize().background(ComposeColor(0xFF24344B))) {
                    Text("Sheet clipping reproduction", color = ComposeColor.White,
                        modifier = Modifier.padding(24.dp))
                    SheetPresentation(Binding(get = { presented.value }, set = { presented.value = it }),
                        fullScreen, ComposeContext(), { content }, { dismissals.incrementAndGet() })
                }
            }
        }
        rule.waitForIdle()
        assertTrue("The sheet header must be laid out", headerBounds.height > 0)
    }

    // Read the detent inside the sheet's content scope, not the presenting parent's scope.
    private val content = ComposeView { context ->
        ComposeView {
            SideEffect { compositions.incrementAndGet() }
            Column(Modifier.fillMaxSize().background(ComposeColor.White)
                .drawWithContent { draws.incrementAndGet(); drawContent() }) {
                Box(Modifier.fillMaxWidth().height(64.dp).background(ComposeColor.Green)
                    .onGloballyPositioned { headerBounds = it.boundsInWindow() }
                    .testTag("header").clickable { clicks.incrementAndGet() }) {
                    Text("HEADER MUST STAY VISIBLE", color = ComposeColor.Black,
                        modifier = Modifier.padding(start = 48.dp, top = 20.dp))
                }
                Text("Only the requested detent changes.\nGreen header = correct clipping.",
                    modifier = Modifier.padding(24.dp))
                when (mode.value) {
                    "scroll" -> Column(Modifier.weight(1f).verticalScroll(rememberScrollState()).testTag("rows")) {
                        repeat(rowCount.value) { Text("Row $it", modifier = Modifier.padding(12.dp)) }
                    }
                    "input" -> TextField(query.value, { query.value = it }, modifier = Modifier.testTag("input"))
                    "native" -> AndroidView(modifier = Modifier.weight(1f).testTag("web"), factory = { context ->
                        WebView(context).also {
                            webView = it
                            it.loadData("<html><body style='background:#ffeeaa'>Native content</body></html>", "text/html", "UTF-8")
                        }
                    })
                    "updates" -> Text("Update ${ticks.value}")
                }
                SheetPresentation(Binding(get = { nested.value }, set = { nested.value = it }),
                    false, ComposeContext(), {
                        ComposeView { Text("Nested content", modifier = Modifier.testTag("nested")) }
                            .presentationDetents(skip.lib.setOf(PresentationDetent.height(200.0)))
                    }, null)
            }
        }.presentationDetents(skip.lib.setOf(detent.value)).Compose(context)
    }

    /** Inspect actual window pixels after each clock step, not just the settled semantics tree. */
    @Test fun changingHeightKeepsHeaderVisibleEveryFrame() {
        install()
        rule.mainClock.autoAdvance = false
        checkTransitions(listOf(520.0, 260.0, 580.0, 320.0).map { PresentationDetent.height(it) })
    }

    @Test fun standardDetentsKeepHeaderVisibleEveryFrame() {
        install()
        checkTransitions(listOf(PresentationDetent.medium, PresentationDetent.large,
            PresentationDetent.fraction(0.4), PresentationDetent.fraction(0.8), PresentationDetent.height(260.0)))
    }

    @Test fun fullScreenCoverKeepsHeaderVisible() {
        install(fullScreen = true)
        checkTransitions(listOf(PresentationDetent.height(520.0), PresentationDetent.medium))
        rule.runOnIdle { presented.value = false }
        rule.mainClock.autoAdvance = true
        rule.waitForIdle()
        assertEquals(1, dismissals.get())
    }

    @Test fun boundaryTapsBackAndReopen() {
        install()
        checkTransitions(listOf(PresentationDetent.height(520.0)))
        rule.mainClock.autoAdvance = true
        rule.onNodeWithTag("header").performTouchInput { click(androidx.compose.ui.geometry.Offset(width / 2f, 4f)) }
        assertEquals(1, clicks.get())
        InstrumentationRegistry.getInstrumentation().sendKeyDownUpSync(android.view.KeyEvent.KEYCODE_BACK)
        rule.waitForIdle()
        assertFalse(presented.value)
        assertEquals(1, dismissals.get())
        rule.runOnIdle { presented.value = true }
        rule.waitForIdle()
        Thread.sleep(80)
        assertHeaderVisible("reopened")
    }

    @Test fun rotationRetainsOpenSheetAndInput() {
        mode.value = "input"
        query.value = "retained value"
        install()
        val originalActivity = rule.activity
        val originalOrientation = rule.activity.requestedOrientation
        try {
            for (orientation in listOf(android.content.pm.ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE,
                android.content.pm.ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)) {
                rule.runOnUiThread { rule.activity.requestedOrientation = orientation }
                val expected = if (orientation == android.content.pm.ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
                    android.content.res.Configuration.ORIENTATION_LANDSCAPE else android.content.res.Configuration.ORIENTATION_PORTRAIT
                rule.waitUntil(5000) { rule.activity.resources.configuration.orientation == expected }
                rule.waitForIdle()
                Thread.sleep(300)
                assertTrue(originalActivity === rule.activity)
                assertTrue(presented.value)
                rule.onNodeWithTag("input").assertTextContains("retained value")
                assertHeaderVisible("rotation-$orientation")
            }
        } finally {
            rule.runOnUiThread { rule.activity.requestedOrientation = originalOrientation }
        }
    }

    @Test fun dragDismissalAndReopen() {
        install()
        rule.onNodeWithTag("header").performTouchInput {
            swipe(center, center + androidx.compose.ui.geometry.Offset(0f, 1000f), 300)
        }
        rule.waitForIdle()
        assertFalse("Dragging down must dismiss the sheet", presented.value)
        assertEquals(1, dismissals.get())
        rule.runOnIdle { presented.value = true }
        rule.waitForIdle()
        Thread.sleep(80)
        assertHeaderVisible("drag-reopened")
    }

    @Test fun scrollAndContentGrowthDoNotClipHeader() {
        mode.value = "scroll"
        install()
        rule.runOnIdle { rowCount.value = 60 }
        checkTransitions(listOf(PresentationDetent.height(520.0), PresentationDetent.height(320.0)))
        rule.mainClock.autoAdvance = true
        rule.onNodeWithTag("rows").performTouchInput { swipeUp() }
        rule.waitForIdle()
        Thread.sleep(80)
        assertHeaderVisible("scrolled")
        assertTrue(presented.value)
    }

    @Test fun keyboardBackKeepsSheetThenDismissesIt() {
        mode.value = "input"
        // Use the expanded presentation for editing. Opt in to the separate,
        // pre-existing compact-sheet/IME investigation with compactKeyboard=true.
        if (InstrumentationRegistry.getArguments().getString("compactKeyboard") != "true") {
            detent.value = PresentationDetent.large
        }
        install()
        rule.onNodeWithTag("input").performClick().performTextInput("typed text")
        rule.waitForIdle()
        Thread.sleep(400)
        assertEquals("typed text", query.value)
        assertHeaderVisible("keyboard-shown")
        InstrumentationRegistry.getInstrumentation().sendKeyDownUpSync(android.view.KeyEvent.KEYCODE_BACK)
        rule.waitForIdle()
        assertTrue("First Back should hide the keyboard", presented.value)
        Thread.sleep(400)
        assertHeaderVisible("keyboard-hidden")
        InstrumentationRegistry.getInstrumentation().sendKeyDownUpSync(android.view.KeyEvent.KEYCODE_BACK)
        rule.waitForIdle()
        assertFalse(presented.value)
    }

    @Test fun nestedSheetDismissalPreservesParent() {
        install()
        rule.runOnIdle { nested.value = true }
        rule.onNodeWithTag("nested").assertIsDisplayed()
        InstrumentationRegistry.getInstrumentation().sendKeyDownUpSync(android.view.KeyEvent.KEYCODE_BACK)
        rule.waitForIdle()
        assertFalse(nested.value)
        assertTrue(presented.value)
        Thread.sleep(80)
        assertHeaderVisible("nested-dismissed")
    }

    @Test fun nativeWebViewSurvivesHeightChanges() {
        mode.value = "native"
        install()
        val original = webView
        assertTrue(original != null)
        checkTransitions(listOf(PresentationDetent.height(520.0), PresentationDetent.height(320.0)))
        assertTrue("Native view must retain its identity", original === webView)
        rule.mainClock.autoAdvance = true
        rule.onNodeWithTag("web").assertIsDisplayed()
        rule.runOnIdle { mode.value = "plain" }
        rule.waitForIdle()
        rule.runOnUiThread { original?.destroy() }
    }

    @Test fun repeatedUpdatesSettleWithoutRedrawLoop() {
        mode.value = "updates"
        install()
        rule.mainClock.autoAdvance = false
        repeat(30) {
            rule.runOnUiThread { ticks.value = it; detent.value = PresentationDetent.height(if (it % 2 == 0) 520.0 else 320.0) }
            rule.mainClock.advanceTimeByFrame()
        }
        rule.mainClock.autoAdvance = true
        rule.waitForIdle()
        Thread.sleep(150)
        assertHeaderVisible("updates-settled")
        val oldCompositions = compositions.get()
        val oldDraws = draws.get()
        Thread.sleep(350)
        rule.waitForIdle()
        assertEquals("No continuous recomposition after updates stop", oldCompositions, compositions.get())
        assertEquals("No continuous redraw after updates stop", oldDraws, draws.get())
    }

    private fun checkTransitions(values: kotlin.collections.List<PresentationDetent>) {
        rule.mainClock.autoAdvance = false
        for ((step, value) in values.withIndex()) {
            rule.runOnUiThread { detent.value = value }
            repeat(6) { frame ->
                rule.mainClock.advanceTimeByFrame()
                // Drawing runs outside the controlled Compose clock. Allow the display
                // to present this frame without advancing composition to the next one.
                rule.waitForIdle()
                Thread.sleep(80)
                assertHeaderVisible("detent-$step-frame-$frame")
            }
        }
    }

    /** Opt-in real-time sequence for before/after PR recordings using the same production presenter. */
    @Test fun recordDetentTransitions() {
        org.junit.Assume.assumeTrue(InstrumentationRegistry.getArguments().getString("sheetVideo") == "true")
        install()
        Thread.sleep(1500)
        rule.mainClock.autoAdvance = false
        repeat(160) { frame ->
            if (frame == 20 || frame == 60 || frame == 100 || frame == 140) {
                rule.runOnUiThread {
                    detent.value = PresentationDetent.height(if (frame == 20 || frame == 100) 560.0 else 260.0)
                }
            }
            rule.mainClock.advanceTimeByFrame()
            Thread.sleep(16)
        }
        Thread.sleep(1200)
    }

    private fun assertHeaderVisible(label: String) {
        val bounds = headerBounds
        val bitmap = InstrumentationRegistry.getInstrumentation().uiAutomation.takeScreenshot()
        val x = (bounds.left + 20).toInt().coerceIn(0, bitmap.width - 1)
        val y = (bounds.top + bounds.height / 2).toInt().coerceIn(0, bitmap.height - 1)
        val pixel = bitmap.getPixel(x, y)
        val visible = android.graphics.Color.green(pixel) > 220 &&
            android.graphics.Color.red(pixel) < 40 && android.graphics.Color.blue(pixel) < 40
        if (!visible) {
            val file = File(InstrumentationRegistry.getInstrumentation().targetContext.getExternalFilesDir(null), "$label.png")
            FileOutputStream(file).use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
        }
        bitmap.recycle()
        assertTrue("$label: header clipped at ($x,$y), bounds=$bounds, pixel=${pixel.toUInt().toString(16)}", visible)
    }
}
