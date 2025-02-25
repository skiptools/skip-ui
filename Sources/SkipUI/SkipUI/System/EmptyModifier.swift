// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP

public struct EmptyModifier : ViewModifier {
    public static let identity: EmptyModifier = EmptyModifier()

    public func body(content: Content) -> some View {
        content
    }
}

#endif
