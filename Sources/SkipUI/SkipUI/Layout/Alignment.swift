// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// An alignment in both axes.
///
/// An `Alignment` contains a ``HorizontalAlignment`` guide and a
/// ``VerticalAlignment`` guide. Specify an alignment to direct the behavior of
/// certain layout containers and modifiers, like when you place views in a
/// ``ZStack``, or layer a view in front of or behind another view using
/// ``View/overlay(alignment:content:)`` or
/// ``View/background(alignment:content:)``, respectively. During layout,
/// SkipUI brings the specified guides of the affected views together,
/// aligning the views.
///
/// SkipUI provides a set of built-in alignments that represent common
/// combinations of the built-in horizontal and vertical alignment guides.
/// The blue boxes in the following diagram demonstrate the alignment named
/// by each box's label, relative to the background view:
///
/// ![A square that's divided into four equal quadrants. The upper-
/// left quadrant contains the text, Some text in an upper quadrant. The
/// lower-right quadrant contains the text, More text in a lower quadrant.
/// In both cases, the text is split over two lines. A variety of blue
/// boxes are overlaid atop the square. Each contains the name of a built-in
/// alignment, and is aligned with the square in a way that matches the
/// alignment name. For example, the box lableled center appears at the
/// center of the square.](Alignment-1-iOS)
///
/// The following code generates the diagram above, where each blue box appears
/// in an overlay that's configured with a different alignment:
///
///     struct AlignmentGallery: View {
///         var body: some View {
///             BackgroundView()
///                 .overlay(alignment: .topLeading) { box(".topLeading") }
///                 .overlay(alignment: .top) { box(".top") }
///                 .overlay(alignment: .topTrailing) { box(".topTrailing") }
///                 .overlay(alignment: .leading) { box(".leading") }
///                 .overlay(alignment: .center) { box(".center") }
///                 .overlay(alignment: .trailing) { box(".trailing") }
///                 .overlay(alignment: .bottomLeading) { box(".bottomLeading") }
///                 .overlay(alignment: .bottom) { box(".bottom") }
///                 .overlay(alignment: .bottomTrailing) { box(".bottomTrailing") }
///                 .overlay(alignment: .leadingLastTextBaseline) { box(".leadingLastTextBaseline") }
///                 .overlay(alignment: .trailingFirstTextBaseline) { box(".trailingFirstTextBaseline") }
///         }
///
///         private func box(_ name: String) -> some View {
///             Text(name)
///                 .font(.system(.caption, design: .monospaced))
///                 .padding(2)
///                 .foregroundColor(.white)
///                 .background(.blue.opacity(0.8), in: Rectangle())
///         }
///     }
///
///     private struct BackgroundView: View {
///         var body: some View {
///             Grid(horizontalSpacing: 0, verticalSpacing: 0) {
///                 GridRow {
///                     Text("Some text in an upper quadrant")
///                     Color.gray.opacity(0.3)
///                 }
///                 GridRow {
///                     Color.gray.opacity(0.3)
///                     Text("More text in a lower quadrant")
///                 }
///             }
///             .aspectRatio(1, contentMode: .fit)
///             .foregroundColor(.secondary)
///             .border(.gray)
///         }
///     }
///
/// To avoid crowding, the alignment diagram shows only two of the available
/// text baseline alignments. The others align as their names imply. Notice that
/// the first text baseline alignment aligns with the top-most line of text in
/// the background view, while the last text baseline aligns with the
/// bottom-most line. For more information about text baseline alignment, see
/// ``VerticalAlignment``.
///
/// In a left-to-right language like English, the leading and trailing
/// alignments appear on the left and right edges, respectively. SkipUI
/// reverses these in right-to-left language environments. For more
/// information, see ``HorizontalAlignment``.
///
/// ### Custom alignment
///
/// You can create custom alignments --- which you typically do to make use
/// of custom horizontal or vertical guides --- by using the
/// ``init(horizontal:vertical:)`` initializer. For example, you can combine
/// a custom vertical guide called `firstThird` with the built-in horizontal
/// ``HorizontalAlignment/center`` guide, and use it to configure a ``ZStack``:
///
///     ZStack(alignment: Alignment(horizontal: .center, vertical: .firstThird)) {
///         // ...
///     }
///
/// For more information about creating custom guides, including the code
/// that creates the custom `firstThird` alignment in the example above,
/// see ``AlignmentID``.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct Alignment : Equatable {

    /// The alignment on the horizontal axis.
    ///
    /// Set this value when you initialize an alignment using the
    /// ``init(horizontal:vertical:)`` method. Use one of the built-in
    /// ``HorizontalAlignment`` guides, like ``HorizontalAlignment/center``,
    /// or a custom guide that you create.
    ///
    /// For information about creating custom guides, see ``AlignmentID``.
    public var horizontal: HorizontalAlignment { get { fatalError() } }

    /// The alignment on the vertical axis.
    ///
    /// Set this value when you initialize an alignment using the
    /// ``init(horizontal:vertical:)`` method. Use one of the built-in
    /// ``VerticalAlignment`` guides, like ``VerticalAlignment/center``,
    /// or a custom guide that you create.
    ///
    /// For information about creating custom guides, see ``AlignmentID``.
    public var vertical: VerticalAlignment { get { fatalError() } }

    /// Creates a custom alignment value with the specified horizontal
    /// and vertical alignment guides.
    ///
    /// SkipUI provides a variety of built-in alignments that combine built-in
    /// ``HorizontalAlignment`` and ``VerticalAlignment`` guides. Use this
    /// initializer to create a custom alignment that makes use
    /// of a custom horizontal or vertical guide, or both.
    ///
    /// For example, you can combine a custom vertical guide called
    /// `firstThird` with the built-in ``HorizontalAlignment/center``
    /// guide, and use it to configure a ``ZStack``:
    ///
    ///     ZStack(alignment: Alignment(horizontal: .center, vertical: .firstThird)) {
    ///         // ...
    ///     }
    ///
    /// For more information about creating custom guides, including the code
    /// that creates the custom `firstThird` alignment in the example above,
    /// see ``AlignmentID``.
    ///
    /// - Parameters:
    ///   - horizontal: The alignment on the horizontal axis.
    ///   - vertical: The alignment on the vertical axis.
    @inlinable public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) { fatalError() }

    
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Alignment {

    /// A guide that marks the center of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/center``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Center, appears at the center of the
    /// square.](Alignment-center-1-iOS)
    public static let center: Alignment = { fatalError() }()

    /// A guide that marks the leading edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/center``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Leading, appears on the left edge of the
    /// square, centered vertically.](Alignment-leading-1-iOS)
    public static let leading: Alignment = { fatalError() }()

    /// A guide that marks the trailing edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/center``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Trailing, appears on the right edge of the
    /// square, centered vertically.](Alignment-trailing-1-iOS)
    public static let trailing: Alignment = { fatalError() }()

    /// A guide that marks the top edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/top``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Top, appears on the top edge of the
    /// square, centered horizontally.](Alignment-top-1-iOS)
    public static let top: Alignment = { fatalError() }()

    /// A guide that marks the bottom edge of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/bottom``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, Bottom, appears on the bottom edge of the
    /// square, centered horizontally.](Alignment-bottom-1-iOS)
    public static let bottom: Alignment = { fatalError() }()

    /// A guide that marks the top and leading edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/top``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, topLeading, appears in the upper-left corner of
    /// the square.](Alignment-topLeading-1-iOS)
    public static let topLeading: Alignment = { fatalError() }()

    /// A guide that marks the top and trailing edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/top``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, topTrailing, appears in the upper-right corner of
    /// the square.](Alignment-topTrailing-1-iOS)
    public static let topTrailing: Alignment = { fatalError() }()

    /// A guide that marks the bottom and leading edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/bottom``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, bottomLeading, appears in the lower-left corner of
    /// the square.](Alignment-bottomLeading-1-iOS)
    public static let bottomLeading: Alignment = { fatalError() }()

    /// A guide that marks the bottom and trailing edges of the view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/bottom``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, bottomTrailing, appears in the lower-right corner of
    /// the square.](Alignment-bottomTrailing-1-iOS)
    public static let bottomTrailing: Alignment = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Alignment {

    /// A guide that marks the top-most text baseline in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/firstTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, centerFirstTextBaseline, appears aligned with, and
    /// partially overlapping, the first line of the text in the upper quadrant,
    /// centered horizontally.](Alignment-centerFirstTextBaseline-1-iOS)
    public static var centerFirstTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the bottom-most text baseline in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/center``
    /// horizontal guide and the ``VerticalAlignment/lastTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, centerLastTextBaseline, appears aligned with, and
    /// partially overlapping, the last line of the text in the lower quadrant,
    /// centered horizontally.](Alignment-centerLastTextBaseline-1-iOS)
    public static var centerLastTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the leading edge and top-most text baseline in a
    /// view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/firstTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, leadingFirstTextBaseline, appears aligned with, and
    /// partially overlapping, the first line of the text in the upper quadrant.
    /// The box aligns with the left edge of the
    /// square.](Alignment-leadingFirstTextBaseline-1-iOS)
    public static var leadingFirstTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the leading edge and bottom-most text baseline
    /// in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/leading``
    /// horizontal guide and the ``VerticalAlignment/lastTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, leadingLastTextBaseline, appears aligned with the
    /// last line of the text in the lower quadrant. The box aligns with the
    /// left edge of the square.](Alignment-leadingLastTextBaseline-1-iOS)
    public static var leadingLastTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the trailing edge and top-most text baseline in
    /// a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/firstTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, trailingFirstTextBaseline, appears aligned with the
    /// first line of the text in the upper quadrant. The box aligns with the
    /// right edge of the square.](Alignment-trailingFirstTextBaseline-1-iOS)
    public static var trailingFirstTextBaseline: Alignment { get { fatalError() } }

    /// A guide that marks the trailing edge and bottom-most text baseline
    /// in a view.
    ///
    /// This alignment combines the ``HorizontalAlignment/trailing``
    /// horizontal guide and the ``VerticalAlignment/lastTextBaseline``
    /// vertical guide:
    ///
    /// ![A square that's divided into four equal quadrants. The upper-
    /// left quadrant contains the text, Some text in an upper quadrant. The
    /// lower-right quadrant contains the text, More text in a lower quadrant.
    /// In both cases, the text is split over two lines. A blue box that
    /// contains the text, trailingLastTextBaseline, appears aligned with the
    /// last line of the text in the lower quadrant. The box aligns with the
    /// right edge of the square.](Alignment-trailingLastTextBaseline-1-iOS)
    public static var trailingLastTextBaseline: Alignment { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Alignment : Sendable {
}

#endif
