// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.RoundRect
import androidx.compose.ui.graphics.Matrix
import androidx.compose.ui.graphics.PathOperation
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
#endif

public struct Path : Shape, Equatable {
    #if SKIP
    private let path: androidx.compose.ui.graphics.Path

    public init(path: androidx.compose.ui.graphics.Path = androidx.compose.ui.graphics.Path()) {
        self.path = path
    }

    // Custom copy constructor to copy the path
    public init(copy: MutableStruct) {
        self.init()
        path.addPath((copy as! Path).path)
    }
    #else
    public init() {
    }
    #endif

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

    public func path(in rect: CGRect) -> Path {
        return self
    }

    #if SKIP
    public func asComposePath(density: Density) -> androidx.compose.ui.graphics.Path {
        let px = with(density) { 1.dp.toPx() }
        let scaledPath = androidx.compose.ui.graphics.Path()
        scaledPath.addPath(path)
        let matrix = Matrix()
        matrix.scale(px, px, Float(1.0))
        scaledPath.transform(matrix)
        return scaledPath
    }
    #else
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }
    public typealias Body = NeverView
    public var body: Body { fatalError() }
    #endif

    public var isEmpty: Bool {
        #if SKIP
        return path.isEmpty
        #else
        return false
        #endif
    }

    public var boundingRect: CGRect {
        #if SKIP
        let bounds = path.getBounds()
        return CGRect(x: CGFloat(bounds.left), y: CGFloat(bounds.top), width: CGFloat(bounds.width), height: CGFloat(bounds.height))
        #else
        return .zero
        #endif
    }

    public func contains(_ p: CGPoint, eoFill: Bool = false) -> Bool {
        return boundingRect.contains(p)
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
        #if SKIP
        path.moveTo(Float(end.x), Float(end.y))
        #endif
    }

    public mutating func addLine(to end: CGPoint) {
        #if SKIP
        path.lineTo(Float(end.x), Float(end.y))
        #endif
    }

    public mutating func addQuadCurve(to end: CGPoint, control: CGPoint) {
        #if SKIP
        path.quadraticBezierTo(Float(control.x), Float(control.y), Float(end.x), Float(end.y))
        #endif
    }

    public mutating func addCurve(to end: CGPoint, control1: CGPoint, control2: CGPoint) {
        #if SKIP
        path.cubicTo(Float(control1.x), Float(control1.y), Float(control2.x), Float(control2.y), Float(end.x), Float(end.y))
        #endif
    }

    public mutating func closeSubpath() {
        #if SKIP
        path.close()
        #endif
    }

    public mutating func addRect(_ rect: CGRect, transform: CGAffineTransform = .identity) {
        #if SKIP
        if transform.isIdentity {
            path.addRect(Rect(Float(rect.minX), Float(rect.minY), Float(rect.maxX), Float(rect.maxY)))
        } else {
            path.addPath(Path(rect).applying(transform).path)
        }
        #endif
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) {
        #if SKIP
        if transform.isIdentity {
            path.addRoundRect(RoundRect(Float(rect.minX), Float(rect.minY), Float(rect.maxX), Float(rect.maxY), Float(cornerSize.width), Float(cornerSize.height)))
        } else {
            path.addPath(Path(roundedRect: rect, cornerSize: cornerSize, style: style).applying(transform).path)
        }
        #endif
    }

    public mutating func addRoundedRect(in rect: CGRect, cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous, transform: CGAffineTransform = .identity) {
        #if SKIP
        if transform.isIdentity {
            path.addRoundRect(RoundRect(Rect(Float(rect.minX), Float(rect.minY), Float(rect.maxX), Float(rect.maxY)), CornerRadius(Float(cornerRadii.topLeading), Float(cornerRadii.topLeading)), CornerRadius(Float(cornerRadii.topTrailing), Float(cornerRadii.topTrailing)), CornerRadius(Float(cornerRadii.bottomTrailing), Float(cornerRadii.bottomTrailing)), CornerRadius(Float(cornerRadii.bottomLeading), Float(cornerRadii.bottomLeading))))
        } else {
            path.addPath(Path(roundedRect: rect, cornerRadii: cornerRadii, style: style).applying(transform).path)
        }
        #endif
    }

    public mutating func addEllipse(in rect: CGRect, transform: CGAffineTransform = .identity) {
        #if SKIP
        if transform.isIdentity {
            path.addOval(Rect(Float(rect.minX), Float(rect.minY), Float(rect.maxX), Float(rect.maxY)))
        } else {
            path.addPath(Path(ellipseIn: rect).applying(transform).path)
        }
        #endif
    }

    public mutating func addRects(_ rects: [CGRect], transform: CGAffineTransform = .identity) {
        rects.forEach { addRect($0, transform: transform) }
    }

    public mutating func addLines(_ lines: [CGPoint]) {
        if let first = lines.first {
            move(to: first)
        }
        for i in 1..<lines.count {
            addLine(to: lines[i])
        }
    }

    public mutating func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) {
        #if SKIP
        if transform.isIdentity {
            path.arcTo(Rect(Float(center.x - radius), Float(center.y - radius), Float(center.x + radius), Float(center.y + radius)), Float(startAngle.degrees), Float(delta.degrees), forceMoveTo = false)
        } else {
            var arcPath = Path()
            arcPath.addRelativeArc(center: center, radius: radius, startAngle: startAngle, delta: delta)
            path.addPath(arcPath.applying(transform).path)
        }
        #endif
    }

    public mutating func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, transform: CGAffineTransform = .identity) {
        let deltar = clockwise ? startAngle.radians - endAngle.radians : endAngle.radians - startAngle.radians
        addRelativeArc(center: center, radius: radius, startAngle: startAngle, delta: Angle(radians: deltar))
    }

    @available(*, unavailable)
    public mutating func addArc(tangent1End: CGPoint, tangent2End: CGPoint, radius: CGFloat, transform: CGAffineTransform = .identity) {
    }

    public mutating func addPath(_ other: Path, transform: CGAffineTransform = .identity) {
        #if SKIP
        path.addPath(other.applying(transform).path)
        #endif
    }

    @available(*, unavailable)
    public var currentPoint: CGPoint? {
        return nil
    }

    @available(*, unavailable)
    public func normalized(eoFill: Bool = true) -> Path {
        return self
    }

    public func intersection(_ other: Path, eoFill: Bool = false) -> Path {
        #if SKIP
        return Path(path: androidx.compose.ui.graphics.Path.combine(PathOperation.Intersect, path, other.path))
        #else
        return self
        #endif
    }

    public func union(_ other: Path, eoFill: Bool = false) -> Path {
        #if SKIP
        return Path(path: androidx.compose.ui.graphics.Path.combine(PathOperation.Union, path, other.path))
        #else
        return self
        #endif
    }

    public func subtracting(_ other: Path, eoFill: Bool = false) -> Path {
        #if SKIP
        return Path(path: androidx.compose.ui.graphics.Path.combine(PathOperation.Difference, path, other.path))
        #else
        return self
        #endif
    }

    public func symmetricDifference(_ other: Path, eoFill: Bool = false) -> Path {
        #if SKIP
        return Path(path: androidx.compose.ui.graphics.Path.combine(PathOperation.Xor, path, other.path))
        #else
        return self
        #endif
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
        guard !transform.isIdentity else {
            return self
        }
        #if SKIP
        let transformedPath = androidx.compose.ui.graphics.Path()
        transformedPath.addPath(path)
        transformedPath.transform(transform.asMatrix())
        return Path(path: transformedPath)
        #else
        return self
        #endif
    }

    public func offsetBy(dx: CGFloat, dy: CGFloat) -> Path {
        #if SKIP
        let translatedPath = androidx.compose.ui.graphics.Path()
        translatedPath.addPath(path, Offset(Float(dx), Float(dy)))
        return Path(path: translatedPath)
        #else
        return self
        #endif
    }
}

#if SKIP
extension CGAffineTransform {
    func asMatrix() -> Matrix {
        return Matrix(floatArrayOf(
            Float(a), Float(b), Float(0.0), Float(0.0),
            Float(c), Float(d), Float(0.0), Float(0.0),
            Float(tx), Float(ty), Float(1.0), Float(0.0),
            Float(0.0), Float(0.0), Float(0.0), Float(1.0)
        ))
    }
}
#endif

#if false

// TODO: Process for use in SkipUI

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
