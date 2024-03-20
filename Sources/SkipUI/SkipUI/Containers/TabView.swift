// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.foundation.background
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
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
#endif

public struct TabView : View {
    let selection: Binding<Any>?
    let content: ComposeBuilder

    public init(@ViewBuilder content: () -> any View) {
        self.selection = nil
        self.content = ComposeBuilder.from(content)
    }

    public init(selection: Any?, @ViewBuilder content: () -> any View) {
        self.selection = selection as! Binding<Any>?
        self.content = ComposeBuilder.from(content)
    }

    #if SKIP
    @ExperimentalMaterial3Api
    @Composable public override func ComposeContent(context: ComposeContext) {
        let tabItemContext = context.content()
        var tabViews: [View] = []
        EnvironmentValues.shared.setValues {
            $0.set_placement(ViewPlacement.tagged)
        } in: {
            tabViews = content.collectViews(context: tabItemContext).filter { !$0.isSwiftUIEmptyView }
        }

        let navController = rememberNavController()
        let currentRoute = currentRoute(for: navController)
        if let selection, let currentRoute, selection.wrappedValue != tagValue(route: currentRoute, in: tabViews) {
            if let route = route(tagValue: selection.wrappedValue, in: tabViews) {
                navigate(controller: navController, route: route)
            }
        }

        let preferenceUpdates = remember { mutableStateOf(0) }
        let _ = preferenceUpdates.value // Read so that it can trigger recompose on change
        let tabBarPreferences = rememberSaveable(stateSaver: context.stateSaver as! Saver<ToolbarBarPreferences?, Any>) { mutableStateOf<ToolbarBarPreferences?>(nil) }
        let tabBarPreferencesPreference = Preference<ToolbarBarPreferences?>(key: TabBarPreferenceKey.self, update: { tabBarPreferences.value = $0 }, didChange: { preferenceUpdates.value += 1 })

        ComposeContainer(modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
            Scaffold(
                modifier: modifier,
                bottomBar: {
                    guard tabBarPreferences.value?.visibility != Visibility.hidden else {
                        return
                    }
                    var tabBarModifier = Modifier.fillMaxWidth()
                    let tabBarBackgroundColor: androidx.compose.ui.graphics.Color
                    if tabBarPreferences.value?.backgroundVisibility == Visibility.hidden {
                        tabBarBackgroundColor = Color.clear.colorImpl()
                    } else if let background = tabBarPreferences.value?.background {
                        if let color = background.asColor(opacity: 1.0, animationContext: nil) {
                            tabBarBackgroundColor = color
                        } else {
                            tabBarBackgroundColor = Color.clear.colorImpl()
                            if let brush = background.asBrush(opacity: 1.0, animationContext: nil) {
                                tabBarModifier = tabBarModifier.background(brush)
                            }
                        }
                    } else {
                        tabBarBackgroundColor = Color.systemBarBackground.colorImpl()
                    }
                    NavigationBar(modifier: tabBarModifier, containerColor: tabBarBackgroundColor) {
                        for tabIndex in 0..<tabViews.count {
                            let route = String(describing: tabIndex)
                            let tabItem = tabViews[tabIndex].strippingModifiers(until: { $0 == .tabItem }, perform: { $0 as? TabItemModifierView })
                            NavigationBarItem(
                                icon: {
                                    tabItem?.ComposeImage(context: tabItemContext)
                                },
                                label: {
                                    tabItem?.ComposeTitle(context: tabItemContext)
                                },
                                selected: route == currentRoute,
                                onClick: {
                                    if let selection, let tagValue = tagValue(route: route, in: tabViews) {
                                        selection.wrappedValue = tagValue
                                    } else {
                                        navigate(controller: navController, route: route)
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
                                PreferenceValues.shared.collectPreferences([tabBarPreferencesPreference]) {
                                    // Use a custom composer to only render the tabIndex'th view
                                    content.Compose(context: context.content(composer: TabIndexComposer(index: tabIndex)))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func tagValue(route: String, in tabViews: [View]) -> Any? {
        guard let tabIndex = Int(string: route), tabIndex >= 0, tabIndex < tabViews.count else {
            return nil
        }
        return TagModifierView.strip(from: tabViews[tabIndex], role: ComposeModifierRole.tag)?.value
    }

    private func route(tagValue: Any, in tabViews: [View]) -> String? {
        for tabIndex in 0..<tabViews.count {
            let tabTagValue = TagModifierView.strip(from: tabViews[tabIndex], role: ComposeModifierRole.tag)?.value
            if tagValue == tabTagValue {
                return String(describing: tabIndex)
            }
        }
        return nil
    }

    private func navigate(controller navController: NavHostController, route: String) {
        navController.navigate(route) {
            popUpTo(navController.graph.startDestinationId) {
                saveState = true
            }
            // Avoid multiple copies of the same destination when reselecting the same item
            launchSingleTop = true
            // Restore state when reselecting a previously selected item
            restoreState = true
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
struct TabBarPreferenceKey: PreferenceKey {
    typealias Value = ToolbarBarPreferences?

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ToolbarBarPreferences?>
    class Companion: PreferenceKeyCompanion {
        let defaultValue: ToolbarBarPreferences? = nil
        func reduce(value: inout ToolbarBarPreferences?, nextValue: () -> ToolbarBarPreferences?) {
            guard let next = nextValue() else {
                return
            }
            if value == nil {
                value = next
            } else {
                value = value!.reduce(next)
            }
        }
    }
}

struct TabItemModifierView: ComposeModifierView {
    let label: ComposeBuilder

    init(view: View, @ViewBuilder label: () -> any View) {
        self.label = ComposeBuilder.from(label)
        super.init(view: view, role: .tabItem)
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        view.Compose(context: context)
    }

    @Composable func ComposeTitle(context: ComposeContext) {
        label.Compose(context: context.content(composer: RenderingComposer { view, context in
            let stripped = view.strippingModifiers { $0 }
            if let label = stripped as? Label {
                label.ComposeTitle(context: context(false))
            } else if stripped is Text {
                view.ComposeContent(context: context(false))
            }
        }))
    }

    @Composable func ComposeImage(context: ComposeContext) {
        label.Compose(context: context.content(composer: RenderingComposer { view, context in
            let stripped = view.strippingModifiers { $0 }
            if let label = stripped as? Label {
                label.ComposeImage(context: context(false))
            } else if stripped is Image {
                view.ComposeContent(context: context(false))
            }
        }))
    }
}

final class TabIndexComposer: RenderingComposer {
    let index: Int
    var currentIndex = 0

    init(index: Int) {
        self.index = index
        super.init()
    }

    override func willCompose() {
        currentIndex = 0
    }

    @Composable override func Compose(view: View, context: (Bool) -> ComposeContext) {
        // Be sure to keep the filtering of empty views consistent with our rendering of corresponding TabItems in the navigation bar
        guard !view.isSwiftUIEmptyView else {
            return
        }
        if currentIndex == index {
            view.ComposeContent(context: context(false))
        }
        currentIndex += 1
    }
}
#endif

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
        return TabItemModifierView(view: self, label: label)
        #else
        return self
        #endif
    }

    public func tabViewStyle(_ style: TabViewStyle) -> some View {
        // We only support .automatic
        return self
    }
}

#if false

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
