// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view that arranges its subviews in a vertical line.
///
/// Unlike ``LazyVStack``, which only renders the views when your app needs to
/// display them, a `VStack` renders the views all at once, regardless
/// of whether they are on- or offscreen. Use the regular `VStack` when you have
/// a small number of subviews or don't want the delayed rendering behavior
/// of the "lazy" version.
///
/// The following example shows a simple vertical stack of 10 text views:
///
///     var body: some View {
///         VStack(
///             alignment: .leading,
///             spacing: 10
///         ) {
///             ForEach(
///                 1...10,
///                 id: \.self
///             ) {
///                 Text("Item \($0)")
///             }
///         }
///     }
///
/// ![Ten text views, named Item 1 through Item 10, arranged in a
/// vertical line.](SkipUI-VStack-simple.png)
///
/// > Note: If you need a vertical stack that conforms to the ``Layout``
/// protocol, like when you want to create a conditional layout using
/// ``AnyLayout``, use ``VStackLayout`` instead.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct VStack<Content> : View where Content : View {

    /// Creates an instance with the given spacing and horizontal alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack. This
    ///     guide has the same vertical screen coordinate for every subview.
    ///   - spacing: The distance between adjacent subviews, or `nil` if you
    ///     want the stack to choose a default distance for each pair of
    ///     subviews.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A vertical container that you can use in conditional layouts.
///
/// This layout container behaves like a ``VStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``VStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct VStackLayout : Layout {

    /// The horizontal alignment of subviews.
    public var alignment: HorizontalAlignment { get { fatalError() } }

    /// The distance between adjacent subviews.
    ///
    /// Set this value to `nil` to use default distances between subviews.
    public var spacing: CGFloat?

    /// Creates a vertical stack with the specified spacing and horizontal
    /// alignment.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. It
    ///       has the same horizontal screen coordinate for all subviews.
    ///     - spacing: The distance between adjacent subviews. Set this value
    ///       to `nil` to use default distances between subviews.
    @inlinable public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil) { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// Cached values associated with the layout instance.
    ///
    /// If you create a cache for your custom layout, you can use
    /// a type alias to define this type as your data storage type.
    /// Alternatively, you can refer to the data storage type directly in all
    /// the places where you work with the cache.
    ///
    /// See ``makeCache(subviews:)-23agy`` for more information.
    public typealias Cache = Never

    public func makeCache(subviews: Subviews) -> Never {
        fatalError()
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Never) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Never) {
        fatalError()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension VStackLayout : Sendable {
}

#endif
