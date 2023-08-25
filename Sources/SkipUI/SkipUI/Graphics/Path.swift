// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import class CoreGraphics.CGPath
import struct CoreGraphics.CGPoint
import class CoreGraphics.CGMutablePath
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize

/// The outline of a 2D shape.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Path : Equatable, LosslessStringConvertible, @unchecked Sendable {

    /// Creates an empty path.
    public init() { fatalError() }

    /// Creates a path from an immutable shape path.
    ///
    /// - Parameter path: The immutable CoreGraphics path to initialize
    ///   the new path from.
    ///
    public init(_ path: CGPath) { fatalError() }

    /// Creates a path from a copy of a mutable shape path.
    ///
    /// - Parameter path: The CoreGraphics path to initialize the new
    ///   path from.
    ///
    public init(_ path: CGMutablePath) { fatalError() }

    /// Creates a path containing a rectangle.
    ///
    /// This is a convenience function that creates a path of a
    /// rectangle. Using this convenience function is more efficient
    /// than creating a path and adding a rectangle to it.
    ///
    /// Calling this function is equivalent to using `minX` and related
    /// properties to find the corners of the rectangle, then using the
    /// `move(to:)`, `addLine(to:)`, and `closeSubpath()` functions to
    /// add the rectangle.
    ///
    /// - Parameter rect: The rectangle to add.
    ///
    public init(_ rect: CGRect) { fatalError() }

    /// Creates a path containing a rounded rectangle.
    ///
    /// This is a convenience function that creates a path of a rounded
    /// rectangle. Using this convenience function is more efficient
    /// than creating a path and adding a rounded rectangle to it.
    ///
    /// - Parameters:
    ///   - rect: A rectangle, specified in user space coordinates.
    ///   - cornerSize: The size of the corners, specified in user space
    ///     coordinates.
    ///   - style: The corner style. Defaults to the `continous` style
    ///     if not specified.
    ///
    public init(roundedRect rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Creates a path containing a rounded rectangle.
    ///
    /// This is a convenience function that creates a path of a rounded
    /// rectangle. Using this convenience function is more efficient
    /// than creating a path and adding a rounded rectangle to it.
    ///
    /// - Parameters:
    ///   - rect: A rectangle, specified in user space coordinates.
    ///   - cornerRadius: The radius of all corners of the rectangle,
    ///     specified in user space coordinates.
    ///   - style: The corner style. Defaults to the `continous` style
    ///     if not specified.
    ///
    public init(roundedRect rect: CGRect, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Creates a path as the given rounded rectangle, which may have
    /// uneven corner radii.
    ///
    /// This is a convenience function that creates a path of a rounded
    /// rectangle. Using this function is more efficient than creating
    /// a path and adding a rounded rectangle to it.
    ///
    /// - Parameters:
    ///   - rect: A rectangle, specified in user space coordinates.
    ///   - cornerRadii: The radius of each corner of the rectangle,
    ///     specified in user space coordinates.
    ///   - style: The corner style. Defaults to the `continous` style
    ///     if not specified.
    ///
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public init(roundedRect rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) { fatalError() }

    /// Creates a path as an ellipse within the given rectangle.
    ///
    /// This is a convenience function that creates a path of an
    /// ellipse. Using this convenience function is more efficient than
    /// creating a path and adding an ellipse to it.
    ///
    /// The ellipse is approximated by a sequence of Bézier
    /// curves. Its center is the midpoint of the rectangle defined by
    /// the rect parameter. If the rectangle is square, then the
    /// ellipse is circular with a radius equal to one-half the width
    /// (or height) of the rectangle. If the rect parameter specifies a
    /// rectangular shape, then the major and minor axes of the ellipse
    /// are defined by the width and height of the rectangle.
    ///
    /// The ellipse forms a complete subpath of the path—that
    /// is, the ellipse drawing starts with a move-to operation and
    /// ends with a close-subpath operation, with all moves oriented in
    /// the clockwise direction. If you supply an affine transform,
    /// then the constructed Bézier curves that define the
    /// ellipse are transformed before they are added to the path.
    ///
    /// - Parameter rect: The rectangle that bounds the ellipse.
    ///
    public init(ellipseIn rect: CGRect) { fatalError() }

    /// Creates an empty path, then executes a closure to add its
    /// initial elements.
    ///
    /// - Parameter callback: The Swift function that will be called to
    ///   initialize the new path.
    ///
    public init(_ callback: (inout Path) -> ()) { fatalError() }

    /// Initializes from the result of a previous call to
    /// `Path.stringRepresentation`. Fails if the `string` does not
    /// describe a valid path.
    public init?(_ string: String) { fatalError() }

    /// A description of the path that may be used to recreate the path
    /// via `init?(_:)`.
    public var description: String { get { fatalError() } }

    /// An immutable path representing the elements in the path.
    public var cgPath: CGPath { get { fatalError() } }

    /// A Boolean value indicating whether the path contains zero elements.
    public var isEmpty: Bool { get { fatalError() } }

    /// A rectangle containing all path segments.
    ///
    /// This is the smallest rectangle completely enclosing all points
    /// in the path but not including control points for Bézier
    /// curves.
    public var boundingRect: CGRect { get { fatalError() } }

    /// Returns true if the path contains a specified point.
    ///
    /// If `eoFill` is true, this method uses the even-odd rule to define which
    /// points are inside the path. Otherwise, it uses the non-zero rule.
    public func contains(_ p: CGPoint, eoFill: Bool = false) -> Bool { fatalError() }

    /// An element of a path.
    @frozen public enum Element : Equatable {

        /// A path element that terminates the current subpath (without closing
        /// it) and defines a new current point.
        case move(to: CGPoint)

        /// A line from the previous current point to the given point, which
        /// becomes the new current point.
        case line(to: CGPoint)

        /// A quadratic Bézier curve from the previous current point to the
        /// given end-point, using the single control point to define the curve.
        ///
        /// The end-point of the curve becomes the new current point.
        case quadCurve(to: CGPoint, control: CGPoint)

        /// A cubic Bézier curve from the previous current point to the given
        /// end-point, using the two control points to define the curve.
        ///
        /// The end-point of the curve becomes the new current point.
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)

        /// A line from the start point of the current subpath (if any) to the
        /// current point, which terminates the subpath.
        ///
        /// After closing the subpath, the current point becomes undefined.
        case closeSubpath

        
    }

    /// Calls `body` with each element in the path.
    public func forEach(_ body: (Path.Element) -> Void) { fatalError() }

    /// Returns a stroked copy of the path using `style` to define how the
    /// stroked outline is created.
    public func strokedPath(_ style: StrokeStyle) -> Path { fatalError() }

    /// Returns a partial copy of the path.
    ///
    /// The returned path contains the region between `from` and `to`, both of
    /// which must be fractions between zero and one defining points
    /// linearly-interpolated along the path.
    public func trimmedPath(from: CGFloat, to: CGFloat) -> Path { fatalError() }

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Path : Shape {

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in _: CGRect) -> Path { fatalError() }

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
extension Path {

    /// Begins a new subpath at the specified point.
    ///
    /// The specified point becomes the start point of a new subpath.
    /// The current point is set to this start point.
    ///
    /// - Parameter end: The point, in user space coordinates, at which
    ///   to start a new subpath.
    ///
    public mutating func move(to end: CGPoint) { fatalError() }

    /// Appends a straight line segment from the current point to the
    /// specified point.
    ///
    /// After adding the line segment, the current point is set to the
    /// endpoint of the line segment.
    ///
    /// - Parameter end: The location, in user space coordinates, for the
    ///   end of the new line segment.
    ///
    public mutating func addLine(to end: CGPoint) { fatalError() }

    ///     the curve.
    ///   - control: The control point of the curve, in user space
    ///     coordinates.
    ///
    public mutating func addQuadCurve(to end: CGPoint, control: CGPoint) { fatalError() }

    ///     the curve.
    ///   - control1: The first control point of the curve, in user
    ///     space coordinates.
    ///   - control2: The second control point of the curve, in user
    ///     space coordinates.
    ///
    public mutating func addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint) { fatalError() }

    /// Closes and completes the current subpath.
    ///
    /// Appends a line from the current point to the starting point of
    /// the current subpath and ends the subpath.
    ///
    /// After closing the subpath, your application can begin a new
    /// subpath without first calling `move(to:)`. In this case, a new
    /// subpath is implicitly created with a starting and current point
    /// equal to the previous subpath's starting point.
    ///
    public mutating func closeSubpath() { fatalError() }

    /// Adds a rectangular subpath to the path.
    ///
    /// This is a convenience function that adds a rectangle to a path,
    /// starting by moving to the bottom-left corner and then adding
    /// lines counter-clockwise to create a rectangle, closing the
    /// subpath.
    ///
    /// - Parameters:
    ///   - rect: A rectangle, specified in user space coordinates.
    ///   - transform: An affine transform to apply to the rectangle
    ///     before adding to the path. Defaults to the identity
    ///     transform if not specified.
    ///
    public mutating func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds a rounded rectangle to the path.
    ///
    /// This is a convenience function that adds a rounded rectangle to
    /// a path, starting by moving to the center of the right edge and
    /// then adding lines and curves counter-clockwise to create a
    /// rounded rectangle, closing the subpath.
    ///
    /// - Parameters:
    ///   - rect: A rectangle, specified in user space coordinates.
    ///   - cornerSize: The size of the corners, specified in user space
    ///     coordinates.
    ///   - style: The corner style. Defaults to the `continous` style
    ///     if not specified.
    ///   - transform: An affine transform to apply to the rectangle
    ///     before adding to the path. Defaults to the identity
    ///     transform if not specified.
    ///
    public mutating func addRoundedRect(in rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds a rounded rectangle with uneven corners to the path.
    ///
    /// This is a convenience function that adds a rounded rectangle to
    /// a path, starting by moving to the center of the right edge and
    /// then adding lines and curves counter-clockwise to create a
    /// rounded rectangle, closing the subpath.
    ///
    /// - Parameters:
    ///   - rect: A rectangle, specified in user space coordinates.
    ///   - cornerRadii: The radius of each corner of the rectangle,
    ///     specified in user space coordinates.
    ///   - style: The corner style. Defaults to the `continous` style
    ///     if not specified.
    ///   - transform: An affine transform to apply to the rectangle
    ///     before adding to the path. Defaults to the identity
    ///     transform if not specified.
    ///
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public mutating func addRoundedRect(in rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds an ellipse that fits inside the specified rectangle to the
    /// path.
    ///
    /// The ellipse is approximated by a sequence of Bézier
    /// curves. Its center is the midpoint of the rectangle defined by
    /// the `rect` parameter. If the rectangle is square, then the
    /// ellipse is circular with a radius equal to one-half the width
    /// (or height) of the rectangle. If the `rect` parameter specifies
    /// a rectangular shape, then the major and minor axes of the
    /// ellipse are defined by the width and height of the rectangle.
    ///
    /// The ellipse forms a complete subpath of the path—
    /// that is, the ellipse drawing starts with a move-to operation
    /// and ends with a close-subpath operation, with all moves
    /// oriented in the clockwise direction.
    ///
    /// - Parameter:
    ///   - rect: A rectangle that defines the area for the ellipse to
    ///     fit in.
    ///   - transform: An affine transform to apply to the ellipse
    ///     before adding to the path. Defaults to the identity
    ///     transform if not specified.
    ///
    public mutating func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds a set of rectangular subpaths to the path.
    ///
    /// Calling this convenience method is equivalent to repeatedly
    /// calling the `addRect(_:transform:)` method for each rectangle
    /// in the array.
    ///
    /// - Parameter:
    ///   - rects: An array of rectangles, specified in user space
    ///     coordinates.
    ///   - transform: An affine transform to apply to the ellipse
    ///     before adding to the path. Defaults to the identity
    ///     transform if not specified.
    ///
    public mutating func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds a sequence of connected straight-line segments to the path.
    ///
    /// Calling this convenience method is equivalent to applying the
    /// transform to all points in the array, then calling the
    /// `move(to:)` method with the first value in the `points` array,
    /// then calling the `addLine(to:)` method for each subsequent
    /// point until the array is exhausted. After calling this method,
    /// the path's current point is the last point in the array.
    ///
    /// - Parameter:
    ///   - lines: An array of values that specify the start and end
    ///     points of the line segments to draw. Each point in the
    ///     array specifies a position in user space. The first point
    ///     in the array specifies the initial starting point.
    ///   - transform: An affine transform to apply to the points
    ///     before adding to the path. Defaults to the identity
    ///     transform if not specified.
    ///
    public mutating func addLines(_ lines: [CGPoint]) { fatalError() }

    /// Adds an arc of a circle to the path, specified with a radius
    /// and a difference in angle.
    ///
    /// This method calculates starting and ending points using the
    /// radius and angles you specify, uses a sequence of cubic
    /// Bézier curves to approximate a segment of a circle
    /// between those points, and then appends those curves to the
    /// path.
    ///
    /// The `delta` parameter determines both the length of the arc the
    /// direction in which the arc is created; the actual direction of
    /// the final path is dependent on the `transform` parameter and
    /// the current transform of a context where the path is drawn.
    /// However, because SkipUI by default uses a vertically-flipped
    /// coordinate system (with the origin in the top-left of the
    /// view), specifying a clockwise arc results in a counterclockwise
    /// arc after the transformation is applied.
    ///
    /// If the path ends with an unclosed subpath, this method adds a
    /// line connecting the current point to the starting point of the
    /// arc. If there is no unclosed subpath, this method creates a new
    /// subpath whose starting point is the starting point of the arc.
    /// The ending point of the arc becomes the new current point of
    /// the path.
    ///
    /// - Parameters:
    ///   - center: The center of the arc, in user space coordinates.
    ///   - radius: The radius of the arc, in user space coordinates.
    ///   - startAngle: The angle to the starting point of the arc,
    ///     measured from the positive x-axis.
    ///   - delta: The difference between the starting angle and ending
    ///     angle of the arc. A positive value creates a counter-
    ///     clockwise arc (in user space coordinates), and vice versa.
    ///   - transform: An affine transform to apply to the arc before
    ///     adding to the path. Defaults to the identity transform if
    ///     not specified.
    ////
    public mutating func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds an arc of a circle to the path, specified with a radius
    /// and angles.
    ///
    /// This method calculates starting and ending points using the
    /// radius and angles you specify, uses a sequence of cubic
    /// Bézier curves to approximate a segment of a circle
    /// between those points, and then appends those curves to the
    /// path.
    ///
    /// The `clockwise` parameter determines the direction in which the
    /// arc is created; the actual direction of the final path is
    /// dependent on the `transform` parameter and the current
    /// transform of a context where the path is drawn. However,
    /// because SkipUI by default uses a vertically-flipped coordinate
    /// system (with the origin in the top-left of the view),
    /// specifying a clockwise arc results in a counterclockwise arc
    /// after the transformation is applied.
    ///
    /// If the path ends with an unclosed subpath, this method adds a
    /// line connecting the current point to the starting point of the
    /// arc. If there is no unclosed subpath, this method creates a new
    /// subpath whose starting point is the starting point of the arc.
    /// The ending point of the arc becomes the new current point of
    /// the path.
    ///
    /// - Parameters:
    ///   - center: The center of the arc, in user space coordinates.
    ///   - radius: The radius of the arc, in user space coordinates.
    ///   - startAngle: The angle to the starting point of the arc,
    ///     measured from the positive x-axis.
    ///   - endAngle: The angle to the end point of the arc, measured
    ///     from the positive x-axis.
    ///   - clockwise: true to make a clockwise arc; false to make a
    ///     counterclockwise arc.
    ///   - transform: An affine transform to apply to the arc before
    ///     adding to the path. Defaults to the identity transform if
    ///     not specified.
    ///
    public mutating func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, transform: CGAffineTransform = .identity) { fatalError() }

    /// Adds an arc of a circle to the path, specified with a radius
    /// and two tangent lines.
    ///
    /// This method calculates two tangent lines—the first
    /// from the current point to the tangent1End point, and the second
    /// from the `tangent1End` point to the `tangent2End`
    /// point—then calculates the start and end points for a
    /// circular arc of the specified radius such that the arc is
    /// tangent to both lines. Finally, this method approximates that
    /// arc with a sequence of cubic Bézier curves and appends
    /// those curves to the path.
    ///
    /// If the starting point of the arc (that is, the point where a
    /// circle of the specified radius must meet the first tangent line
    /// in order to also be tangent to the second line) is not the
    /// current point, this method appends a straight line segment from
    /// the current point to the starting point of the arc.
    ///
    /// The ending point of the arc (that is, the point where a circle
    /// of the specified radius must meet the second tangent line in
    /// order to also be tangent to the first line) becomes the new
    /// current point of the path.
    ///
    /// - Parameters:
    ///   - tangent1End:The end point, in user space coordinates, for
    ///     the first tangent line to be used in constructing the arc.
    ///     (The start point for this tangent line is the path's
    ///     current point.)
    ///   - tangent2End: The end point, in user space coordinates, for
    ///     the second tangent line to be used in constructing the arc.
    ///     (The start point for this tangent line is the tangent1End
    ///     point.)
    ///   - radius: The radius of the arc, in user space coordinates.
    ///   - transform: An affine transform to apply to the arc before
    ///     adding to the path. Defaults to the identity transform if
    ///     not specified.
    ///
    public mutating func addArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) { fatalError() }

    /// Appends another path value to this path.
    ///
    /// If the `path` parameter is a non-empty empty path, its elements
    /// are appended in order to this path. Afterward, the start point
    /// and current point of this path are those of the last subpath in
    /// the `path` parameter.
    ///
    /// - Parameters:
    ///   - path: The path to add.
    ///   - transform: An affine transform to apply to the path
    ///     parameter before adding to this path. Defaults to the
    ///     identity transform if not specified.
    ///
    public mutating func addPath(_ path: Path, transform: CGAffineTransform = .identity) { fatalError() }

    /// Returns the last point in the path, or nil if the path contains
    /// no points.
    public var currentPoint: CGPoint? { get { fatalError() } }

    /// Returns a new weakly-simple copy of this path.
    ///
    /// - Parameters:
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The returned path is a weakly-simple path, has no
    /// self-intersections, and has a normalized orientation. The
    /// result of filling this path using either even-odd or non-zero
    /// fill rules is identical.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func normalized(eoFill: Bool = true) -> Path { fatalError() }

    /// Returns a new path with filled regions common to both paths.
    ///
    /// - Parameters:
    ///   - other: The path to intersect.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The filled region of the resulting path is the overlapping area
    /// of the filled region of both paths.  This can be used to clip
    /// the fill of a path to a mask.
    ///
    /// Any unclosed subpaths in either path are assumed to be closed.
    /// The result of filling this path using either even-odd or
    /// non-zero fill rules is identical.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func intersection(_ other: Path, eoFill: Bool = false) -> Path { fatalError() }

    /// Returns a new path with filled regions in either this path or
    /// the given path.
    ///
    /// - Parameters:
    ///   - other: The path to union.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The filled region of resulting path is the combination of the
    /// filled region of both paths added together.
    ///
    /// Any unclosed subpaths in either path are assumed to be closed.
    /// The result of filling this path using either even-odd or
    /// non-zero fill rules is identical.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func union(_ other: Path, eoFill: Bool = false) -> Path { fatalError() }

    /// Returns a new path with filled regions from this path that are
    /// not in the given path.
    ///
    /// - Parameters:
    ///   - other: The path to subtract.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The filled region of the resulting path is the filled region of
    /// this path with the filled region `other` removed from it.
    ///
    /// Any unclosed subpaths in either path are assumed to be closed.
    /// The result of filling this path using either even-odd or
    /// non-zero fill rules is identical.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func subtracting(_ other: Path, eoFill: Bool = false) -> Path { fatalError() }

    /// Returns a new path with filled regions either from this path or
    /// the given path, but not in both.
    ///
    /// - Parameters:
    ///   - other: The path to difference.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The filled region of the resulting path is the filled region
    /// contained in either this path or `other`, but not both.
    ///
    /// Any unclosed subpaths in either path are assumed to be closed.
    /// The result of filling this path using either even-odd or
    /// non-zero fill rules is identical.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func symmetricDifference(_ other: Path, eoFill: Bool = false) -> Path { fatalError() }

    /// Returns a new path with a line from this path that overlaps the
    /// filled regions of the given path.
    ///
    /// - Parameters:
    ///   - other: The path to intersect.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The line of the resulting path is the line of this path that
    /// overlaps the filled region of `other`.
    ///
    /// Intersected subpaths that are clipped create open subpaths.
    /// Closed subpaths that do not intersect `other` remain closed.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func lineIntersection(_ other: Path, eoFill: Bool = false) -> Path { fatalError() }

    /// Returns a new path with a line from this path that does not
    /// overlap the filled region of the given path.
    ///
    /// - Parameters:
    ///   - other: The path to subtract.
    ///   - eoFill: Whether to use the even-odd rule for determining
    ///       which areas to treat as the interior of the paths (if true),
    ///       or the non-zero rule (if false).
    /// - Returns: A new path.
    ///
    /// The line of the resulting path is the line of this path that
    /// does not overlap the filled region of `other`.
    ///
    /// Intersected subpaths that are clipped create open subpaths.
    /// Closed subpaths that do not intersect `other` remain closed.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func lineSubtraction(_ other: Path, eoFill: Bool = false) -> Path { fatalError() }

    /// Returns a path constructed by applying the transform to all
    /// points of the path.
    ///
    /// - Parameter transform: An affine transform to apply to the path.
    ///
    /// - Returns: a new copy of the path with the transform applied to
    ///   all points.
    ///
    public func applying(_ transform: CGAffineTransform) -> Path { fatalError() }

    /// Returns a path constructed by translating all its points.
    ///
    /// - Parameters:
    ///   - dx: The offset to apply in the horizontal axis.
    ///   - dy: The offset to apply in the vertical axis.
    ///
    /// - Returns: a new copy of the path with the offset applied to
    ///   all points.
    ///
    public func offsetBy(dx: CGFloat, dy: CGFloat) -> Path { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Path.Element : Sendable {
}

#endif
