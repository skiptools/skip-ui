// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.runtime.AbstractApplier
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Composition
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.NonRestartableComposable
import androidx.compose.runtime.Recomposer
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.movableContentOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCompositionContext
import androidx.compose.ui.layout.SubcomposeLayout
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Assert.assertTrue
import org.junit.Test
import kotlin.coroutines.EmptyCoroutineContext

/**
 * Adversarial ownership checks for returning environment evaluation. Keep these on the real
 * Compose compiler/runtime: mocks cannot establish which calls share a restart scope.
 * RenderingRegressionTests also covers the original fresh-wrapper loop and selective invalidation.
 */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class ReturningEnvironmentTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    /** A reader can restart after the provider's synchronous tracking stack has disappeared. */
    @Test fun independentlyRestartedReaderKeepsEnvironmentSubscription() {
        val key = "returning-independent-reader"
        val parent = mutableStateOf(0)
        val child = mutableStateOf(0)
        var parentPasses = 0
        var observed: Pair<Any?, Int>? = null
        val reader: (Pair<Any?, Int>) -> Unit = { observed = it }
        rule.setContent {
            parentPasses++
            val value = EnvironmentSupport(builtinValue = parent.value)
            ProvideReturning(key, value) {
                StatefulEnvironmentReader(key, child, reader)
                0
            }
        }
        var initialParentPasses = 0
        rule.runOnIdle {
            assertEquals(0 to 0, observed)
            initialParentPasses = parentPasses
            child.value = 1
        }
        rule.runOnIdle {
            assertEquals(0 to 1, observed)
            assertEquals("Exercise a child-only restart", initialParentPasses, parentPasses)
            parent.value = 2
        }
        rule.runOnIdle { assertEquals(2 to 1, observed); child.value = 3 }
        rule.runOnIdle { assertEquals(2 to 3, observed) }
    }

    /** A plain provider inside returning evaluation must still own its same-key override. */
    @Test fun ordinaryOverrideInsideReturningProviderUpdatesAndCanBeRemoved() {
        val key = "returning-ordinary-override"
        val outer = mutableStateOf(0)
        val inner = mutableStateOf(10)
        val enabled = mutableStateOf(true)
        var observed: Any? = null
        var sibling: Any? = null
        val reader: (Any?) -> Unit = { observed = it }
        val siblingReader: (Any?) -> Unit = { sibling = it }
        rule.setContent {
            ProvideReturning(key, EnvironmentSupport(builtinValue = outer.value)) {
                OrdinaryOverride(key, inner, enabled, reader)
                EnvironmentReader(key, siblingReader)
                0
            }
        }
        rule.runOnIdle { assertEquals(10, observed); assertEquals(0, sibling); inner.value = 11 }
        rule.runOnIdle { assertEquals(11, observed); outer.value = 1 }
        rule.runOnIdle { assertEquals(11, observed); assertEquals(1, sibling); enabled.value = false }
        rule.runOnIdle { assertEquals(1, observed); outer.value = 2 }
        rule.runOnIdle { assertEquals(2, observed); enabled.value = true }
        rule.runOnIdle { assertEquals(11, observed); inner.value = 12 }
        rule.runOnIdle { assertEquals(12, observed); assertEquals(2, sibling) }
    }

    /** The inherited read after a returning override must subscribe to a plain outer provider. */
    @Test fun returningOverrideInsideOrdinaryProviderRestoresInheritedTracking() {
        val key = "returning-inside-ordinary"
        val outer = mutableStateOf(0)
        val inner = mutableStateOf(10)
        var observed: Pair<Any?, Any?>? = null
        val reader: (Pair<Any?, Any?>) -> Unit = { observed = it }
        rule.setContent {
            EnvironmentValues.shared.setValues({ environment ->
                environment.setBridged(key, EnvironmentSupport(builtinValue = outer.value))
                ComposeResult.ok
            }, { ReturningOverrideAndInheritedReader(key, inner, reader) })
        }
        rule.runOnIdle { assertEquals(10 to 0, observed); inner.value = 11 }
        rule.runOnIdle { assertEquals(11 to 0, observed); outer.value = 1 }
        rule.runOnIdle { assertEquals(11 to 1, observed); inner.value = 12 }
        rule.runOnIdle { assertEquals(12 to 1, observed); outer.value = 2 }
        rule.runOnIdle { assertEquals(12 to 2, observed) }
    }

    /** Empty returning providers must not hide inherited dependencies or change the current value. */
    @Test fun emptyReturningProviderPreservesInheritedSubscription() {
        val key = "returning-empty"
        val version = mutableStateOf(0)
        var observed: Any? = null
        val reader: (Any?) -> Unit = { observed = it }
        rule.setContent {
            ProvideReturning(key, EnvironmentSupport(builtinValue = version.value)) {
                EmptyReturningReader(key, reader)
                0
            }
        }
        rule.runOnIdle { assertEquals(0, observed); version.value = 1 }
        rule.runOnIdle { assertEquals(1, observed); version.value = 2 }
        rule.runOnIdle { assertEquals(2, observed) }
    }

    /** A key that was not supplied by the returning provider must continue to invalidate readers. */
    @Test fun unrelatedOrdinaryLocalRemainsObservedDuringReturningEvaluation() {
        val local = compositionLocalOf { -1 }
        val version = mutableStateOf(0)
        var observed = -1
        val reader: (Int) -> Unit = { observed = it }
        rule.setContent {
            CompositionLocalProvider(local provides version.value) {
                UnrelatedLocalReader(local, reader)
            }
        }
        rule.runOnIdle { assertEquals(0, observed); version.value = 1 }
        rule.runOnIdle { assertEquals(1, observed); version.value = 2 }
        rule.runOnIdle { assertEquals(2, observed) }
    }

    /** Explicit nil masks an ancestor; removing the override reveals the ancestor's latest value. */
    @Test fun nilOverrideAndProviderRemovalRestoreCurrentValues() {
        val key = "returning-nil"
        val outer = mutableStateOf(0)
        val mode = mutableStateOf(0)
        var observed: Any? = "not composed"
        val reader: (Any?) -> Unit = { observed = it }
        rule.setContent {
            ProvideReturning(key, EnvironmentSupport(builtinValue = outer.value)) {
                NullableOverrideReader(key, mode, reader)
                0
            }
        }
        rule.runOnIdle { assertEquals(10, observed); mode.value = 1 }
        rule.runOnIdle { assertEquals(null, observed); outer.value = 1 }
        rule.runOnIdle { assertEquals(null, observed); mode.value = 2 }
        rule.runOnIdle { assertEquals(1, observed); outer.value = 2 }
        rule.runOnIdle { assertEquals(2, observed); mode.value = 0 }
        rule.runOnIdle { assertEquals(10, observed) }
    }

    /** Separate keys must not share subscriptions just because one provider supplies both. */
    @Test fun multipleKeysInvalidateOnlyTheirOwnReaders() {
        val firstKey = "returning-first-key"
        val secondKey = "returning-second-key"
        val first = mutableStateOf(EnvironmentSupport(builtinValue = 0))
        val second = mutableStateOf(EnvironmentSupport(builtinValue = 10))
        var firstValue: Any? = null
        var secondValue: Any? = null
        var firstPasses = 0
        var secondPasses = 0
        val firstReader: (Any?) -> Unit = { firstValue = it; firstPasses++ }
        val secondReader: (Any?) -> Unit = { secondValue = it; secondPasses++ }
        val content: @Composable () -> Int = {
            EnvironmentReader(firstKey, firstReader)
            EnvironmentReader(secondKey, secondReader)
            0
        }
        rule.setContent {
            EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged(firstKey, first.value)
                environment.setBridged(secondKey, second.value)
                ComposeResult.ok
            }, content)
        }
        var initialSecondPasses = 0
        var updatedFirstPasses = 0
        rule.runOnIdle {
            assertEquals(0, firstValue); assertEquals(10, secondValue)
            initialSecondPasses = secondPasses
            first.value = EnvironmentSupport(builtinValue = 1)
        }
        rule.runOnIdle {
            assertEquals(1, firstValue)
            assertEquals(initialSecondPasses, secondPasses)
            updatedFirstPasses = firstPasses
            second.value = EnvironmentSupport(builtinValue = 11)
        }
        rule.runOnIdle {
            assertEquals(11, secondValue)
            assertEquals(updatedFirstPasses, firstPasses)
        }
    }

    /** Conditional reads must subscribe to the newly selected key and stop observing the old one. */
    @Test fun conditionalReaderSwitchesItsSubscription() {
        val firstKey = "returning-selected-first"
        val secondKey = "returning-selected-second"
        val first = mutableStateOf(EnvironmentSupport(builtinValue = 0))
        val second = mutableStateOf(EnvironmentSupport(builtinValue = 10))
        val selectFirst = mutableStateOf(true)
        var observed: Any? = null
        var readerPasses = 0
        val reader: (Any?) -> Unit = { observed = it; readerPasses++ }
        val content: @Composable () -> Int = {
            ConditionalEnvironmentReader(firstKey, secondKey, selectFirst, reader)
            0
        }
        rule.setContent {
            EnvironmentValues.shared.setValuesWithReturn({ environment ->
                environment.setBridged(firstKey, first.value)
                environment.setBridged(secondKey, second.value)
                ComposeResult.ok
            }, content)
        }
        var passesBeforeInactiveUpdate = 0
        rule.runOnIdle {
            assertEquals(0, observed)
            passesBeforeInactiveUpdate = readerPasses
            second.value = EnvironmentSupport(builtinValue = 11)
        }
        rule.runOnIdle {
            assertEquals(passesBeforeInactiveUpdate, readerPasses)
            selectFirst.value = false
        }
        rule.runOnIdle {
            assertEquals(11, observed)
            passesBeforeInactiveUpdate = readerPasses
            first.value = EnvironmentSupport(builtinValue = 1)
        }
        rule.runOnIdle {
            assertEquals("The old key must no longer invalidate this reader", passesBeforeInactiveUpdate, readerPasses)
            second.value = EnvironmentSupport(builtinValue = 12)
        }
        rule.runOnIdle { assertEquals(12, observed); selectFirst.value = true }
        rule.runOnIdle { assertEquals(1, observed) }
    }

    /** A computed ordinary override can read state during lookup, not when its provider is built. */
    @Test fun ordinaryComputedOverridePreservesItsStateDependency() {
        val key = "returning-computed-override"
        val local = EnvironmentValues.shared.bridgedCompositionLocal(key)
        val version = mutableStateOf(10)
        var observed: Any? = null
        rule.setContent {
            ProvideReturning(key, EnvironmentSupport(builtinValue = 99)) {
                CompositionLocalProvider(local providesComputed { EnvironmentSupport(builtinValue = version.value) }) {
                    val value = EnvironmentValues.shared.bridged(key)?.builtinValue
                    SideEffect { observed = value }
                }
                0
            }
        }
        rule.runOnIdle { assertEquals(10, observed); version.value = 11 }
        rule.runOnIdle { assertEquals(11, observed); version.value = 12 }
        rule.runOnIdle { assertEquals(12, observed) }
    }

    /** An explicitly non-restartable reader belongs to the supplying scope and must also settle. */
    @Test fun nonRestartableReaderDoesNotSubscribeProviderToItself() {
        val key = "returning-nonrestartable"
        val version = mutableStateOf(0)
        val independent = mutableStateOf(0)
        var observed: Pair<Any?, Int>? = null
        var passes = 0
        var provided = EnvironmentSupport(builtinValue = 0)
        val reader: (Pair<Any?, Int>) -> Unit = { observed = it }
        rule.setContent {
            val currentVersion = version.value
            passes++
            if (passes < 32) provided = EnvironmentSupport(builtinValue = currentVersion)
            // Explicit Int matters: inferring Unit from setContent would create a restartable
            // content lambda and stop this test from exercising a provider-scope self-read.
            ProvideReturning<Int>(key, provided) {
                NonRestartableEnvironmentReader(key, independent, reader)
                0
            }
        }
        rule.runOnIdle {
            assertEquals(0 to 0, observed)
            assertTrue("The initial self-read must settle: $passes passes", passes < 8)
            independent.value = 1
        }
        rule.runOnIdle { assertEquals(0 to 1, observed); version.value = 2 }
        rule.runOnIdle {
            assertEquals(2 to 1, observed)
            assertTrue("Non-restartable content must settle: $passes passes", passes < 10)
        }
    }

    /** Providing a value must neither change its default nor leave a value visible after return. */
    @Test fun unprovidedReadsBeforeAndAfterReturningEvaluationUseDefault() {
        val key = "returning-default"
        val version = mutableStateOf(0)
        var observed: Triple<Any?, Any?, Any?>? = null
        var passes = 0
        var provided = EnvironmentSupport(builtinValue = 0)
        rule.setContent {
            val currentVersion = version.value
            passes++
            if (passes < 32) provided = EnvironmentSupport(builtinValue = currentVersion)
            val before = EnvironmentValues.shared.bridged(key)?.builtinValue
            val inside = ProvideReturning(key, provided) { EnvironmentValues.shared.bridged(key)?.builtinValue }
            val after = EnvironmentValues.shared.bridged(key)?.builtinValue
            SideEffect { observed = Triple(before, inside, after) }
        }
        rule.runOnIdle { assertEquals(Triple(null, 0, null), observed); version.value = 1 }
        rule.runOnIdle {
            assertEquals(Triple(null, 1, null), observed)
            assertTrue("Default reads must not acquire a dependency on the override", passes < 8)
        }
    }

    /** Look past unrelated/empty providers to find an enclosing owner in the same restart scope. */
    @Test fun nestedDifferentKeysAndEmptyProviderPreserveSelfReadSuppression() {
        val outerKey = "returning-chain-outer"
        val innerKey = "returning-chain-inner"
        val version = mutableStateOf(0)
        var observed: Triple<Any?, Any?, Any?>? = null
        var passes = 0
        var outer = EnvironmentSupport(builtinValue = 0)
        var inner = EnvironmentSupport(builtinValue = 10)
        rule.setContent {
            val currentVersion = version.value
            passes++
            if (passes < 32) {
                outer = EnvironmentSupport(builtinValue = currentVersion)
                inner = EnvironmentSupport(builtinValue = 10 + currentVersion)
            }
            val value = ProvideReturning(outerKey, outer) {
                val nested = EnvironmentValues.shared.setValuesWithReturn({ ComposeResult.ok }, {
                    ProvideReturning(innerKey, inner) {
                        EnvironmentValues.shared.bridged(outerKey)?.builtinValue to
                            EnvironmentValues.shared.bridged(innerKey)?.builtinValue
                    }
                })
                Triple(nested.first, nested.second, EnvironmentValues.shared.bridged(outerKey)?.builtinValue)
            }
            SideEffect { observed = value }
        }
        rule.runOnIdle { assertEquals(Triple(0, 10, 0), observed); version.value = 1 }
        rule.runOnIdle {
            assertEquals(Triple(1, 11, 1), observed)
            assertTrue("Every self-read in the provider chain must settle: $passes passes", passes < 8)
        }
    }

    /** Sibling providers use the same key but own different values and different subscriptions. */
    @Test fun sameKeySiblingProvidersRemainIndependent() {
        val key = "returning-siblings"
        val left = mutableStateOf(EnvironmentSupport(builtinValue = 0))
        val right = mutableStateOf(EnvironmentSupport(builtinValue = 10))
        var leftValue: Any? = null
        var rightValue: Any? = null
        var leftPasses = 0
        var rightPasses = 0
        val leftReader: (Any?) -> Unit = { leftValue = it; leftPasses++ }
        val rightReader: (Any?) -> Unit = { rightValue = it; rightPasses++ }
        val leftContent: @Composable () -> Int = { EnvironmentReader(key, leftReader); 0 }
        val rightContent: @Composable () -> Int = { EnvironmentReader(key, rightReader); 0 }
        rule.setContent {
            ProvideReturning(key, left.value, leftContent)
            ProvideReturning(key, right.value, rightContent)
        }
        var unchangedPasses = 0
        rule.runOnIdle {
            assertEquals(0, leftValue); assertEquals(10, rightValue)
            unchangedPasses = rightPasses
            left.value = EnvironmentSupport(builtinValue = 1)
        }
        rule.runOnIdle {
            assertEquals(1, leftValue); assertEquals(10, rightValue)
            assertEquals(unchangedPasses, rightPasses)
            unchangedPasses = leftPasses
            right.value = EnvironmentSupport(builtinValue = 11)
        }
        rule.runOnIdle {
            assertEquals(1, leftValue); assertEquals(11, rightValue)
            assertEquals(unchangedPasses, leftPasses)
        }
    }

    /** A remembered movable reader must follow its placement's environment after moving. */
    @Test fun movableReaderUsesDestinationProviderAndKeepsItsState() {
        val key = "returning-movable"
        val move = mutableStateOf(false)
        val left = mutableStateOf(0)
        val right = mutableStateOf(10)
        var observed: Any? = null
        var token: Any? = null
        rule.setContent {
            val content = remember {
                movableContentOf {
                    val identity = remember { Any() }
                    val value = EnvironmentValues.shared.bridged(key)?.builtinValue
                    SideEffect { token = identity; observed = value }
                }
            }
            Box {
                ProvideReturning(key, EnvironmentSupport(builtinValue = left.value)) {
                    if (!move.value) content()
                    0
                }
                ProvideReturning(key, EnvironmentSupport(builtinValue = right.value)) {
                    if (move.value) content()
                    0
                }
            }
        }
        var initialToken: Any? = null
        rule.runOnIdle { assertEquals(0, observed); initialToken = token; move.value = true }
        rule.runOnIdle { assertEquals(10, observed); assertSame(initialToken, token); right.value = 11 }
        rule.runOnIdle { assertEquals(11, observed); left.value = 1 }
        rule.runOnIdle { assertEquals(11, observed); move.value = false }
        rule.runOnIdle { assertEquals(1, observed); assertSame(initialToken, token); left.value = 2 }
        rule.runOnIdle { assertEquals(2, observed) }
    }

    /** Layout-time subcomposition reads after the returning provider has left the tracking stack. */
    @Test fun layoutSubcompositionInheritsUpdatesAndIndependentState() {
        val key = "returning-subcompose"
        val version = mutableStateOf(0)
        val child = mutableStateOf(0)
        var observed: Pair<Any?, Int>? = null
        val reader: (Pair<Any?, Int>) -> Unit = { observed = it }
        rule.setContent {
            ProvideReturning(key, EnvironmentSupport(builtinValue = version.value)) {
                SubcomposeLayout { _ ->
                    subcompose("reader") { StatefulEnvironmentReader(key, child, reader) }
                    layout(1, 1) {}
                }
                0
            }
        }
        rule.runOnIdle { assertEquals(0 to 0, observed); child.value = 1 }
        rule.runOnIdle { assertEquals(0 to 1, observed); version.value = 2 }
        rule.runOnIdle { assertEquals(2 to 1, observed); child.value = 3 }
        rule.runOnIdle { assertEquals(2 to 3, observed) }
    }

    /** A second composer can run synchronously while the first one's provider stack is active. */
    @Test fun synchronousChildCompositionKeepsInheritedAndIndependentSubscriptions() {
        val key = "returning-reentrant"
        val version = mutableStateOf(0)
        val childState = mutableStateOf(0)
        var observed: Pair<Any?, Int>? = null
        val reader: (Pair<Any?, Int>) -> Unit = { observed = it }
        val childContent: @Composable () -> Unit = { StatefulEnvironmentReader(key, childState, reader) }
        rule.setContent {
            ProvideReturning(key, EnvironmentSupport(builtinValue = version.value)) {
                val parentContext = rememberCompositionContext()
                val child = remember { Composition(EnvironmentTestApplier(), parentContext) }
                // setContent performs the initial child composition before the provider exits.
                remember(child) { child.setContent(childContent); true }
                DisposableEffect(child) { onDispose { child.dispose() } }
                0
            }
        }
        rule.runOnIdle { assertEquals(0 to 0, observed); childState.value = 1 }
        rule.runOnIdle { assertEquals(0 to 1, observed); version.value = 2 }
        rule.runOnIdle { assertEquals(2 to 1, observed); childState.value = 3 }
        rule.runOnIdle { assertEquals(2 to 3, observed) }
    }

    /** An aborted nested composition must restore the still-active outer provider's ownership. */
    @Test fun failedNestedCompositionDoesNotPoisonOuterProviderTracking() {
        val key = "returning-failure"
        val version = mutableStateOf(0)
        val expected = IllegalStateException("Expected composition failure")
        var observed: Any? = null
        var failures = 0
        var passes = 0
        var provided = EnvironmentSupport(builtinValue = 0)
        rule.setContent {
            val currentVersion = version.value
            passes++
            if (passes < 32) provided = EnvironmentSupport(builtinValue = currentVersion)
            val value = ProvideReturning(key, provided) {
                // Catch outside composable code: a failed child composition is discarded, never
                // resumed. Leaking its stack entry would make the outer self-read subscribe again.
                assertSame(expected, runFailingComposition {
                    ProvideReturning(key, EnvironmentSupport(builtinValue = 99)) { throw expected }
                })
                failures++
                EnvironmentValues.shared.bridged(key)?.builtinValue
            }
            SideEffect { observed = value }
        }
        rule.runOnIdle { assertEquals(0, observed); version.value = 1 }
        rule.runOnIdle {
            assertEquals(1, observed)
            assertTrue("The failure path must actually run", failures >= 2)
            assertTrue("Outer tracking must be restored after failure: $passes passes", passes < 8)
        }
    }
}

/** Returning helpers deliberately keep their caller's restart scope, as bridge evaluation does. */
@Composable
private fun <R> ProvideReturning(key: String, value: EnvironmentSupport?, content: @Composable () -> R): R =
    EnvironmentValues.shared.setValuesWithReturn({ environment ->
        environment.setBridged(key, value)
        ComposeResult.ok
    }, content)

/** Stable arguments let the test distinguish environment invalidation from parameter changes. */
@Composable
private fun EnvironmentReader(key: String, onValue: (Any?) -> Unit) {
    val value = EnvironmentValues.shared.bridged(key)?.builtinValue
    SideEffect { onValue(value) }
}

/** Only this restart scope reads the child state; its parent must be able to remain skipped. */
@Composable
private fun StatefulEnvironmentReader(key: String, state: MutableState<Int>, onValue: (Pair<Any?, Int>) -> Unit) {
    val value = EnvironmentValues.shared.bridged(key)?.builtinValue to state.value
    SideEffect { onValue(value) }
}

/** No additional restart scope: only the environment lookup, not the state read, may be suppressed. */
@Composable
@NonRestartableComposable
private fun NonRestartableEnvironmentReader(key: String, state: MutableState<Int>, onValue: (Pair<Any?, Int>) -> Unit) {
    val value = EnvironmentValues.shared.bridged(key)?.builtinValue to state.value
    SideEffect { onValue(value) }
}

/** Keep key selection inside the reader so switching keys exercises a child-only recomposition. */
@Composable
private fun ConditionalEnvironmentReader(first: String, second: String, selectFirst: MutableState<Boolean>, onValue: (Any?) -> Unit) {
    val value = EnvironmentValues.shared.bridged(if (selectFirst.value) first else second)?.builtinValue
    SideEffect { onValue(value) }
}

/** Exercise the standard SkipUI provider, which does not participate in returning-provider tracking. */
@Composable
private fun OrdinaryOverride(key: String, state: MutableState<Int>, enabled: MutableState<Boolean>, onValue: (Any?) -> Unit) {
    if (enabled.value) {
        EnvironmentValues.shared.setValues({ environment ->
            environment.setBridged(key, EnvironmentSupport(builtinValue = state.value))
            ComposeResult.ok
        }, { EnvironmentReader(key, onValue) })
    } else {
        EnvironmentReader(key, onValue)
    }
}

/** The second read is outside the local override but still in the same independently restartable child. */
@Composable
private fun ReturningOverrideAndInheritedReader(key: String, state: MutableState<Int>, onValue: (Pair<Any?, Any?>) -> Unit) {
    val override = ProvideReturning(key, EnvironmentSupport(builtinValue = state.value)) {
        EnvironmentValues.shared.bridged(key)?.builtinValue
    }
    val inherited = EnvironmentValues.shared.bridged(key)?.builtinValue
    SideEffect { onValue(override to inherited) }
}

/** An empty provider still creates a tracking entry; it must not stop lookup of enclosing owners. */
@Composable
private fun EmptyReturningReader(key: String, onValue: (Any?) -> Unit) {
    val value = EnvironmentValues.shared.setValuesWithReturn({ ComposeResult.ok }, {
        EnvironmentValues.shared.bridged(key)?.builtinValue
    })
    SideEffect { onValue(value) }
}

/** Read an ordinary local through the same lookup helper while providing a different bridged key. */
@Composable
private fun UnrelatedLocalReader(local: androidx.compose.runtime.CompositionLocal<Int>, onValue: (Int) -> Unit) {
    val value = ProvideReturning("returning-unrelated-key", EnvironmentSupport(builtinValue = 99)) {
        ReadBridgedEnvironmentValue(local)
    }
    SideEffect { onValue(value) }
}

/** A null bridged value is an explicit override; mode 2 removes the provider itself. */
@Composable
private fun NullableOverrideReader(key: String, mode: MutableState<Int>, onValue: (Any?) -> Unit) {
    if (mode.value == 2) {
        EnvironmentReader(key, onValue)
    } else {
        ProvideReturning(key, if (mode.value == 0) EnvironmentSupport(builtinValue = 10) else null) {
            EnvironmentReader(key, onValue)
            0
        }
    }
}

/** These child compositions contain only state reads/effects, so emitting UI nodes is a test error. */
private class EnvironmentTestApplier : AbstractApplier<Unit>(Unit) {
    override fun insertTopDown(index: Int, instance: Unit) = error("Unexpected node")
    override fun insertBottomUp(index: Int, instance: Unit) = error("Unexpected node")
    override fun remove(index: Int, count: Int) = error("Unexpected node")
    override fun move(from: Int, to: Int, count: Int) = error("Unexpected node")
    override fun onClear() {}
}

/** Isolate a deliberate failure from the UI rule's recomposer and always dispose the failed tree. */
private fun runFailingComposition(content: @Composable () -> Unit): Throwable? {
    val recomposer = Recomposer(EmptyCoroutineContext)
    val composition = Composition(EnvironmentTestApplier(), recomposer)
    return try {
        composition.setContent(content)
        null
    } catch (failure: IllegalStateException) {
        failure
    } finally {
        composition.dispose()
        recomposer.cancel()
    }
}
