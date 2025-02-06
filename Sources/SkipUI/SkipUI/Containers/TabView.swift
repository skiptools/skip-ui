// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.PagerState
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarDefaults
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemColors
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.contentColorFor
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.setValue
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
#endif

// SKIP @bridge
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

    // SKIP @bridge
    public init(selectionGet: (() -> Any)?, selectionSet: ((Any) -> Void)?, bridgedContent: any View) {
        if let selectionGet, let selectionSet {
            self.selection = Binding(get: selectionGet, set: selectionSet)
        } else {
            self.selection = nil
        }
        self.content = ComposeBuilder.from { bridgedContent }
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        if let pageTabViewStyle = EnvironmentValues.shared._tabViewStyle as? PageTabViewStyle {
            ComposePageViewContent(indexDisplayMode: pageTabViewStyle.indexDisplayMode, context: context)
        } else {
            ComposeTabViewContent(context: context)
        }
    }

    @Composable private func ComposePageViewContent(indexDisplayMode: PageTabViewStyle.IndexDisplayMode, context: ComposeContext) {
        // WARNING: This function is a potential recomposition hotspot
        let contentContext = context.content()
        let tabViews = content.collectViews(context: contentContext).filter { !$0.isSwiftUIEmptyView }
        let tags = tabViews.map { TagModifierView.strip(from: $0, role: ComposeModifierRole.tag)?.value }
        let coroutineScope = rememberCoroutineScope()
        let isSyncingToSelection = remember { mutableStateOf(false) }
        let pagerState = rememberPagerState(pageCount: { tabViews.count })
        ComposeContainer(modifier: context.modifier, fillWidth: true) { modifier in
            Box(modifier: modifier) {
                syncPagerStateToSelection(pagerState, tags: tags, isSyncingToSelection: isSyncingToSelection, coroutineScope: coroutineScope)
                ComposePageViewPager(pagerState: pagerState, tabViews: tabViews, tags: tags, isSyncingToSelection: isSyncingToSelection, context: contentContext)
                if indexDisplayMode == .always || (indexDisplayMode == .automatic && tabViews.count > 1) {
                    let modifier = Modifier
                        .wrapContentHeight()
                        .fillMaxWidth()
                        .align(androidx.compose.ui.Alignment.BottomCenter)
                        .padding(bottom: 16.dp)
                    ComposePageViewIndicator(pagerState: pagerState, modifier: modifier, coroutineScope: coroutineScope, context: contentContext)
                }
            }
        }
    }

    @Composable private func ComposePageViewPager(pagerState: PagerState, tabViews: [View], tags: [Any?], isSyncingToSelection: MutableState<Bool>, context: ComposeContext) {
        HorizontalPager(state: pagerState, modifier: Modifier.fillMaxSize()) { page in
            if page >= 0 && page < tabViews.count {
                Box(modifier: Modifier.fillMaxSize(), contentAlignment: androidx.compose.ui.Alignment.Center) {
                    tabViews[page].Compose(context: context)
                }
                // We don't get a callback when the user scrolls the pager, so use the rendering callback to sync any
                // user-initiated navigation to the selection binding
                syncSelectionToPagerState(pagerState, tags: tags, isSyncingToSelection: isSyncingToSelection)
            }
        }
    }

    @Composable private func syncPagerStateToSelection(_ pagerState: PagerState, tags: [Any?], isSyncingToSelection: MutableState<Bool>, coroutineScope: CoroutineScope) {
        guard let selectedTag = selection?.wrappedValue else {
            return
        }
        let selectedPageState = rememberUpdatedState(tags.firstIndex { $0 == selectedTag })
        guard let selectedPage = selectedPageState.value, selectedPage != pagerState.targetPage else {
            return
        }
        // Don't attempt to sync to the selection while the user is scrolling
        guard !pagerState.isScrollInProgress || isSyncingToSelection.value else {
            return
        }
        let isWithAnimationState = rememberUpdatedState(Animation.isInWithAnimation)
        // Track that we're syncing to the selection so that we don't try to sync the other way while waiting for
        // the coroutine to launch, or confuse the resulting scrolling with user scrolling
        isSyncingToSelection.value = true
        coroutineScope.launch {
            if let selectedPage = selectedPageState.value {
                if pagerState.isScrollInProgress || isWithAnimationState.value {
                    pagerState.animateScrollToPage(selectedPage)
                } else {
                    pagerState.scrollToPage(selectedPage)
                }
                isSyncingToSelection.value = false
            }
        }
    }

    @Composable private func syncSelectionToPagerState(_ pagerState: PagerState, tags: [Any?], isSyncingToSelection: MutableState<Bool>) {
        // Don't confuse our own programmatic scrolling with user scrolling
        guard !isSyncingToSelection.value else {
            return
        }
        guard pagerState.targetPage >= 0 && pagerState.targetPage < tags.count else {
            return
        }
        guard let targetTag = tags[pagerState.targetPage], let selectedTag = selection?.wrappedValue, selectedTag != targetTag else {
            return
        }
        selection?.wrappedValue = targetTag
    }

    // https://developer.android.com/develop/ui/compose/layouts/pager#add-page
    @Composable private func ComposePageViewIndicator(pagerState: PagerState, modifier: Modifier, coroutineScope: CoroutineScope, context: ComposeContext) {
        Row(modifier: modifier, horizontalArrangement: Arrangement.Center) {
            for indicatorPage in 0..<pagerState.pageCount {
                let isCurrentPage = pagerState.targetPage == indicatorPage
                let buttonModifier = context.modifier.clickable(onClick: {
                    coroutineScope.launch { pagerState.animateScrollToPage(indicatorPage) }
                }, enabled: !isCurrentPage)
                Box(modifier: buttonModifier) {
                    let indicatorColor = isCurrentPage ? Color.white : Color.white.opacity(0.5)
                    let indicatorDynamicSize = 8.dp * LocalDensity.current.fontScale
                    let indicatorModifier = Modifier
                        .padding(horizontal: indicatorDynamicSize)
                        .clip(CircleShape)
                        .background(indicatorColor.colorImpl())
                        .size(indicatorDynamicSize)
                    Box(modifier: indicatorModifier)
                }
            }
        }
    }

    @Composable private func ComposeTabViewContent(context: ComposeContext) {
        // WARNING: This function is a potential recomposition hotspot. It should not need to be called on every tab
        // change. Test after any modification

        let tabItemContext = context.content()
        var tabViews: [View] = []
        EnvironmentValues.shared.setValues {
            $0.set_placement(ViewPlacement.tagged)
        } in: {
            tabViews = content.collectViews(context: tabItemContext).filter { !$0.isSwiftUIEmptyView }
        }
        let tabItems = tabViews.map { view in
            view.strippingModifiers(until: { $0 is TabItemModifierView }, perform: { $0 as? TabItemModifierView })
        }

        let navController = rememberNavController()
        // Isolate access to current route within child Composable so route nav does not force us to recompose
        navigateToCurrentRoute(controller: navController, tabViews: tabViews)

        let tabBarPreferences = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<ToolbarBarPreferences>, Any>) { mutableStateOf(Preference<ToolbarBarPreferences>(key: TabBarPreferenceKey.self)) }
        let tabBarPreferencesCollector = PreferenceCollector<ToolbarBarPreferences>(key: TabBarPreferenceKey.self, state: tabBarPreferences)

        let safeArea = EnvironmentValues.shared._safeArea
        let density = LocalDensity.current
        let defaultBottomBarHeight = 80.dp
        let bottomBarTopPx = remember {
            // Default our initial value to the expected value, which helps avoid visual artifacts as we measure actual values and
            // recompose with adjusted layouts
            if let safeArea {
                mutableStateOf(with(density) { safeArea.presentationBoundsPx.bottom - defaultBottomBarHeight.toPx() })
            } else {
                mutableStateOf(Float(0.0))
            }
        }
        let bottomBarHeightPx = remember { mutableStateOf(with(density) { defaultBottomBarHeight.toPx() }) }

        // Reduce the tab bar preferences outside the bar composable. Otherwise the reduced value may change
        // when the bottom bar recomposes
        let reducedTabBarPreferences = tabBarPreferences.value.reduced
        let bottomBar: @Composable () -> Void = {
            guard tabItems.contains(where: { $0 != nil }) && reducedTabBarPreferences.visibility != Visibility.hidden else {
                SideEffect {
                    bottomBarTopPx.value = Float(0.0)
                    bottomBarHeightPx.value = Float(0.0)
                }
                return
            }
            var tabBarModifier = Modifier.fillMaxWidth()
                .onGloballyPositionedInWindow { bounds in
                    bottomBarTopPx.value = bounds.top
                    bottomBarHeightPx.value = bounds.bottom - bounds.top
                }
            let tint = EnvironmentValues.shared._tint
            let hasColorScheme = reducedTabBarPreferences.colorScheme != nil
            let isSystemBackground = reducedTabBarPreferences.isSystemBackground == true
            let showScrolledBackground = reducedTabBarPreferences.backgroundVisibility == Visibility.visible || reducedTabBarPreferences.scrollableState?.canScrollForward == true
            let materialColorScheme: androidx.compose.material3.ColorScheme
            if showScrolledBackground, let customColorScheme = reducedTabBarPreferences.colorScheme?.asMaterialTheme() {
                materialColorScheme = customColorScheme
            } else {
                materialColorScheme = MaterialTheme.colorScheme
            }
            MaterialTheme(colorScheme: materialColorScheme) {
                let indicatorColor: androidx.compose.ui.graphics.Color
                if let tint {
                    indicatorColor = tint.asComposeColor().copy(alpha: Float(0.35))
                } else {
                    indicatorColor = ColorScheme.fromMaterialTheme(colorScheme: materialColorScheme) == ColorScheme.dark ? androidx.compose.ui.graphics.Color.White.copy(alpha: Float(0.1)) : androidx.compose.ui.graphics.Color.Black.copy(alpha: Float(0.1))
                }
                let tabBarBackgroundColor: androidx.compose.ui.graphics.Color
                let unscrolledTabBarBackgroundColor: androidx.compose.ui.graphics.Color
                let tabBarBackgroundForBrush: ShapeStyle?
                let tabBarItemColors: NavigationBarItemColors
                if reducedTabBarPreferences.backgroundVisibility == Visibility.hidden {
                    tabBarBackgroundColor = androidx.compose.ui.graphics.Color.Transparent
                    unscrolledTabBarBackgroundColor = androidx.compose.ui.graphics.Color.Transparent
                    tabBarBackgroundForBrush = nil
                    tabBarItemColors = NavigationBarItemDefaults.colors(indicatorColor: indicatorColor)
                } else if let background = reducedTabBarPreferences.background {
                    if let color = background.asColor(opacity: 1.0, animationContext: nil) {
                        tabBarBackgroundColor = color
                        unscrolledTabBarBackgroundColor = isSystemBackground ? Color.systemBarBackground.colorImpl() : color.copy(alpha: Float(0.0))
                        tabBarBackgroundForBrush = nil
                    } else {
                        unscrolledTabBarBackgroundColor = isSystemBackground ? Color.systemBarBackground.colorImpl() : androidx.compose.ui.graphics.Color.Transparent
                        tabBarBackgroundColor = unscrolledTabBarBackgroundColor.copy(alpha: Float(0.0))
                        tabBarBackgroundForBrush = background
                    }
                    tabBarItemColors = NavigationBarItemDefaults.colors(indicatorColor: indicatorColor)
                } else {
                    tabBarBackgroundColor = Color.systemBarBackground.colorImpl()
                    unscrolledTabBarBackgroundColor = isSystemBackground ? tabBarBackgroundColor : tabBarBackgroundColor.copy(alpha: Float(0.0))
                    tabBarBackgroundForBrush = nil
                    if tint == nil {
                        tabBarItemColors = NavigationBarItemDefaults.colors()
                    } else {
                        tabBarItemColors = NavigationBarItemDefaults.colors(indicatorColor: indicatorColor)
                    }
                }
                if showScrolledBackground, let tabBarBackgroundForBrush {
                    if let tabBarBackgroundBrush = tabBarBackgroundForBrush.asBrush(opacity: 1.0, animationContext: nil) {
                        tabBarModifier = tabBarModifier.background(tabBarBackgroundBrush)
                    }
                }

                let currentRoute = currentRoute(for: navController) // Note: forces recompose of this context on tab navigation
                // Pull the tab bar below the keyboard
                let bottomPadding = with(density) { min(bottomBarHeightPx.value, Float(WindowInsets.ime.getBottom(density))).toDp() }
                PaddingLayout(padding: EdgeInsets(top: 0.0, leading: 0.0, bottom: Double(-bottomPadding.value), trailing: 0.0), context: context.content()) { context in
                    let tabItemsState = rememberUpdatedState(tabItems)
                    let containerColor = showScrolledBackground ? tabBarBackgroundColor : unscrolledTabBarBackgroundColor
                    let onItemClick: (Int) -> Void = { tabIndex in
                        let route = String(describing: tabIndex)
                        if let selection, let tagValue = tagValue(route: route, in: tabViews) {
                            selection.wrappedValue = tagValue
                        } else {
                            navigate(controller: navController, route: route)
                        }
                    }
                    let itemIcon: @Composable (Int) -> Void = { tabIndex in
                        let tabItem = tabItemsState.value[tabIndex]
                        tabItem?.ComposeImage(context: tabItemContext)
                    }
                    let itemLabel: @Composable (Int) -> Void = { tabIndex in
                        let tabItem = tabItemsState.value[tabIndex]
                        tabItem?.ComposeTitle(context: tabItemContext)
                    }
                    var options = Material3NavigationBarOptions(modifier: context.modifier.then(tabBarModifier), containerColor: containerColor, contentColor: MaterialTheme.colorScheme.contentColorFor(containerColor), onItemClick: onItemClick, itemIcon: itemIcon, itemLabel: itemLabel, itemColors: tabBarItemColors)
                    if let updateOptions = EnvironmentValues.shared._material3NavigationBar {
                        options = updateOptions(options)
                    }
                    NavigationBar(modifier: options.modifier, containerColor: options.containerColor, contentColor: options.contentColor, tonalElevation: options.tonalElevation) {
                        for tabIndex in 0..<tabViews.count {
                            let route = String(describing: tabIndex)
                            let label: (@Composable () -> Void)?
                            if let itemLabel = options.itemLabel {
                                label = { itemLabel(tabIndex)  }
                            } else {
                                label = nil
                            }
                            NavigationBarItem(selected: route == currentRoute,
                                onClick: { options.onItemClick(tabIndex) },
                                icon: { options.itemIcon(tabIndex) },
                                modifier: options.itemModifier(tabIndex),
                                enabled: options.itemEnabled(tabIndex),
                                label: label,
                                alwaysShowLabel: options.alwaysShowItemLabels,
                                colors: options.itemColors,
                                interactionSource: options.itemInteractionSource
                            )
                        }
                    }
                }
            }
        }

        // When we layout, extend into the safe area if it is due to system bars, not into any app chrome. We extend
        // into the top bar too so that tab content can also extend into the top area without getting cut off during
        // tab switches
        var ignoresSafeAreaEdges: Edge.Set = [.bottom, .top]
        ignoresSafeAreaEdges.formIntersection(safeArea?.absoluteSystemBarEdges ?? [])
        IgnoresSafeAreaLayout(expandInto: ignoresSafeAreaEdges) { _, _ in
            ComposeContainer(modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
                // Don't use a Scaffold: it clips content beyond its bounds and prevents .ignoresSafeArea modifiers from working
                Column(modifier: modifier.background(Color.background.colorImpl())) {
                    NavHost(navController,
                            modifier: Modifier.fillMaxWidth().weight(Float(1.0)),
                            startDestination: "0",
                            enterTransition: { EnterTransition.None },
                            exitTransition: { ExitTransition.None }) {
                        // Use a constant number of routes. Changing routes causes a NavHost to reset its state
                        for tabIndex in 0..<100 {
                            composable(String(describing: tabIndex)) { _ in
                                // Inset manually where our container ignored the safe area, but we aren't showing a bar
                                let topPadding = ignoresSafeAreaEdges.contains(.top) ? WindowInsets.safeDrawing.asPaddingValues().calculateTopPadding() : 0.dp
                                var bottomPadding = 0.dp
                                if bottomBarTopPx.value <= Float(0.0) && ignoresSafeAreaEdges.contains(.bottom) {
                                    bottomPadding = max(0.dp, WindowInsets.safeDrawing.asPaddingValues().calculateBottomPadding() - WindowInsets.ime.asPaddingValues().calculateBottomPadding())
                                }
                                let contentModifier = Modifier.fillMaxSize().padding(top: topPadding, bottom: bottomPadding)
                                let contentSafeArea = safeArea?.insetting(.bottom, to: bottomBarTopPx.value)

                                // Special-case the first composition to avoid seeing the layout adjust. This is a common
                                // issue with nav stacks in particular, and they're common enough that we need to cater to them.
                                // Use an extra container to avoid causing the content itself to recompose
                                let hasComposed = remember { mutableStateOf(false) }
                                SideEffect { hasComposed.value = true }
                                let alpha = hasComposed.value ? Float(1.0) : Float(0.0)
                                Box(modifier: Modifier.alpha(alpha), contentAlignment: androidx.compose.ui.Alignment.Center) {
                                    // This block is called multiple times on tab switch. Use stable arguments that will prevent our entry from
                                    // recomposing when called with the same values
                                    let arguments = TabEntryArguments(tabIndex: tabIndex, modifier: contentModifier, safeArea: contentSafeArea)
                                    PreferenceValues.shared.collectPreferences([tabBarPreferencesCollector]) {
                                        ComposeEntry(with: arguments, context: context)
                                    }
                                }
                            }
                        }
                    }
                    bottomBar()
                }
            }
        }
    }

    @Composable private func ComposeEntry(with arguments: TabEntryArguments, context: ComposeContext) {
        // WARNING: This function is a potential recomposition hotspot. It should not need to be called
        // multiple times for the same tab on tab change. Test after modifications
        Box(modifier: arguments.modifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
            EnvironmentValues.shared.setValues {
                if let safeArea = arguments.safeArea {
                    $0.set_safeArea(safeArea)
                }
            } in: {
                // Use a custom composer to only render the tabIndex'th view
                content.Compose(context: context.content(composer: TabIndexComposer(index: arguments.tabIndex)))
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
            // Clear back stack so that tabs don't participate in Android system back button
            let destinationID = navController.currentBackStackEntry?.destination?.id ?? navController.graph.startDestinationId
            popUpTo(destinationID) {
                inclusive = true
                saveState = true
            }
            // Avoid multiple copies of the same destination when reselecting the same item
            launchSingleTop = true
            // Restore state when reselecting a previously selected item
            restoreState = true
        }
    }

    @Composable private func navigateToCurrentRoute(controller navController: NavHostController, tabViews: [View]) {
        let currentRoute = currentRoute(for: navController)
        if let selection, let currentRoute, selection.wrappedValue != tagValue(route: currentRoute, in: tabViews) {
            if let route = route(tagValue: selection.wrappedValue, in: tabViews) {
                navigate(controller: navController, route: route)
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
@Stable struct TabEntryArguments: Equatable {
    let tabIndex: Int
    let modifier: Modifier
    let safeArea: SafeArea?
}

struct TabBarPreferenceKey: PreferenceKey {
    typealias Value = ToolbarBarPreferences

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<ToolbarBarPreferences>
    class Companion: PreferenceKeyCompanion {
        let defaultValue = ToolbarBarPreferences()
        func reduce(value: inout ToolbarBarPreferences, nextValue: () -> ToolbarBarPreferences) {
            value = value.reduce(nextValue())
        }
    }
}

struct TabItemModifierView: ComposeModifierView {
    let label: ComposeBuilder

    init(view: View, @ViewBuilder label: () -> any View) {
        self.label = ComposeBuilder.from(label)
        super.init(view: view)
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

// MARK: TabViewStyle

public protocol TabViewStyle: Equatable {}

public struct DefaultTabViewStyle : TabViewStyle {
    public init() {}
}

extension TabViewStyle where Self == DefaultTabViewStyle {
    public static var automatic: DefaultTabViewStyle { DefaultTabViewStyle() }
}

public struct TabBarOnlyTabViewStyle: TabViewStyle {
    public init() {}
}

extension TabViewStyle where Self == TabBarOnlyTabViewStyle {
    public static var tabBarOnly: TabBarOnlyTabViewStyle { TabBarOnlyTabViewStyle() }
}

public struct PageTabViewStyle: TabViewStyle {
    public let indexDisplayMode: PageTabViewStyle.IndexDisplayMode

    public struct IndexDisplayMode: RawRepresentable, Equatable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let automatic = IndexDisplayMode(rawValue: 0)
        public static let always = IndexDisplayMode(rawValue: 1)
        public static let never = IndexDisplayMode(rawValue: 2)
    }

    public init(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic) {
        self.indexDisplayMode = indexDisplayMode
    }
}

extension TabViewStyle where Self == PageTabViewStyle {
    public static var page: PageTabViewStyle { PageTabViewStyle() }

    public static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) -> PageTabViewStyle {
        return PageTabViewStyle(indexDisplayMode: indexDisplayMode)
    }
}

// MARK: View extensions

extension View {
    public func tabItem(@ViewBuilder _ label: () -> any View) -> any View {
        #if SKIP
        return TabItemModifierView(view: self, label: label)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func tabItem(bridgedLabel: any View) -> any View {
        return tabItem({ bridgedLabel })
    }

    public func tabViewStyle(_ style: any TabViewStyle) -> some View {
        #if SKIP
        return environment(\._tabViewStyle, style)
        #else
        return self
        #endif
    }

    #if SKIP
    public func material3NavigationBar(_ options: @Composable (Material3NavigationBarOptions) -> Material3NavigationBarOptions) -> View {
        return environment(\._material3NavigationBar, options)
    }
    #endif
}

#if SKIP
public struct Material3NavigationBarOptions {
    public var modifier: Modifier = Modifier
    public var containerColor: androidx.compose.ui.graphics.Color
    public var contentColor: androidx.compose.ui.graphics.Color
    public var tonalElevation: Dp = NavigationBarDefaults.Elevation
    public var onItemClick: (Int) -> Void
    public var itemIcon: @Composable (Int) -> Void
    public var itemModifier: @Composable (Int) -> Modifier = { _ in Modifier }
    public var itemEnabled: (Int) -> Boolean = { _ in true }
    public var itemLabel: (@Composable (Int) -> Void)? = nil
    public var alwaysShowItemLabels = true
    public var itemColors: NavigationBarItemColors
    public var itemInteractionSource: MutableInteractionSource? = nil

    public func copy(
        modifier: Modifier = self.modifier,
        containerColor: androidx.compose.ui.graphics.Color = self.containerColor,
        contentColor: androidx.compose.ui.graphics.Color = self.contentColor,
        tonalElevation: Dp = self.tonalElevation,
        onItemClick: (Int) -> Void = self.onItemClick,
        itemIcon: @Composable (Int) -> Void = self.itemIcon,
        itemModifier: @Composable (Int) -> Modifier = self.itemModifier,
        itemEnabled: (Int) -> Boolean = self.itemEnabled,
        itemLabel: (@Composable (Int) -> Void)? = self.itemLabel,
        alwaysShowItemLabels: Bool = self.alwaysShowItemLabels,
        itemColors: NavigationBarItemColors = self.itemColors,
        itemInteractionSource: MutableInteractionSource? = self.itemInteractionSource
    ) -> Material3NavigationBarOptions {
        return Material3NavigationBarOptions(modifier: modifier, containerColor: containerColor, contentColor: contentColor, tonalElevation: tonalElevation, onItemClick: onItemClick, itemIcon: itemIcon, itemModifier: itemModifier, itemEnabled: itemEnabled, itemLabel: itemLabel, alwaysShowItemLabels: alwaysShowItemLabels, itemColors: itemColors, itemInteractionSource: itemInteractionSource)
    }
}
#endif
#endif
