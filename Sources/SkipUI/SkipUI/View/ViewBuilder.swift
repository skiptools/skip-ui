// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
// Note: @ViewBuilder support is built into the Skip transpiler.
// This file does not need SKIP support. This stub is maintained
// to allow this package to compile in Swift.

#if !SKIP_BRIDGE
#if !SKIP

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@resultBuilder public struct ViewBuilder {
    public static func buildBlock<Content: View >(_ content: Content) -> Content{
        return content
    }

    #if SKIP_WEB
    public static func buildBlock<C0: View, C1: View>(_ c0: C0, _ c1: C1) -> WebTupleView {
        WebTupleView(views: [c0, c1])
    }

    public static func buildBlock<C0: View, C1: View, C2: View>(_ c0: C0, _ c1: C1, _ c2: C2) -> WebTupleView {
        WebTupleView(views: [c0, c1, c2])
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> WebTupleView {
        WebTupleView(views: [c0, c1, c2, c3])
    }

    public static func buildEither<Content: View>(first content: Content) -> Content { content }
    public static func buildEither<Content: View>(second content: Content) -> Content { content }
    public static func buildOptional<Content: View>(_ content: Content?) -> any View { content ?? EmptyView() }
    #endif
}

#endif
#endif
