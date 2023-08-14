// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// An alignment position along the horizontal axis.
///
/// Use horizontal alignment guides to tell SkipUI how to position views
/// relative to one another horizontally, like when you place views vertically
/// in an ``VStack``. The following example demonstrates common built-in
/// horizontal alignments:
///
/// ![Three columns of content. Each column contains a string
/// inside a box with a vertical line above and below the box. The
/// lines are aligned horizontally with the text in a different way for each
/// column. The lines for the left-most string, labeled Leading, align with
/// the left edge of the string. The lines for the middle string, labeled
/// Center, align with the center of the string. The lines for the right-most
/// string, labeled Trailing, align with the right edge of the
/// string.](HorizontalAlignment-1-iOS)
///
/// You can generate the example above by creating a series of columns
/// implemented as vertical stacks, where you configure each stack with a
/// different alignment guide:
///
///     private struct HorizontalAlignmentGallery: View {
///         var body: some View {
///             HStack(spacing: 30) {
///                 column(alignment: .leading, text: "Leading")
///                 column(alignment: .center, text: "Center")
///                 column(alignment: .trailing, text: "Trailing")
///             }
///             .frame(height: 150)
///         }
///
///         private func column(alignment: HorizontalAlignment, text: String) -> some View {
///             VStack(alignment: alignment, spacing: 0) {
///                 Color.red.frame(width: 1)
///                 Text(text).font(.title).border(.gray)
///                 Color.red.frame(width: 1)
///             }
///         }
///     }
///
/// During layout, SkipUI aligns the views inside each stack by bringing
/// together the specified guides of the affected views. SkipUI calculates
/// the position of a guide for a particular view based on the characteristics
/// of the view. For example, the ``HorizontalAlignment/center`` guide appears
/// at half the width of the view. You can override the guide calculation for a
/// particular view using the ``View/alignmentGuide(_:computeValue:)-9mdoh``
/// view modifier.
///
/// ### Layout direction
///
/// When a user configures their device to use a left-to-right language like
/// English, the system places the leading alignment on the left and the
/// trailing alignment on the right, as the example from the previous section
/// demonstrates. However, in a right-to-left language, the system reverses
/// these. You can see this by using the ``View/environment(_:_:)`` view
/// modifier to explicitly override the ``EnvironmentValues/layoutDirection``
/// environment value for the view defined above:
///
///     HorizontalAlignmentGallery()
///         .environment(\.layoutDirection, .rightToLeft)
///
/// ![Three columns of content. Each column contains a string
/// inside a box with a vertical line above and below the box. The
/// lines are aligned horizontally with the text in a different way for each
/// column. The lines for the left-most string, labeled Trailing, align with
/// the left edge of the string. The lines for the middle string, labeled
/// Center, align with the center of the string. The lines for the right-most
/// string, labeled Leading, align with the right edge of the
/// string.](HorizontalAlignment-2-iOS)
///
/// This automatic layout adjustment makes it easier to localize your app,
/// but it's still important to test your app for the different locales that
/// you ship into. For more information about the localization process, see
/// .
///
/// ### Custom alignment guides
///
/// You can create a custom horizontal alignment by creating a type that
/// conforms to the ``AlignmentID`` protocol, and then using that type to
/// initalize a new static property on `HorizontalAlignment`:
///
///     private struct OneQuarterAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.width / 4
///         }
///     }
///
///     extension HorizontalAlignment {
///         static let oneQuarter = HorizontalAlignment(OneQuarterAlignment.self)
///     }
///
/// You implement the ``AlignmentID/defaultValue(in:)`` method to calculate
/// a default value for the custom alignment guide. The method receives a
/// ``ViewDimensions`` instance that you can use to calculate an appropriate
/// value based on characteristics of the view. The example above places
/// the guide at one quarter of the width of the view, as measured from the
/// view's origin.
///
/// You can then use the custom alignment guide like any built-in guide. For
/// example, you can use it as the `alignment` parameter to a ``VStack``,
/// or you can change it for a specific view using the
/// ``View/alignmentGuide(_:computeValue:)-9mdoh`` view modifier.
/// Custom alignment guides also automatically reverse in a right-to-left
/// environment, just like built-in guides.
///
/// ### Composite alignment
///
/// Combine a ``VerticalAlignment`` with a `HorizontalAlignment` to create a
/// composite ``Alignment`` that indicates both vertical and horizontal
/// positioning in one value. For example, you could combine your custom
/// `oneQuarter` horizontal alignment from the previous section with a built-in
/// ``VerticalAlignment/center`` vertical alignment to use in a ``ZStack``:
///
///     struct LayeredVerticalStripes: View {
///         var body: some View {
///             ZStack(alignment: Alignment(horizontal: .oneQuarter, vertical: .center)) {
///                 verticalStripes(color: .blue)
///                     .frame(width: 300, height: 150)
///                 verticalStripes(color: .green)
///                     .frame(width: 180, height: 80)
///             }
///         }
///
///         private func verticalStripes(color: Color) -> some View {
///             HStack(spacing: 1) {
///                 ForEach(0..<4) { _ in color }
///             }
///         }
///     }
///
/// The example above uses widths and heights that generate two mismatched sets
/// of four vertical stripes. The ``ZStack`` centers the two sets vertically and
/// aligns them horizontally one quarter of the way from the leading edge of
/// each set. In a left-to-right locale, this aligns the right edges of the
/// left-most stripes of each set:
///
/// ![Two sets of four rectangles. The first set is blue. The
/// second set is green, is smaller, and is layered on top of the first set.
/// The two sets are centered vertically, but align horizontally at the right
/// edge of each set's left-most rectangle.](HorizontalAlignment-3-iOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct HorizontalAlignment : Equatable {
    /// The underlying identifier for the alignment
    private let key: String

    init(key: String) {
        self.key = key
    }

    /// Creates a custom horizontal alignment of the specified type.
    ///
    /// Use this initializer to create a custom horizontal alignment. Define
    /// an ``AlignmentID`` type, and then use that type to create a new
    /// static property on ``HorizontalAlignment``:
    ///
    ///     private struct OneQuarterAlignment: AlignmentID {
    ///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
    ///             context.width / 4
    ///         }
    ///     }
    ///
    ///     extension HorizontalAlignment {
    ///         static let oneQuarter = HorizontalAlignment(OneQuarterAlignment.self)
    ///     }
    ///
    /// Every horizontal alignment instance that you create needs a unique
    /// identifier. For more information, see ``AlignmentID``.
    ///
    /// - Parameter id: The type of an identifier that uniquely identifies a
    ///   horizontal alignment.
    public init(_ id: AlignmentID.Type) { fatalError() }

    
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension HorizontalAlignment {

    /// Merges a sequence of explicit alignment values produced by
    /// this instance.
    ///
    /// For built-in horizontal alignment types, this method returns the mean
    /// of all non-`nil` values.
    public func combineExplicit<S>(_ values: S) -> CGFloat? where S : Sequence, S.Element == CGFloat? { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension HorizontalAlignment {

    /// A guide that marks the leading edge of the view.
    ///
    /// Use this guide to align the leading edges of views.
    /// For a device that uses a left-to-right language, the leading edge
    /// is on the left:
    ///
    /// ![A box that contains the word, Leading. Vertical
    /// lines appear above and below the box. The lines align horizontally
    /// with the left edge of the box.](HorizontalAlignment-leading-1-iOS)
    ///
    /// The following code generates the image above using a ``VStack``:
    ///
    ///     struct HorizontalAlignmentLeading: View {
    ///         var body: some View {
    ///             VStack(alignment: .leading, spacing: 0) {
    ///                 Color.red.frame(width: 1)
    ///                 Text("Leading").font(.title).border(.gray)
    ///                 Color.red.frame(width: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let leading: HorizontalAlignment = HorizontalAlignment(key: "leading")

    /// A guide that marks the horizontal center of the view.
    ///
    /// Use this guide to align the centers of views:
    ///
    /// ![A box that contains the word, Center. Vertical
    /// lines appear above and below the box. The lines align horizontally
    /// with the center of the box.](HorizontalAlignment-center-1-iOS)
    ///
    /// The following code generates the image above using a ``VStack``:
    ///
    ///     struct HorizontalAlignmentCenter: View {
    ///         var body: some View {
    ///             VStack(alignment: .center, spacing: 0) {
    ///                 Color.red.frame(width: 1)
    ///                 Text("Center").font(.title).border(.gray)
    ///                 Color.red.frame(width: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let center: HorizontalAlignment = HorizontalAlignment(key: "center")

    /// A guide that marks the trailing edge of the view.
    ///
    /// Use this guide to align the trailing edges of views.
    /// For a device that uses a left-to-right language, the trailing edge
    /// is on the right:
    ///
    /// ![A box that contains the word, Trailing. Vertical
    /// lines appear above and below the box. The lines align horizontally
    /// with the right edge of the box.](HorizontalAlignment-trailing-1-iOS)
    ///
    /// The following code generates the image above using a ``VStack``:
    ///
    ///     struct HorizontalAlignmentTrailing: View {
    ///         var body: some View {
    ///             VStack(alignment: .trailing, spacing: 0) {
    ///                 Color.red.frame(width: 1)
    ///                 Text("Trailing").font(.title).border(.gray)
    ///                 Color.red.frame(width: 1)
    ///             }
    ///         }
    ///     }
    ///
    public static let trailing: HorizontalAlignment = HorizontalAlignment(key: "trailing")
}

@available(iOS 16.0, macOS 13.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension HorizontalAlignment {

    /// A guide marking the leading edge of a `List` row separator.
    ///
    /// Use this guide to align the leading end of the bottom `List` row
    /// separator with any other horizontal guide of a view that is part of the
    /// cell content.
    ///
    /// The following example shows the row separator aligned with the leading
    /// edge of the `Text` containing the name of food:
    ///
    ///     List {
    ///         ForEach(favoriteFoods) { food in
    ///             HStack {
    ///                 Text(food.emoji)
    ///                     .font(.system(size: 40))
    ///                 Text(food.name)
    ///                     .alignmentGuide(.listRowSeparatorLeading) {
    ///                         $0[.leading]
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// To change the visibility or tint of the row separator use respectively
    /// ``View/listRowSeparator(_:edges:)`` and
    /// ``View/listRowSeparatorTint(_:edges:)``.
    ///
    public static let listRowSeparatorLeading: HorizontalAlignment = { fatalError() }()

    /// A guide marking the trailing edge of a `List` row separator.
    ///
    /// Use this guide to align the trailing end of the bottom `List` row
    /// separator with any other horizontal guide of a view that is part of the
    /// cell content.
    ///
    /// To change the visibility or tint of the row separator use respectively
    /// ``View/listRowSeparator(_:edges:)`` and
    /// ``View/listRowSeparatorTint(_:edges:)``.
    ///
    public static let listRowSeparatorTrailing: HorizontalAlignment = { fatalError() }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension HorizontalAlignment : Sendable {
}

#endif
