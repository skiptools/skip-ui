// Copyright 2023–2026 Skip
#if SKIP
import androidx.compose.runtime.Composable

/// Used by the transpiler in place of SkipLib's standard `linvoke` when dealing with Composable code.
@Composable public func linvokeComposable<R>(l: @Composable () -> R) -> R {
    return l()
}
#endif
