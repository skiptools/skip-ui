// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.performTouchInput
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Exercise the public gesture callbacks with motion delivered only in ACTION_UP. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class DragReleaseTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @Test fun regularReleaseIncludesLastPosition() = release(simultaneous = false, minimumDistance = 0.0)
    @Test fun simultaneousReleaseIncludesLastPosition() = release(simultaneous = true, minimumDistance = 0.0)
    @Test fun regularReleaseAfterSlop() = release(simultaneous = false, minimumDistance = 10.0)
    @Test fun simultaneousReleaseAfterSlop() = release(simultaneous = true, minimumDistance = 10.0)
    @Test fun regularCancellationKeepsLastPosition() = cancellation(simultaneous = false)
    @Test fun simultaneousCancellationKeepsLastPosition() = cancellation(simultaneous = true)
    @Test fun regularUnacceptedGestureDoesNotEnd() = unaccepted(simultaneous = false)
    @Test fun simultaneousGlobalReleaseIncludesLastPosition() = release(simultaneous = true, minimumDistance = 0.0, global = true)

    @Test fun simultaneousUnacceptedGestureCancelsDetector() {
        var changes = 0
        var ends = 0
        var cancellations = 0
        rule.setContent {
            Box(Modifier.size(240.dp, 160.dp).testTag("drag-release").pointerInput(Unit) {
                detectSimultaneousDragGestures(onDrag = { _, _ -> changes++ },
                    onDragEnd = { ends++ }, onDragCancel = { cancellations++ },
                    shouldAwaitTouchSlop = { true })
            })
        }
        rule.onNodeWithTag("drag-release").performTouchInput {
            down(Offset(20f, 30f))
            up()
        }
        rule.runOnIdle {
            assertEquals(0, changes)
            assertEquals(0, ends)
            assertEquals(1, cancellations)
        }
    }

    private fun host(simultaneous: Boolean, minimumDistance: Double,
                     changes: MutableList<DragGesture.Value>, ends: MutableList<DragGesture.Value>, global: Boolean = false): FloatArray {
        val density = floatArrayOf(1f)
        rule.setContent {
            density[0] = LocalDensity.current.density
            val gesture = DragGesture(minimumDistance = minimumDistance, coordinateSpace = if (global) GlobalCoordinateSpace.global else LocalCoordinateSpace.local)
                .onChanged { changes.add(it) }.onEnded { ends.add(it) }
            val view = Color.red.frame(width = 240.0, height = 160.0)
            val target = if (simultaneous) view.simultaneousGesture(gesture, isEnabled = true)
                         else view.gesture(gesture, isEnabled = true)
            Box(Modifier.padding(12.dp)) {
                target.accessibilityIdentifier("drag-release").Compose()
            }
        }
        return density
    }

    private fun release(simultaneous: Boolean, minimumDistance: Double, global: Boolean = false) {
        val changes = mutableListOf<DragGesture.Value>()
        val ends = mutableListOf<DragGesture.Value>()
        val density = host(simultaneous, minimumDistance, changes, ends, global)
        val bounds = rule.onNodeWithTag("drag-release").fetchSemanticsNode().boundsInRoot
        val origin = if (global) bounds.topLeft else Offset.Zero
        repeat(2) { iteration ->
            rule.onNodeWithTag("drag-release").performTouchInput {
                down(Offset(20f, 30f))
                moveTo(Offset(100f, 50f))
                // updatePointerTo changes the UP position without sending another MOVE.
                updatePointerTo(0, Offset(180f, 90f))
                up()
            }
            rule.runOnIdle {
                assertEquals("Complete exactly once per gesture", iteration + 1, ends.size)
                val end = ends.last()
                val move = changes.last()
                assertEquals((origin.x + 100.0) / density[0], move.location.x, 0.01)
                assertEquals((origin.x + 180.0) / density[0], end.location.x, 0.01)
                assertEquals((origin.y + 90.0) / density[0], end.location.y, 0.01)
                assertEquals(move.translation.width + 80.0 / density[0], end.translation.width, 0.01)
                assertEquals(move.translation.height + 40.0 / density[0], end.translation.height, 0.01)
                assertEquals(move.startLocation.x, end.startLocation.x, 0.01)
                assertEquals(move.startLocation.y, end.startLocation.y, 0.01)
                if (minimumDistance == 0.0) {
                    assertEquals(160.0 / density[0], end.translation.width, 0.01)
                }
            }
        }
    }

    private fun cancellation(simultaneous: Boolean) {
        val changes = mutableListOf<DragGesture.Value>()
        val ends = mutableListOf<DragGesture.Value>()
        host(simultaneous, 0.0, changes, ends)
        rule.onNodeWithTag("drag-release").performTouchInput {
            down(Offset(20f, 30f))
            moveTo(Offset(100f, 50f))
            cancel()
        }
        rule.runOnIdle {
            // SkipUI already completes accepted cancelled drags with their last known value.
            assertEquals(1, ends.size)
            assertEquals(changes.last().location.x, ends.single().location.x, 0.01)
            assertEquals(changes.last().translation.width, ends.single().translation.width, 0.01)
        }
    }

    private fun unaccepted(simultaneous: Boolean) {
        val changes = mutableListOf<DragGesture.Value>()
        val ends = mutableListOf<DragGesture.Value>()
        host(simultaneous, 10.0, changes, ends)
        rule.onNodeWithTag("drag-release").performTouchInput {
            down(Offset(20f, 30f))
            up()
        }
        rule.runOnIdle {
            assertTrue(changes.isEmpty())
            assertTrue(ends.isEmpty())
        }
    }
}
