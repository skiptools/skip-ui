// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import skip.model.StateTracking
#endif

// SKIP @bridge
public struct EmptyModifier : ViewModifier {
    public static let identity: EmptyModifier = EmptyModifier()

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
