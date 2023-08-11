// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP


/// A placeholder used to construct an inline modifier, transition, or other
/// helper type.
///
/// You don't use this type directly. Instead SkipUI creates this type on
/// your behalf.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct PlaceholderContentView<Value> : View {

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

#endif
