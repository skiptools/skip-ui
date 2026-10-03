// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.foundation.ScrollState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Test

/** Exercise the modifier's real layout callback inside a clipping scroll viewport. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class GeometryChangeTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @Test fun contentHeightIgnoresScrollClippingButTracksResize() {
        val height = mutableStateOf(300.0)
        val scroll = ScrollState(0)
        val observed = mutableListOf<Double>()
        rule.setContent {
            CompositionLocalProvider(LocalDensity provides Density(2f)) {
                Box(Modifier.size(100.dp)) {
                    Box(Modifier.height(100.dp).verticalScroll(scroll)) {
                        Color.red.frame(width = 100.0, height = height.value)
                            .onGeometryChangeErased(of = { it.size.height }, action = { value: Double -> observed.add(value) })
                            .Compose(ComposeContext())
                    }
                }
            }
        }
        rule.runOnIdle { assertEquals(listOf(300.0), observed) }
        rule.runOnIdle { runBlocking { scroll.scrollTo(100) } }
        rule.runOnIdle {
            assertEquals("Scrolling must not change the content's measured height", listOf(300.0), observed)
            height.value = 350.0
        }
        rule.runOnIdle { assertEquals(listOf(300.0, 350.0), observed) }
    }

    /** Even fully clipped layouts must deliver size changes; movement alone is not a size change. */
    @Test fun fullyClippedContentStillReportsSizeChanges() {
        val y = mutableStateOf(200)
        val height = mutableStateOf(50.0)
        val observed = mutableListOf<Pair<Double, Double>>()
        rule.setContent {
            CompositionLocalProvider(LocalDensity provides Density(1f)) {
                Box(Modifier.size(100.dp).clipToBounds()) {
                    Color.red.frame(width = 50.0, height = height.value)
                        .onGeometryChangeErased(of = { it.size.height }, action = { old: Double, new: Double -> observed.add(old to new) })
                        .Compose(ComposeContext(modifier = Modifier.offset { IntOffset(0, y.value) }))
                }
            }
        }
        rule.runOnIdle { assertEquals(listOf(50.0 to 50.0), observed); height.value = 75.0 }
        rule.runOnIdle { assertEquals(listOf(50.0 to 50.0, 50.0 to 75.0), observed); y.value = 0 }
        rule.runOnIdle { assertEquals(listOf(50.0 to 50.0, 50.0 to 75.0), observed) }
    }
}
