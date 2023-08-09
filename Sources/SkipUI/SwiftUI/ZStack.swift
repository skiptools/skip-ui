// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org


/// A view that overlays its subviews, aligning them in both axes.
///
/// The `ZStack` assigns each successive subview a higher z-axis value than
/// the one before it, meaning later subviews appear "on top" of earlier ones.
///
/// The following example creates a `ZStack` of 100 x 100 point ``Rectangle``
/// views filled with one of six colors, offsetting each successive subview
/// by 10 points so they don't completely overlap:
///
///     let colors: [Color] =
///         [.red, .orange, .yellow, .green, .blue, .purple]
///
///     var body: some View {
///         ZStack {
///             ForEach(0..<colors.count) {
///                 Rectangle()
///                     .fill(colors[$0])
///                     .frame(width: 100, height: 100)
///                     .offset(x: CGFloat($0) * 10.0,
///                             y: CGFloat($0) * 10.0)
///             }
///         }
///     }
///
/// ![Six squares of different colors, stacked atop each other, with a 10-point
/// offset in both the x and y axes for each layer so they can be
/// seen.](SkipUI-ZStack-offset-rectangles.png)
///
/// The `ZStack` uses an ``Alignment`` to set the x- and y-axis coordinates of
/// each subview, defaulting to a ``Alignment/center`` alignment. In the following
/// example, the `ZStack` uses a ``Alignment/bottomLeading`` alignment to lay
/// out two subviews, a red 100 x 50 point rectangle below, and a blue 50 x 100
/// point rectangle on top. Because of the alignment value, both rectangles
/// share a bottom-left corner with the `ZStack` (in locales where left is the
/// leading side).
///
///     var body: some View {
///         ZStack(alignment: .bottomLeading) {
///             Rectangle()
///                 .fill(Color.red)
///                 .frame(width: 100, height: 50)
///             Rectangle()
///                 .fill(Color.blue)
///                 .frame(width:50, height: 100)
///         }
///         .border(Color.green, width: 1)
///     }
///
/// ![A green 100 by 100 square containing two overlapping rectangles: on the
/// bottom, a red 100 by 50 rectangle, and atop it, a blue 50 by 100 rectangle.
/// The rectangles share their bottom left point with the containing green
/// square.](SkipUI-ZStack-alignment.png)
///
/// > Note: If you need a version of this stack that conforms to the ``Layout``
/// protocol, like when you want to create a conditional layout using
/// ``AnyLayout``, use ``ZStackLayout`` instead.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ZStack<Content> : View where Content : View {

    /// Creates an instance with the given alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack on both
    ///     the x- and y-axes.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = Never

    public var body: Body { fatalError() }
}

/// An overlaying container that you can use in conditional layouts.
///
/// This layout container behaves like a ``ZStack``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``ZStack`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct ZStackLayout : Layout {
    /// The alignment of subviews.
    public var alignment: Alignment { get { fatalError() } }

    /// Creates a stack with the specified alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack
    ///     on both the x- and y-axes.
    @inlinable public init(alignment: Alignment = .center) { fatalError() }

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
    public typealias Cache = Void

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        fatalError()
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        fatalError()
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension ZStackLayout : Sendable {
}
