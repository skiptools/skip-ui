// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCompositionContext
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.test.assertHeightIsEqualTo
import androidx.compose.ui.test.assertWidthIsEqualTo
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Before
import org.junit.Test
import skip.model.StateTracking

/** Android rendering regressions that need direct access to Compose identity and measurement. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class RenderingRegressionTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @Before fun resetAnimationProvenance() {
        Animation.resetRecentWithAnimationForTesting()
    }

    /** Returning evaluation must not subscribe the provider's restart scope to its own value. */
    @Test fun freshBridgedEnvironmentSettlesAfterParentUpdate() {
        val version = mutableStateOf(0)
        var passes = 0
        var observed: Any? = null
        var provided = EnvironmentSupport(builtinValue = 0)
        rule.setContent {
            val currentVersion = version.value
            passes++
            // Bound a regression so waitForIdle completes and reports an assertion, not a hang.
            if (passes < 32) provided = EnvironmentSupport(builtinValue = currentVersion)
            val value = EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged("regression-fresh-environment", provided)
                ComposeResult.ok
            }, {
                EnvironmentValues.shared.bridged("regression-fresh-environment")
            })
            SideEffect { observed = value?.builtinValue }
        }
        rule.runOnIdle { version.value = 1 }
        rule.runOnIdle {
            assertEquals("The changed environment must reach returning evaluation", 1, observed)
            assertTrue("Provider must settle instead of invalidating itself: $passes passes", passes < 8)
        }
    }

    /** Changing an environment value must not invalidate siblings that never read it. */
    @Test fun bridgedEnvironmentOnlyInvalidatesReaders() {
        val version = mutableStateOf(0)
        var observed: Any? = null
        var unrelatedPasses = 0
        val reader: (Any?) -> Unit = { observed = it }
        val unrelated: () -> Unit = { unrelatedPasses++ }
        val content: @Composable () -> Int = {
            ReadBridgedEnvironment("regression-targeted-environment", reader)
            CountUnrelatedComposition(unrelated)
            0
        }
        rule.setContent {
            val provided = EnvironmentSupport(builtinValue = version.value)
            EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged("regression-targeted-environment", provided)
                ComposeResult.ok
            }, content)
        }
        var initialPasses = 0
        rule.runOnIdle {
            assertEquals(0, observed)
            initialPasses = unrelatedPasses
            version.value = 1
        }
        rule.runOnIdle {
            assertEquals(1, observed)
            assertEquals("A non-reader must remain skipped", initialPasses, unrelatedPasses)
            version.value = 2
        }
        rule.runOnIdle {
            assertEquals(2, observed)
            assertEquals("Selective invalidation must survive another update", initialPasses, unrelatedPasses)
        }
    }

    /** Suppressing a provider's self-read must not suppress other state reads in its content. */
    @Test fun returningEnvironmentPreservesIndependentStateReads() {
        val childState = mutableStateOf(0)
        var observed = -1
        var passes = 0
        var provided = EnvironmentSupport(builtinValue = 10)
        rule.setContent {
            passes++
            if (passes < 32) provided = EnvironmentSupport(builtinValue = 10)
            val value = EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged("regression-independent-state", provided)
                ComposeResult.ok
            }, {
                val environment = EnvironmentValues.shared.bridged("regression-independent-state")
                (environment?.builtinValue as Int) + childState.value
            })
            SideEffect { observed = value }
        }
        rule.runOnIdle { assertEquals(10, observed); childState.value = 1 }
        rule.runOnIdle {
            assertEquals("An independent state read must remain observed", 11, observed)
            assertTrue("The update must settle: $passes passes", passes < 8)
        }
    }

    /** Returning evaluation must still observe values supplied by a different restart scope. */
    @Test fun returningEnvironmentTracksInheritedValues() {
        val version = mutableStateOf(0)
        var observed: Any? = null
        val reader: (Any?) -> Unit = { observed = it }
        rule.setContent {
            val provided = EnvironmentSupport(builtinValue = version.value)
            EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged("regression-inherited-outer", provided)
                ComposeResult.ok
            }, {
                ReadInheritedReturningEnvironment(reader)
                0
            })
        }
        rule.runOnIdle { assertEquals(0, observed); version.value = 1 }
        rule.runOnIdle { assertEquals(1, observed); version.value = 2 }
        rule.runOnIdle { assertEquals(2, observed) }
    }

    /** Leaving an override must restore observation of the ancestor's value of the same key. */
    @Test fun returningEnvironmentRestoresInheritedReadTracking() {
        val version = mutableStateOf(0)
        var observed: Pair<Any?, Any?>? = null
        val reader: (Pair<Any?, Any?>) -> Unit = { observed = it }
        rule.setContent {
            val provided = EnvironmentSupport(builtinValue = version.value)
            EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged("regression-shadowed-environment", provided)
                ComposeResult.ok
            }, {
                ReadShadowedReturningEnvironment(reader)
                0
            })
        }
        rule.runOnIdle { assertEquals(99 to 0, observed); version.value = 1 }
        rule.runOnIdle { assertEquals(99 to 1, observed); version.value = 2 }
        rule.runOnIdle { assertEquals(99 to 2, observed) }
    }

    /** Nested returning providers must restore the outer value and its ownership on exit. */
    @Test fun returningEnvironmentRestoresNestedProvider() {
        val version = mutableStateOf(0)
        var observed: Triple<Any?, Any?, Any?>? = null
        var passes = 0
        var provided = EnvironmentSupport(builtinValue = 0)
        var innerProvided = EnvironmentSupport(builtinValue = 99)
        rule.setContent {
            val currentVersion = version.value
            passes++
            if (passes < 32) {
                provided = EnvironmentSupport(builtinValue = currentVersion)
                innerProvided = EnvironmentSupport(builtinValue = 99)
            }
            val values = EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged("regression-returning-nested", provided)
                ComposeResult.ok
            }, {
                val before = EnvironmentValues.shared.bridged("regression-returning-nested")?.builtinValue
                val inner = EnvironmentValues.shared.setValuesWithReturn({ environment ->
                    environment.setBridged("regression-returning-nested", innerProvided)
                    ComposeResult.ok
                }, {
                    EnvironmentValues.shared.bridged("regression-returning-nested")?.builtinValue
                })
                val after = EnvironmentValues.shared.bridged("regression-returning-nested")?.builtinValue
                Triple(before, inner, after)
            })
            SideEffect { observed = values }
        }
        rule.runOnIdle { assertEquals(Triple(0, 99, 0), observed); version.value = 1 }
        rule.runOnIdle {
            assertEquals(Triple(1, 99, 1), observed)
            assertTrue("Nested returning providers must settle: $passes passes", passes < 8)
        }
    }

    /** A retained consumer must receive replacements even when its own parameters are unchanged. */
    @Test fun bridgedEnvironmentUpdatesRetainedReader() {
        val version = mutableStateOf(0)
        var observed: Any? = null
        val reader: (Any?) -> Unit = { observed = it }
        rule.setContent {
            val provided = EnvironmentSupport(builtinValue = version.value)
            EnvironmentValues.shared.setValues({ environment ->
                environment.setBridged("regression-retained-environment", provided)
                ComposeResult.ok
            }, {
                ReadBridgedEnvironment("regression-retained-environment", reader)
            })
        }
        rule.runOnIdle { assertEquals(0, observed); version.value = 1 }
        rule.runOnIdle { assertEquals(1, observed) }
    }

    /** Nested overrides stay local and removing one reveals the latest outer value. */
    @Test fun bridgedEnvironmentPreservesNestedScopeAndRemoval() {
        val version = mutableStateOf(0)
        val override = mutableStateOf(true)
        var outer: Any? = null
        var inner: Any? = null
        var sibling: Any? = null
        rule.setContent {
            val provided = EnvironmentSupport(builtinValue = version.value)
            EnvironmentValues.shared.setValues({ environment ->
                environment.setBridged("regression-nested-environment", provided)
                ComposeResult.ok
            }, {
                ReadBridgedEnvironment("regression-nested-environment") { outer = it }
                if (override.value) {
                    EnvironmentValues.shared.setValues({ environment ->
                        environment.setBridged("regression-nested-environment", EnvironmentSupport(builtinValue = 99))
                        ComposeResult.ok
                    }, {
                        ReadBridgedEnvironment("regression-nested-environment") { inner = it }
                    })
                } else {
                    ReadBridgedEnvironment("regression-nested-environment") { inner = it }
                }
                ReadBridgedEnvironment("regression-nested-environment") { sibling = it }
            })
        }
        rule.runOnIdle { assertEquals(0, outer); assertEquals(99, inner); assertEquals(0, sibling); version.value = 1 }
        rule.runOnIdle { assertEquals(1, outer); assertEquals(99, inner); assertEquals(1, sibling); override.value = false }
        rule.runOnIdle { assertEquals(1, inner) }
    }

    @Test fun plainConsumerDoesNotUseOtherConsumersPrime() {
        var plainResult: Animation? = null
        var animatedResult: Animation? = null
        rule.setContent {
            Animation.primeBridgedProvenance(null)
            val plainTx = StateTracking.captureLastReadAndClear()
            Animation.primeBridgedProvenance(Animation.linear(duration = 1.0))
            val animatedTx = StateTracking.captureLastReadAndClear()
            // Construction of both modifiers finishes before their render functions run.
            val plain = Animation.current(isAnimating = false, animTx = plainTx)
            val animated = Animation.current(isAnimating = false, animTx = animatedTx)
            SideEffect {
                plainResult = plain
                animatedResult = animated
            }
        }
        rule.waitForIdle()
        assertNull("Plain consumer must not receive the later modifier's animation", plainResult)
        assertNotNull("The animated consumer must keep its captured animation", animatedResult)
    }

    @Test fun boundaryPreservesWrapContentSize() {
        rule.setContent {
            val parent = rememberCompositionContext()
            Box(Modifier.size(200.dp)) {
                AndroidView(factory = { context ->
                    AndroidCompositionBoundaryComposeView(context, parent) {
                        Box(Modifier.size(20.dp))
                    }
                }, modifier = Modifier.testTag("boundary"))
            }
        }
        rule.onNodeWithTag("boundary").assertWidthIsEqualTo(20.dp)
        rule.onNodeWithTag("boundary").assertHeightIsEqualTo(20.dp)
    }

    @Test fun nestedForEachRetainsInnerRowStateInZStack() {
        assertNestedRowsRetainState { content -> ZStack(content = content) }
    }

    @Test fun nestedForEachRetainsInnerRowStateInHStack() {
        assertNestedRowsRetainState { content -> HStack(content = content) }
    }

    @Test fun nestedForEachRetainsInnerRowStateInVStack() {
        assertNestedRowsRetainState { content -> VStack(content = content) }
    }

    private fun assertNestedRowsRetainState(stack: (() -> View) -> View) {
        val reversed = mutableStateOf(false)
        val tokens = mutableMapOf<Pair<Int, Int>, Any>()
        rule.setContent {
            stack {
                ForEach(0 until 2) { outerID ->
                    val ids = if (reversed.value) skip.lib.arrayOf(2, 1) else skip.lib.arrayOf(1, 2)
                    ForEach(ids, id = { it }) { innerID ->
                        RenderingIdentityProbe(outerID to innerID, tokens)
                    }
                }
            }.Compose()
        }
        rule.waitForIdle()
        val initial = tokens.toMap()
        rule.runOnIdle { reversed.value = true }
        rule.waitForIdle()
        for (outerID in 0 until 2) {
            for (innerID in 1..2) {
                val id = outerID to innerID
                assertNotNull("Row $id must have rendered", initial[id])
                assertSame("Row $id must retain its remembered state on reorder", initial[id], tokens[id])
            }
        }
    }
}

/** A separate restart scope with stable arguments for environment propagation tests. */
@Composable
private fun ReadBridgedEnvironment(key: String, onValue: (Any?) -> Unit) {
    val value = EnvironmentValues.shared.bridged(key)?.builtinValue
    SideEffect { onValue(value) }
}

/** A skippable sibling that records committed compositions without reading the environment. */
@Composable
private fun CountUnrelatedComposition(onCompose: () -> Unit) {
    SideEffect(onCompose)
}

/** Read an inherited key from a returning provider in a distinct, independently restartable scope. */
@Composable
private fun ReadInheritedReturningEnvironment(onValue: (Any?) -> Unit) {
    val value = EnvironmentValues.shared.setValuesWithReturn({ environment ->
        environment.setBridged("regression-inherited-inner", EnvironmentSupport(builtinValue = 99))
        ComposeResult.ok
    }, {
        EnvironmentValues.shared.bridged("regression-inherited-outer")?.builtinValue
    })
    SideEffect { onValue(value) }
}

/** Read a local override, then read the ancestor value after the override has left the scope. */
@Composable
private fun ReadShadowedReturningEnvironment(onValue: (Pair<Any?, Any?>) -> Unit) {
    val shadow = EnvironmentValues.shared.setValuesWithReturn({ environment ->
        environment.setBridged("regression-shadowed-environment", EnvironmentSupport(builtinValue = 99))
        ComposeResult.ok
    }, {
        EnvironmentValues.shared.bridged("regression-shadowed-environment")?.builtinValue
    })
    val inherited = EnvironmentValues.shared.bridged("regression-shadowed-environment")?.builtinValue
    SideEffect { onValue(shadow to inherited) }
}

private class RenderingIdentityProbe(
    val id: Pair<Int, Int>,
    val tokens: MutableMap<Pair<Int, Int>, Any>
): View, Renderable {
    @Composable override fun Render(context: ComposeContext) {
        val token = remember { Any() }
        SideEffect { tokens[id] = token }
        Box(Modifier.size(20.dp))
    }
}
