// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.requiredSize
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import skip.lib.CGRect
import skip.lib.CGSize

/** Real snapshot/Compose tests: equal results must avoid work without hiding required updates. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class GeometryReaderTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @Test fun sizeOnlyReaderSkipsTranslationButObservesResize() {
        val state = geometry()
        val proxy = GeometryProxy(state, Density(2f))
        val probe = Probe()
        rule.setContent { ReadGeometry({ proxy.bridgedSize }, probe) }
        rule.runOnIdle {
            assertEquals(50.0, proxy.size.width, 0.0)
            probe.mark()
            state.update(IntSize(100, 200), Rect(20f, 30f, 120f, 230f))
        }
        rule.runOnIdle { probe.assertSkipped(); state.update(IntSize(120, 240), Rect(20f, 30f, 140f, 270f)) }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(60.0, proxy.size.width, 0.0); assertEquals(120.0, proxy.size.height, 0.0) }
    }

    @Test fun globalFrameReaderObservesMovementAndClipping() {
        val state = geometry()
        val proxy = GeometryProxy(state, Density(2f))
        val probe = Probe()
        rule.setContent { ReadGeometry({ proxy.frame(GlobalCoordinateSpace()) }, probe) }
        rule.runOnIdle { probe.mark(); state.update(IntSize(100, 200), Rect(20f, 30f, 120f, 130f)) }
        rule.runOnIdle {
            probe.assertUpdated()
            val frame = proxy.frame(GlobalCoordinateSpace())
            assertEquals(10.0, frame.origin.x, 0.0)
            assertEquals(15.0, frame.origin.y, 0.0)
            assertEquals(50.0, frame.size.height, 0.0)
            assertEquals("Measured size is independent of clipped global bounds", 100.0, proxy.size.height, 0.0)
        }
    }

    @Test fun localFrameReaderSkipsMovementButObservesResize() {
        val state = geometry()
        val proxy = GeometryProxy(state, Density(1f))
        val probe = Probe()
        rule.setContent { ReadGeometry({ proxy.frame(LocalCoordinateSpace()) }, probe) }
        rule.runOnIdle { probe.mark(); state.update(IntSize(100, 200), Rect(20f, 30f, 120f, 230f)) }
        rule.runOnIdle { probe.assertSkipped(); state.update(IntSize(100, 250), Rect(20f, 30f, 120f, 280f)) }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(0.0, proxy.frame(LocalCoordinateSpace()).origin.y, 0.0); assertEquals(250.0, proxy.frame(LocalCoordinateSpace()).size.height, 0.0) }
    }

    @Test fun insetReaderSkipsTranslationButObservesEveryInsetAndRemoval() {
        val state = geometry()
        state.updateSafeArea(area())
        val proxy = GeometryProxy(state, Density(2f))
        val probe = Probe()
        rule.setContent { ReadGeometry({ proxy.bridgedSafeAreaInsets }, probe) }
        rule.runOnIdle { probe.mark(); state.updateSafeArea(area(y = 40f)) }
        rule.runOnIdle { probe.assertSkipped(); state.updateSafeArea(area(y = 40f, top = 12f, left = 6f, bottom = 24f, right = 8f)) }
        rule.runOnIdle {
            probe.assertUpdated()
            val insets = proxy.safeAreaInsets
            assertEquals(6.0, insets.top, 0.0); assertEquals(3.0, insets.leading, 0.0)
            assertEquals(12.0, insets.bottom, 0.0); assertEquals(4.0, insets.trailing, 0.0)
            probe.mark(); state.updateSafeArea(null)
        }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(0.0, proxy.safeAreaInsets.bottom, 0.0) }
    }

    @Test fun sizeReaderDoesNotSubscribeToInsets() {
        val state = geometry()
        val proxy = GeometryProxy(state, Density(1f))
        val probe = Probe()
        rule.setContent { ReadGeometry({ proxy.bridgedSize }, probe) }
        rule.runOnIdle { probe.mark(); state.updateSafeArea(area(bottom = 80f)) }
        rule.runOnIdle { probe.assertSkipped(); assertEquals(80.0, proxy.safeAreaInsets.bottom, 0.0) }
    }

    @Test fun conditionalGlobalReadCanBeAddedAndRemoved() {
        val state = geometry()
        val proxy = GeometryProxy(state, Density(1f))
        val global = mutableStateOf(false)
        val probe = Probe()
        rule.setContent { ReadGeometry({ if (global.value) proxy.frame(GlobalCoordinateSpace()) else proxy.size }, probe) }
        rule.runOnIdle { global.value = true }
        rule.runOnIdle { probe.mark(); state.update(IntSize(100, 200), Rect(0f, 10f, 100f, 210f)) }
        rule.runOnIdle { probe.assertUpdated(); global.value = false }
        rule.runOnIdle { probe.mark(); state.update(IntSize(100, 200), Rect(0f, 20f, 100f, 220f)) }
        rule.runOnIdle { probe.assertSkipped() }
    }

    @Test fun zeroSizeIsAValidFirstLayoutAndPositionedFlagDoesNotTrackMotion() {
        val state = GeometryReaderState()
        val probe = Probe()
        rule.setContent { ReadGeometry({ state.isPositioned }, probe) }
        rule.runOnIdle { assertEquals(false, probe.value); probe.mark(); state.update(IntSize.Zero, Rect.Zero) }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(true, probe.value); probe.mark(); state.update(IntSize(100, 200), Rect(0f, 10f, 100f, 210f)) }
        rule.runOnIdle { probe.assertSkipped() }
    }

    @Test fun fixedProxyUsedByGeometryChangeKeepsSnapshotBehavior() {
        val proxy = GeometryProxy(Rect(10f, 20f, 110f, 220f), Density(2f), area())
        assertEquals(50.0, proxy.size.width, 0.0)
        assertEquals(100.0, proxy.size.height, 0.0)
        assertEquals(5.0, proxy.frame(GlobalCoordinateSpace()).origin.x, 0.0)
        assertEquals(10.0, proxy.safeAreaInsets.bottom, 0.0)
    }

    /** Moving the actual layout node must not rerun a size-only content factory. */
    @Test fun actualReaderSkipsPositionOnlyLayoutChanges() {
        val y = mutableStateOf(0)
        val probe = Probe()
        val reader = GeometryReader { proxy -> probe.record(proxy.bridgedSize); EmptyView() }
        rule.setContent {
            Box(Modifier.size(300.dp)) {
                reader.Render(ComposeContext(modifier = Modifier.offset { IntOffset(0, y.value) }.size(100.dp)))
            }
        }
        rule.runOnIdle { probe.mark(); y.value = 20 }
        rule.runOnIdle { probe.assertSkipped(); y.value = 40 }
        rule.runOnIdle { probe.assertSkipped() }
    }

    @Test fun actualReaderGlobalContentFollowsMovement() {
        val y = mutableStateOf(0)
        val probe = Probe()
        val reader = GeometryReader { proxy -> probe.record(proxy.frame(GlobalCoordinateSpace())); EmptyView() }
        rule.setContent {
            CompositionLocalProvider(LocalDensity provides Density(1f)) {
                Box(Modifier.size(300.dp)) {
                    reader.Render(ComposeContext(modifier = Modifier.offset { IntOffset(0, y.value) }.size(100.dp)))
                }
            }
        }
        var initialY = 0.0
        rule.runOnIdle { initialY = (probe.value as CGRect).origin.y; probe.mark(); y.value = 20 }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(initialY + 20.0, (probe.value as CGRect).origin.y, 0.0) }
    }

    @Test fun actualReaderUsesMeasuredSizeUnderClippingAndUpdatesDensity() {
        val density = mutableStateOf(1f)
        val probe = Probe()
        val reader = GeometryReader { proxy -> probe.record(proxy.size); EmptyView() }
        rule.setContent {
            CompositionLocalProvider(LocalDensity provides Density(density.value)) {
                Box(Modifier.size(50.dp).clipToBounds()) {
                    reader.Render(ComposeContext(modifier = Modifier.requiredSize(100.dp)))
                }
            }
        }
        rule.runOnIdle { assertEquals(100.0, (probe.value as CGSize).width, 0.0); probe.mark(); density.value = 2f }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(100.0, (probe.value as CGSize).width, 0.0) }
    }

    /** Environment changes reach the isolated updater, including initial, overridden and nil values. */
    @Test fun actualReaderEnvironmentUpdatesOnlyInsetConsumers() {
        val environment = mutableStateOf<SafeArea?>(area())
        val sizeProbe = Probe()
        val insetProbe = Probe()
        val sizeReader = GeometryReader { proxy -> sizeProbe.record(proxy.bridgedSize); EmptyView() }
        val insetReader = GeometryReader { proxy -> insetProbe.record(proxy.safeAreaInsets); EmptyView() }
        val content: @Composable () -> Unit = {
            sizeReader.Render(ComposeContext(modifier = Modifier.size(100.dp)))
            insetReader.Render(ComposeContext(modifier = Modifier.size(100.dp)))
        }
        rule.setContent {
            CompositionLocalProvider(LocalDensity provides Density(1f)) {
                EnvironmentValues.shared.setValues({ env -> env.set_safeArea(environment.value); ComposeResult.ok }, content)
            }
        }
        rule.runOnIdle {
            assertEquals(20.0, (insetProbe.value as EdgeInsets).bottom, 0.0)
            sizeProbe.mark(); insetProbe.mark(); environment.value = area(y = 50f)
        }
        rule.runOnIdle { sizeProbe.assertSkipped(); insetProbe.assertSkipped(); environment.value = area(y = 50f, bottom = 80f) }
        rule.runOnIdle { sizeProbe.assertSkipped(); insetProbe.assertUpdated(); assertEquals(80.0, (insetProbe.value as EdgeInsets).bottom, 0.0); environment.value = null }
        rule.runOnIdle { sizeProbe.assertSkipped(); assertEquals(0.0, (insetProbe.value as EdgeInsets).bottom, 0.0) }
    }

    @Test fun actualReaderContentStillObservesItsOwnState() {
        val value = mutableStateOf(0)
        val probe = Probe()
        val reader = GeometryReader { proxy -> probe.record(proxy.size.width to value.value); EmptyView() }
        rule.setContent { reader.Render(ComposeContext(modifier = Modifier.size(100.dp))) }
        rule.runOnIdle { probe.mark(); value.value = 1 }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(1, (probe.value as Pair<*, *>).second) }
    }

    @Test fun parentCanReplaceContentWithoutChangingGeometry() {
        val value = mutableStateOf(0)
        val probe = Probe()
        rule.setContent {
            val captured = value.value
            GeometryReader { proxy -> probe.record(proxy.size.width to captured); EmptyView() }
                .Render(ComposeContext(modifier = Modifier.size(100.dp)))
        }
        rule.runOnIdle { probe.mark(); value.value = 2 }
        rule.runOnIdle { probe.assertUpdated(); assertEquals(2, (probe.value as Pair<*, *>).second) }
    }

    @Test fun remountedReaderUsesFreshGeometryAndEnvironment() {
        val visible = mutableStateOf(true)
        val size = mutableStateOf(100)
        val inset = mutableStateOf(20f)
        val probe = Probe()
        val reader = GeometryReader { proxy -> probe.record(proxy.size.width to proxy.safeAreaInsets.bottom); EmptyView() }
        rule.setContent {
            CompositionLocalProvider(LocalDensity provides Density(1f)) {
                EnvironmentValues.shared.setValues({ env -> env.set_safeArea(area(bottom = inset.value)); ComposeResult.ok }, {
                    if (visible.value) reader.Render(ComposeContext(modifier = Modifier.size(size.value.dp)))
                })
            }
        }
        rule.runOnIdle { assertEquals(100.0 to 20.0, probe.value); visible.value = false }
        rule.runOnIdle { size.value = 150; inset.value = 40f; visible.value = true }
        rule.runOnIdle { assertEquals(150.0 to 40.0, probe.value) }
    }

    private fun geometry() = GeometryReaderState().apply { update(IntSize(100, 200), Rect(0f, 0f, 100f, 200f)) }
    private fun area(y: Float = 0f, top: Float = 10f, left: Float = 2f, bottom: Float = 20f, right: Float = 4f) =
        SafeArea(Rect(0f, y, 100f, y + 200f), Rect(left, y + top, 100f - right, y + 200f - bottom))
}

private class Probe {
    var passes = 0
    var marked = 0
    var value: Any? = null
    fun record(value: Any?) { passes++; this.value = value }
    fun mark() { marked = passes; assertTrue("A vacuous unrendered probe is not evidence", marked > 0) }
    fun assertSkipped() = assertEquals("Equal projection must avoid content work", marked, passes)
    fun assertUpdated() = assertTrue("Changed projection must reach content", passes > marked)
}

@Composable
private fun ReadGeometry(read: () -> Any?, probe: Probe) {
    val value = read()
    SideEffect { probe.record(value) }
}
