// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct TabView<Content> : View where Content : View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    @available(*, unavailable)
    public init(selection: Binding<Any>?, @ViewBuilder content: () -> Content) {
        self.content = content()
    }

    #if SKIP
//    @Composable public override func ComposeContent(context: ComposeContext) {
//        // Check to see if we've initialized our tab items from our content views .tabItem modifiers. If we haven't,
//        // compose the content view with a custom composer that will capture the items. Note that 'content' is just a reference to
//        // the enclosing ComposeView, so a custom composer is the only way to receive a reference to our actual content views.
//        let rememberedItems = remember { mutableStateOf<NavigationDestinations?>(nil) }
//        if rememberedItems.value == nil {
//            root.Compose(context: context.content(composer: { view, context in
//                rememberedItems.value = (view as? NavigationDestinationView)?.destinations ?? [:]
//            }))
//        }
//        let items = rememberedItems.value ?? arrayOf()
//
//        //~~~
//    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

// TODO: Process for use in SkipUI

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
