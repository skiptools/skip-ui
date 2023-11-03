// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

public protocol Shape: View, Sendable {
}

extension Shape where Self == Circle {
    // SKIP NOWARN
    @available(*, unavailable)
    public static var circle: Circle {
        fatalError()
        //return Circle()
    }
}

extension Shape where Self == Rectangle {
    // SKIP NOWARN
    @available(*, unavailable)
    public static var rect: Rectangle {
        fatalError()
        //return Rectangle()
    }
}

extension Shape where Self == RoundedRectangle {
    // SKIP NOWARN
    @available(*, unavailable)
    public static func rect(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
        fatalError()
        //return RoundedRectangle(cornerSize: cornerSize, style: style)
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public static func rect(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
        fatalError()
        //return RoundedRectangle(cornerRadius: cornerRadius, style: style)
    }
}

extension Shape where Self == UnevenRoundedRectangle {
    // SKIP NOWARN
    @available(*, unavailable)
    public static func rect(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) -> UnevenRoundedRectangle {
        fatalError()
        // return UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style)
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public static func rect(topLeadingRadius: CGFloat = 0.0, bottomLeadingRadius: CGFloat = 0.0, bottomTrailingRadius: CGFloat = 0.0, topTrailingRadius: CGFloat = 0.0, style: RoundedCornerStyle = .continuous) -> UnevenRoundedRectangle {
        fatalError()
        // return UnevenRoundedRectangle(topLeadingRadius: topLeadingRadius, bottomLeadingRadius: bottomLeadingRadius, bottomTrailingRadius: bottomTrailingRadius, topTrailingRadius: topTrailingRadius, style: style)
    }
}

extension Shape where Self == Capsule {
    // SKIP NOWARN
    @available(*, unavailable)
    public static var capsule: Capsule {
        fatalError()
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public static func capsule(style: RoundedCornerStyle) -> Capsule {
        fatalError()
    }
}

extension Shape where Self == Ellipse {
    // SKIP NOWARN
    @available(*, unavailable)
    public static var ellipse: Ellipse {
        fatalError()
    }
}

public final class Circle : Shape {
    @available(*, unavailable)
    public init() {
    }

    #if SKIP

    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public final class Rectangle : Shape {
    @available(*, unavailable)
    public init() {
    }

    #if SKIP
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public final class RoundedRectangle : Shape {
    public let cornerSize: CGSize
    public let style: RoundedCornerStyle

    @available(*, unavailable)
    public init(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) {
        self.cornerSize = cornerSize
        self.style = style
    }

    @available(*, unavailable)
    public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        self.cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        self.style = style
    }

    #if SKIP
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public final class UnevenRoundedRectangle : Shape {
    public let cornerRadii: RectangleCornerRadii
    public let style: RoundedCornerStyle

    @available(*, unavailable)
    public init(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) {
        self.cornerRadii = cornerRadii
        self.style = style
    }

    @available(*, unavailable)
    public init(topLeadingRadius: CGFloat = 0.0, bottomLeadingRadius: CGFloat = 0.0, bottomTrailingRadius: CGFloat = 0.0, topTrailingRadius: CGFloat = 0.0, style: RoundedCornerStyle = .continuous) {
        self.cornerRadii = RectangleCornerRadii(topLeading: topLeadingRadius, bottomLeading: bottomLeadingRadius, bottomTrailing: bottomTrailingRadius, topTrailing: topTrailingRadius)
        self.style = style
    }

    #if SKIP
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias AnimatableData = RectangleCornerRadii.AnimatableData
    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public final class Capsule : Shape {
    public let style: RoundedCornerStyle

    @available(*, unavailable)
    public init(style: RoundedCornerStyle = .continuous) {
        self.style = style
    }

    #if SKIP
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public final class Ellipse : Shape {
    @available(*, unavailable)
    public init() {
    }

    #if SKIP
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public final class AnyShape : Shape, Sendable {
    private let shape: any Shape

    public init(_ shape: any Shape) {
        self.shape = shape
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        shape.Compose(context: context)
    }
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif
}

public struct RectangleCornerRadii : Equatable, Sendable /*, Animatable */ {
    public let topLeading: CGFloat
    public let bottomLeading: CGFloat
    public let bottomTrailing: CGFloat
    public let topTrailing: CGFloat

    public init(topLeading: CGFloat = 0.0, bottomLeading: CGFloat = 0.0, bottomTrailing: CGFloat = 0.0, topTrailing: CGFloat = 0.0) {
        self.topLeading = topLeading
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
        self.topTrailing = topTrailing
    }

    #if !SKIP
    public typealias AnimatableData = AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>
    public var animatableData: AnimatableData { get { fatalError() } set { } }
    #endif
}

extension Shape {
    @available(*, unavailable)
    public func stroke(_ content: any ShapeStyle, style: StrokeStyle, antialiased: Bool = true) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func stroke(_ content: any ShapeStyle, lineWidth: CGFloat = 1.0, antialiased: Bool = true) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func fill(_ content: any ShapeStyle, style: FillStyle = FillStyle()) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func fill(style: FillStyle = FillStyle()) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func stroke(_ content: any ShapeStyle, style: StrokeStyle) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func stroke(_ content: any ShapeStyle, lineWidth: CGFloat = 1.0) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func stroke(style: StrokeStyle) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func stroke(lineWidth: CGFloat = 1.0) -> any Shape {
        return self
    }

    @available(*, unavailable)
    public func strokeBorder(_ content: any ShapeStyle = .foreground, style: StrokeStyle, antialiased: Bool = true) -> any View {
        return self
    }

    @available(*, unavailable)
    public func strokeBorder(style: StrokeStyle, antialiased: Bool = true) -> any View {
        return self
    }

    @available(*, unavailable)
    public func strokeBorder(_ content: any ShapeStyle = .foreground, lineWidth: CGFloat = 1.0, antialiased: Bool = true) -> any View {
        return self
    }

    @available(*, unavailable)
    public func strokeBorder(lineWidth: CGFloat = 1.0, antialiased: Bool = true) -> any View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize

/// No-op
func stubShape() -> some Shape {
    //return never() // raises warning: “A call to a never-returning function”
    struct NeverShape : Shape {
        typealias AnimatableData = Never
        typealias Body = Never
        var body: Body { fatalError() }
        func path(in rect: CGRect) -> Path { fatalError() }
    }
    return NeverShape()
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
extension Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    func path(in rect: CGRect) -> Path { fatalError() }

    /// An indication of how to style a shape.
    ///
    /// SkipUI looks at a shape's role when deciding how to apply a
    /// ``ShapeStyle`` at render time. The ``Shape`` protocol provides a
    /// default implementation with a value of ``ShapeRole/fill``. If you
    /// create a composite shape, you can provide an override of this property
    /// to return another value, if appropriate.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var role: ShapeRole { get { fatalError() } }

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
    var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

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
    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize { fatalError() }
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
    public func intersection<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { stubShape() }


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
    public func union<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { stubShape() }


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
    public func subtracting<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { stubShape() }


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
    public func symmetricDifference<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { stubShape() }


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
    public func lineIntersection<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { stubShape() }


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
    public func lineSubtraction<T>(_ other: T, eoFill: Bool = false) -> some Shape where T : Shape { stubShape() }

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
    public func trim(from startFraction: CGFloat = 0, to endFraction: CGFloat = 1) -> some Shape { stubShape() }

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
    public func offset(_ offset: CGSize) -> OffsetShape<Self> { fatalError() }

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
    public func offset(_ offset: CGPoint) -> OffsetShape<Self> { fatalError() }

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
    public func offset(x: CGFloat = 0, y: CGFloat = 0) -> OffsetShape<Self> { fatalError() }

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
    public func scale(x: CGFloat = 1, y: CGFloat = 1, anchor: UnitPoint = .center) -> ScaledShape<Self> { fatalError() }

    /// Scales this shape without changing its bounding frame.
    ///
    /// - Parameter scale: The multiplication factor used to resize this shape.
    ///   A value of `0` scales the shape to have no size, `0.5` scales to half
    ///   size in both dimensions, `2` scales to twice the regular size, and so
    ///   on.
    ///
    /// - Returns: A scaled form of this shape.
    public func scale(_ scale: CGFloat, anchor: UnitPoint = .center) -> ScaledShape<Self> { fatalError() }

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
    public func rotation(_ angle: Angle, anchor: UnitPoint = .center) -> RotatedShape<Self> { fatalError() }

    /// Applies an affine transform to this shape.
    ///
    /// Affine transforms present a mathematical approach to applying
    /// combinations of rotation, scaling, translation, and skew to shapes.
    ///
    /// - Parameter transform: The affine transformation matrix to apply to this
    ///   shape.
    ///
    /// - Returns: A transformed shape, based on its matrix values.
    public func transform(_ transform: CGAffineTransform) -> TransformedShape<Self> { fatalError() }
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
    public func size(_ size: CGSize) -> some Shape { stubShape() }


    /// Returns a new version of self representing the same shape, but
    /// that will ask it to create its path from a rect of size
    /// `(width, height)`. This does not affect the layout properties
    /// of any views created from the shape (e.g. by filling it).
    public func size(width: CGFloat, height: CGFloat) -> some Shape { stubShape() }

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
    //public typealias AnimatableData = Content.AnimatableData

    /// The data to animate.
    //public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Rectangle : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
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
    //public typealias AnimatableData = AnimatablePair<Content.AnimatableData, AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData>>

    /// The data to animate.
    //public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RotatedShape : InsettableShape where Content : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> RotatedShape<Content.InsetShape> { fatalError() }

    /// The type of the inset shape.
    public typealias InsetShape = RotatedShape<Content.InsetShape>
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RoundedRectangle : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Capsule : InsettableShape {
    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { stub() as Never }


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
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ContainerRelativeShape : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
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
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


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
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension UnevenRoundedRectangle : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


    /// The type of the inset shape.
    public typealias InsetShape = Never
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Ellipse : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> InsetShape { fatalError() }


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
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension OffsetShape : InsettableShape where Content : InsettableShape {

    /// Returns `self` inset by `amount`.
    public func inset(by amount: CGFloat) -> OffsetShape<Content.InsetShape> { fatalError() }

    /// The type of the inset shape.
    public typealias InsetShape = OffsetShape<Content.InsetShape>
}

extension Never : Shape {
    public typealias AnimatableData = Never
    public var animatableData: AnimatableData { get { fatalError() } set { } }

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
