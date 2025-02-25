// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.runtime.Composable

/// Used by the transpiler in place of SkipLib's standard `linvoke` when dealing with Composable code.
@Composable public func linvokeComposable<R>(l: @Composable () -> R) -> R {
    return l()
}
#endif
