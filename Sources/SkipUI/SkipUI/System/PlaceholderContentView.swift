// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// A placeholder used to construct an inline modifier, transition, or other
/// helper type.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PlaceholderContentView<Value> : View {

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}
#endif
