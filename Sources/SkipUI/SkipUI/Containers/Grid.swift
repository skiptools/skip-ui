// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if false

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize

/// A container view that arranges other views in a two dimensional layout.
///
/// Create a two dimensional layout by initializing a `Grid` with a collection
/// of ``GridRow`` structures. The first view in each grid row appears in
/// the grid's first column, the second view in the second column, and so
/// on. The following example creates a grid with two rows and two columns:
///
///     Grid {
///         GridRow {
///             Text("Hello")
///             Image(systemName: "globe")
///         }
///         GridRow {
///             Image(systemName: "hand.wave")
///             Text("World")
///         }
///     }
///
/// A grid and its rows behave something like a collection of ``HStack``
/// instances wrapped in a ``VStack``. However, the grid handles row and column
/// creation as a single operation, which applies alignment and spacing to
/// cells, rather than first to rows and then to a column of unrelated rows.
/// The grid produced by the example above demonstrates this:
///
/// ![A screenshot of items arranged in a grid. The upper-left
/// position in the grid contains the word hello. The upper-right contains
/// an image of a globe. The lower-left contains an image of a waving hand.
/// The lower-right contains the word world. The cells of the grid
/// have minimal vertical or horizontal spacing.](Grid-1-iOS)
///
/// > Note: If you need a grid that conforms to the ``Layout``
/// protocol, like when you want to create a conditional layout using
/// ``AnyLayout``, use ``GridLayout`` instead.
///
/// ### Multicolumn cells
///
/// If you provide a view rather than a ``GridRow`` as an element in the
/// grid's content, the grid uses the view to create a row that spans all of
/// the grid's columns. For example, you can add a ``Divider`` between the
/// rows of the previous example:
///
///     Grid {
///         GridRow {
///             Text("Hello")
///             Image(systemName: "globe")
///         }
///         Divider()
///         GridRow {
///             Image(systemName: "hand.wave")
///             Text("World")
///         }
///     }
///
/// Because a divider takes as much horizontal space as its parent offers, the
/// entire grid widens to fill the width offered by its parent view.
///
/// ![A screenshot of items arranged in a grid. The upper-left
/// cell in the grid contains the word hello. The upper right contains
/// an image of a globe. The lower-left contains an image of a waving hand.
/// The lower-right contains the word world. A dividing line that spans
/// the width of the grid separates the upper and lower elements. The grid's
/// rows have minimal vertical spacing, but it's columns have a lot of
/// horizontal spacing, with column content centered horizontally.](Grid-2-iOS)
///
/// To prevent a flexible view from taking more space on a given axis than the
/// other cells in a row or column require, add the
/// ``View/gridCellUnsizedAxes(_:)`` view modifier to the view:
///
///     Divider()
///         .gridCellUnsizedAxes(.horizontal)
///
/// This restores the grid to the width that the text and images require:
///
/// ![A screenshot of items arranged in a grid. The upper-left
/// position in the grid contains the word hello. The upper-right contains
/// an image of a globe. The lower-left contains an image of a waving hand.
/// The lower-right contains the word world. A dividing line that spans
/// the width of the grid separates the upper and lower elements. The grid's
/// rows and columns have minimal vertical or horizontal spacing.](Grid-3-iOS)
///
/// To make a cell span a specific number of columns rather than the whole
/// grid, use the ``View/gridCellColumns(_:)`` modifier on a view that's
/// contained inside a ``GridRow``.
///
/// ### Column count
///
/// The grid's column count grows to handle the row with the largest number of
/// columns. If you create rows with different numbers of columns, the grid
/// adds empty cells to the trailing edge of rows that have fewer columns.
/// The example below creates three rows with different column counts:
///
///     Grid {
///         GridRow {
///             Text("Row 1")
///             ForEach(0..<2) { _ in Color.red }
///         }
///         GridRow {
///             Text("Row 2")
///             ForEach(0..<5) { _ in Color.green }
///         }
///         GridRow {
///             Text("Row 3")
///             ForEach(0..<4) { _ in Color.blue }
///         }
///     }
///
/// The resulting grid has as many columns as the widest row, adding empty
/// cells to rows that don't specify enough views:
///
/// ![A screenshot of a grid with three rows and six columns. The first
/// column contains cells with the labels Row 1, Row 2, and Row 3, reading
/// from top to bottom. The text is centered in the cell in each case. The
/// other columns contain cells that are either filled with a rectangle, or
/// that are empty. Scanning from left to right, the first row contains two
/// red rectangle cells after its label cell, and then three empty cells.
/// The second row contains five green rectangle cells after its label cell.
/// The third row contains four blue rectangle cells after its label cell,
/// and then one empty cell. There's 20 points of space between each of
/// the cells.](Grid-4-iOS)
///
/// The grid sets the width of all the cells in a column to match the needs of
/// column's widest cell. In the example above, the width of the first column
/// depends on the width of the widest ``Text`` view that the column contains.
/// The other columns, which contain flexible ``Color`` views, share the
/// remaining horizontal space offered by the grid's parent view equally.
///
/// Similarly, the tallest cell in a row sets the height of the entire row.
/// The cells in the first column of the grid above need only the height
/// required for each string, but the ``Color`` cells expand to equally share
/// the total height available to the grid. As a result, the color cells
/// determine the row heights.
///
/// ### Cell spacing and alignment
///
/// You can control the spacing between cells in both the horizontal and
/// vertical dimensions and set a default alignment for the content in all
/// the grid cells when you initialize the grid using the
/// ``init(alignment:horizontalSpacing:verticalSpacing:content:)`` initializer.
/// Consider a modified version of the previous example:
///
///     Grid(alignment: .bottom, horizontalSpacing: 1, verticalSpacing: 1) {
///         // ...
///     }
///
/// This configuration causes all of the cells to use ``Alignment/bottom``
/// alignment --- which only affects the text cells because the colors fill
/// their cells completely --- and it reduces the spacing between cells:
///
/// ![A screenshot of a grid with three rows and six columns. The first
/// column contains cells with the labels Row 1, Row 2, and Row 3, reading
/// from top to bottom. The text is horizontally centered and bottom aligned
/// in the cell in each case. The other columns contain cells that are either
/// filled with a rectangle, or that are empty. Scanning from left to right,
/// the first row contains two red rectangle cells after its label cell, and
/// then three empty cells. The second row contains five green rectangle cells
/// after its label cell. The third row contains four blue rectangle cells
/// after its label cell, and then one empty cell. There's 1 point of space
/// between each of the cells.](Grid-5-iOS)
///
/// You can override the alignment of specific cells or groups of cells. For
/// example, you can change the horizontal alignment of the cells in a column
/// by adding the ``View/gridColumnAlignment(_:)`` modifier, or the vertical
/// alignment of the cells in a row by configuring the row's
/// ``GridRow/init(alignment:content:)`` initializer. You can also align
/// a single cell with the ``View/gridCellAnchor(_:)`` modifier.
///
/// ### Performance considerations
///
/// A grid can size its rows and columns correctly because
/// it renders all of its child views immediately. If your app exhibits
/// poor performance when it first displays a large grid that appears
/// inside a ``ScrollView``, consider switching to a ``LazyVGrid`` or
/// ``LazyHGrid`` instead.
///
/// Lazy grids render their cells when SkipUI needs to display
/// them, rather than all at once. This reduces the initial cost of displaying
/// a large scrollable grid that's never fully visible, but also reduces the
/// grid's ability to optimally lay out cells. Switch to a lazy grid only if
/// profiling your code shows a worthwhile performance improvement.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct Grid<Content> where Content : View {

    /// Creates a grid with the specified spacing, alignment, and child
    /// views.
    ///
    /// Use this initializer to create a ``Grid``. Provide a content closure
    /// that defines the rows of the grid, and optionally customize the
    /// spacing between cells and the alignment of content within each cell.
    /// The following example customizes the spacing between cells:
    ///
    ///     Grid(horizontalSpacing: 30, verticalSpacing: 30) {
    ///         ForEach(0..<5) { row in
    ///             GridRow {
    ///                 ForEach(0..<5) { column in
    ///                     Text("(\(column), \(row))")
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// You can list rows and the cells within rows directly, or you can
    /// use a ``ForEach`` structure to generate either, as the example above
    /// does:
    ///
    /// ![A screenshot of a grid that contains five rows and five columns.
    /// Each cell in the grid contains an pair of integers in parentheses.
    /// The first integer indicates the column position, counting from zero
    /// on the left up to four on the right. The second integer indicates the
    /// row position, counting from zero on the top to four on the
    /// bottom.](Grid-init-1-iOS)
    ///
    /// By default, the grid's alignment value applies to all of the cells in
    /// the grid. However, you can also change the alignment for particular
    /// cells or groups of cells:
    ///
    /// * Override the vertical alignment for the cells in a row
    ///   by specifying a ``VerticalAlignment`` parameter to the corresponding
    ///   row's ``GridRow/init(alignment:content:)`` initializer.
    /// * Override the horizontal alignment for the cells in a column by adding
    ///   a ``View/gridColumnAlignment(_:)`` view modifier to exactly one of
    ///   the cells in the column, and specifying a ``HorizontalAlignment``
    ///   parameter.
    /// * Specify a custom alignment anchor for a particular cell by using the
    ///   ``View/gridCellAnchor(_:)`` modifier on the cell's view.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the child views within the
    ///     space allocated for a given cell. The default is
    ///     ``Alignment/center``.
    ///   - horizontalSpacing: The horizontal distance between each cell, given
    ///     in points. The value is `nil` by default, which results in a
    ///     default distance between cells that's appropriate for the platform.
    ///   - verticalSpacing: The vertical distance between each cell, given
    ///     in points. The value is `nil` by default, which results in a
    ///     default distance between cells that's appropriate for the platform.
    ///   - content: A closure that creates the grid's rows.
    ///
    @inlinable public init(alignment: Alignment = .center, horizontalSpacing: CGFloat? = nil, verticalSpacing: CGFloat? = nil, @ViewBuilder content: () -> Content) { fatalError() }

    public typealias Body = NeverView
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Grid : View {
    public var body: Body { fatalError() }
}

/// A description of a row or a column in a lazy grid.
///
/// Use an array of `GridItem` instances to configure the layout of items in
/// a lazy grid. Each grid item in the array specifies layout properties like
/// size and spacing for the rows of a ``LazyHGrid`` or the columns of
/// a ``LazyVGrid``. The following example defines four rows for a
/// horizontal grid, each with different characteristics:
///
///     struct GridItemDemo: View {
///         let rows = [
///             GridItem(.fixed(30), spacing: 1),
///             GridItem(.fixed(60), spacing: 10),
///             GridItem(.fixed(90), spacing: 20),
///             GridItem(.fixed(10), spacing: 50)
///         ]
///
///         var body: some View {
///             ScrollView(.horizontal) {
///                 LazyHGrid(rows: rows, spacing: 5) {
///                     ForEach(0...300, id: \.self) { _ in
///                         Color.red.frame(width: 30)
///                         Color.green.frame(width: 30)
///                         Color.blue.frame(width: 30)
///                         Color.yellow.frame(width: 30)
///                     }
///                 }
///             }
///         }
///     }
///
/// A lazy horizontal grid sets the width of each column based on the widest
/// cell in the column. It can do this because it has access to all of the views
/// in a given column at once. In the example above, the ``Color`` views always
/// have the same fixed width, resulting in a uniform column width across the
/// whole grid.
///
/// However, a lazy horizontal grid doesn't generally have access to all the
/// views in a row, because it generates new cells as people scroll through
/// information in your app. Instead, it relies on a grid item for information
/// about each row. The example above indicates a different fixed height for
/// each row, and sets a different amount of spacing to appear after each row:
///
/// ![A screenshot of a grid of rectangles arranged in four rows and a large
/// number of colums. All the rectangles are the same width, and have a uniform
/// horizontal spacing. The rectangles in a given row are the same height as
/// each other, but different than the rectangles in other rows. The vertical
/// spacing between rows also varies.](GridItem-1-iOS)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct GridItem : Sendable {

    /// The size in the minor axis of one or more rows or columns in a grid
    /// layout.
    ///
    /// Use a `Size` instance when you create a ``GridItem``. The value tells a
    /// ``LazyHGrid`` how to size its rows, or a ``LazyVGrid`` how to size
    /// its columns.
    public enum Size : Sendable {

        /// A single item with the specified fixed size.
        case fixed(CGFloat)

        /// A single flexible item.
        ///
        /// The size of this item is the size of the grid with spacing and
        /// inflexible items removed, divided by the number of flexible items,
        /// clamped to the provided bounds.
        case flexible(minimum: CGFloat = 10, maximum: CGFloat = .infinity)

        /// Multiple items in the space of a single flexible item.
        ///
        /// This size case places one or more items into the space assigned to
        /// a single `flexible` item, using the provided bounds and
        /// spacing to decide exactly how many items fit. This approach prefers
        /// to insert as many items of the `minimum` size as possible
        /// but lets them increase to the `maximum` size.
        case adaptive(minimum: CGFloat, maximum: CGFloat = .infinity)
    }

    /// The size of the item, which is the width of a column item or the
    /// height of a row item.
    public var size: GridItem.Size { get { fatalError() } }

    /// The spacing to the next item.
    ///
    /// If this value is `nil`, the item uses a reasonable default for the
    /// current platform.
    public var spacing: CGFloat?

    /// The alignment to use when placing each view.
    ///
    /// Use this property to anchor the view's relative position to the same
    /// relative position in the view's assigned grid space.
    public var alignment: Alignment?

    /// Creates a grid item with the specified size, spacing, and alignment.
    ///
    /// - Parameters:
    ///   - size: The size of the grid item.
    ///   - spacing: The spacing to use between this and the next item.
    ///   - alignment: The alignment to use for this grid item.
    public init(_ size: GridItem.Size = .flexible(), spacing: CGFloat? = nil, alignment: Alignment? = nil) { fatalError() }
}

/// A grid that you can use in conditional layouts.
///
/// This layout container behaves like a ``Grid``, but conforms to the
/// ``Layout`` protocol so you can use it in the conditional layouts that you
/// construct with ``AnyLayout``. If you don't need a conditional layout, use
/// ``Grid`` instead.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct GridLayout {

    /// The alignment of subviews.
    public var alignment: Alignment { get { fatalError() } }

    /// The horizontal distance between adjacent subviews.
    ///
    /// Set this value to `nil` to use default horizonal distances between
    /// subviews.
    public var horizontalSpacing: CGFloat?

    /// The vertical distance between adjacent subviews.
    ///
    /// Set this value to `nil` to use default vertical distances between
    /// subviews.
    public var verticalSpacing: CGFloat?

    /// Creates a grid with the specified spacing and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning subviews within the
    ///     space allocated for a given cell. The default is
    ///     ``Alignment/center``.
    ///   - horizontalSpacing: The horizontal distance between each cell, given
    ///     in points. The value is `nil` by default, which results in a
    ///     default distance between cells that's appropriate for the platform.
    ///   - verticalSpacing: The vertical distance between each cell, given
    ///     in points. The value is `nil` by default, which results in a
    ///     default distance between cells that's appropriate for the platform.table
    ///
    @inlinable public init(alignment: Alignment = .center, horizontalSpacing: CGFloat? = nil, verticalSpacing: CGFloat? = nil) { fatalError() }

    public typealias Body = NeverView
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension GridLayout : Layout {

    /// Creates and initializes a cache for a layout instance.
    ///
    /// You can optionally use a cache to preserve calculated values across
    /// calls to a layout container's methods. Many layout types don't need
    /// a cache, because SkipUI automatically reuses both the results of
    /// calls into the layout and the values that the layout reads from its
    /// subviews. Rely on the protocol's default implementation of this method
    /// if you don't need a cache.
    ///
    /// However you might find a cache useful when:
    ///
    /// - The layout container repeats complex, intermediate calculations
    /// across calls like ``sizeThatFits(proposal:subviews:cache:)``,
    /// ``placeSubviews(in:proposal:subviews:cache:)``, and
    /// ``explicitAlignment(of:in:proposal:subviews:cache:)-8ofeu``.
    /// You might be able to improve performance by calculating values
    /// once and storing them in a cache.
    /// - The layout container reads many ``LayoutValueKey`` values from
    /// subviews. It might be more efficient to do that once and store the
    /// results in the cache, rather than rereading the subviews' values before
    /// each layout call.
    /// - You want to maintain working storage, like temporary Swift arrays,
    /// across calls into the layout, to minimize the number of allocation
    /// events.
    ///
    /// Only implement a cache if profiling shows that it improves performance.
    ///
    /// ### Initialize a cache
    ///
    /// Implement the `makeCache(subviews:)` method to create a cache.
    /// You can add computed values to the cache right away, using information
    /// from the `subviews` input parameter, or you can do that later. The
    /// methods of the ``Layout`` protocol that can access the cache
    /// take the cache as an in-out parameter, which enables you to modify
    /// the cache anywhere that you can read it.
    ///
    /// You can use any storage type that makes sense for your layout
    /// algorithm, but be sure that you only store data that you derive
    /// from the layout and its subviews (lazily, if possible). For this to
    /// work correctly, SkipUI needs to be able to call this method to
    /// recreate the cache without changing the layout result.
    ///
    /// When you return a cache from this method, you implicitly define a type
    /// for your cache. Be sure to either make the type of the `cache`
    /// parameters on your other ``Layout`` protocol methods match, or use
    /// a type alias to define the ``Cache`` associated type.
    ///
    /// ### Update the cache
    ///
    /// If the layout container or any of its subviews change, SkipUI
    /// calls the ``updateCache(_:subviews:)-9hkj9`` method so you can
    /// modify or invalidate the contents of the
    /// cache. The default implementation of that method calls the
    /// `makeCache(subviews:)` method to recreate the cache, but you can
    /// provide your own implementation of the update method to take an
    /// incremental approach, if appropriate.
    ///
    /// - Parameters:
    ///   - subviews: A collection of proxy instances that represent the
    ///     views that the container arranges. You can use the proxies in the
    ///     collection to get information about the subviews as you
    ///     calculate values to store in the cache.
    ///
    /// - Returns: Storage for calculated data that you share among
    ///   the methods of your custom layout container.
    public func makeCache(subviews: GridLayout.Subviews) -> GridLayout.Cache { fatalError() }

    /// Updates the layout's cache when something changes.
    ///
    /// If your custom layout container creates a cache by implementing the
    /// ``makeCache(subviews:)-23agy`` method, SkipUI calls the update method
    /// when your layout or its subviews change, giving you an opportunity
    /// to modify or invalidate the contents of the cache.
    /// The method's default implementation recreates the
    /// cache by calling the ``makeCache(subviews:)-23agy`` method,
    /// but you can provide your own implementation to take an
    /// incremental approach, if appropriate.
    ///
    /// - Parameters:
    ///   - cache: Storage for calculated data that you share among
    ///     the methods of your custom layout container.
    ///   - subviews: A collection of proxy instances that represent the
    ///     views arranged by the container. You can use the proxies in the
    ///     collection to get information about the subviews as you
    ///     calculate values to store in the cache.
    public func updateCache(_ cache: inout GridLayout.Cache, subviews: GridLayout.Subviews) { fatalError() }

    /// Returns the preferred spacing values of the composite view.
    ///
    /// Implement this method to provide custom spacing preferences
    /// for a layout container. The value you return affects
    /// the spacing around the container, but it doesn't affect how the
    /// container arranges subviews relative to one another inside the
    /// container.
    ///
    /// Create a custom ``ViewSpacing`` instance for your container by
    /// initializing one with default values, and then merging that with
    /// spacing instances of certain subviews. For example, if you define
    /// a basic vertical stack that places subviews in a column, you could
    /// use the spacing preferences of the subview edges that make
    /// contact with the container's edges:
    ///
    ///     extension BasicVStack {
    ///         func spacing(subviews: Subviews, cache: inout ()) -> ViewSpacing {
    ///             var spacing = ViewSpacing()
    ///
    ///             for index in subviews.indices {
    ///                 var edges: Edge.Set = [.leading, .trailing]
    ///                 if index == 0 { edges.formUnion(.top) }
    ///                 if index == subviews.count - 1 { edges.formUnion(.bottom) }
    ///                 spacing.formUnion(subviews[index].spacing, edges: edges)
    ///             }
    ///
    ///             return spacing
    ///         }
    ///     }
    ///
    /// In the above example, the first and last subviews contribute to the
    /// spacing above and below the container, respectively, while all subviews
    /// affect the spacing on the leading and trailing edges.
    ///
    /// If you don't implement this method, the protocol provides a default
    /// implementation, namely ``Layout/spacing(subviews:cache:)-1z0gt``,
    /// that merges the spacing preferences across all subviews on all edges.
    ///
    /// - Parameters:
    ///   - subviews: A collection of proxy instances that represent the
    ///     views that the container arranges. You can use the proxies in the
    ///     collection to get information about the subviews as you determine
    ///     how much spacing the container prefers around it.
    ///   - cache: Optional storage for calculated data that you can share among
    ///     the methods of your custom layout container. See
    ///     ``makeCache(subviews:)-23agy`` for details.
    ///
    /// - Returns: A ``ViewSpacing`` instance that describes the preferred
    ///   spacing around the container view.
    public func spacing(subviews: GridLayout.Subviews, cache: inout GridLayout.Cache) -> ViewSpacing { fatalError() }

    /// Returns the size of the composite view, given a proposed size
    /// and the view's subviews.
    ///
    /// Implement this method to tell your custom layout container's parent
    /// view how much space the container needs for a set of subviews, given
    /// a size proposal. The parent might call this method more than once
    /// during a layout pass with different proposed sizes to test the
    /// flexibility of the container, using proposals like:
    ///
    /// * The ``ProposedViewSize/zero`` proposal; respond with the
    ///   layout's minimum size.
    /// * The ``ProposedViewSize/infinity`` proposal; respond with the
    ///   layout's maximum size.
    /// * The ``ProposedViewSize/unspecified`` proposal; respond with the
    ///   layout's ideal size.
    ///
    /// The parent might also choose to test flexibility in one dimension at a
    /// time. For example, a horizontal stack might propose a fixed height and
    /// an infinite width, and then the same height with a zero width.
    ///
    /// The following example calculates the size for a basic vertical stack
    /// that places views in a column, with no spacing between the views:
    ///
    ///     private struct BasicVStack: Layout {
    ///         func sizeThatFits(
    ///             proposal: ProposedViewSize,
    ///             subviews: Subviews,
    ///             cache: inout ()
    ///         ) -> CGSize {
    ///             subviews.reduce(CGSize.zero) { result, subview in
    ///                 let size = subview.sizeThatFits(.unspecified)
    ///                 return CGSize(
    ///                     width: max(result.width, size.width),
    ///                     height: result.height + size.height)
    ///             }
    ///         }
    ///
    ///         // This layout also needs a placeSubviews() implementation.
    ///     }
    ///
    /// The implementation asks each subview for its ideal size by calling the
    /// ``LayoutSubview/sizeThatFits(_:)`` method with an
    /// ``ProposedViewSize/unspecified`` proposed size.
    /// It then reduces these values into a single size that represents
    /// the maximum subview width and the sum of subview heights.
    /// Because this example isn't flexible, it ignores its size proposal
    /// input and always returns the same value for a given set of subviews.
    ///
    /// SkipUI views choose their own size, so the layout engine always
    /// uses a value that you return from this method as the actual size of the
    /// composite view. That size factors into the construction of the `bounds`
    /// input to the ``placeSubviews(in:proposal:subviews:cache:)`` method.
    ///
    /// - Parameters:
    ///   - proposal: A size proposal for the container. The container's parent
    ///     view that calls this method might call the method more than once
    ///     with different proposals to learn more about the container's
    ///     flexibility before deciding which proposal to use for placement.
    ///   - subviews: A collection of proxies that represent the
    ///     views that the container arranges. You can use the proxies in the
    ///     collection to get information about the subviews as you determine
    ///     how much space the container needs to display them.
    ///   - cache: Optional storage for calculated data that you can share among
    ///     the methods of your custom layout container. See
    ///     ``makeCache(subviews:)-23agy`` for details.
    ///
    /// - Returns: A size that indicates how much space the container
    ///   needs to arrange its subviews.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: GridLayout.Subviews, cache: inout GridLayout.Cache) -> CGSize { fatalError() }

    /// Assigns positions to each of the layout's subviews.
    ///
    /// SkipUI calls your implementation of this method to tell your
    /// custom layout container to place its subviews. From this method, call
    /// the ``LayoutSubview/place(at:anchor:proposal:)`` method on each
    /// element in `subviews` to tell the subviews where to appear in the
    /// user interface.
    ///
    /// For example, you can create a basic vertical stack that places views
    /// in a column, with views horizontally aligned on their leading edge:
    ///
    ///     struct BasicVStack: Layout {
    ///         func placeSubviews(
    ///             in bounds: CGRect,
    ///             proposal: ProposedViewSize,
    ///             subviews: Subviews,
    ///             cache: inout ()
    ///         ) {
    ///             var point = bounds.origin
    ///             for subview in subviews {
    ///                 subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
    ///                 point.y += subview.dimensions(in: .unspecified).height
    ///             }
    ///         }
    ///
    ///         // This layout also needs a sizeThatFits() implementation.
    ///     }
    ///
    /// The example creates a placement point that starts at the origin of the
    /// specified `bounds` input and uses that to place the first subview. It
    /// then moves the point in the y dimension by the subview's height,
    /// which it reads using the ``LayoutSubview/dimensions(in:)`` method.
    /// This prepares the point for the next iteration of the loop. All
    /// subview operations use an ``ProposedViewSize/unspecified`` size
    /// proposal to indicate that subviews should use and report their ideal
    /// size.
    ///
    /// A more complex layout container might add space between subviews
    /// according to their ``LayoutSubview/spacing`` preferences, or a
    /// fixed space based on input configuration. For example, you can extend
    /// the basic vertical stack's placement method to calculate the
    /// preferred distances between adjacent subviews and store the results in
    /// an array:
    ///
    ///     let spacing: [CGFloat] = subviews.indices.dropLast().map { index in
    ///         subviews[index].spacing.distance(
    ///             to: subviews[index + 1].spacing,
    ///             along: .vertical)
    ///     }
    ///
    /// The spacing's ``ViewSpacing/distance(to:along:)`` method considers the
    /// preferences of adjacent views on the edge where they meet. It returns
    /// the smallest distance that satisfies both views' preferences for the
    /// given edge. For example, if one view prefers at least `2` points on its
    /// bottom edge, and the next view prefers at least `8` points on its top
    /// edge, the distance method returns `8`, because that's the smallest
    /// value that satisfies both preferences.
    ///
    /// Update the placement calculations to use the spacing values:
    ///
    ///     var point = bounds.origin
    ///     for (index, subview) in subviews.enumerated() {
    ///         if index > 0 { point.y += spacing[index - 1] } // Add spacing.
    ///         subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
    ///         point.y += subview.dimensions(in: .unspecified).height
    ///     }
    ///
    /// Be sure that you use computations during placement that are consistent
    /// with those in your implementation of other protocol methods for a given
    /// set of inputs. For example, if you add spacing during placement,
    /// make sure your implementation of
    /// ``sizeThatFits(proposal:subviews:cache:)`` accounts for the extra space.
    /// Similarly, if the sizing method returns different values for different
    /// size proposals, make sure the placement method responds to its
    /// `proposal` input in the same way.
    ///
    /// - Parameters:
    ///   - bounds: The region that the container view's parent allocates to the
    ///     container view, specified in the parent's coordinate space.
    ///     Place all the container's subviews within the region.
    ///     The size of this region matches a size that your container
    ///     previously returned from a call to the
    ///     ``sizeThatFits(proposal:subviews:cache:)`` method.
    ///   - proposal: The size proposal from which the container generated the
    ///     size that the parent used to create the `bounds` parameter.
    ///     The parent might propose more than one size before calling the
    ///     placement method, but it always uses one of the proposals and the
    ///     corresponding returned size when placing the container.
    ///   - subviews: A collection of proxies that represent the
    ///     views that the container arranges. Use the proxies in the collection
    ///     to get information about the subviews and to tell the subviews
    ///     where to appear.
    ///   - cache: Optional storage for calculated data that you can share among
    ///     the methods of your custom layout container. See
    ///     ``makeCache(subviews:)-23agy`` for details.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: GridLayout.Subviews, cache: inout GridLayout.Cache) { fatalError() }

    /// Returns the position of the specified horizontal alignment guide along
    /// the x axis.
    ///
    /// Implement this method to return a value for the specified alignment
    /// guide of a custom layout container. The value you return affects
    /// the placement of the container as a whole, but it doesn't affect how the
    /// container arranges subviews relative to one another.
    ///
    /// You can use this method to put an alignment guide in a nonstandard
    /// position. For example, you can indent the container's leading edge
    /// alignment guide by 10 points:
    ///
    ///     extension BasicVStack {
    ///         func explicitAlignment(
    ///             of guide: HorizontalAlignment,
    ///             in bounds: CGRect,
    ///             proposal: ProposedViewSize,
    ///             subviews: Subviews,
    ///             cache: inout ()
    ///         ) -> CGFloat? {
    ///             if guide == .leading {
    ///                 return bounds.minX + 10
    ///             }
    ///             return nil
    ///         }
    ///     }
    ///
    /// The above example returns `nil` for other guides to indicate that they
    /// don't have an explicit value. A guide without an explicit value behaves
    /// as it would for any other view. If you don't implement the
    /// method, the protocol's default implementation merges the
    /// subviews' guides.
    ///
    /// - Parameters:
    ///   - guide: The ``HorizontalAlignment`` guide that the method calculates
    ///     the position of.
    ///   - bounds: The region that the container view's parent allocates to the
    ///     container view, specified in the parent's coordinate space.
    ///   - proposal: A proposed size for the container.
    ///   - subviews: A collection of proxy instances that represent the
    ///     views arranged by the container. You can use the proxies in the
    ///     collection to get information about the subviews as you determine
    ///     where to place the guide.
    ///   - cache: Optional storage for calculated data that you can share among
    ///     the methods of your custom layout container. See
    ///     ``makeCache(subviews:)-23agy`` for details.
    ///
    /// - Returns: The guide's position relative to the `bounds`.
    ///   Return `nil` to indicate that the guide doesn't have an explicit
    ///   value.
    public func explicitAlignment(of guide: HorizontalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: GridLayout.Subviews, cache: inout GridLayout.Cache) -> CGFloat? { fatalError() }

    /// Returns the position of the specified vertical alignment guide along
    /// the y axis.
    ///
    /// Implement this method to return a value for the specified alignment
    /// guide of a custom layout container. The value you return affects
    /// the placement of the container as a whole, but it doesn't affect how the
    /// container arranges subviews relative to one another.
    ///
    /// You can use this method to put an alignment guide in a nonstandard
    /// position. For example, you can raise the container's bottom edge
    /// alignment guide by 10 points:
    ///
    ///     extension BasicVStack {
    ///         func explicitAlignment(
    ///             of guide: VerticalAlignment,
    ///             in bounds: CGRect,
    ///             proposal: ProposedViewSize,
    ///             subviews: Subviews,
    ///             cache: inout ()
    ///         ) -> CGFloat? {
    ///             if guide == .bottom {
    ///                 return bounds.minY - 10
    ///             }
    ///             return nil
    ///         }
    ///     }
    ///
    /// The above example returns `nil` for other guides to indicate that they
    /// don't have an explicit value. A guide without an explicit value behaves
    /// as it would for any other view. If you don't implement the
    /// method, the protocol's default implementation merges the
    /// subviews' guides.
    ///
    /// - Parameters:
    ///   - guide: The ``VerticalAlignment`` guide that the method calculates
    ///     the position of.
    ///   - bounds: The region that the container view's parent allocates to the
    ///     container view, specified in the parent's coordinate space.
    ///   - proposal: A proposed size for the container.
    ///   - subviews: A collection of proxy instances that represent the
    ///     views arranged by the container. You can use the proxies in the
    ///     collection to get information about the subviews as you determine
    ///     where to place the guide.
    ///   - cache: Optional storage for calculated data that you can share among
    ///     the methods of your custom layout container. See
    ///     ``makeCache(subviews:)-23agy`` for details.
    ///
    /// - Returns: The guide's position relative to the `bounds`.
    ///   Return `nil` to indicate that the guide doesn't have an explicit
    ///   value.
    public func explicitAlignment(of guide: VerticalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: GridLayout.Subviews, cache: inout GridLayout.Cache) -> CGFloat? { fatalError() }

    /// The type defining the data to animate.
    public typealias AnimatableData = EmptyAnimatableData
    public var animatableData: AnimatableData { get { fatalError() } set { } }
}

extension GridLayout {

    /// A stateful grid layout algorithm.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public struct Cache {
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension GridLayout : Sendable {
}

/// A horizontal row in a two dimensional grid container.
///
/// Use one or more `GridRow` instances to define the rows of a ``Grid``
/// container. The child views inside the row define successive grid cells.
/// You can add rows to the grid explicitly, or use the ``ForEach`` structure
/// to generate multiple rows. Similarly, you can add cells to the row
/// explicitly or you can use ``ForEach`` to generate multiple cells inside
/// the row. The following example mixes these strategies:
///
///     Grid {
///         GridRow {
///             Color.clear
///                 .gridCellUnsizedAxes([.horizontal, .vertical])
///             ForEach(1..<4) { column in
///                 Text("C\(column)")
///             }
///         }
///         ForEach(1..<4) { row in
///             GridRow {
///                 Text("R\(row)")
///                 ForEach(1..<4) { _ in
///                     Circle().foregroundStyle(.mint)
///                 }
///             }
///         }
///     }
///
/// The grid in the example above has an explicit first row and three generated
/// rows. Similarly, each row has an explicit first cell and three generated
/// cells:
///
/// ![A screenshot of a grid that contains four rows and four columns. Scanning
/// from left to right, the first row contains an empty cell followed by cells
/// with the strings C1, C2, and C3. Scanning from top to bottom, the first
/// column contains an empty cell, followed by cells with the strings R1, R2,
/// and R3. All the other cells contain circles in a mint color.](GridRow-1-iOS)
///
/// To create an empty cell, use something invisible, like the
/// ``ShapeStyle/clear`` color that appears in the first column of the first
/// row in the example above. However, if you use a flexible view like a
/// ``Color`` or a ``Spacer``, you might also need to add the
/// ``View/gridCellUnsizedAxes(_:)`` modifier to prevent the view from
/// taking up more space than the other cells in the row or column need.
///
/// > Important: You can't use ``EmptyView`` to create a blank cell because
/// that resolves to the absence of a view and doesn't generate a cell.
///
/// By default, the cells in the row use the ``Alignment`` that you define
/// when you initialize the ``Grid``. However, you can override the vertical
/// alignment for the cells in a row by providing a ``VerticalAlignment``
/// value to the row's ``init(alignment:content:)`` initializer.
///
/// If you apply a view modifier to a row, the row applies the modifier to
/// all of the cells, similar to how a ``Group`` behaves. For example,  if
/// you apply the ``View/border(_:width:)`` modifier to a row, SkipUI draws
/// a border on each cell in the row rather than around the row.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen public struct GridRow<Content> where Content : View {

    /// Creates a horizontal row of child views in a grid.
    ///
    /// Use this initializer to create a ``GridRow`` inside of a ``Grid``.
    /// Provide a content closure that defines the cells of the row, and
    /// optionally customize the vertical alignment of content within each cell.
    /// The following example customizes the vertical alignment of the cells
    /// in the first and third rows:
    ///
    ///     Grid(alignment: .trailing) {
    ///         GridRow(alignment: .top) { // Use top vertical alignment.
    ///             Text("Top")
    ///             Color.red.frame(width: 1, height: 50)
    ///             Color.blue.frame(width: 50, height: 1)
    ///         }
    ///         GridRow { // Use the default (center) alignment.
    ///             Text("Center")
    ///             Color.red.frame(width: 1, height: 50)
    ///             Color.blue.frame(width: 50, height: 1)
    ///         }
    ///         GridRow(alignment: .bottom) { // Use bottom vertical alignment.
    ///             Text("Bottom")
    ///             Color.red.frame(width: 1, height: 50)
    ///             Color.blue.frame(width: 50, height: 1)
    ///         }
    ///     }
    ///
    /// The example above specifies ``Alignment/trailing`` alignment for the
    /// grid, which is composed of ``VerticalAlignment/center`` vertical
    /// alignment and ``HorizontalAlignment/trailing`` horizontal alignment.
    /// The middle row relies on the center vertical alignment, but the
    /// other two rows specify custom vertical alignments:
    ///
    /// ![A grid with three rows and three columns. Scanning from top to bottom,
    /// the first column contains cells with the strings top, center, and
    /// bottom. All strings are horizontally aligned on the right and vertically
    /// aligned in a way that matches their content. The second column contains
    /// cells with red vertical lines. The lines consume both the full height
    /// and full width of the cells they occupy. The third column contains
    /// cells with blue horizontal lines that consume the full width of the
    /// cells they occupy, and that are vertically aligned in a way that matches
    /// the text in column one of the corresponding row.](GridRow-init-1-iOS)
    ///
    /// > Important: A grid row behaves like a ``Group`` if you create it
    /// outside of a grid.
    ///
    /// To override column alignment, use ``View/gridColumnAlignment(_:)``. To
    /// override alignment for a single cell, use ``View/gridCellAnchor(_:)``.
    ///
    /// - Parameters:
    ///   - alignment: An optional ``VerticalAlignment`` for the row. If you
    ///     don't specify a value, the row uses the vertical alignment component
    ///     of the ``Alignment`` parameter that you specify in the grid's
    ///     ``Grid/init(alignment:horizontalSpacing:verticalSpacing:content:)``
    ///     initializer, which is ``VerticalAlignment/center`` by default.
    ///   - content: The builder closure that contains the child views. Each
    ///     view in the closure implicitly maps to a cell in the grid.
    ///
    @inlinable public init(alignment: VerticalAlignment? = nil, @ViewBuilder content: () -> Content) { fatalError() }

    public typealias Body = NeverView
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension GridRow : View {
    public var body: Body { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Tells a view that acts as a cell in a grid to span the specified
    /// number of columns.
    ///
    /// By default, each view that you put into the content closure of a
    /// ``GridRow`` corresponds to exactly one column of the grid. Apply the
    /// `gridCellColumns(_:)` modifier to a view that you want to span more
    /// than one column, as in the following example of a typical macOS
    /// configuration view:
    ///
    ///     Grid(alignment: .leadingFirstTextBaseline) {
    ///         GridRow {
    ///             Text("Regular font:")
    ///                 .gridColumnAlignment(.trailing)
    ///             Text("Helvetica 12")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Text("Fixed-width font:")
    ///             Text("Menlo Regular 11")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Color.clear
    ///                 .gridCellUnsizedAxes([.vertical, .horizontal])
    ///             Toggle("Use fixed-width font for new documents", isOn: $isOn)
    ///                 .gridCellColumns(2) // Span two columns.
    ///         }
    ///     }
    ///
    /// The ``Toggle`` in the example above spans the column that contains
    /// the font names and the column that contains the buttons:
    ///
    /// ![A screenshot of a configuration view, arranged in a grid. The grid
    /// has three colums and three rows. Scanning from top to bottom, the
    /// left-most column contains a cell with the text Regular font, a cell with
    /// the text Fixed-width font, and a blank cell. The middle row contains
    /// a cell with the text Helvetica 12, a cell with the text Menlo Regular
    /// 11, and a cell with a labeled checkbox. The label says Use fixed-width
    /// font for new documents. The label spans its own cell and the cell to
    /// its right. The right-most column contains two cells with buttons
    /// labeled Select. The last column's bottom cell is merged with the cell
    /// from the middle columnn that holds the labeled
    /// checkbox.](View-gridCellColumns-1-macOS)
    ///
    /// > Important: When you tell a cell to span multiple columns, the grid
    /// changes the merged cell to use anchor alignment, rather than the
    /// usual alignment guides. For information about the behavior of
    /// anchor alignment, see ``View/gridCellAnchor(_:)``.
    ///
    /// As a convenience you can cause a view to span all of the ``Grid``
    /// columns by placing the view directly in the content closure of the
    /// ``Grid``, outside of a ``GridRow``, and omitting the modifier. To do
    /// the opposite and include more than one view in a cell, group the views
    /// using an appropriate layout container, like an ``HStack``, so that
    /// they act as a single view.
    ///
    /// - Parameters:
    ///   - count: The number of columns that the view should consume
    ///     when placed in a grid row.
    ///
    /// - Returns: A view that occupies the specified number of columns in a
    ///   grid row.
    public func gridCellColumns(_ count: Int) -> some View { return stubView() }


    /// Specifies a custom alignment anchor for a view that acts as a grid cell.
    ///
    /// Grids, like stacks and other layout containers, perform most alignment
    /// operations using alignment guides. The grid moves the contents of each
    /// cell in a row in the y direction until the specified
    /// ``VerticalAlignment`` guide of each view in the row aligns with the same
    /// guide of all the other views in the row. Similarly, the grid aligns the
    /// ``HorizontalAlignment`` guides of views in a column by adjusting views
    /// in the x direction. See the guide types for more information about
    /// typical SkipUI alignment operations.
    ///
    /// When you use the `gridCellAnchor(_:)` modifier on a
    /// view in a grid, the grid changes to an anchor-based alignment strategy
    /// for the associated cell. With anchor alignment, the grid projects a
    /// ``UnitPoint`` that you specify onto both the view and the cell, and
    /// aligns the two projections. For example, consider the following grid:
    ///
    ///     Grid(horizontalSpacing: 1, verticalSpacing: 1) {
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.red.frame(width: 60, height: 60)
    ///         }
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.blue.frame(width: 10, height: 10)
    ///                 .gridCellAnchor(UnitPoint(x: 0.25, y: 0.75))
    ///         }
    ///     }
    ///
    /// The grid creates red reference squares in the first row and column to
    /// establish row and column sizes. Without the anchor modifier, the blue
    /// marker in the remaining cell would appear at the center of its cell,
    /// because of the grid's default ``Alignment/center`` alignment. With
    /// the anchor modifier shown in the code above, the grid aligns the one
    /// quarter point of the marker with the one quarter point of its cell in
    /// the x direction, as measured from the origin at the top left of the
    /// cell. The grid also aligns the three quarters point of the marker
    /// with the three quarters point of the cell in the y direction:
    ///
    /// ![A screenshot of a grid with two rows and two columns. The cells in
    /// the top row and left-most column are each completely filled with a red
    /// rectangle. The lower-right cell contains a small blue square that's
    /// horizontally placed about one quarter of the way from the left to the
    /// right, and about three quarters of the way from the top to the
    /// bottom of the cell it occupies.](View-gridCellAnchor-1-iOS)
    ///
    /// ``UnitPoint`` defines many convenience points that correspond to the
    /// typical alignment guides, which you can use as well. For example, you
    /// can use ``UnitPoint/topTrailing`` to align the top and trailing edges
    /// of a view in a cell with the top and trailing edges of the cell:
    ///
    ///     Color.blue.frame(width: 10, height: 10)
    ///         .gridCellAnchor(.topTrailing)
    ///
    /// ![A screenshot of a grid with two rows and two columns. The cells in
    /// the top row and left-most column are each completely filled with a red
    /// rectangle. The lower-right cell contains a small blue square that's
    /// horizontally aligned with the trailing edge, and vertically aligned
    /// with the top edge of the cell.](View-gridCellAnchor-2-iOS)
    ///
    /// Applying the anchor-based alignment strategy to a single cell
    /// doesn't affect the alignment strategy that the grid uses on other cells.
    ///
    /// ### Anchor alignment for merged cells
    ///
    /// If you use the ``View/gridCellColumns(_:)`` modifier to cause
    /// a cell to span more than one column, or if you place a view in a grid
    /// outside of a row so that the view spans the entire grid, the grid
    /// automatically converts its vertical and horizontal alignment guides
    /// to the unit point equivalent for the merged cell, and uses an
    /// anchor-based approach for that cell. For example, the following grid
    /// places the marker at the center of the merged cell by converting the
    /// grid's default ``Alignment/center`` alignment guide to a
    /// ``UnitPoint/center`` anchor for the blue marker in the merged cell:
    ///
    ///     Grid(alignment: .center, horizontalSpacing: 1, verticalSpacing: 1) {
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.red.frame(width: 60, height: 60)
    ///         }
    ///         GridRow {
    ///             Color.red.frame(width: 60, height: 60)
    ///             Color.blue.frame(width: 10, height: 10)
    ///                 .gridCellColumns(2)
    ///         }
    ///     }
    ///
    /// The grid makes this conversion in part to avoid ambiguity. Each column
    /// has its own horizontal guide, and it isn't clear which of these
    /// a cell that spans multiple columns should align with. Further, in
    /// the example above, neither of the center alignment guides for the
    /// second or third column would provide the expected behavior, which is
    /// to center the marker in the merged cell. Anchor alignment provides
    /// this behavior:
    ///
    /// ![A screenshot of a grid with two rows and three columns. The cells in
    /// the top row and left-most column are each completely filled with a red
    /// rectangle. The other two cells are meged into a single cell that
    /// contains a small blue square that's centered in the merged
    /// cell.](View-gridCellAnchor-3-iOS)
    ///
    /// - Parameters:
    ///   - anchor: The unit point that defines how to align the view
    ///     within the bounds of its grid cell.
    ///
    /// - Returns: A view that uses the specified anchor point to align its
    ///   content.
    public func gridCellAnchor(_ anchor: UnitPoint) -> some View { return stubView() }


    /// Overrides the default horizontal alignment of the grid column that
    /// the view appears in.
    ///
    /// You set a default alignment for the cells in a grid in both vertical
    /// and horizontal dimensions when you create the grid with the
    /// ``Grid/init(alignment:horizontalSpacing:verticalSpacing:content:)``
    /// initializer. However, you can use the `gridColumnAlignment(_:)` modifier
    /// to override the horizontal alignment of a column within the grid. The
    /// following example sets a grid's alignment to
    /// ``Alignment/leadingFirstTextBaseline``, and then sets the first column
    /// to use ``HorizontalAlignment/trailing`` alignment:
    ///
    ///     Grid(alignment: .leadingFirstTextBaseline) {
    ///         GridRow {
    ///             Text("Regular font:")
    ///                 .gridColumnAlignment(.trailing) // Align the entire first column.
    ///             Text("Helvetica 12")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Text("Fixed-width font:")
    ///             Text("Menlo Regular 11")
    ///             Button("Select...") { }
    ///         }
    ///         GridRow {
    ///             Color.clear
    ///                 .gridCellUnsizedAxes([.vertical, .horizontal])
    ///             Toggle("Use fixed-width font for new documents", isOn: $isOn)
    ///                 .gridCellColumns(2)
    ///         }
    ///     }
    ///
    /// This creates the layout of a typical macOS configuration
    /// view, with the trailing edge of the first column flush with the
    /// leading edge of the second column:
    ///
    /// ![A screenshot of a configuration view, arranged in a grid. The grid
    /// has three colums and three rows. Scanning from top to bottom, the
    /// left-most column contains a cell with the text Regular font, a cell with
    /// the text Fixed-width font, and a blank cell. The middle row contains
    /// a cell with the text Helvetica 12, a cell with the text Menlo Regular
    /// 11, and a cell with a labeled checkbox. The label says Use fixed-width
    /// font for new documents. The label spans its own cell and the cell to
    /// its right. The right-most column contains two cells with buttons
    /// labeled Select. The last column's bottom cell is merged with the cell
    /// from the middle columnn that holds the labeled
    /// checkbox.](View-gridColumnAlignment-1-macOS)
    ///
    /// Add the modifier to only one cell in a column. The grid
    /// automatically aligns all cells in that column the same way.
    /// You get undefined behavior if you apply different alignments to
    /// different cells in the same column.
    ///
    /// To override row alignment, see ``GridRow/init(alignment:content:)``. To
    /// override alignment for a single cell, see ``View/gridCellAnchor(_:)``.
    ///
    /// - Parameters:
    ///   - guide: The ``HorizontalAlignment`` guide to use for the grid
    ///     column that the view appears in.
    ///
    /// - Returns: A view that uses the specified horizontal alignment, and
    ///   that causes all cells in the same column of a grid to use the
    ///   same alignment.
    public func gridColumnAlignment(_ guide: HorizontalAlignment) -> some View { return stubView() }


    /// Asks grid layouts not to offer the view extra size in the specified
    /// axes.
    ///
    /// Use this modifier to prevent a flexible view from taking more space
    /// on the specified axes than the other cells in a row or column require.
    /// For example, consider the following ``Grid`` that places a ``Divider``
    /// between two rows of content:
    ///
    ///     Grid {
    ///         GridRow {
    ///             Text("Hello")
    ///             Image(systemName: "globe")
    ///         }
    ///         Divider()
    ///         GridRow {
    ///             Image(systemName: "hand.wave")
    ///             Text("World")
    ///         }
    ///     }
    ///
    /// The text and images all have ideal widths for their content. However,
    /// because a divider takes as much space as its parent offers, the grid
    /// fills the width of the display, expanding all the other cells to match:
    ///
    /// ![A screenshot of items arranged in a grid. The upper-left
    /// cell in the grid contains the word hello. The upper-right contains
    /// an image of a globe. The lower-left contains an image of a waving hand.
    /// The lower-right contains the word world. A dividing line that spans
    /// the width of the grid separates the upper and lower elements. The grid's
    /// rows have minimal vertical spacing, but it's columns have a lot of
    /// horizontal spacing, with column content centered
    /// horizontally.](View-gridCellUnsizedAxes-1-iOS)
    ///
    /// You can prevent the grid from giving the divider more width than
    /// the other cells require by adding the modifier with the
    /// ``Axis/horizontal`` parameter:
    ///
    ///     Divider()
    ///         .gridCellUnsizedAxes(.horizontal)
    ///
    /// This restores the grid to the width that it would have without the
    /// divider:
    ///
    /// ![A screenshot of items arranged in a grid. The upper-left
    /// position in the grid contains the word hello. The upper-right contains
    /// an image of a globe. The lower-left contains an image of a waving hand.
    /// The lower-right contains the word world. A dividing line that spans
    /// the width of the grid separates the upper and lower elements. The grid's
    /// rows and columns have minimal vertical or horizontal
    /// spacing.](View-gridCellUnsizedAxes-2-iOS)
    ///
    /// - Parameters:
    ///   - axes: The dimensions in which the grid shouldn't offer the view a
    ///     share of any available space. This prevents a flexible view like a
    ///     ``Spacer``, ``Divider``, or ``Color`` from defining the size of
    ///     a row or column.
    ///
    /// - Returns: A view that doesn't ask an enclosing grid for extra size
    ///   in one or more axes.
    public func gridCellUnsizedAxes(_ axes: Axis.Set) -> some View { return stubView() }

}

#endif
