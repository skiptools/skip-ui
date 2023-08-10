// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// A  function defined by a two-dimensional curve that maps an input
/// progress in the range [0,1] to an output progress that is also in the
/// range [0,1]. By changing the shape of the curve, the effective speed
/// of an animation or other interpolation can be changed.
///
/// The horizontal (x) axis defines the input progress: a single input
/// progress value in the range [0,1] must be provided when evaluating a
/// curve.
///
/// The vertical (y) axis maps to the output progress: when a curve is
/// evaluated, the y component of the point that intersects the input progress
/// is returned.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct UnitCurve {

    /// Creates a new curve using bezier control points.
    ///
    /// The x components of the control points are clamped to the range [0,1] when
    /// the curve is evaluated.
    ///
    /// - Parameters:
    ///   - startControlPoint: The cubic Bézier control point associated with
    ///     the curve's start point at (0, 0). The tangent vector from the
    ///     start point to its control point defines the initial velocity of
    ///     the timing function.
    ///   - endControlPoint: The cubic Bézier control point associated with the
    ///     curve's end point at (1, 1). The tangent vector from the end point
    ///     to its control point defines the final velocity of the timing
    ///     function.
    public static func bezier(startControlPoint: UnitPoint, endControlPoint: UnitPoint) -> UnitCurve { fatalError() }

    /// Returns the output value (y component) of the curve at the given time.
    ///
    /// - Parameters:
    ///   - time: The input progress (x component). The provided value is
    ///     clamped to the range [0,1].
    ///
    /// - Returns: The output value (y component) of the curve at the given
    ///   progress.
    public func value(at progress: Double) -> Double { fatalError() }

    /// Returns the rate of change (first derivative) of the output value of
    /// the curve at the given time.
    ///
    /// - Parameters:
    ///   - progress: The input progress (x component). The provided value is
    ///     clamped to the range [0,1].
    ///
    /// - Returns: The velocity of the output value (y component) of the curve
    ///   at the given time.
    public func velocity(at progress: Double) -> Double { fatalError() }

    /// Returns a copy of the curve with its x and y components swapped.
    ///
    /// The inverse can be used to solve a curve in reverse: given a
    /// known output (y) value, the corresponding input (x) value can be found
    /// by using `inverse`:
    ///
    ///     let curve = UnitCurve.easeInOut
    ///
    ///     /// The input time for which an easeInOut curve returns 0.6.
    ///     let inputTime = curve.inverse.evaluate(at: 0.6)
    ///
    public var inverse: UnitCurve { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve : Sendable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve : Hashable {

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: UnitCurve, b: UnitCurve) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve {

    /// A bezier curve that starts out slowly, speeds up over the middle, then
    /// slows down again as it approaches the end.
    ///
    /// The start and end control points are located at (x: 0.42, y: 0) and
    /// (x: 0.58, y: 1).
    @available(*, deprecated, message: "Use easeInOut instead")
    public static let easeInEaseOut: UnitCurve = { fatalError() }()

    /// A bezier curve that starts out slowly, speeds up over the middle, then
    /// slows down again as it approaches the end.
    ///
    /// The start and end control points are located at (x: 0.42, y: 0) and
    /// (x: 0.58, y: 1).
    public static let easeInOut: UnitCurve = { fatalError() }()

    /// A bezier curve that starts out slowly, then speeds up as it finishes.
    ///
    /// The start and end control points are located at (x: 0.42, y: 0) and
    /// (x: 1, y: 1).
    public static let easeIn: UnitCurve = { fatalError() }()

    /// A bezier curve that starts out quickly, then slows down as it
    /// approaches the end.
    ///
    /// The start and end control points are located at (x: 0, y: 0) and
    /// (x: 0.58, y: 1).
    public static let easeOut: UnitCurve = { fatalError() }()

    /// A curve that starts out slowly, then speeds up as it finishes.
    ///
    /// The shape of the curve is equal to the fourth (bottom right) quadrant
    /// of a unit circle.
    public static let circularEaseIn: UnitCurve = { fatalError() }()

    /// A circular curve that starts out quickly, then slows down as it
    /// approaches the end.
    ///
    /// The shape of the curve is equal to the second (top left) quadrant of
    /// a unit circle.
    public static let circularEaseOut: UnitCurve = { fatalError() }()

    /// A circular curve that starts out slowly, speeds up over the middle,
    /// then slows down again as it approaches the end.
    ///
    /// The shape of the curve is defined by a piecewise combination of
    /// `circularEaseIn` and `circularEaseOut`.
    public static let circularEaseInOut: UnitCurve = { fatalError() }()

    /// A linear curve.
    ///
    /// As the linear curve is a straight line from (0, 0) to (1, 1),
    /// the output progress is always equal to the input progress, and
    /// the velocity is always equal to 1.0.
    public static let linear: UnitCurve = { fatalError() }()
}

/// A normalized 2D point in a view's coordinate space.
///
/// Use a unit point to represent a location in a view without having to know
/// the view's rendered size. The point stores a value in each dimension that
/// indicates the fraction of the view's size in that dimension --- measured
/// from the view's origin --- where the point appears. For example, you can
/// create a unit point that represents the center of any view by using the
/// value `0.5` for each dimension:
///
///     let unitPoint = UnitPoint(x: 0.5, y: 0.5)
///
/// To project the unit point into the rendered view's coordinate space,
/// multiply each component of the unit point with the corresponding
/// component of the view's size:
///
///     let projectedPoint = CGPoint(
///         x: unitPoint.x * size.width,
///         y: unitPoint.y * size.height
///     )
///
/// You can perform this calculation yourself if you happen to know a view's
/// size, or if you want to use the unit point for some custom purpose, but
/// SkipUI typically does this for you to carry out operations that
/// you request, like when you:
///
/// * Transform a shape using a shape modifier. For example, to rotate a
///   shape with ``Shape/rotation(_:anchor:)``, you indicate an anchor point
///   that you want to rotate the shape around.
/// * Override the alignment of the view in a ``Grid`` cell using the
///   ``View/gridCellAnchor(_:)`` view modifier. The grid aligns the projection
///   of a unit point onto the view with the projection of the same unit point
///   onto the cell.
/// * Create a gradient that has a center, or start and stop points, relative
///   to the shape that you are styling. See the gradient methods in
///   ``ShapeStyle``.
///
/// You can create custom unit points with explicit values, like the example
/// above, or you can use one of the built-in unit points that SkipUI provides,
/// like ``zero``, ``center``, or ``topTrailing``. The built-in values
/// correspond to the alignment positions of the similarly named, built-in
/// ``Alignment`` types.
///
/// > Note: A unit point with one or more components outside the range `[0, 1]`
/// projects to a point outside of the view.
///
/// ### Layout direction
///
/// When a person configures their device to use a left-to-right language like
/// English, the system places the view's origin in its top-left corner,
/// with positive x toward the right and positive y toward the bottom of the
/// view. In a right-to-left environment, the origin moves to the upper-right
/// corner, and the positive x direction changes to be toward the left. You
/// don't typically need to do anything to handle this change, because SkipUI
/// applies the change to all aspects of the system. For example, see the
/// discussion about layout direction in ``HorizontalAlignment``.
///
/// It’s important to test your app for the different locales that you
/// distribute your app in. For more information about the localization process,
/// see .
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct UnitPoint : Hashable {

    /// The normalized distance from the origin to the point in the horizontal
    /// direction.
    public var x: CGFloat { get { fatalError() } }

    /// The normalized distance from the origin to the point in the vertical
    /// dimension.
    public var y: CGFloat { get { fatalError() } }

    /// Creates a unit point at the origin.
    ///
    /// A view's origin appears in the top-left corner in a left-to-right
    /// language environment, with positive x toward the right. It appears in
    /// the top-right corner in a right-to-left language, with positive x toward
    /// the left. Positive y is always toward the bottom of the view.
    @inlinable public init() { fatalError() }

    /// Creates a unit point with the specified horizontal and vertical offsets.
    ///
    /// Values outside the range `[0, 1]` project to points outside of a view.
    ///
    /// - Parameters:
    ///   - x: The normalized distance from the origin to the point in the
    ///     horizontal direction.
    ///   - y: The normalized distance from the origin to the point in the
    ///     vertical direction.
    @inlinable public init(x: CGFloat, y: CGFloat) { fatalError() }

    /// The origin of a view.
    ///
    /// A view's origin appears in the top-left corner in a left-to-right
    /// language environment, with positive x toward the right. It appears in
    /// the top-right corner in a right-to-left language, with positive x toward
    /// the left. Positive y is always toward the bottom of the view.
    public static let zero: UnitPoint = { fatalError() }()

    /// A point that's centered in a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/center`` alignment.
    public static let center: UnitPoint = { fatalError() }()

    /// A point that's centered vertically on the leading edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/leading`` alignment.
    /// The leading edge appears on the left in a left-to-right language
    /// environment and on the right in a right-to-left environment.
    public static let leading: UnitPoint = { fatalError() }()

    /// A point that's centered vertically on the trailing edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/trailing`` alignment.
    /// The trailing edge appears on the right in a left-to-right language
    /// environment and on the left in a right-to-left environment.
    public static let trailing: UnitPoint = { fatalError() }()

    /// A point that's centered horizontally on the top edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/top`` alignment.
    public static let top: UnitPoint = { fatalError() }()

    /// A point that's centered horizontally on the bottom edge of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/bottom`` alignment.
    public static let bottom: UnitPoint = { fatalError() }()

    /// A point that's in the top, leading corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/topLeading`` alignment.
    /// The leading edge appears on the left in a left-to-right language
    /// environment and on the right in a right-to-left environment.
    public static let topLeading: UnitPoint = { fatalError() }()

    /// A point that's in the top, trailing corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/topTrailing`` alignment.
    /// The trailing edge appears on the right in a left-to-right language
    /// environment and on the left in a right-to-left environment.
    public static let topTrailing: UnitPoint = { fatalError() }()

    /// A point that's in the bottom, leading corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/bottomLeading`` alignment.
    /// The leading edge appears on the left in a left-to-right language
    /// environment and on the right in a right-to-left environment.
    public static let bottomLeading: UnitPoint = { fatalError() }()

    /// A point that's in the bottom, trailing corner of a view.
    ///
    /// This point occupies the position where the horizontal and vertical
    /// alignment guides intersect for ``Alignment/bottomTrailing`` alignment.
    /// The trailing edge appears on the right in a left-to-right language
    /// environment and on the left in a right-to-left environment.
    public static let bottomTrailing: UnitPoint = { fatalError() }()

    public func hash(into hasher: inout Hasher) { fatalError() }

    public static func == (a: UnitPoint, b: UnitPoint) -> Bool { fatalError() }

    public var hashValue: Int { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension UnitPoint : Sendable {
}
