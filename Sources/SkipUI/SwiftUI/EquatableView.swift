// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view type that compares itself against its previous value and prevents its
/// child updating if its new value is the same as its old value.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct EquatableView<Content> : View where Content : Equatable, Content : View {

    public var content: Content { get { fatalError() } }

    @inlinable public init(content: Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never
    public var body: Body { fatalError() }
}


#endif
