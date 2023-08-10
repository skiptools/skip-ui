// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

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
    public typealias Body = Never
    public var body: Body { fatalError() }
}


#endif
