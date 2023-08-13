// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view's size and alignment guides in its own coordinate space.
///
/// This structure contains the size and alignment guides of a view.
/// You receive an instance of this structure to use in a variety of
/// layout calculations, like when you:
///
/// * Define a default value for a custom alignment guide;
///   see ``AlignmentID/defaultValue(in:)``.
/// * Modify an alignment guide on a view;
///   see ``View/alignmentGuide(_:computeValue:)-9mdoh``.
/// * Ask for the dimensions of a subview of a custom view layout;
///   see ``LayoutSubview/dimensions(in:)``.
///
/// ### Custom alignment guides
///
/// You receive an instance of this structure as the `context` parameter to
/// the ``AlignmentID/defaultValue(in:)`` method that you implement to produce
/// the default offset for an alignment guide, or as the first argument to the
/// closure you provide to the ``View/alignmentGuide(_:computeValue:)-6y3u2``
/// view modifier to override the default calculation for an alignment guide.
/// In both cases you can use the instance, if helpful, to calculate the
/// offset for the guide. For example, you could compute a default offset
/// for a custom ``VerticalAlignment`` as a fraction of the view's ``height``:
///
///     private struct FirstThirdAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.height / 3
///         }
///     }
///
///     extension VerticalAlignment {
///         static let firstThird = VerticalAlignment(FirstThirdAlignment.self)
///     }
///
/// As another example, you could use the view dimensions instance to look
/// up the offset of an existing guide and modify it:
///
///     struct ViewDimensionsOffset: View {
///         var body: some View {
///             VStack(alignment: .leading) {
///                 Text("Default")
///                 Text("Indented")
///                     .alignmentGuide(.leading) { context in
///                         context[.leading] - 10
///                     }
///             }
///         }
///     }
///
/// The example above indents the second text view because the subtraction
/// moves the second text view's leading guide in the negative x direction,
/// which is to the left in the view's coordinate space. As a result,
/// SkipUI moves the second text view to the right, relative to the first
/// text view, to keep their leading guides aligned:
///
/// ![A screenshot of two strings. The first says Default and the second,
/// which appears below the first, says Indented. The left side of the second
/// string appears horizontally offset to the right from the left side of the
/// first string by about the width of one character.](ViewDimensions-1-iOS)
///
/// ### Layout direction
///
/// The discussion above describes a left-to-right language environment,
/// but you don't change your guide calculation to operate in a right-to-left
/// environment. SkipUI moves the view's origin from the left to the right side
/// of the view and inverts the positive x direction. As a result,
/// the existing calculation produces the same effect, but in the opposite
/// direction.
///
/// You can see this if you use the ``View/environment(_:_:)``
/// modifier to set the ``EnvironmentValues/layoutDirection`` property for the
/// view that you defined above:
///
///     ViewDimensionsOffset()
///         .environment(\.layoutDirection, .rightToLeft)
///
/// With no change in your guide, this produces the desired effect ---
/// it indents the second text view's right side, relative to the
/// first text view's right side. The leading edge is now on the right,
/// and the direction of the offset is reversed:
///
/// ![A screenshot of two strings. The first says Default and the second,
/// which appears below the first, says Indented. The right side of the second
/// string appears horizontally offset to the left from the right side of the
/// first string by about the width of one character.](ViewDimensions-2-iOS)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ViewDimensions {

    /// The view's width.
    public var width: CGFloat { get { fatalError() } }

    /// The view's height.
    public var height: CGFloat { get { fatalError() } }

    /// Gets the value of the given horizontal guide.
    ///
    /// Find the offset of a particular guide in the corresponding view by
    /// using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.leading) { context in
    ///         context[.leading] - 10
    ///     }
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(guide: HorizontalAlignment) -> CGFloat { get { fatalError() } }

    /// Gets the value of the given vertical guide.
    ///
    /// Find the offset of a particular guide in the corresponding view by
    /// using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.top) { context in
    ///         context[.top] - 10
    ///     }
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(guide: VerticalAlignment) -> CGFloat { get { fatalError() } }

    /// Gets the explicit value of the given horizontal alignment guide.
    ///
    /// Find the horizontal offset of a particular guide in the corresponding
    /// view by using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.leading) { context in
    ///         context[.leading] - 10
    ///     }
    ///
    /// This subscript returns `nil` if no value exists for the guide.
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(explicit guide: HorizontalAlignment) -> CGFloat? { get { fatalError() } }

    /// Gets the explicit value of the given vertical alignment guide
    ///
    /// Find the vertical offset of a particular guide in the corresponding
    /// view by using that guide as an index to read from the context:
    ///
    ///     .alignmentGuide(.top) { context in
    ///         context[.top] - 10
    ///     }
    ///
    /// This subscript returns `nil` if no value exists for the guide.
    ///
    /// For information about using subscripts in Swift to access member
    /// elements of a collection, list, or, sequence, see
    /// [Subscripts](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
    /// in _The Swift Programming Language_.
    public subscript(explicit guide: VerticalAlignment) -> CGFloat? { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewDimensions : Equatable {

}

/// A collection of the geometric spacing preferences of a view.
///
/// This type represents how much space a view prefers to have between it and
/// the next view in a layout. The type stores independent values

#endif
