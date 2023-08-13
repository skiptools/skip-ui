// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A kind for the content shape of a view.
///
/// The kind is used by the system to influence various effects, hit-testing,
/// and more.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ContentShapeKinds : OptionSet, Sendable {

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int { get { fatalError() } }

    /// Creates a content shape kind.
    public init(rawValue: Int) { fatalError() }

    /// The kind for hit-testing and accessibility.
    ///
    /// Setting a content shape with this kind causes the view to hit-test
    /// using the specified shape.
    public static let interaction: ContentShapeKinds = { fatalError() }()

    /// The kind for drag and drop previews.
    ///
    /// When using this kind, only the preview shape is affected. To control the
    /// shape used to hit-test and start the drag preview, use the `interaction`
    /// kind.
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let dragPreview: ContentShapeKinds = { fatalError() }()

    /// The kind for context menu previews.
    ///
    /// When using this kind, only the preview shape will be affected. To
    /// control the shape used to hit-test and start the context menu
    /// presentation, use the `.interaction` kind.
    @available(tvOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    public static let contextMenuPreview: ContentShapeKinds = { fatalError() }()

    /// The kind for hover effects.
    ///
    /// When using this kind, only the preview shape is affected. To control
    /// the shape used to hit-test and start the effect, use the `interaction`
    /// kind.
    ///
    /// This kind does not affect the `onHover` modifier.
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let hoverEffect: ContentShapeKinds = { fatalError() }()

    /// The kind for accessibility visuals and sorting.
    ///
    /// Setting a content shape with this kind causes the accessibility frame
    /// and path of the view's underlying accessibility element to match the
    /// shape without adjusting the hit-testing shape, updating the visual focus
    /// ring that assistive apps, such as VoiceOver, draw, as well as how the
    /// element is sorted. Updating the accessibility shape is only required if
    /// the shape or size used to hit-test significantly diverges from the visual
    /// shape of the view.
    ///
    /// To control the shape for accessibility and hit-testing, use the `interaction` kind.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static let accessibility: ContentShapeKinds = { fatalError() }()

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = ContentShapeKinds

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = ContentShapeKinds

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}


#endif
