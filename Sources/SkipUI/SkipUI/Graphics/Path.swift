// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.unit.Density
#else
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
#endif

public struct Path : Shape, Equatable {
    #if SKIP
    private let path: androidx.compose.ui.graphics.Path = androidx.compose.ui.graphics.Path()

    // Skip doesn't add the standard copy constructor used by MutableStruct.scopy() because we have no mutable properties.
    // That works out because we need to add a custom one anyway in order to copy the path
    public init(copy: MutableStruct) {
        path.addPath((copy as! Path).path)
    }
    #endif

    public init() {
    }

    public init(_ rect: CGRect) {
        self.init()
        addRect(rect)
    }

    public init(roundedRect rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous) {
        self.init()
        addRoundedRect(in: rect, cornerSize: cornerSize, style: style)
    }

    public init(roundedRect rect: CGRect, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        self.init()
        addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius), style: style)
    }

    public init(roundedRect rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) {
        self.init()
        addRoundedRect(in: rect, cornerRadii: cornerRadii, style: style)
    }

    public init(ellipseIn rect: CGRect) {
        self.init()
        addEllipse(in: rect)
    }

    public init(_ callback: (inout Path) -> ()) {
        self.init()
        callback(&self)
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        //~~~ scale and flip
        return path
    }
    #else
    public func path(in rect: CGRect) -> Path { fatalError() }
    public var layoutDirectionBehavior: LayoutDirectionBehavior { get { fatalError() } }

    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif

    public var isEmpty: Bool {
        return false
    }

    public var boundingRect: CGRect {
        return .zero
    }

    public func contains(_ p: CGPoint, eoFill: Bool = false) -> Bool {
        return false
    }

    public enum Element : Equatable, Sendable {
        case move(to: CGPoint)
        case line(to: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case closeSubpath
    }

    @available(*, unavailable)
    public func forEach(_ body: (Path.Element) -> Void) {
    }

    @available(*, unavailable)
    public func strokedPath(_ style: StrokeStyle) -> Path {
        return self
    }

    @available(*, unavailable)
    public func trimmedPath(from: CGFloat, to: CGFloat) -> Path {
        return self
    }

    public mutating func move(to end: CGPoint) {
    }

    public mutating func addLine(to end: CGPoint) {
    }

    public mutating func addQuadCurve(to end: CGPoint, control: CGPoint) {
    }

    public mutating func addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint) {
    }

    public mutating func closeSubpath() {
    }

    public mutating func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) {
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) {
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) {
    }

    public mutating func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) {
    }

    public mutating func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) {
    }

    public mutating func addLines(_ lines: [CGPoint]) {
    }

    public mutating func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) {
    }

    public mutating func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, transform: CGAffineTransform = .identity) {
    }

    public mutating func addArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) {
    }

    public mutating func addPath(_ path: Path, transform: CGAffineTransform = .identity) {
    }

    @available(*, unavailable)
    public var currentPoint: CGPoint? {
        return nil
    }

    @available(*, unavailable)
    public func normalized(eoFill: Bool = true) -> Path {
        return self
    }

    @available(*, unavailable)
    public func intersection(_ other: Path, eoFill: Bool = false) -> Path {
        return self
    }

    @available(*, unavailable)
    public func union(_ other: Path, eoFill: Bool = false) -> Path {
        return self
    }

    @available(*, unavailable)
    public func subtracting(_ other: Path, eoFill: Bool = false) -> Path {
        return self
    }

    @available(*, unavailable)
    public func symmetricDifference(_ other: Path, eoFill: Bool = false) -> Path {
        return self
    }

    @available(*, unavailable)
    public func lineIntersection(_ other: Path, eoFill: Bool = false) -> Path {
        return self
    }

    @available(*, unavailable)
    public func lineSubtraction(_ other: Path, eoFill: Bool = false) -> Path {
        return self
    }

    public func applying(_ transform: CGAffineTransform) -> Path {
        return self
    }

    public func offsetBy(dx: CGFloat, dy: CGFloat) -> Path {
        return self
    }
}

#if !SKIP

import struct CoreGraphics.CGAffineTransform
import class CoreGraphics.CGPath
import class CoreGraphics.CGMutablePath

/// The outline of a 2D shape.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Path : LosslessStringConvertible, @unchecked Sendable {
    public init(_ path: CGPath) { fatalError() }
    public init(_ path: CGMutablePath) { fatalError() }
    public init?(_ string: String) { fatalError() }
    public var description: String { get { fatalError() } }
    public var cgPath: CGPath { get { fatalError() } }
}

#endif
