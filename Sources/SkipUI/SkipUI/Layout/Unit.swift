// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct UnitPoint : Hashable, Sendable {
    public var x = 0.0
    public var y = 0.0

    public static let zero = UnitPoint(x: 0.0, y: 0.0)
    public static let center = UnitPoint(x: 0.5, y: 0.5)
    public static let leading = UnitPoint(x: 0.0, y: 0.5)
    public static let trailing = UnitPoint(x: 1.0, y: 0.5)
    public static let top = UnitPoint(x: 0.5, y: 0.0)
    public static let bottom = UnitPoint(x: 0.5, y: 1.0)
    public static let topLeading = UnitPoint(x: 0.0, y: 0.0)
    public static let topTrailing = UnitPoint(x: 1.0, y: 0.0)
    public static let bottomLeading = UnitPoint(x: 0.0, y: 1.0)
    public static let bottomTrailing = UnitPoint(x: 1.0, y: 1.0)
}

#if !SKIP

// TODO: Process for use in SkipUI

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

#endif
