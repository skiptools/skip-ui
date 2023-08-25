// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize

/// No-op
@usableFromInline func stubShape() -> some Shape {
    return never()
}

/// A 2D shape that you can use when drawing a view.
///
/// Shapes without an explicit fill or stroke get a default fill based on the
/// foreground color.
///
/// You can define shapes in relation to an implicit frame of reference, such as
/// the natural size of the view that contains it. Alternatively, you can define
/// shapes in terms of absolute coordinates.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol Shape : Sendable, Animatable, View {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    func path(in rect: CGRect) -> Path

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var role: ShapeRole { get }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    var layoutDirectionBehavior: LayoutDirectionBehavior { get }

    /// Returns the size of the view that will render the shape, given
    /// a proposed size.
    ///
    /// Implement this method to tell the container of the shape how
    /// much space the shape needs to render itself, given a size
    /// proposal.
    ///
    /// See ``Layout/sizeThatFits(proposal:subviews:cache:)``
    /// for more details about how the layout system chooses the size of
    /// views.
    ///
    /// - Parameters:
    ///   - proposal: A size proposal for the container.
    ///
    /// - Returns: A size that indicates how much space the shape needs.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize
}


/// A type-erased shape value.
///
/// You can use this type to dynamically switch between shape types:
///
///     struct MyClippedView: View {
///         var isCircular: Bool
///
///         var body: some View {
///             OtherView().clipShape(isCircular ?
///                 AnyShape(Circle()) : AnyShape(Capsule()))
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct AnyShape : Shape, @unchecked Sendable {

    /// Create an any shape instance from a shape.
    public init<S>(_ shape: S) where S : Shape { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Returns the size of the view that will render the shape, given
    /// a proposed size.
    ///
    /// Implement this method to tell the container of the shape how
    /// much space the shape needs to render itself, given a size
    /// proposal.
    ///
    /// See ``Layout/sizeThatFits(proposal:subviews:cache:)``
    /// for more details about how the layout system chooses the size of
    /// views.
    ///
    /// - Parameters:
    ///   - proposal: A size proposal for the container.
    ///
    /// - Returns: A size that indicates how much space the shape needs.
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = Never

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Shape {

    /// Returns a new shape with filled regions common to both shapes.
    ///
    /// - Parameters:
    ///   - other: The shape to intersect.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the shapes (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new shape.
    ///
    /// The filled region of the resulting shape is the overlapping area
    /// of the filled region of both shapes.  This can be used to clip
    /// the fill of a shape to a mask.
    ///
    /// Any unclosed subpaths in either shape are assumed to be closed.
    /// The result of filling this shape using either even-odd or
    /// non-zero fill rules is identical.
    public func intersection<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { return stubShape() }


    /// Returns a new shape with filled regions in either this shape or
    /// the given shape.
    ///
    /// - Parameters:
    ///   - other: The shape to union.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the shapes (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new shape.
    ///
    /// The filled region of resulting shape is the combination of the
    /// filled region of both shapes added together.
    ///
    /// Any unclosed subpaths in either shape are assumed to be closed.
    /// The result of filling this shape using either even-odd or
    /// non-zero fill rules is identical.
    public func union<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { return stubShape() }


    /// Returns a new shape with filled regions from this shape that are
    /// not in the given shape.
    ///
    /// - Parameters:
    ///   - other: The shape to subtract.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the shapes (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new shape.
    ///
    /// The filled region of the resulting shape is the filled region of
    /// this shape with the filled  region `other` removed from it.
    ///
    /// Any unclosed subpaths in either shape are assumed to be closed.
    /// The result of filling this shape using either even-odd or
    /// non-zero fill rules is identical.
    public func subtracting<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { return stubShape() }


    /// Returns a new shape with filled regions either from this shape or
    /// the given shape, but not in both.
    ///
    /// - Parameters:
    ///   - other: The shape to difference.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the shapes (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new shape.
    ///
    /// The filled region of the resulting shape is the filled region
    /// contained in either this shape or `other`, but not both.
    ///
    /// Any unclosed subpaths in either shape are assumed to be closed.
    /// The result of filling this shape using either even-odd or
    /// non-zero fill rules is identical.
    public func symmetricDifference<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { return stubShape() }


    /// Returns a new shape with a line from this shape that overlaps the
    /// filled regions of the given shape.
    ///
    /// - Parameters:
    ///   - other: The shape to intersect.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the shapes (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new shape.
    ///
    /// The line of the resulting shape is the line of this shape that
    /// overlaps the filled region of `other`.
    ///
    /// Intersected subpaths that are clipped create open subpaths.
    /// Closed subpaths that do not intersect `other` remain closed.
    public func lineIntersection<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { return stubShape() }


    /// Returns a new shape with a line from this shape that does not
    /// overlap the filled region of the given shape.
    ///
    /// - Parameters:
    ///   - other: The shape to subtract.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the shapes (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new shape.
    ///
    /// The line of the resulting shape is the line of this shape that
    /// does not overlap the filled region of `other`.
    ///
    /// Intersected subpaths that are clipped create open subpaths.
    /// Closed subpaths that do not intersect `other` remain closed.
    public func lineSubtraction<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { return stubShape() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {

    /// Trims this shape by a fractional amount based on its representation as a
    /// path.
    ///
    /// To create a `Shape` instance, you define the shape's path using lines and
    /// curves. Use the `trim(from:to:)` method to draw a portion of a shape by
    /// ignoring portions of the beginning and ending of the shape's path.
    ///
    /// For example, if you're drawing a figure eight or infinity symbol (∞)
    /// starting from its center, setting the `startFraction` and `endFraction`
    /// to different values determines the parts of the overall shape.
    ///
    /// The following example shows a simplified infinity symbol that draws
    /// only three quarters of the full shape. That is, of the two lobes of the
    /// symbol, one lobe is complete and the other is half complete.
    ///
    ///     Path { path in
    ///         path.addLines([
    ///             .init(x: 2, y: 1),
    ///             .init(x: 1, y: 0),
    ///             .init(x: 0, y: 1),
    ///             .init(x: 1, y: 2),
    ///             .init(x: 3, y: 0),
    ///             .init(x: 4, y: 1),
    ///             .init(x: 3, y: 2),
    ///             .init(x: 2, y: 1)
    ///         ])
    ///     }
    ///     .trim(from: 0.25, to: 1.0)
    ///     .scale(50, anchor: .topLeading)
    ///     .stroke(Color.black, lineWidth: 3)
    ///
    /// Changing the parameters of `trim(from:to:)` to
    /// `.trim(from: 0, to: 1)` draws the full infinity symbol, while
    /// `.trim(from: 0, to: 0.5)` draws only the left lobe of the symbol.
    ///
    /// - Parameters:
    ///   - startFraction: The fraction of the way through drawing this shape
    ///     where drawing starts.
    ///   - endFraction: The fraction of the way through drawing this shape
    ///     where drawing ends.
    /// - Returns: A shape built by capturing a portion of this shape's path.
    @inlinable public func trim(from startFraction: CGFloat = 0, to endFraction: CGFloat = 1) -> some Shape { return stubShape() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {

    /// Changes the relative position of this shape using the specified size.
    ///
    /// The following example renders two circles. It places one circle at its
    /// default position. The second circle is outlined with a stroke,
    /// positioned on top of the first circle and offset by 100 points to the
    /// left and 50 points below.
    ///
    ///     Circle()
    ///     .overlay(
    ///         Circle()
    ///         .offset(CGSize(width: -100, height: 50))
    ///         .stroke()
    ///     )
    ///
    /// - Parameter offset: The amount, in points, by which you offset the
    ///   shape. Negative numbers are to the left and up; positive numbers are
    ///   to the right and down.
    ///
    /// - Returns: A shape offset by the specified amount.
    @inlinable public func offset(_ offset: CGSize) -> OffsetShape<Self> { fatalError() }

    /// Changes the relative position of this shape using the specified point.
    ///
    /// The following example renders two circles. It places one circle at its
    /// default position. The second circle is outlined with a stroke,
    /// positioned on top of the first circle and offset by 100 points to the
    /// left and 50 points below.
    ///
    ///     Circle()
    ///     .overlay(
    ///         Circle()
    ///         .offset(CGPoint(x: -100, y: 50))
    ///         .stroke()
    ///     )
    ///
    /// - Parameter offset: The amount, in points, by which you offset the
    ///   shape. Negative numbers are to the left and up; positive numbers are
    ///   to the right and down.
    ///
    /// - Returns: A shape offset by the specified amount.
    @inlinable public func offset(_ offset: CGPoint) -> OffsetShape<Self> { fatalError() }

    /// Changes the relative position of this shape using the specified point.
    ///
    /// The following example renders two circles. It places one circle at its
    /// default position. The second circle is outlined with a stroke,
    /// positioned on top of the first circle and offset by 100 points to the
    /// left and 50 points below.
    ///
    ///     Circle()
    ///     .overlay(
    ///         Circle()
    ///         .offset(x: -100, y: 50)
    ///         .stroke()
    ///     )
    ///
    /// - Parameters:
    ///   - x: The horizontal amount, in points, by which you offset the shape.
    ///     Negative numbers are to the left and positive numbers are to the
    ///     right.
    ///   - y: The vertical amount, in points, by which you offset the shape.
    ///     Negative numbers are up and positive numbers are down.
    ///
    /// - Returns: A shape offset by the specified amount.
    @inlinable public func offset(x: CGFloat = 0, y: CGFloat = 0) -> OffsetShape<Self> { fatalError() }

    /// Scales this shape without changing its bounding frame.
    ///
    /// Both the `x` and `y` multiplication factors halve their respective
    /// dimension's size when set to `0.5`, maintain their existing size when
    /// set to `1`, double their size when set to `2`, and so forth.
    ///
    /// - Parameters:
    ///   - x: The multiplication factor used to resize this shape along its
    ///     x-axis.
    ///   - y: The multiplication factor used to resize this shape along its
    ///     y-axis.
    ///
    /// - Returns: A scaled form of this shape.
    @inlinable public func scale(x: CGFloat = 1, y: CGFloat = 1, anchor: UnitPoint = .center) -> ScaledShape<Self> { fatalError() }

    /// Scales this shape without changing its bounding frame.
    ///
    /// - Parameter scale: The multiplication factor used to resize this shape.
    ///   A value of `0` scales the shape to have no size, `0.5` scales to half
    ///   size in both dimensions, `2` scales to twice the regular size, and so
    ///   on.
    ///
    /// - Returns: A scaled form of this shape.
    @inlinable public func scale(_ scale: CGFloat, anchor: UnitPoint = .center) -> ScaledShape<Self> { fatalError() }

    /// Rotates this shape around an anchor point at the angle you specify.
    ///
    /// The following example rotates a square by 45 degrees to the right to
    /// create a diamond shape:
    ///
    ///     RoundedRectangle(cornerRadius: 10)
    ///     .rotation(Angle(degrees: 45))
    ///     .aspectRatio(1.0, contentMode: .fit)
    ///
    /// - Parameters:
    ///   - angle: The angle of rotation to apply. Positive angles rotate
    ///     clockwise; negative angles rotate counterclockwise.
    ///   - anchor: The point to rotate the shape around.
    ///
    /// - Returns: A rotated shape.
    @inlinable public func rotation(_ angle: Angle, anchor: UnitPoint = .center) -> RotatedShape<Self> { fatalError() }

    /// Applies an affine transform to this shape.
    ///
    /// Affine transforms present a mathematical approach to applying
    /// combinations of rotation, scaling, translation, and skew to shapes.
    ///
    /// - Parameter transform: The affine transformation matrix to apply to this
    ///   shape.
    ///
    /// - Returns: A transformed shape, based on its matrix values.
    @inlinable public func transform(_ transform: CGAffineTransform) -> TransformedShape<Self> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape where Self == Rectangle {

    /// A rectangular shape aligned inside the frame of the view containing it.
    public static var rect: Rectangle { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape where Self == RoundedRectangle {

    /// A rectangular shape with rounded corners, aligned inside the frame of
    /// the view containing it.
    public static func rect(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) -> Self { fatalError() }

    /// A rectangular shape with rounded corners, aligned inside the frame of
    /// the view containing it.
    public static func rect(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) -> Self { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Shape where Self == UnevenRoundedRectangle {

    /// A rectangular shape with rounded corners with different values, aligned
    /// inside the frame of the view containing it.
    public static func rect(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) -> Self { fatalError() }

    /// A rectangular shape with rounded corners with different values, aligned
    /// inside the frame of the view containing it.
    public static func rect(topLeadingRadius: CGFloat = 0, bottomLeadingRadius: CGFloat = 0, bottomTrailingRadius: CGFloat = 0, topTrailingRadius: CGFloat = 0, style: RoundedCornerStyle = .continuous) -> Self { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape where Self == Capsule {

    /// A capsule shape aligned inside the frame of the view containing it.
    ///
    /// A capsule shape is equivalent to a rounded rectangle where the corner
    /// radius is chosen as half the length of the rectangle's smallest edge.
    public static var capsule: Capsule { get { fatalError() } }

    /// A capsule shape aligned inside the frame of the view containing it.
    ///
    /// A capsule shape is equivalent to a rounded rectangle where the corner
    /// radius is chosen as half the length of the rectangle's smallest edge.
    public static func capsule(style: RoundedCornerStyle) -> Self { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape where Self == Ellipse {

    /// An ellipse aligned inside the frame of the view containing it.
    public static var ellipse: Ellipse { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape where Self == Circle {

    /// A circle centered on the frame of the view containing it.
    ///
    /// The circle's radius equals half the length of the frame rectangle's
    /// smallest edge.
    public static var circle: Circle { get { fatalError() } }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Shape where Self == ContainerRelativeShape {

    /// A shape that is replaced by an inset version of the current
    /// container shape. If no container shape was defined, is replaced by
    /// a rectangle.
    public static var containerRelative: ContainerRelativeShape { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {

    /// Returns a new version of self representing the same shape, but
    /// that will ask it to create its path from a rect of `size`. This
    /// does not affect the layout properties of any views created from
    /// the shape (e.g. by filling it).
    @inlinable public func size(_ size: CGSize) -> some Shape { return stubShape() }


    /// Returns a new version of self representing the same shape, but
    /// that will ask it to create its path from a rect of size
    /// `(width, height)`. This does not affect the layout properties
    /// of any views created from the shape (e.g. by filling it).
    @inlinable public func size(width: CGFloat, height: CGFloat) -> some Shape { return stubShape() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Shape {

    /// Returns the original proposal, with nil components replaced by
    /// a small positive value.
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize { fatalError() }
}

extension Shape {

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var role: ShapeRole { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Shape {

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Shape {

    /// Fills this shape with a color or gradient.
    ///
    /// - Parameters:
    ///   - content: The color or gradient to use when filling this shape.
    ///   - style: The style options that determine how the fill renders.
    /// - Returns: A shape filled with the color or gradient you supply.
//    public func fill<S>(_ content: S = .foreground, style: FillStyle = FillStyle()) -> _ShapeView<Self, S> where S : ShapeStyle { fatalError() }

    /// Traces the outline of this shape with a color or gradient.
    ///
    /// The following example adds a dashed purple stroke to a `Capsule`:
    ///
    ///     Capsule()
    ///     .stroke(
    ///         Color.purple,
    ///         style: StrokeStyle(
    ///             lineWidth: 5,
    ///             lineCap: .round,
    ///             lineJoin: .miter,
    ///             miterLimit: 0,
    ///             dash: [5, 10],
    ///             dashPhase: 0
    ///         )
    ///     )
    ///
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - style: The stroke characteristics --- such as the line's width and
    ///     whether the stroke is dashed --- that determine how to render this
    ///     shape.
    /// - Returns: A stroked shape.
    public func stroke<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> StrokeShapeView<Self, S, EmptyView> where S : ShapeStyle { fatalError() }

    /// Traces the outline of this shape with a color or gradient.
    ///
    /// The following example draws a circle with a purple stroke:
    ///
    ///     Circle().stroke(Color.purple, lineWidth: 5)
    ///
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - lineWidth: The width of the stroke that outlines this shape.
    /// - Returns: A stroked shape.
    public func stroke<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeShapeView<Self, S, EmptyView> where S : ShapeStyle { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {

    /// Fills this shape with a color or gradient.
    ///
    /// - Parameters:
    ///   - content: The color or gradient to use when filling this shape.
    ///   - style: The style options that determine how the fill renders.
    /// - Returns: A shape filled with the color or gradient you supply.
    @inlinable public func fill<S>(_ content: S, style: FillStyle = FillStyle()) -> some View where S : ShapeStyle { return stubView() }


    /// Fills this shape with the foreground color.
    ///
    /// - Parameter style: The style options that determine how the fill
    ///   renders.
    /// - Returns: A shape filled with the foreground color.
    @inlinable public func fill(style: FillStyle = FillStyle()) -> some View { return stubView() }


    /// Traces the outline of this shape with a color or gradient.
    ///
    /// The following example adds a dashed purple stroke to a `Capsule`:
    ///
    ///     Capsule()
    ///     .stroke(
    ///         Color.purple,
    ///         style: StrokeStyle(
    ///             lineWidth: 5,
    ///             lineCap: .round,
    ///             lineJoin: .miter,
    ///             miterLimit: 0,
    ///             dash: [5, 10],
    ///             dashPhase: 0
    ///         )
    ///     )
    ///
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - style: The stroke characteristics --- such as the line's width and
    ///     whether the stroke is dashed --- that determine how to render this
    ///     shape.
    /// - Returns: A stroked shape.
    @inlinable public func stroke<S>(_ content: S, style: StrokeStyle) -> some View where S : ShapeStyle { return stubView() }


    /// Traces the outline of this shape with a color or gradient.
    ///
    /// The following example draws a circle with a purple stroke:
    ///
    ///     Circle().stroke(Color.purple, lineWidth: 5)
    ///
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - lineWidth: The width of the stroke that outlines this shape.
    /// - Returns: A stroked shape.
    @inlinable public func stroke<S>(_ content: S, lineWidth: CGFloat = 1) -> some View where S : ShapeStyle { return stubView() }

}

/// A shape acts as view by filling itself with the foreground color and
/// default fill style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {

    //public var body: _ShapeView<Self, ForegroundStyle> { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {

    /// Returns a new shape that is a stroked copy of `self`, using the
    /// contents of `style` to define the stroke characteristics.
    @inlinable public func stroke(style: StrokeStyle) -> some Shape { return stubShape() }


    /// Returns a new shape that is a stroked copy of `self` with
    /// line-width defined by `lineWidth` and all other properties of
    /// `StrokeStyle` having their default values.
    @inlinable public func stroke(lineWidth: CGFloat = 1) -> some Shape { return stubShape() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Shape where Self == ButtonBorderShape {

    /// A shape that defers to the environment to determine the resolved button border shape.
    ///
    /// You can override the resolved shape in a given view hierarchy by using
    /// the ``View/buttonBorderShape(_:)`` modifier. If no button border shape
    /// is specified, it is resolved automatically for the given context and platform.
    public static var buttonBorder: ButtonBorderShape { get { fatalError() } }
}

/// Ways of styling a shape.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ShapeRole : Sendable {

    /// Indicates to the shape's style that SkipUI fills the shape.
    case fill

    /// Indicates to the shape's style that SkipUI applies a stroke to
    /// the shape's path.
    case stroke

    /// Indicates to the shape's style that SkipUI uses the shape as a
    /// separator.
    case separator

    


}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ShapeRole : Equatable {
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ShapeRole : Hashable {
}

/// A shape with an affine transform applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct TransformedShape<Content> : Shape where Content : Shape {

    public var shape: Content { get { fatalError() } }

    public var transform: CGAffineTransform { get { fatalError() } }

    @inlinable public init(shape: Content, transform: CGAffineTransform) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var role: ShapeRole { get { fatalError() } }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = Content.AnimatableData

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A rectangular shape aligned inside the frame of the view containing it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Rectangle : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// Creates a new rectangle shape.
    @inlinable public init() { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Rectangle : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// Describes the corner radius values of a rounded rectangle with
/// uneven corners.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct RectangleCornerRadii : Equatable, Animatable {

    /// The radius of the top-leading corner.
    public var topLeading: CGFloat { get { fatalError() } }

    /// The radius of the bottom-leading corner.
    public var bottomLeading: CGFloat { get { fatalError() } }

    /// The radius of the bottom-trailing corner.
    public var bottomTrailing: CGFloat { get { fatalError() } }

    /// The radius of the top-trailing corner.
    public var topTrailing: CGFloat { get { fatalError() } }

    /// Creates a new set of corner radii for a rounded rectangle with
    /// uneven corners.
    ///
    /// - Parameters:
    ///   - topLeading: the radius of the top-leading corner.
    ///   - bottomLeading: the radius of the bottom-leading corner.
    ///   - bottomTrailing: the radius of the bottom-trailing corner.
    ///   - topTrailing: the radius of the top-trailing corner.
    public init(topLeading: CGFloat = 0, bottomLeading: CGFloat = 0, bottomTrailing: CGFloat = 0, topTrailing: CGFloat = 0) { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension RectangleCornerRadii : Sendable {
}

/// A shape with a rotation transform applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct RotatedShape<Content> : Shape where Content : Shape {

    public var shape: Content { get { fatalError() } }

    public var angle: Angle { get { fatalError() } }

    public var anchor: UnitPoint { get { fatalError() } }

    @inlinable public init(shape: Content, angle: Angle, anchor: UnitPoint = .center) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var role: ShapeRole { get { fatalError() } }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = AnimatablePair<Content.AnimatableData, AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RotatedShape : InsettableShape where Content : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> RotatedShape<Content.InsetShape> { fatalError() }

    /// The type of the inset shape.
    public typealias InsetShape = RotatedShape<Content.InsetShape>
}

/// A rectangular shape with rounded corners, aligned inside the frame of the
/// view containing it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct RoundedRectangle : Shape {

    /// The width and height of the rounded rectangle's corners.
    public var cornerSize: CGSize { get { fatalError() } }

    /// The style of corners drawn by the rounded rectangle.
    public var style: RoundedCornerStyle { get { fatalError() } }

    /// Creates a new rounded rectangle shape.
    ///
    /// - Parameters:
    ///   - cornerSize: the width and height of the rounded corners.
    ///   - style: the style of corners drawn by the shape.
    @inlinable public init(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Creates a new rounded rectangle shape.
    ///
    /// - Parameters:
    ///   - cornerRadius: the radius of the rounded corners.
    ///   - style: the style of corners drawn by the shape.
    @inlinable public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The data to animate.
//    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = Never // CGSize.AnimatableData

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RoundedRectangle : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A capsule shape aligned inside the frame of the view containing it.
///
/// A capsule shape is equivalent to a rounded rectangle where the corner radius
/// is chosen as half the length of the rectangle's smallest edge.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Capsule : Shape {
    public var style: RoundedCornerStyle { get { fatalError() } }

    /// Creates a new capsule shape.
    ///
    /// - Parameters:
    ///   - style: the style of corners drawn by the shape.
    @inlinable public init(style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in r: CGRect) -> Path { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Capsule : InsettableShape {
    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { stub() as Never }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A shape that is replaced by an inset version of the current
/// container shape. If no container shape was defined, is replaced by
/// a rectangle.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen public struct ContainerRelativeShape : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    @inlinable public init() { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ContainerRelativeShape : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A circle centered on the frame of the view containing it.
///
/// The circle's radius equals half the length of the frame rectangle's smallest
/// edge.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Circle : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Creates a new circle shape.
    @inlinable public init() { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Circle {

    /// Returns the size of the view that will render the shape, given
    /// a proposed size.
    ///
    /// Implement this method to tell the container of the shape how
    /// much space the shape needs to render itself, given a size
    /// proposal.
    ///
    /// See ``Layout/sizeThatFits(proposal:subviews:cache:)``
    /// for more details about how the layout system chooses the size of
    /// views.
    ///
    /// - Parameters:
    ///   - proposal: A size proposal for the container.
    ///
    /// - Returns: A size that indicates how much space the shape needs.
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Circle : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A shape with a scale transform applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ScaledShape<Content> : Shape where Content : Shape {

    public var shape: Content { get { fatalError() } }

    public var scale: CGSize { get { fatalError() } }

    public var anchor: UnitPoint { get { fatalError() } }

    @inlinable public init(shape: Content, scale: CGSize, anchor: UnitPoint = .center) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var role: ShapeRole { get { fatalError() } }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = Never // AnimatablePair<Content.AnimatableData, AnimatablePair<CGSize.AnimatableData, UnitPoint.AnimatableData>>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A rectangular shape with rounded corners with different values, aligned
/// inside the frame of the view containing it.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct UnevenRoundedRectangle : Shape {

    /// The radii of each corner of the rounded rectangle.
    public var cornerRadii: RectangleCornerRadii { get { fatalError() } }

    /// The style of corners drawn by the rounded rectangle.
    public var style: RoundedCornerStyle { get { fatalError() } }

    /// Creates a new rounded rectangle shape with uneven corners.
    ///
    /// - Parameters:
    ///   - cornerRadii: the radii of each corner.
    ///   - style: the style of corners drawn by the shape.
    @inlinable public init(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Creates a new rounded rectangle shape with uneven corners.
    public init(topLeadingRadius: CGFloat = 0, bottomLeadingRadius: CGFloat = 0, bottomTrailingRadius: CGFloat = 0, topTrailingRadius: CGFloat = 0, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = RectangleCornerRadii.AnimatableData

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension UnevenRoundedRectangle : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// An ellipse aligned inside the frame of the view containing it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Ellipse : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// Creates a new ellipse shape.
    @inlinable public init() { fatalError() }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Ellipse : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

/// A shape type that is able to inset itself to produce another shape.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol InsettableShape : Shape {

    /// The type of the inset shape.
    associatedtype InsetShape : InsettableShape

    /// Returns `self` inset by `amount`.
    func inset(by amount: CGFloat) -> Self.InsetShape
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension InsettableShape {

    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with `content`.
    @inlinable public func strokeBorder<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> some View where S : ShapeStyle { return stubView() }


    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with the foreground color.
    @inlinable public func strokeBorder(style: StrokeStyle, antialiased: Bool = true) -> some View { return stubView() }


    /// Returns a view that is the result of filling the `lineWidth`-sized
    /// border (aka inner stroke) of `self` with `content`. This is
    /// equivalent to insetting `self` by `lineWidth / 2` and stroking the
    /// resulting shape with `lineWidth` as the line-width.
    @inlinable public func strokeBorder<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View where S : ShapeStyle { return stubView() }


    /// Returns a view that is the result of filling the `lineWidth`-sized
    /// border (aka inner stroke) of `self` with the foreground color.
    /// This is equivalent to insetting `self` by `lineWidth / 2` and
    /// stroking the resulting shape with `lineWidth` as the line-width.
    @inlinable public func strokeBorder(lineWidth: CGFloat = 1, antialiased: Bool = true) -> some View { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension InsettableShape {

    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with `content`.
    public func strokeBorder<S>(_ content: S = .foreground, style: StrokeStyle, antialiased: Bool = true) -> StrokeBorderShapeView<Self, S, EmptyView> where S : ShapeStyle { fatalError() }

    /// Returns a view that is the result of filling the `lineWidth`-sized
    /// border (aka inner stroke) of `self` with `content`. This is
    /// equivalent to insetting `self` by `lineWidth / 2` and stroking the
    /// resulting shape with `lineWidth` as the line-width.
    public func strokeBorder<S>(_ content: S = .foreground, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeBorderShapeView<Self, S, EmptyView> where S : ShapeStyle { fatalError() }
}

/// A shape with a translation offset transform applied to it.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct OffsetShape<Content> : Shape where Content : Shape {

    public var shape: Content { get { fatalError() } }

    public var offset: CGSize { get { fatalError() } }

    @inlinable public init(shape: Content, offset: CGSize) { fatalError() }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path { fatalError() }

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var role: ShapeRole { get { fatalError() } }

    /// Returns the behavior this shape should use for different layout
    /// directions.
    ///
    /// If the layoutDirectionBehavior for a Shape is one that mirrors, the
    /// shape's path will be mirrored horizontally when in the specified layout
    /// direction. When mirrored, the individual points of the path will be
    /// transformed.
    ///
    /// Defaults to `.mirrors` when deploying on iOS 17.0, macOS 14.0,
    /// tvOS 17.0, watchOS 10.0 and later, and to `.fixed` if not.
    /// To mirror a path when deploying to earlier releases, either use
    /// `View.flipsForRightToLeftLayoutDirection` for a filled or stroked
    /// shape or conditionally mirror the points in the path of the shape.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    /// The type defining the data to animate.
    public typealias AnimatableData = Never // AnimatablePair<Content.AnimatableData, CGSize.AnimatableData>

    /// The data to animate.
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension OffsetShape : InsettableShape where Content : InsettableShape {

    /// Returns `self` inset by `amount`.
    @inlinable public func inset(by amount: CGFloat) -> OffsetShape<Content.InsetShape> { fatalError() }

    /// The type of the inset shape.
    public typealias InsetShape = OffsetShape<Content.InsetShape>
}

extension Never : Shape {
    public typealias AnimatableData = Never
    public var animatableData: AnimatableData { get { fatalError() } set { fatalError() } }

    public func path(in rect: CGRect) -> Path {
        fatalError()
    }
}

extension Never : InsettableShape {
    public func inset(by amount: CGFloat) -> Never {
        fatalError()
    }
}

#endif
