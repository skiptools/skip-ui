// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.shape.GenericShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.RoundRect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Matrix
import androidx.compose.ui.graphics.drawscope.DrawStyle
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.inset
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.dp
#endif

public protocol Shape: View, Sendable {
    #if SKIP
    var modified: ModifiedShape { get }
    func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path
    #endif
}

extension Shape where Self == Circle {
    // SKIP NOWARN
    public static var circle: Circle {
        return Circle()
    }
}

extension Shape where Self == Rectangle {
    // SKIP NOWARN
    public static var rect: Rectangle {
        return Rectangle()
    }
}

extension Shape where Self == RoundedRectangle {
    // SKIP NOWARN
    public static func rect(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
        return RoundedRectangle(cornerSize: cornerSize, style: style)
    }

    // SKIP NOWARN
    public static func rect(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) -> RoundedRectangle {
        return RoundedRectangle(cornerRadius: cornerRadius, style: style)
    }
}

extension Shape where Self == UnevenRoundedRectangle {
    // SKIP NOWARN
    public static func rect(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) -> UnevenRoundedRectangle {
        return UnevenRoundedRectangle(cornerRadii: cornerRadii, style: style)
    }

    // SKIP NOWARN
    public static func rect(topLeadingRadius: CGFloat = 0.0, bottomLeadingRadius: CGFloat = 0.0, bottomTrailingRadius: CGFloat = 0.0, topTrailingRadius: CGFloat = 0.0, style: RoundedCornerStyle = .continuous) -> UnevenRoundedRectangle {
        return UnevenRoundedRectangle(topLeadingRadius: topLeadingRadius, bottomLeadingRadius: bottomLeadingRadius, bottomTrailingRadius: bottomTrailingRadius, topTrailingRadius: topTrailingRadius, style: style)
    }
}

extension Shape where Self == Capsule {
    // SKIP NOWARN
    public static var capsule: Capsule {
        return Capsule()
    }

    // SKIP NOWARN
    public static func capsule(style: RoundedCornerStyle) -> Capsule {
        return Capsule(style: style)
    }
}

extension Shape where Self == Ellipse {
    // SKIP NOWARN
    public static var ellipse: Ellipse {
        Ellipse()
    }
}

#if SKIP
extension Shape {
    public var modified: ModifiedShape {
        return ModifiedShape(shape: self)
    }

    public func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        return androidx.compose.ui.graphics.Path()
    }

    public func asComposeShape(density: Density) -> androidx.compose.ui.graphics.Shape {
        return GenericShape { size, _ in
            self.addPath(asComposePath(size: size, density: density))
        }
    }
}

/// Modifications to a shape.
enum ShapeModification {
    case offset(CGPoint)
    case inset(CGFloat)
    case scale(CGSize, UnitPoint)
    case rotation(Angle, UnitPoint)
}

/// Strokes on a shape.
struct ShapeStroke {
    let stroke: ShapeStyle
    let style: StrokeStyle?
    let isInset: Bool
}

/// A shape that has been modified.
public struct ModifiedShape : Shape {
    let shape: Shape
    var modifications: [ShapeModification] = []
    var fill: ShapeStyle?
    var strokes: [ShapeStroke] = []

    init(shape: Shape) {
        self.shape = shape
    }

    @Composable func ComposeContent(context: ComposeContext) {
        let modifier = context.modifier.fillSize()
        let density = LocalDensity.current

        let fillBrush: Brush?
        if let fill {
            fillBrush = fill.asBrush(opacity: 1.0) ?? Color.primary.asBrush(opacity: 1.0)
        } else {
            fillBrush = nil
        }
        var strokeBrushes: [(Brush, DrawStyle, Float)] = []
        for stroke in strokes {
            let brush = stroke.stroke.asBrush(opacity: 1.0) ?? Color.primary.asBrush(opacity: 1.0)!
            let drawStyle = stroke.style?.asDrawStyle() ?? Stroke()
            var inset = Float(0.0)
            if stroke.isInset, let style = stroke.style {
                inset = with(density) { (style.lineWidth / 2.0).dp.toPx() }
            }
            strokeBrushes.append((brush, drawStyle, inset))
        }

        Canvas(modifier: modifier) {
            let scope = self
            let path = asComposePath(size: scope.size, density: density)
            if let fillBrush {
                scope.drawPath(path, fillBrush)
            }
            for strokeBrush in strokeBrushes {
                let strokeInset = strokeBrush.2
                if (strokeInset == Float(0.0)) {
                    scope.drawPath(path, brush: strokeBrush.0, style: strokeBrush.1)
                } else {
                    scope.inset(strokeInset) {
                        let strokePath = asComposePath(size: scope.size, density: density)
                        scope.drawPath(strokePath, brush: strokeBrush.0, style: strokeBrush.1)
                    }
                }
            }
        }
    }

    override var modified: ModifiedShape {
        return self
    }

    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        // Due to Android API limitations, we can't just apply our modifications in order. Instead we calculate the final
        // size of the path, draw it within that size, and then apply any translations and rotations
        var totalOffset: CGPoint = .zero
        var totalInset = 0.0
        var totalScale = CGSize(width: 1.0, height: 1.0)
        var totalRotationDegrees = 0.0
        var totalRotationRadians = 0.0
        var isRotationBeforeOffset = false
        // TODO: Support scale and rotation anchors
        for mod in modifications {
            switch mod {
            case .offset(let offset):
                totalOffset.x += with(density) { offset.x.dp.toPx() }
                totalOffset.y += with(density) { offset.y.dp.toPx() }
            case .inset(let inset):
                let px = with(density) { inset.dp.toPx() }
                totalInset += px
            case .scale(let size, _):
                // Attempting to use matrix.scale results in runtime exception when matrix is applied to path:
                // java.lang.IllegalArgumentException: Android does not support arbitrary transforms
                totalScale.width *= size.width
                totalScale.height *= size.height
            case .rotation(let angle, _):
                totalRotationDegrees += angle.degrees
                totalRotationRadians += angle.radians
                isRotationBeforeOffset = totalOffset == .zero
            }
        }

        // Scale size and translate to re-center
        var sizeOffset: CGPoint = .zero
        let scaledSize = Size(size.width * Float(totalScale.width), size.height * Float(totalScale.height))
        sizeOffset.x += (size.width - scaledSize.width) / 2.0
        sizeOffset.y += (size.height - scaledSize.height) / 2.0
        // Apply insets
        let finalSize = Size(max(Float(0.0), scaledSize.width - Float(totalInset * 2.0)), max(Float(0.0), scaledSize.height - Float(totalInset * 2.0)))
        sizeOffset.x += totalInset
        sizeOffset.y += totalInset

        let path = shape.asComposePath(size: finalSize, density: density)

        if totalRotationDegrees == 0.0 || !isRotationBeforeOffset {
            path.translate(Offset(Float(totalOffset.x), Float(totalOffset.y)))
        }
        if totalRotationDegrees != 0.0 {
            let matrix = Matrix()
            matrix.rotateZ(Float(totalRotationDegrees))
            path.transform(matrix)

            // Android rotates around the origin rather than the center. Calculate the offset that this rotation
            // causes to the center point and apply its inverse to get a rotation around the center. Note that we
            // negate the y axis because mathmatical coordinate systems have the origin in the bottom left, not top
            let xcenter = finalSize.width / 2
            let ycenter = -finalSize.height / 2
            let xnew = xcenter * cos(-totalRotationRadians) - ycenter * sin(-totalRotationRadians)
            let ynew = xcenter * sin(-totalRotationRadians) + ycenter * cos(-totalRotationRadians)
            path.translate(Offset(Float(xcenter - xnew), Float(-(ycenter - ynew))))
            if isRotationBeforeOffset {
                path.translate(Offset(Float(totalOffset.x), Float(totalOffset.y)))
            }
        }

        // Finally, apply the offset from scaling and insetting
        path.translate(Offset(Float(sizeOffset.x), Float(sizeOffset.y)))
        return path
    }
}
#endif

public struct Circle : Shape {
    public init() {
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        let path = androidx.compose.ui.graphics.Path()
        let dim = min(size.width, size.height)
        let x = (size.width - dim) / 2
        let y = (size.height - dim) / 2
        path.addOval(Rect(x, y, x + dim, y + dim))
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
}

public struct Rectangle : Shape {
    public init() {
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        let path = androidx.compose.ui.graphics.Path()
        path.addRect(Rect(Float(0.0), Float(0.0), size.width, size.height))
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
}

public struct RoundedRectangle : Shape {
    public let cornerSize: CGSize
    public let style: RoundedCornerStyle
    var fillStyle: ShapeStyle?

    public init(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) {
        self.cornerSize = cornerSize
        self.style = style
    }

    public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        self.cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        self.style = style
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        let path = androidx.compose.ui.graphics.Path()
        let width = with(density) { cornerSize.width.dp.toPx() }
        let height = with(density) { cornerSize.height.dp.toPx() }
        let cornerRadius = CornerRadius(width, height)
        path.addRoundRect(RoundRect(Float(0.0), Float(0.0), size.width, size.height, cornerRadius))
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
}

public struct UnevenRoundedRectangle : Shape {
    public let cornerRadii: RectangleCornerRadii
    public let style: RoundedCornerStyle


    public init(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) {
        self.cornerRadii = cornerRadii
        self.style = style
    }

    public init(topLeadingRadius: CGFloat = 0.0, bottomLeadingRadius: CGFloat = 0.0, bottomTrailingRadius: CGFloat = 0.0, topTrailingRadius: CGFloat = 0.0, style: RoundedCornerStyle = .continuous) {
        self.cornerRadii = RectangleCornerRadii(topLeading: topLeadingRadius, bottomLeading: bottomLeadingRadius, bottomTrailing: bottomTrailingRadius, topTrailing: topTrailingRadius)
        self.style = style
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        let path = androidx.compose.ui.graphics.Path()
        let topLeft = with(density) { cornerRadii.topLeading.dp.toPx() }
        let topRight = with(density) { cornerRadii.topTrailing.dp.toPx() }
        let bottomLeft = with(density) { cornerRadii.bottomLeading.dp.toPx() }
        let bottomRight = with(density) { cornerRadii.bottomTrailing.dp.toPx() }
        path.addRoundRect(RoundRect(Float(0.0), Float(0.0), size.width, size.height, topLeftCornerRadius: CornerRadius(topLeft, topLeft), topRightCornerRadius: CornerRadius(topRight, topRight), bottomLeftCornerRadius: CornerRadius(bottomLeft, bottomLeft), bottomRightCornerRadius: CornerRadius(bottomRight, bottomRight)))
        return path
    }
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

    public init(style: RoundedCornerStyle = .continuous) {
        self.style = style
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        let path = androidx.compose.ui.graphics.Path()
        if size.width >= size.height {
            path.moveTo(size.height / 2, Float(0.0))
            path.lineTo(size.width - size.height / 2, Float(0.0))
            path.arcTo(Rect(size.width - size.height, Float(0.0), size.width, size.height), Float(-90.0), Float(180.0), false)
            path.lineTo(size.height / 2, size.height)
            path.arcTo(Rect(Float(0.0), Float(0.0), size.height, size.height), Float(90.0), Float(180.0), false)
        } else {
            path.moveTo(Float(0.0), size.width / 2)
            path.arcTo(Rect(Float(0.0), Float(0.0), size.width, size.width), Float(-180.0), Float(180.0), false)
            path.lineTo(size.width, size.height - size.width / 2)
            path.arcTo(Rect(Float(0.0), size.height - size.width, size.width, size.height), Float(0.0), Float(180.0), false)
        }
        path.close()
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
}

public final class Ellipse : Shape {
    public init() {
    }

    #if SKIP
    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        let path = androidx.compose.ui.graphics.Path()
        path.addOval(Rect(Float(0.0), Float(0.0), size.width, size.height))
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

    override var modified: ModifiedShape {
        return shape.modified
    }

    override func asComposePath(size: Size, density: Density) -> androidx.compose.ui.graphics.Path {
        return shape.asComposePath(size: size, density: density)
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
    public func fill(_ content: any ShapeStyle, style: FillStyle = FillStyle()) -> any Shape {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.fill = content
        return modifiedShape
        #else
        return self
        #endif
    }

    public func fill(style: FillStyle = FillStyle()) -> any Shape {
        #if SKIP
        return fill(ForegroundStyle(), style: style)
        #else
        return self
        #endif
    }

    public func inset(by amount: CGFloat) -> any Shape {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.modifications.append(.inset(amount))
        return modifiedShape
        #else
        return self
        #endif
    }

    public func offset(_ offset: CGSize) -> any Shape {
        return self.offset(CGPoint(x: offset.width, y: offset.height))
    }

    public func offset(_ offset: CGPoint) -> any Shape {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.modifications.append(.offset(offset))
        return modifiedShape
        #else
        return self
        #endif
    }

    public func offset(x: CGFloat = 0, y: CGFloat = 0) -> any Shape {
        return self.offset(CGPoint(x: x, y: y))
    }

    public func rotation(_ angle: Angle, anchor: UnitPoint = .center) -> any Shape {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.modifications.append(.rotation(angle, anchor))
        return modifiedShape
        #else
        return self
        #endif
    }

    public func scale(x: CGFloat = 1.0, y: CGFloat = 1.0, anchor: UnitPoint = .center) -> any Shape {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.modifications.append(.scale(CGSize(width: x, height: y), anchor))
        return modifiedShape
        #else
        return self
        #endif
    }

    public func scale(_ scale: CGFloat, anchor: UnitPoint = .center) -> any Shape {
        return self.scale(x: scale, y: scale, anchor: anchor)
    }

    public func stroke(_ content: any ShapeStyle, style: StrokeStyle, antialiased: Bool = true) -> any Shape {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.strokes.append(ShapeStroke(content, style, false))
        return modifiedShape
        #else
        return self
        #endif
    }

    public func stroke(_ content: any ShapeStyle, lineWidth: CGFloat = 1.0, antialiased: Bool = true) -> any Shape {
        return stroke(content, style: StrokeStyle(lineWidth: lineWidth), antialiased: antialiased)
    }

    public func stroke(style: StrokeStyle) -> any Shape {
        return stroke(ForegroundStyle(), style: style)
    }

    public func stroke(lineWidth: CGFloat = 1.0) -> any Shape {
        return stroke(ForegroundStyle(), style: StrokeStyle(lineWidth: lineWidth))
    }

    public func strokeBorder(_ content: any ShapeStyle = .foreground, style: StrokeStyle, antialiased: Bool = true) -> any View {
        #if SKIP
        var modifiedShape = self.modified
        modifiedShape.strokes.append(ShapeStroke(content, style, true))
        return modifiedShape
        #else
        return self
        #endif
    }

    public func strokeBorder(style: StrokeStyle, antialiased: Bool = true) -> any View {
        return strokeBorder(ForegroundStyle(), style: style, antialiased: antialiased)
    }

    public func strokeBorder(_ content: any ShapeStyle = .foreground, lineWidth: CGFloat = 1.0, antialiased: Bool = true) -> any View {
        return strokeBorder(content, style: StrokeStyle(lineWidth: lineWidth), antialiased: antialiased)
    }

    public func strokeBorder(lineWidth: CGFloat = 1.0, antialiased: Bool = true) -> any View {
        return strokeBorder(ForegroundStyle(), style: StrokeStyle(lineWidth: lineWidth), antialiased: antialiased)
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
