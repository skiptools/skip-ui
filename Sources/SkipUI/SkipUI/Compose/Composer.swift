// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.runtime.Composable

/// Mechanism for a parent to change how a child view is composed.
///
/// Composers are escaping, meaning that if the internal content needs to recompose, the calling context will also recompose.
public class Composer {
    private let compose: (@Composable (View, (Bool) -> ComposeContext) -> ComposeResult)?

    /// Optionally provide a compose block to execute instead of subclassing.
    ///
    /// - Note: This is a separate method from the default constructor rather than giving `compose` a default value to work around Kotlin runtime
    ///   crashes related to using composable closures.
    init(compose: @Composable (View, (Bool) -> ComposeContext) -> ComposeResult) {
        self.compose = compose
    }

    init() {
        self.compose = nil
    }

    @Composable public func Compose(view: View, context: (Bool) -> ComposeContext) -> ComposeResult {
        if let compose {
            return compose(view, context)
        } else {
            return ComposeResult.ok
        }
    }
}

#endif
