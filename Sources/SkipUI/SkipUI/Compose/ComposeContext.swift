// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.saveable.Saver
import androidx.compose.ui.Modifier

/// Context to provide modifiers, etc to composables.
///
/// This type is often used as an argument to internal `@Composable` functions and is not mutated by reference, so mark `@Stable`
/// to avoid excessive recomposition.
@Stable public struct ComposeContext: Equatable{
    /// Modifiers to apply.
    public var modifier: Modifier = Modifier

    /// Mechanism for a parent view to change how a child view is composed.
    public var composer: Composer?

    /// Use in conjunction with `rememberSaveable` to store view state.
    public var stateSaver: Saver<Any?, Any> = ComposeStateSaver()

    /// The context to pass to child content of a container view.
    ///
    /// By default, modifiers and the `composer` are reset for child content.
    public func content(modifier: Modifier = Modifier, composer: Composer? = nil, stateSaver: Saver<Any?, Any>? = nil) -> ComposeContext {
        var context = self
        context.modifier = modifier
        context.composer = composer
        context.stateSaver = stateSaver ?? self.stateSaver
        return context
    }
}

#endif
