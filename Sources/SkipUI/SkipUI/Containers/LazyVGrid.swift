// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if false

import struct CoreGraphics.CGFloat

/// A container view that arranges its child views in a grid that
/// grows vertically, creating items only as needed.
///
/// Use a lazy vertical grid when you want to display a large, vertically
/// scrollable collection of views arranged in a two dimensional layout. The
/// first view that you provide to the grid's `content` closure appears in the
/// top row of the column that's on the grid's leading edge. Additional views
/// occupy successive cells in the grid, filling the first row from leading to
/// trailing edges, then the second row, and so on. The number of rows can grow
/// unbounded, but you specify the number of columns by providing a
/// corresponding number of ``GridItem`` instances to the grid's initializer.
///
/// The grid in the following example defines two columns and uses a
/// ``ForEach`` structure to repeatedly generate a pair of ``Text`` views for
/// the columns in each row:
///
///     struct VerticalSmileys: View {
///         let columns = [GridItem(.flexible()), GridItem(.flexible())]
///
///         var body: some View {
///              ScrollView {
///                  LazyVGrid(columns: columns) {
///                      ForEach(0x1f600...0x1f679, id: \.self) { value in
///                          Text(String(format: "%x", value))
///                          Text(emoji(value))
///                              .font(.largeTitle)
///                      }
///                  }
///              }
///         }
///
///         private func emoji(_ value: Int) -> String {
///             guard let scalar = UnicodeScalar(value) else { return "?" }
///             return String(Character(scalar))
///         }
///     }
///
/// For each row in the grid, the first column shows a Unicode code point from
/// the "Smileys" group, and the second shows its corresponding emoji:
///
/// ![A screenshot of a colunb of hexadecimal numbers to the left of a column
/// of emoji, with each number and a corresponding emoji making up a row.
/// Half of the last row is cut off, with seventeen rows fully
/// visible.](LazyVGrid-1-iOS)
///
/// You can achieve a similar layout using a ``Grid`` container. Unlike a lazy
/// grid, which creates child views only when SkipUI needs to display
/// them, a regular grid creates all of its child views right away. This
/// enables the grid to provide better support for cell spacing and alignment.
/// Only use a lazy grid if profiling your app shows that a ``Grid`` view
/// performs poorly because it tries to load too many views at once.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LazyVGrid<Content> : View where Content : View {

    /// Creates a grid that grows vertically.
    ///
    /// - Parameters:
    ///   - columns: An array of grid items to size and position each row of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - content: The content of the grid.
    public init(columns: [GridItem], alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

#endif
