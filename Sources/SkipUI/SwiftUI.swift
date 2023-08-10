// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

/// No-op
@usableFromInline func stub<T>() -> T {
    fatalError("stub")
}

/// No-op
@usableFromInline func never() -> Never {
    stub()
}

/// A type that you use to create custom alignment guides.
///
/// Every built-in alignment guide that ``VerticalAlignment`` or
/// ``HorizontalAlignment`` defines as a static property, like
/// ``VerticalAlignment/top`` or ``HorizontalAlignment/leading``, has a
/// unique alignment identifier type that produces the default offset for
/// that guide. To create a custom alignment guide, define your own alignment
/// identifier as a type that conforms to the `AlignmentID` protocol, and
/// implement the required ``AlignmentID/defaultValue(in:)`` method:
///
///     private struct FirstThirdAlignment: AlignmentID {
///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
///             context.height / 3
///         }
///     }
///
/// When implementing the method, calculate the guide's default offset
/// from the view's origin. If it's helpful, you can use information from the
/// ``ViewDimensions`` input in the calculation. This parameter provides context
/// about the specific view that's using the guide. The above example creates an
/// identifier called `FirstThirdAlignment` and calculates a default value
/// that's one-third of the height of the aligned view.
///
/// Use the identifier's type to create a static property in an extension of
/// one of the alignment guide types, like ``VerticalAlignment``:
///
///     extension VerticalAlignment {
///         static let firstThird = VerticalAlignment(FirstThirdAlignment.self)
///     }
///
/// You can apply your custom guide like any of the built-in guides. For
/// example, you can use an ``HStack`` to align its views at one-third
/// of their height using the guide defined above:
///
///     struct StripesGroup: View {
///         var body: some View {
///             HStack(alignment: .firstThird, spacing: 1) {
///                 HorizontalStripes().frame(height: 60)
///                 HorizontalStripes().frame(height: 120)
///                 HorizontalStripes().frame(height: 90)
///             }
///         }
///     }
///
///     struct HorizontalStripes: View {
///         var body: some View {
///             VStack(spacing: 1) {
///                 ForEach(0..<3) { _ in Color.blue }
///             }
///         }
///     }
///
/// Because each set of stripes has three equal, vertically stacked
/// rectangles, they align at the bottom edge of the top rectangle. This
/// corresponds in each case to a third of the overall height, as
/// measured from the origin at the top of each set of stripes:
///
/// ![Three vertical stacks of rectangles, arranged in a row.
/// The rectangles in each stack have the same height as each other, but
/// different heights than the rectangles in the other stacks. The bottom edges
/// of the top-most rectangle in each stack are aligned with each
/// other.](AlignmentId-1-iOS)
///
/// You can also use the ``View/alignmentGuide(_:computeValue:)-6y3u2`` view
/// modifier to alter the behavior of your custom guide for a view, as you
/// might alter a built-in guide. For example, you can change
/// one of the stacks of stripes from the previous example to align its
/// `firstThird` guide at two thirds of the height instead:
///
///     struct StripesGroupModified: View {
///         var body: some View {
///             HStack(alignment: .firstThird, spacing: 1) {
///                 HorizontalStripes().frame(height: 60)
///                 HorizontalStripes().frame(height: 120)
///                 HorizontalStripes().frame(height: 90)
///                     .alignmentGuide(.firstThird) { context in
///                         2 * context.height / 3
///                     }
///             }
///         }
///     }
///
/// The modified guide calculation causes the affected view to place the
/// bottom edge of its middle rectangle on the `firstThird` guide, which aligns
/// with the bottom edge of the top rectangle in the other two groups:
///
/// ![Three vertical stacks of rectangles, arranged in a row.
/// The rectangles in each stack have the same height as each other, but
/// different heights than the rectangles in the other stacks. The bottom edges
/// of the top-most rectangle in the first two stacks are aligned with each
/// other, and with the bottom edge of the middle rectangle in the third
/// stack.](AlignmentId-2-iOS)
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol AlignmentID {

    /// Calculates a default value for the corresponding guide in the specified
    /// context.
    ///
    /// Implement this method when you create a type that conforms to the
    /// ``AlignmentID`` protocol. Use the method to calculate the default
    /// offset of the corresponding alignment guide. SkipUI interprets the
    /// value that you return as an offset in the coordinate space of the
    /// view that's being laid out. For example, you can use the context to
    /// return a value that's one-third of the height of the view:
    ///
    ///     private struct FirstThirdAlignment: AlignmentID {
    ///         static func defaultValue(in context: ViewDimensions) -> CGFloat {
    ///             context.height / 3
    ///         }
    ///     }
    ///
    /// You can override the default value that this method returns for a
    /// particular guide by adding the
    /// ``View/alignmentGuide(_:computeValue:)-9mdoh`` view modifier to a
    /// particular view.
    ///
    /// - Parameter context: The context of the view that you apply
    ///   the alignment guide to. The context gives you the view's dimensions,
    ///   as well as the values of other alignment guides that apply to the
    ///   view, including both built-in and custom guides. You can use any of
    ///   these values, if helpful, to calculate the value for your custom
    ///   guide.
    ///
    /// - Returns: The offset of the guide from the origin in the
    ///   view's coordinate space.
    static func defaultValue(in context: ViewDimensions) -> CGFloat
}

//@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
//extension AnyShapeStyle.Storage : @unchecked Sendable {
//}

/// The prominence of backgrounds underneath other views.
///
/// Background prominence should influence foreground styling to maintain
/// sufficient contrast against the background. For example, selected rows in
/// a `List` and `Table` can have increased prominence backgrounds with
/// accent color fills when focused; the foreground content above the background
/// should be adjusted to reflect that level of prominence.
///
/// This can be read and written for views with the
/// `EnvironmentValues.backgroundProminence` property.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct BackgroundProminence : Hashable, Sendable {

    /// The standard prominence of a background
    ///
    /// This is the default level of prominence and doesn't require any
    /// adjustment to achieve satisfactory contrast with the background.
    public static let standard: BackgroundProminence = { fatalError() }()

    /// A more prominent background that likely requires some changes to the
    /// views above it.
    ///
    /// This is the level of prominence for more highly saturated and full
    /// color backgrounds, such as focused/emphasized selected list rows.
    /// Typically foreground content should take on monochrome styling to
    /// have greater contrast against the background.
    public static let increased: BackgroundProminence = { fatalError() }()


    

}

/// The kinds of background tasks that your app or extension can handle.
///
/// Use a value of this type with the ``Scene/backgroundTask(_:action:)`` scene
/// modifier to create a handler for background tasks that the system sends
/// to your app or extension. For example, you can use ``urlSession`` to define
/// an asynchronous closure that the system calls when it launches your app or
/// extension to handle a response from a background
/// .
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct BackgroundTask<Request, Response> : Sendable {
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension BackgroundTask {

    /// A task that responds to background URL sessions.
    public static var urlSession: BackgroundTask<String, Void> { get { fatalError() } }

    /// A task that responds to background URL sessions matching the given
    /// identifier.
    ///
    /// - Parameter identifier: The identifier to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    public static func urlSession(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }

    /// A task that responds to background URL sessions matching the given
    /// predicate.
    ///
    /// - Parameter matching: The predicate to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    public static func urlSession(matching: @escaping @Sendable (String) -> Bool) -> BackgroundTask<String, Void> { fatalError() }

    /// A task that updates your app’s state in the background for a
    /// matching identifier.
    ///
    /// - Parameter matching: The identifier to match.
    ///
    /// - Returns: A background task that you can handle with your app or
    ///   extension.
    @available(macOS, unavailable)
    public static func appRefresh(_ identifier: String) -> BackgroundTask<Void, Void> { fatalError() }
}

/// The visual prominence of a badge.
///
/// Badges can be used for different kinds of information, from the
/// passive number of items in a container to the number of required
/// actions. The prominence of badges in Lists can be adjusted to reflect
/// this and be made to draw more or less attention to themselves.
///
/// Badges will default to `standard` prominence unless specified.
///
/// The following example shows a ``List`` displaying a list of folders
/// with an informational badge with lower prominence, showing the number
/// of items in the folder.
///
///     List(folders) { folder in
///         Text(folder.name)
///             .badge(folder.numberOfItems)
///     }
///     .badgeProminence(.decreased)
///
@available(iOS 17.0, macOS 14.0, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct BadgeProminence : Hashable, Sendable {

    /// The lowest level of prominence for a badge.
    ///
    /// This level or prominence should be used for badges that display a value
    /// of passive information that requires no user action, such as total
    /// number of messages or content.
    ///
    /// In lists on iOS and macOS, this results in badge labels being
    /// displayed without any extra decoration. On iOS, this looks the same as
    /// `.standard`.
    ///
    ///     List(folders) { folder in
    ///         Text(folder.name)
    ///             .badge(folder.numberOfItems)
    ///     }
    ///     .badgeProminence(.decreased)
    ///
    public static let decreased: BadgeProminence = { fatalError() }()

    /// The standard level of prominence for a badge.
    ///
    /// This level of prominence should be used for badges that display a value
    /// that suggests user action, such as a count of unread messages or new
    /// invitations.
    ///
    /// In lists on macOS, this results in a badge label on a grayscale platter;
    /// and in lists on iOS, this prominence of badge has no platter.
    ///
    ///     List(mailboxes) { mailbox in
    ///         Text(mailbox.name)
    ///             .badge(mailbox.numberOfUnreadMessages)
    ///     }
    ///     .badgeProminence(.standard)
    ///
    public static let standard: BadgeProminence = { fatalError() }()

    /// The highest level of prominence for a badge.
    ///
    /// This level of prominence should be used for badges that display a value
    /// that requires user action, such as number of updates or account errors.
    ///
    /// In lists on iOS and macOS, this results in badge labels being displayed
    /// on a red platter.
    ///
    ///     ForEach(accounts) { account in
    ///         Text(account.userName)
    ///             .badge(account.setupErrors)
    ///             .badgeProminence(.increased)
    ///     }
    ///
    public static let increased: BadgeProminence = { fatalError() }()

    


}

/// Modes for compositing a view with overlapping content.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum BlendMode : Sendable {

    case normal

    case multiply

    case screen

    case overlay

    case darken

    case lighten

    case colorDodge

    case colorBurn

    case softLight

    case hardLight

    case difference

    case exclusion

    case hue

    case saturation

    case color

    case luminosity

    case sourceAtop

    case destinationOver

    case destinationOut

    case plusDarker

    case plusLighter

    


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension BlendMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension BlendMode : Hashable {
}

/// A menu style that displays a borderless button that toggles the display of
/// the menu's contents when pressed.
///
/// Use ``MenuStyle/borderlessButton`` to construct this style.
@available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(macOS, introduced: 11.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(tvOS, introduced: 17.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use .menuStyle(.button) and .buttonStyle(.borderless).")
public struct BorderlessButtonMenuStyle : MenuStyle {

    /// Creates a borderless button menu style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a menu.
    ///
    /// - Parameter configuration: The properties of the menu.
    ///
    /// The system calls this method for each ``Menu`` instance in a view
    /// hierarchy where this style is the current menu style.
    public func makeBody(configuration: BorderlessButtonMenuStyle.Configuration) -> some View { return never() }


    /// A view that represents the body of a menu.
//    public typealias Body = some View
}

/// The options for controlling the repeatability of button actions.
///
/// Use values of this type with the ``View/buttonRepeatBehavior(_:)``
/// modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ButtonRepeatBehavior : Hashable, Sendable {

    /// The automatic repeat behavior.
    public static let automatic: ButtonRepeatBehavior = { fatalError() }()

    /// Repeating button actions will be enabled.
    public static let enabled: ButtonRepeatBehavior = { fatalError() }()

    /// Repeating button actions will be disabled.
    public static let disabled: ButtonRepeatBehavior = { fatalError() }()


    

}

/// A value that describes the purpose of a button.
///
/// A button role provides a description of a button's purpose.  For example,
/// the ``ButtonRole/destructive`` role indicates that a button performs
/// a destructive action, like delete user data:
///
///     Button("Delete", role: .destructive) { delete() }
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ButtonRole : Equatable, Sendable {

    /// A role that indicates a destructive button.
    ///
    /// Use this role for a button that deletes user data, or performs an
    /// irreversible operation. A destructive button signals by its appearance
    /// that the user should carefully consider whether to tap or click the
    /// button. For example, SkipUI presents a destructive button that you add
    /// with the ``View/swipeActions(edge:allowsFullSwipe:content:)``
    /// modifier using a red background:
    ///
    ///     List {
    ///         ForEach(items) { item in
    ///             Text(item.title)
    ///                 .swipeActions {
    ///                     Button(role: .destructive) { delete() } label: {
    ///                         Label("Delete", systemImage: "trash")
    ///                     }
    ///                 }
    ///         }
    ///     }
    ///     .navigationTitle("Shopping List")
    ///
    /// ![A screenshot of a list of three items, where the second item is
    /// shifted to the left, and the row displays a red button with a trash
    /// icon on the right side.](ButtonRole-destructive-1)
    public static let destructive: ButtonRole = { fatalError() }()

    /// A role that indicates a button that cancels an operation.
    ///
    /// Use this role for a button that cancels the current operation.
    public static let cancel: ButtonRole = { fatalError() }()

    
}

/// A matrix to use in an RGBA color transformation.
///
/// The matrix has five columns, each with a red, green, blue, and alpha
/// component. You can use the matrix for tasks like creating a color
/// transformation ``GraphicsContext/Filter`` for a ``GraphicsContext`` using
/// the ``GraphicsContext/Filter/colorMatrix(_:)`` method.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen public struct ColorMatrix : Equatable {

    public var r1: Float { get { fatalError() } }

    public var r2: Float { get { fatalError() } }

    public var r3: Float { get { fatalError() } }

    public var r4: Float { get { fatalError() } }

    public var r5: Float { get { fatalError() } }

    public var g1: Float { get { fatalError() } }

    public var g2: Float { get { fatalError() } }

    public var g3: Float { get { fatalError() } }

    public var g4: Float { get { fatalError() } }

    public var g5: Float { get { fatalError() } }

    public var b1: Float { get { fatalError() } }

    public var b2: Float { get { fatalError() } }

    public var b3: Float { get { fatalError() } }

    public var b4: Float { get { fatalError() } }

    public var b5: Float { get { fatalError() } }

    public var a1: Float { get { fatalError() } }

    public var a2: Float { get { fatalError() } }

    public var a3: Float { get { fatalError() } }

    public var a4: Float { get { fatalError() } }

    public var a5: Float { get { fatalError() } }

    /// Creates the identity matrix.
    @inlinable public init() { fatalError() }

    
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ColorMatrix : Sendable {
}

/// The set of possible working color spaces for color-compositing operations.
///
/// Each color space guarantees the preservation of a particular range of color
/// values.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorRenderingMode : Sendable {

    /// The non-linear sRGB working color space.
    ///
    /// Color component values outside the range `[0, 1]` produce undefined
    /// results. This color space is gamma corrected.
    case nonLinear

    /// The linear sRGB working color space.
    ///
    /// Color component values outside the range `[0, 1]` produce undefined
    /// results. This color space isn't gamma corrected.
    case linear

    /// The extended linear sRGB working color space.
    ///
    /// Color component values outside the range `[0, 1]` are preserved.
    /// This color space isn't gamma corrected.
    case extendedLinear

    


}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorRenderingMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorRenderingMode : Hashable {
}

/// The possible color schemes, corresponding to the light and dark appearances.
///
/// You receive a color scheme value when you read the
/// ``EnvironmentValues/colorScheme`` environment value. The value tells you if
/// a light or dark appearance currently applies to the view. SkipUI updates
/// the value whenever the appearance changes, and redraws views that
/// depend on the value. For example, the following ``Text`` view automatically
/// updates when the user enables Dark Mode:
///
///     @Environment(\.colorScheme) private var colorScheme
///
///     var body: some View {
///         Text(colorScheme == .dark ? "Dark" : "Light")
///     }
///
/// Set a preferred appearance for a particular view hierarchy to override
/// the user's Dark Mode setting using the ``View/preferredColorScheme(_:)``
/// view modifier.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorScheme : CaseIterable, Sendable {

    /// The color scheme that corresponds to a light appearance.
    case light

    /// The color scheme that corresponds to a dark appearance.
    case dark

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ColorScheme]

    /// A collection of all values of this type.
    public static var allCases: [ColorScheme] { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorScheme : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorScheme : Hashable {
}

/// The contrast between the app's foreground and background colors.
///
/// You receive a contrast value when you read the
/// ``EnvironmentValues/colorSchemeContrast`` environment value. The value
/// tells you if a standard or increased contrast currently applies to the view.
/// SkipUI updates the value whenever the contrast changes, and redraws
/// views that depend on the value. For example, the following ``Text`` view
/// automatically updates when the user enables increased contrast:
///
///     @Environment(\.colorSchemeContrast) private var colorSchemeContrast
///
///     var body: some View {
///         Text(colorSchemeContrast == .standard ? "Standard" : "Increased")
///     }
///
/// The user sets the contrast by selecting the Increase Contrast option in
/// Accessibility > Display in System Preferences on macOS, or
/// Accessibility > Display & Text Size in the Settings app on iOS.
/// Your app can't override the user's choice.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ColorSchemeContrast : CaseIterable, Sendable {

    /// SkipUI displays views with standard contrast between the app's
    /// foreground and background colors.
    case standard

    /// SkipUI displays views with increased contrast between the app's
    /// foreground and background colors.
    case increased

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ColorSchemeContrast]

    /// A collection of all values of this type.
    public static var allCases: [ColorSchemeContrast] { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorSchemeContrast : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ColorSchemeContrast : Hashable {
}

/// The placement of a container background.
///
/// This method controls where to place a background that you specify with the
/// ``View/containerBackground(_:for:)`` or
/// ``View/containerBackground(for:alignment:content:)`` modifier.
@available(iOS 17.0, tvOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct ContainerBackgroundPlacement : Sendable, Hashable {


    

}

/// The placement of margins.
///
/// Different views can support customizating margins that appear in
/// different parts of that view. Use values of this type to customize
/// those margins of a particular placement.
///
/// For example, use a ``ContentMarginPlacement/scrollIndicators``
/// placement to customize the margins of scrollable view's scroll
/// indicators separately from the margins of a scrollable view's
/// content.
///
/// Use this type in conjunction with the ``View/contentMargin(_:for:)``
/// modifier.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ContentMarginPlacement {

    /// The automatic placement.
    ///
    /// Views that support margin customization can automatically use
    /// margins with this placement. For example, a ``ScrollView`` will
    /// use this placement to automatically inset both its content and
    /// scroll indicators by the specified amount.
    public static var automatic: ContentMarginPlacement { get { fatalError() } }

    /// The scroll content placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their content, but not their scroll indicators.
    public static var scrollContent: ContentMarginPlacement { get { fatalError() } }

    /// The scroll indicators placement.
    ///
    /// Scrollable views like ``ScrollView`` will use this placement to
    /// inset their scroll indicators, but not their content.
    public static var scrollIndicators: ContentMarginPlacement { get { fatalError() } }
}

/// Constants that define how a view's content fills the available space.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public enum ContentMode : Hashable, CaseIterable {

    /// An option that resizes the content so it's all within the available space,
    /// both vertically and horizontally.
    ///
    /// This mode preserves the content's aspect ratio.
    /// If the content doesn't have the same aspect ratio as the available
    /// space, the content becomes the same size as the available space on
    /// one axis and leaves empty space on the other.
    case fit

    /// An option that resizes the content so it occupies all available space,
    /// both vertically and horizontally.
    ///
    /// This mode preserves the content's aspect ratio.
    /// If the content doesn't have the same aspect ratio as the available
    /// space, the content becomes the same size as the available space on
    /// one axis, and larger on the other axis.
    case fill

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ContentMode]

    /// A collection of all values of this type.
    public static var allCases: [ContentMode] { get { fatalError() } }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ContentMode : Sendable {
}

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

@available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "DynamicTypeSize")
public enum ContentSizeCategory : Hashable, CaseIterable {

    case extraSmall

    case small

    case medium

    case large

    case extraLarge

    case extraExtraLarge

    case extraExtraExtraLarge

    case accessibilityMedium

    case accessibilityLarge

    case accessibilityExtraLarge

    case accessibilityExtraExtraLarge

    case accessibilityExtraExtraExtraLarge

    /// A Boolean value indicating whether the content size category is one that
    /// is associated with accessibility.
    @available(iOS 13.4, macOS 10.15.4, tvOS 13.4, watchOS 6.2, *)
    public var isAccessibilityCategory: Bool { get { fatalError() } }

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ContentSizeCategory]

    /// A collection of all values of this type.
    public static var allCases: [ContentSizeCategory] { get { fatalError() } }

}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ContentSizeCategory {

    /// Returns a Boolean value indicating whether the value of the first argument is less than that of the second argument.
    public static func < (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }

    /// Returns a Boolean value indicating whether the value of the first argument is less than or equal to that of the second argument.
    public static func <= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }

    /// Returns a Boolean value indicating whether the value of the first argument is greater than that of the second argument.
    public static func > (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }

    /// Returns a Boolean value indicating whether the value of the first argument is greater than or equal to that of the second argument.
    public static func >= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool { fatalError() }
}

/// An interface, consisting of a label and additional content, that you
/// display when the content of your app is unavailable to users.
///
/// It is recommended to use `ContentUnavailableView` in situations where a view's
/// content cannot be displayed. That could be caused by a network error, a
/// list without items, a search that returns no results etc.
///
/// You create an `ContentUnavailableView` in its simplest form, by providing a
/// label and some additional content such as a description or a call to action:
///
///     ContentUnavailableView {
///         Label("No Mail", systemImage: "tray.fill")
///     } description: {
///         Text("New mails you receive will appear here.")
///     }
///
/// The system provides default `ContentUnavailableView`s that you can use in
/// specific situations. The example below illustrates the usage of the
/// ``ContentUnavailableView/search`` view:
///
///     struct ContentView: View {
///         @ObservedObject private var viewModel = ContactsViewModel()
///
///         var body: some View {
///             NavigationStack {
///                 List {
///                     ForEach(viewModel.searchResults) { contact in
///                         NavigationLink {
///                             ContactsView(contact)
///                         } label: {
///                             Text(contact.name)
///                         }
///                     }
///                 }
///                 .navigationTitle("Contacts")
///                 .searchable(text: $viewModel.searchText)
///                 .overlay {
///                     if searchResults.isEmpty {
///                         ContentUnavailableView.search
///                     }
///                 }
///             }
///         }
///     }
///
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct ContentUnavailableView<LabelX, Description, Actions> : View where LabelX : View, Description : View, Actions : View {

    /// Creates an interface, consisting of a label and additional content, that you
    /// display when the content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///   - label: The label that describes the view.
    ///   - description: The view that describes the interface.
    ///   - actions: The content of the interface actions.
    public init(@ViewBuilder label: () -> LabelX, @ViewBuilder description: () -> Description = { EmptyView() }, @ViewBuilder actions: () -> Actions = { EmptyView() }) { fatalError() }

    /// The content and behavior of the view.
    ///
    /// When you implement a custom view, you must implement a computed
    /// `body` property to provide the content for your view. Return a view
    /// that's composed of built-in views that SkipUI provides, plus other
    /// composite views that you've already defined:
    ///
    ///     struct MyView: View {
    ///         var body: some View {
    ///             Text("Hello, World!")
    ///         }
    ///     }
    ///
    /// For more information about composing views and a view hierarchy,
    /// see <doc:Declaring-a-Custom-View>.
    @MainActor public var body: some View { get { return never() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentUnavailableView where LabelX == Label<Text, Image>, Description == Text?, Actions == EmptyView {

    /// Creates an interface, consisting of a title generated from a localized
    /// string, an image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, image name: String, description: Text? = nil) { fatalError() }

    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init(_ title: LocalizedStringKey, systemImage name: String, description: Text? = nil) { fatalError() }

    /// Creates an interface, consisting of a title generated from a string,
    /// an image and additional content, that you display when the content of
    /// your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - image: The name of the image resource to lookup.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, image name: String, description: Text? = nil) where S : StringProtocol { fatalError() }

    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// - Parameters:
    ///    - title: A string used as the title.
    ///    - systemImage: The name of the system symbol image resource to lookup.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    public init<S>(_ title: S, systemImage name: String, description: Text? = nil) where S : StringProtocol { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ContentUnavailableView where LabelX == SearchUnavailableContent.Label, Description == SearchUnavailableContent.Description, Actions == SearchUnavailableContent.Actions {

    /// Creates a `ContentUnavailableView` instance that conveys a search state.
    ///
    /// A `ContentUnavailableView` initialized with this static member is expected to
    /// be contained within a searchable view hierarchy. Such a configuration
    /// enables the search query to be parsed into the view's description.
    ///
    /// For example, consider the usage of this static member in *ContactsListView*:
    ///
    ///     struct ContactsListView: View {
    ///         @ObservedObject private var viewModel = ContactsViewModel()
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 List {
    ///                     ForEach(viewModel.searchResults) { contact in
    ///                         NavigationLink {
    ///                             ContactsView(contact)
    ///                         } label: {
    ///                             Text(contact.name)
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("Contacts")
    ///                 .searchable(text: $viewModel.searchText)
    ///                 .overlay {
    ///                     if searchResults.isEmpty {
    ///                         ContentUnavailableView.search
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    public static var search: ContentUnavailableView<SearchUnavailableContent.Label, SearchUnavailableContent.Description, SearchUnavailableContent.Actions> { get { fatalError() } }

    /// Creates a `ContentUnavailableView` instance that conveys a search state.
    ///
    /// For example, consider the usage of this static member in *ContactsListView*:
    ///
    ///     struct ContactsListView: View {
    ///         @ObservedObject private var viewModel = ContactsViewModel()
    ///
    ///         var body: some View {
    ///             NavigationStack {
    ///                 CustomSearchBar(query: $viewModel.searchText)
    ///                 List {
    ///                     ForEach(viewModel.searchResults) { contact in
    ///                         NavigationLink {
    ///                             ContactsView(contact)
    ///                         } label: {
    ///                             Text(contact.name)
    ///                         }
    ///                     }
    ///                 }
    ///                 .navigationTitle("Contacts")
    ///                 .overlay {
    ///                     if viewModel.searchResults.isEmpty {
    ///                         ContentUnavailableView
    ///                             .search(text: viewModel.searchText)
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter text: The search text query.
    public static func search(text: String) -> ContentUnavailableView<LabelX, Description, Actions> { fatalError() }
}

/// A container for views that you present as menu items in a context menu.
///
/// A context menu view allows you to present a situationally specific menu
/// that enables taking actions relevant to the current task.
///
/// You can create a context menu by first defining a `ContextMenu` container
/// with the controls that represent the actions that people can take,
/// and then using the ``View/contextMenu(_:)`` view modifier to apply the
/// menu to a view.
///
/// The example below creates and applies a two item context menu container
/// to a ``Text`` view. The Boolean value `shouldShowMenu`, which defaults to
/// true, controls the availability of context menu:
///
///     private let menuItems = ContextMenu {
///         Button {
///             // Add this item to a list of favorites.
///         } label: {
///             Label("Add to Favorites", systemImage: "heart")
///         }
///         Button {
///             // Open Maps and center it on this item.
///         } label: {
///             Label("Show in Maps", systemImage: "mappin")
///         }
///     }
///
///     private struct ContextMenuMenuItems: View {
///         @State private var shouldShowMenu = true
///
///         var body: some View {
///             Text("Turtle Rock")
///                 .contextMenu(shouldShowMenu ? menuItems : nil)
///         }
///     }
///
/// ![A screenshot of a context menu showing two menu items: Add to
/// Favorites, and Show in Maps.](View-contextMenu-1-iOS)
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "Use `contextMenu(menuItems:)` instead.")
@available(tvOS, unavailable)
@available(watchOS, introduced: 6.0, deprecated: 7.0)
public struct ContextMenu<MenuItems> where MenuItems : View {

    public init(@ViewBuilder menuItems: () -> MenuItems) { fatalError() }
}

/// The size classes, like regular or small, that you can apply to controls
/// within a view.
@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
public enum ControlSize : CaseIterable, Sendable {

    /// A control version that is minimally sized.
    case mini

    /// A control version that is proportionally smaller size for space-constrained views.
    case small

    /// A control version that is the default size.
    case regular

    /// A control version that is prominently sized.
    @available(macOS 11.0, *)
    case large

    @available(iOS 17.0, macOS 14.0, watchOS 10.0, xrOS 1.0, *)
    case extraLarge

    /// A collection of all values of this type.
    public static var allCases: [ControlSize] { get { fatalError() } }

    


    /// A type that can represent a collection of all values of this type.
    public typealias AllCases = [ControlSize]

}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ControlSize : Equatable {
}

@available(iOS 15.0, macOS 10.15, watchOS 9.0, *)
@available(tvOS, unavailable)
extension ControlSize : Hashable {
}

/// A resolved coordinate space created by `CoordinateSpaceProtocol`.
///
/// You don't typically use `CoordinateSpace` directly. Instead, use the static
/// properties and functions of `CoordinateSpaceProtocol` such as `.global`,
/// `.local`, and `.named(_:)`.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum CoordinateSpace {

    /// The global coordinate space at the root of the view hierarchy.
    case global

    /// The local coordinate space of the current view.
    case local

    /// A named reference to a view's local coordinate space.
    case named(AnyHashable)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CoordinateSpace {

    public var isGlobal: Bool { get { fatalError() } }

    public var isLocal: Bool { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CoordinateSpace : Equatable, Hashable {


}

/// A frame of reference within the layout system.
///
/// All geometric properties of a view, including size, position, and
/// transform, are defined within the local coordinate space of the view's
/// parent. These values can be converted into other coordinate spaces
/// by passing types conforming to this protocol into functions such as
/// `GeometryProxy.frame(in:)`.
///
/// For example, a named coordinate space allows you to convert the frame
/// of a view into the local coordinate space of an ancestor view by defining
/// a named coordinate space using the `coordinateSpace(_:)` modifier, then
/// passing that same named coordinate space into the `frame(in:)` function.
///
///     VStack {
///         GeometryReader { geometryProxy in
///             let distanceFromTop = geometryProxy.frame(in: "container").origin.y
///             Text("This view is \(distanceFromTop) points from the top of the VStack")
///         }
///         .padding()
///     }
///     .coordinateSpace(.named("container"))
///
/// You don't typically create types conforming to this protocol yourself.
/// Instead, use the system-provided `.global`, `.local`, and `.named(_:)`
/// implementations.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol CoordinateSpaceProtocol {

    /// The resolved coordinate space.
    var coordinateSpace: CoordinateSpace { get }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {

    /// The named coordinate space that is added by the system for the innermost
    /// containing scroll view that allows scrolling along the provided axis.
    public static func scrollView(axis: Axis) -> Self { fatalError() }

    /// The named coordinate space that is added by the system for the innermost
    /// containing scroll view.
    public static var scrollView: NamedCoordinateSpace { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == NamedCoordinateSpace {

    /// Creates a named coordinate space using the given value.
    ///
    /// Use the `coordinateSpace(_:)` modifier to assign a name to the local
    /// coordinate space of a  parent view. Child views can then refer to that
    /// coordinate space using `.named(_:)`.
    ///
    /// - Parameter name: A unique value that identifies the coordinate space.
    ///
    /// - Returns: A named coordinate space identified by the given value.
    public static func named(_ name: some Hashable) -> NamedCoordinateSpace { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == LocalCoordinateSpace {

    /// The local coordinate space of the current view.
    public static var local: LocalCoordinateSpace { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CoordinateSpaceProtocol where Self == GlobalCoordinateSpace {

    /// The global coordinate space at the root of the view hierarchy.
    public static var global: GlobalCoordinateSpace { get { fatalError() } }
}
