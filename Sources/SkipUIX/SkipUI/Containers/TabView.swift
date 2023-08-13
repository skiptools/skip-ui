// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

/// A view that switches between multiple child views using interactive user
/// interface elements.
///
/// To create a user interface with tabs, place views in a `TabView` and apply
/// the ``View/tabItem(_:)`` modifier to the contents of each tab. On iOS, you
/// can also use one of the badge modifiers, like ``View/badge(_:)-84e43``, to
/// assign a badge to each of the tabs.
///
/// The following example creates a tab view with three tabs, each presenting a
/// custom child view. The first tab has a numeric badge and the third has a
/// string badge.
///
///     TabView {
///         ReceivedView()
///             .badge(2)
///             .tabItem {
///                 Label("Received", systemImage: "tray.and.arrow.down.fill")
///             }
///         SentView()
///             .tabItem {
///                 Label("Sent", systemImage: "tray.and.arrow.up.fill")
///             }
///         AccountView()
///             .badge("!")
///             .tabItem {
///                 Label("Account", systemImage: "person.crop.circle.fill")
///             }
///     }
///
/// ![A tab bar with three tabs, each with an icon image and a text label.
/// The first and third tabs have badges.](TabView-1)
///
/// Use a ``Label`` for each tab item, or optionally a ``Text``, an ``Image``,
/// or an image followed by text. Passing any other type of view results in a
/// visible but empty tab item.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
public struct TabView<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {

    /// Creates an instance that selects from content associated with
    /// `Selection` values.
    public init(selection: Binding<SelectionValue>?, @ViewBuilder content: () -> Content) { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
//    public typealias Body = some View
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension TabView where SelectionValue == Int {

    public init(@ViewBuilder content: () -> Content) { fatalError() }
}

/// A specification for the appearance and interaction of a `TabView`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol TabViewStyle {
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
extension TabViewStyle where Self == PageTabViewStyle {

    /// A `TabViewStyle` that implements a paged scrolling `TabView`.
    public static var page: PageTabViewStyle { get { fatalError() } }

    /// A `TabViewStyle` that implements a paged scrolling `TabView` with an
    /// index display mode.
    public static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) -> PageTabViewStyle { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension TabViewStyle where Self == DefaultTabViewStyle {

    /// The default `TabView` style.
    public static var automatic: DefaultTabViewStyle { get { fatalError() } }
}

/// A `TabViewStyle` that implements a paged scrolling `TabView`.
///
/// You can also use ``TabViewStyle/page`` or
/// ``TabViewStyle/page(indexDisplayMode:)`` to construct this style.
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
public struct PageTabViewStyle : TabViewStyle {

    /// A style for displaying the page index view
    public struct IndexDisplayMode : Sendable {

        /// Displays an index view when there are more than one page
        public static let automatic: PageTabViewStyle.IndexDisplayMode = { fatalError() }()

        /// Always display an index view regardless of page count
        @available(watchOS 8.0, *)
        public static let always: PageTabViewStyle.IndexDisplayMode = { fatalError() }()

        /// Never display an index view
        @available(watchOS 8.0, *)
        public static let never: PageTabViewStyle.IndexDisplayMode = { fatalError() }()
    }

    /// Creates a new `PageTabViewStyle` with an index display mode
    public init(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic) { fatalError() }
}

/// The default `TabView` style.
///
/// You can also use ``TabViewStyle/automatic`` to construct this style.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct DefaultTabViewStyle : TabViewStyle {

    public init() { fatalError() }
}

#endif
