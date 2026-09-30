// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import androidx.compose.runtime.Composable
import androidx.compose.runtime.Composer
import androidx.compose.runtime.CompositionLocal
import androidx.compose.runtime.InternalComposeApi
import androidx.compose.runtime.ProvidedValue
import androidx.compose.runtime.RecomposeScope
import androidx.compose.runtime.currentComposer
import androidx.compose.runtime.snapshots.Snapshot

/**
 * Active returning providers on this thread; entries exist only during synchronous evaluation.
 * This is call-stack ownership, not a cache of the composition tree. A child can recompose later
 * without its provider being called, so an absent entry must always mean an ordinary tracked read.
 */
private class ReturningEnvironmentProvider(
    val composer: Composer,
    val scope: RecomposeScope?,
    val values: Array<out ProvidedValue<*>>,
    val previous: ReturningEnvironmentProvider?
)

// A second composition can run on the same thread before the first one returns. Keep a stack,
// and check composer identity as well as scope identity before attributing a read to a provider.
private val returningEnvironmentProvider = ThreadLocal<ReturningEnvironmentProvider?>()

/**
 * Provide values during returning evaluation without introducing another restart scope.
 * Returning composables share their caller's scope. Remember that scope only for this call so a
 * bridged reader can distinguish a provider's self-read from an independently restartable reader.
 *
 * A fresh opaque bridge wrapper compares unequal even when the Swift value has not changed.
 * Subscribing the supplying scope to that wrapper can make every evaluation schedule another one.
 * Dynamic locals are still needed: replacing them with static locals invalidates non-readers too.
 */
@Composable
@OptIn(InternalComposeApi::class)
internal fun <R> WithReturningEnvironmentValues(
    values: Array<out ProvidedValue<*>>,
    content: @Composable () -> R
): R {
    val composer = currentComposer
    val previous = returningEnvironmentProvider.get()
    val provider = ReturningEnvironmentProvider(
        composer, composer.recomposeScope, values, previous
    )
    // These provider calls were already required by returning evaluation. Scope identity is an
    // additional dependency on Compose internals: rerun ReturningEnvironmentTests when upgrading
    // the runtime/compiler, especially its movable-content and separate-composition cases.
    composer.startProviders(values)
    val result = withReturningEnvironmentProvider(provider) { content() }
    composer.endProviders()
    return result
}

/**
 * Restore thread-local ownership on failure as well as normal return, outside Compose's groups.
 * A failed nested composition is discarded by its caller; its tracking entry must not survive
 * and hide a still-active outer provider. The ordinary inline helper also keeps try/finally out
 * of composable control flow, which the Compose compiler does not support here.
 */
private inline fun <R> withReturningEnvironmentProvider(
    provider: ReturningEnvironmentProvider,
    content: () -> R
): R {
    returningEnvironmentProvider.set(provider)
    try {
        return content()
    } finally {
        returningEnvironmentProvider.set(provider.previous)
    }
}

/**
 * Omit only a returning provider's dependency on its own supplied value. The provider already
 * evaluates when the inputs that produce that value change. Reads from other restart scopes,
 * inherited values, and all state read after this lookup remain observed normally.
 */
@Composable
@OptIn(InternalComposeApi::class)
internal fun <T> ReadBridgedEnvironmentValue(local: CompositionLocal<T>): T {
    val composer = currentComposer
    var provider = returningEnvironmentProvider.get()
    while (provider != null) {
        if (provider.values.any { it.compositionLocal === local }) {
            // The provider's own inputs already cause this scope to run. A different scope needs
            // a real subscription, even if it is executing inside the same provider call.
            // Null is not evidence of shared ownership: fall back to normal observation.
            if (provider.composer === composer && provider.scope != null &&
                provider.scope === composer.recomposeScope) {
                // Suppress only this lookup. Wrapping content() would also suppress unrelated
                // state reads and could leave the UI stale after a legitimate state change.
                return Snapshot.withoutReadObservation { composer.consume(local) }
            }
            // A closer recorded same-key override rules out ownership by an older entry. Do not
            // find a more distant matching scope and suppress a reader of the closer override.
            break
        }
        provider = provider.previous
    }
    return local.current
}
