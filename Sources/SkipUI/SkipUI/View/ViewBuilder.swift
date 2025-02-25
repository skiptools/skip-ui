// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
// Note: @ViewBuilder support is built into the Skip transpiler.
// This file does not need SKIP support. This stub is maintained
// to allow this package to compile in Swift.

#if !SKIP_BRIDGE
#if !SKIP

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@resultBuilder public struct ViewBuilder {
    public static func buildBlock<Content: View >(_ content: Content) -> Content{
        fatalError()
    }
}

#endif
#endif
