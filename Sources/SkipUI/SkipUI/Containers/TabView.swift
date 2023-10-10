// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
#endif

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
    @ExperimentalMaterial3Api
    @Composable public override func ComposeContent(context: ComposeContext) {
        // Use a custom composer to count the number of child views in our content
        var tabCount = 0
        content.Compose(context: context.content(composer: ClosureComposer { _, _ in tabCount += 1 }))

        let navController = rememberNavController()
        ComposeContainer(modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
            Scaffold(
                modifier: modifier,
                bottomBar: {
                    NavigationBar(modifier: Modifier.fillMaxWidth()) {
                        for tabIndex in 0..<tabCount {
                            // Use a custom composer to get the tabIndex'th tab item
                            var composeIndex = 0
                            var tabItem: TabItem? = nil
                            content.Compose(context: context.content(composer: ClosureComposer { view, _ in
                                if composeIndex == tabIndex {
                                    tabItem = view.strippingModifiers { $0 as? TabItem }
                                }
                                composeIndex += 1
                            }))
                            
                            // Render it
                            let tabItemContext = context.content()
                            NavigationBarItem(
                                icon: {
                                    tabItem?.ComposeImage(context: tabItemContext)
                                },
                                label: {
                                    tabItem?.ComposeTitle(context: tabItemContext)
                                },
                                selected: String(describing: tabIndex) == currentRoute(for: navController),
                                onClick: {
                                    navController.navigate(String(describing: tabIndex)) {
                                        popUpTo(navController.graph.startDestinationId) {
                                            saveState = true
                                        }
                                        // Avoid multiple copies of the same destination when reselecting the same item
                                        launchSingleTop = true
                                        // Restore state when reselecting a previously selected item
                                        restoreState = true
                                    }
                                }
                            )
                        }
                    }
                }
            ) { padding in
                NavHost(navController, 
                        startDestination: "0", 
                        enterTransition: { EnterTransition.None },
                        exitTransition: { ExitTransition.None }) {
                    // Use a constant number of routes. Changing routes causes a NavHost to reset its state
                    for tabIndex in 0..<100 {
                        composable(String(describing: tabIndex)) {
                            Box(modifier: Modifier.padding(padding).fillMaxSize(), contentAlignment: androidx.compose.ui.Alignment.Center) {
                                // Use a custom composer to only render the tabIndex'th view
                                content.Compose(context: context.content(composer: TabIndexComposer(index: tabIndex)))
                            }
                        }
                    }
                }
            }
        }
    }

    @Composable private func currentRoute(for navController: NavHostController) -> String? {
        // In your BottomNavigation composable, get the current NavBackStackEntry using the currentBackStackEntryAsState() function. This entry gives you access to the current NavDestination. The selected state of each BottomNavigationItem can then be determined by comparing the item's route with the route of the current destination and its parent destinations (to handle cases when you are using nested navigation) via the NavDestination hierarchy.
        navController.currentBackStackEntryAsState().value?.destination?.route
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
struct TabItem: View {
    let view: View
    let label: View

    init(view: View, @ViewBuilder label: () -> View) {
        // Don't copy view
        // SKIP REPLACE: this.view = view
        self.view = view
        self.label = label()
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = view.Compose(context: context)
    }

    @Composable func ComposeTitle(context: ComposeContext) {
        label.Compose(context: context.content(composer: ClosureComposer { view, context in
            let stripped = view.strippingModifiers { $0 }
            if let label = stripped as? Label {
                label.ComposeTitle(context: context(false))
            } else if stripped is Text {
                view.ComposeContent(context: context(false))
            }
        }))
    }

    @Composable func ComposeImage(context: ComposeContext) {
        label.Compose(context: context.content(composer: ClosureComposer { view, context in
            let stripped = view.strippingModifiers { $0 }
            if let label = stripped as? Label {
                label.ComposeImage(context: context(false))
            } else if stripped is Image {
                view.Compose(context: context(false))
            }
        }))
    }
}

class TabIndexComposer: Composer {
    let index: Int
    var currentIndex = 0

    init(index: Int) {
        self.index = index
    }

    override func willCompose() {
        currentIndex = 0
    }

    @Composable override func Compose(view: inout View, context: (Bool) -> ComposeContext) {
        if currentIndex == index {
            view.ComposeContent(context: context(false))
        }
        currentIndex += 1
    }
}
#endif

// Model `TabViewStyle` as a struct. Kotlin does not support static members of protocols
public struct TabViewStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let automatic = TabViewStyle(rawValue: 0)

    @available(*, unavailable)
    public static let page = TabViewStyle(rawValue: 1)
}

extension View {
    public func tabItem(@ViewBuilder _ label: () -> any View) -> some View {
        #if SKIP
        return TabItem(view: self, label: label)
        #else
        return self
        #endif
    }

    public func tabViewStyle(_ style: TabViewStyle) -> some View {
        // We only support .automatic
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
extension TabViewStyle /* where Self == PageTabViewStyle */ {

    /// A `TabViewStyle` that implements a paged scrolling `TabView` with an
    /// index display mode.
    public static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) -> PageTabViewStyle { fatalError() }
}

/// A `TabViewStyle` that implements a paged scrolling `TabView`.
///
/// You can also use ``TabViewStyle/page`` or
/// ``TabViewStyle/page(indexDisplayMode:)`` to construct this style.
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(macOS, unavailable)
public struct PageTabViewStyle /* : TabViewStyle */ {

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

#endif
