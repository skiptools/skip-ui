// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
/// A type-erased widget configuration.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 16.1, macOS 13.0, watchOS 9.1, *)
@available(tvOS, unavailable)
@frozen public struct LimitedAvailabilityConfiguration : WidgetConfiguration {

    /// The type of widget configuration representing the body of
    /// this configuration.
    ///
    /// When you create a custom widget, Swift infers this type from your
    /// implementation of the required `body` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}
#endif
