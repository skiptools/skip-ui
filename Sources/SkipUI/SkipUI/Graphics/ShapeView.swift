// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
import struct CoreGraphics.CGFloat

/// A view that provides a shape that you can use for drawing operations.
///
/// Use this type with the drawing methods on ``Shape`` to apply multiple fills
/// and/or strokes to a shape. For example, the following code applies a fill
/// and stroke to a capsule shape:
///
///     Capsule()
///         .fill(.yellow)
///         .stroke(.blue, lineWidth: 8)
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol ShapeView<Content> : View {

    /// The type of shape this can provide.
    associatedtype Content : Shape

    /// The shape that this type draws and provides for other drawing
    /// operations.
    var shape: Self.Content { get }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ShapeView {

    /// Fills this shape with a color or gradient.
    ///
    /// - Parameters:
    ///   - content: The color or gradient to use when filling this shape.
    ///   - style: The style options that determine how the fill renders.
    /// - Returns: A shape filled with the color or gradient you supply.
    public func fill<S>(_ content: S = .foreground, style: FillStyle = FillStyle()) -> FillShapeView<Self.Content, S, Self> where S : ShapeStyle { fatalError() }

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
    public func stroke<S>(_ content: S, style: StrokeStyle, antialiased: Bool = true) -> StrokeShapeView<Self.Content, S, Self> where S : ShapeStyle { fatalError() }

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
    public func stroke<S>(_ content: S, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeShapeView<Self.Content, S, Self> where S : ShapeStyle { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ShapeView where Self.Content : InsettableShape {

    /// Returns a view that's the result of insetting this view by half of its style's line width.
    ///
    /// This method strokes the resulting shape with
    /// `style` and fills it with `content`.
    public func strokeBorder<S>(_ content: S = .foreground, style: StrokeStyle, antialiased: Bool = true) -> StrokeBorderShapeView<Self.Content, S, Self> where S : ShapeStyle { fatalError() }

    /// Returns a view that's the result of filling an inner stroke of this view with the content you supply.
    ///
    /// This is equivalent to insetting `self` by `lineWidth / 2` and stroking the
    /// resulting shape with `lineWidth` as the line-width.
    public func strokeBorder<S>(_ content: S = .foreground, lineWidth: CGFloat = 1, antialiased: Bool = true) -> StrokeBorderShapeView<Self.Content, S, Self> where S : ShapeStyle { fatalError() }
}


/// A shape provider that strokes the border of its shape.
///
/// You don't create this type directly; it's the return type of
/// `Shape.strokeBorder`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct StrokeBorderShapeView<Content, Style, Background> : ShapeView where Content : InsettableShape, Style : ShapeStyle, Background : View {

    /// The shape that this type draws and provides for other drawing
    /// operations.
    public var shape: Content { get { fatalError() } }

    /// The style that strokes the border of this view's shape.
    public var style: Style { get { fatalError() } }

    /// The stroke style used when stroking this view's shape.
    public var strokeStyle: StrokeStyle { get { fatalError() } }

    /// Whether this shape should be drawn antialiased.
    public var isAntialiased: Bool { get { fatalError() } }

    /// The background shown beneath this view.
    public var background: Background { get { fatalError() } }

    /// Create a stroke border shape.
    public init(shape: Content, style: Style, strokeStyle: StrokeStyle, isAntialiased: Bool, background: Background) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A shape provider that strokes its shape.
///
/// You don't create this type directly; it's the return type of
/// `Shape.stroke`.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@frozen public struct StrokeShapeView<Content, Style, Background> : ShapeView where Content : Shape, Style : ShapeStyle, Background : View {

    /// The shape that this type draws and provides for other drawing
    /// operations.
    public var shape: Content { get { fatalError() } }

    /// The style that strokes this view's shape.
    public var style: Style { get { fatalError() } }

    /// The stroke style used when stroking this view's shape.
    public var strokeStyle: StrokeStyle { get { fatalError() } }

    /// Whether this shape should be drawn antialiased.
    public var isAntialiased: Bool { get { fatalError() } }

    /// The background shown beneath this view.
    public var background: Background { get { fatalError() } }

    /// Create a StrokeShapeView.
    public init(shape: Content, style: Style, strokeStyle: StrokeStyle, isAntialiased: Bool, background: Background) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}
#endif
