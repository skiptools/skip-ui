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

/** Active returning providers on this thread; entries exist only during synchronous evaluation. */
private class ReturningEnvironmentProvider(
    val composer: Composer,
    val scope: RecomposeScope?,
    val values: Array<out ProvidedValue<*>>,
    val previous: ReturningEnvironmentProvider?
)

private val returningEnvironmentProvider = ThreadLocal<ReturningEnvironmentProvider?>()

/**
 * Provide values during returning evaluation without introducing another restart scope.
 * Returning composables share their caller's scope. Remember that scope only for this call so a
 * bridged reader can distinguish a provider's self-read from an independently restartable reader.
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
    composer.startProviders(values)
    val result = withReturningEnvironmentProvider(provider) { content() }
    composer.endProviders()
    return result
}

/** Restore thread-local ownership on failure as well as normal return, outside Compose's groups. */
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
            if (provider.composer === composer && provider.scope != null &&
                provider.scope === composer.recomposeScope) {
                return Snapshot.withoutReadObservation { composer.consume(local) }
            }
            break
        }
        provider = provider.previous
    }
    return local.current
}
