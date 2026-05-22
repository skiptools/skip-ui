// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import skip.model.StateTracking
#endif

// SKIP @bridge
public struct EmptyModifier : ViewModifier {
    nonisolated(unsafe) public static let identity: EmptyModifier = EmptyModifier()

    // SKIP @bridge
    public init() {
    }

    #if SKIP
    public func body(content: Content) -> some View {
        content
    }
    #endif
}

#endif
