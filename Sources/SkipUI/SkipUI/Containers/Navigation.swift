// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.activity.compose.BackHandler
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.material.IconButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material.icons.outlined.KeyboardArrowRight
import androidx.compose.material.icons.outlined.KeyboardArrowLeft
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MediumTopAppBar
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberTopAppBarState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.ProvidableCompositionLocal
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.platform.SoftwareKeyboardController
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.zIndex
import androidx.navigation.NavBackStackEntry
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.navArgument
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import kotlin.reflect.full.superclasses
import kotlinx.coroutines.delay
#endif

public struct NavigationStack<Root> : View where Root: View {
    let root: Root
    let path: Binding<[Any]>?
    let navigationPath: Binding<NavigationPath>?

    public init(@ViewBuilder root: () -> Root) {
        self.root = root()
        self.path = nil
        self.navigationPath = nil
    }

    public init(path: Binding<NavigationPath>, @ViewBuilder root: () -> Root) {
        self.root = root()
        self.path = nil
        self.navigationPath = path
    }

    public init(path: Any, @ViewBuilder root: () -> Root) {
        self.root = root()
        self.path = path as! Binding<[Any]>?
        self.navigationPath = nil
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalComposeUiApi::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        // Have to use rememberSaveable for e.g. a nav stack in each tab
        let destinations = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<NavigationDestinations>, Any>) { mutableStateOf(Preference<NavigationDestinations>(key: NavigationDestinationsPreferenceKey.self))
        }
        // Make this collector non-erasable so that destinations defined at e.g. the root nav stack layer don't disappear when you push
        let destinationsCollector = PreferenceCollector<NavigationDestinations>(key: NavigationDestinationsPreferenceKey.self, state: destinations, isErasable: false)
        let reducedDestinations = destinations.value.reduced
        let navController = rememberNavController()
        let navigator = rememberSaveable(stateSaver: context.stateSaver as! Saver<Navigator, Any>) { mutableStateOf(Navigator(navController: navController, destinations: reducedDestinations)) }
        navigator.value.didCompose(navController: navController, destinations: reducedDestinations, path: path, navigationPath: navigationPath, keyboardController: LocalSoftwareKeyboardController.current)

        // SKIP INSERT: val providedNavigator = LocalNavigator provides navigator.value
        CompositionLocalProvider(providedNavigator) {
            let safeArea = EnvironmentValues.shared._safeArea
            // We have to ignore the safe area around the entire NavHost to prevent push/pop animation issues with the system bars.
            // When we layout, only extend into safe areas that are due to system bars, not into any app chrome
            var ignoresSafeAreaEdges: Edge.Set = [.top, .bottom]
            ignoresSafeAreaEdges.formIntersection(safeArea?.absoluteSystemBarEdges ?? [])
            IgnoresSafeAreaLayout(edges: ignoresSafeAreaEdges, context: context) { context in
                ComposeContainer(modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
                    let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
                    NavHost(navController: navController, startDestination: Navigator.rootRoute, modifier: modifier) {
                        composable(route: Navigator.rootRoute,
                                   exitTransition: { slideOutHorizontally(targetOffsetX: { $0 * (isRTL ? 1 : -1) / 3 }) },
                                   popEnterTransition: { slideInHorizontally(initialOffsetX: { $0 * (isRTL ? 1 : -1) / 3 }) }) { entry in
                            guard let state = navigator.value.state(for: entry) else {
                                return
                            }
                            // These preferences are per-entry, but if we put them in ComposeEntry then their initial values don't show
                            // during the navigation animation. We have to collect them here
                            let title = rememberSaveable(stateSaver: state.stateSaver as! Saver<Preference<Text>, Any>) { mutableStateOf(Preference<Text>(key: NavigationTitlePreferenceKey.self)) }
                            let titleCollector = PreferenceCollector<Text>(key: NavigationTitlePreferenceKey.self, state: title)
                            let toolbarPreferences = rememberSaveable(stateSaver: state.stateSaver as! Saver<Preference<ToolbarPreferences>, Any>) { mutableStateOf(Preference<ToolbarPreferences>(key: ToolbarPreferenceKey.self)) }
                            let toolbarPreferencesCollector = PreferenceCollector<ToolbarPreferences>(key: ToolbarPreferenceKey.self, state: toolbarPreferences)

                            let arguments = NavigationEntryArguments(isRoot: true, state: state, safeArea: safeArea, ignoresSafeAreaEdges: ignoresSafeAreaEdges, title: title.value.reduced, toolbarPreferences: toolbarPreferences.value.reduced)
                            PreferenceValues.shared.collectPreferences([titleCollector, toolbarPreferencesCollector, destinationsCollector]) {
                                ComposeEntry(navigator: navigator, arguments: arguments, context: context) { context in
                                    root.Compose(context: context)
                                }
                            }
                        }
                        for destinationIndex in 0..<Navigator.destinationCount {
                            composable(route: Navigator.route(for: destinationIndex, valueString: "{identifier}"),
                                       arguments: listOf(navArgument("identifier") { type = NavType.StringType }),
                                       enterTransition: { slideInHorizontally(initialOffsetX: { $0 * (isRTL ? -1 : 1) }) },
                                       exitTransition: { slideOutHorizontally(targetOffsetX: { $0 * (isRTL ? 1 : -1) / 3 }) },
                                       popEnterTransition: { slideInHorizontally(initialOffsetX: { $0 * (isRTL ? 1 : -1) / 3 }) },
                                       popExitTransition: { slideOutHorizontally(targetOffsetX: { $0 * (isRTL ? -1 : 1) }) }) { entry in
                                guard let state = navigator.value.state(for: entry), let targetValue = state.targetValue else {
                                    return
                                }
                                // These preferences are per-entry, but if we put them in ComposeEntry then their initial values don't show
                                // during the navigation animation. We have to collect them here
                                let title = rememberSaveable(stateSaver: state.stateSaver as! Saver<Preference<Text>, Any>) { mutableStateOf(Preference<Text>(key: NavigationTitlePreferenceKey.self)) }
                                let titleCollector = PreferenceCollector<Text>(key: NavigationTitlePreferenceKey.self, state: title)
                                let toolbarPreferences = rememberSaveable(stateSaver: state.stateSaver as! Saver<Preference<ToolbarPreferences>, Any>) { mutableStateOf(Preference<ToolbarPreferences>(key: ToolbarPreferenceKey.self)) }
                                let toolbarPreferencesCollector = PreferenceCollector<ToolbarPreferences>(key: ToolbarPreferenceKey.self, state: toolbarPreferences)

                                EnvironmentValues.shared.setValues {
                                    $0.setdismiss(DismissAction(action: { navigator.value.navigateBack() }))
                                } in: {
                                    let arguments = NavigationEntryArguments(isRoot: false, state: state, safeArea: safeArea, ignoresSafeAreaEdges: ignoresSafeAreaEdges, title: title.value.reduced, toolbarPreferences: toolbarPreferences.value.reduced)
                                    PreferenceValues.shared.collectPreferences([titleCollector, toolbarPreferencesCollector,  destinationsCollector]) {
                                        ComposeEntry(navigator: navigator, arguments: arguments, context: context) { context in
                                            let destinationArguments = NavigationDestinationArguments(targetValue: targetValue)
                                            ComposeDestination(state.destination, arguments: destinationArguments, context: context)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
    @Composable private func ComposeEntry(navigator: MutableState<Navigator>, arguments: NavigationEntryArguments, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
        let context = context.content(stateSaver: arguments.state.stateSaver)

        let topBarPreferences = arguments.toolbarPreferences.navigationBar
        let bottomBarPreferences = arguments.toolbarPreferences.bottomBar
        let effectiveTitleDisplayMode = navigator.value.titleDisplayMode(for: arguments.state, preference: arguments.toolbarPreferences.titleDisplayMode)
        let isInlineTitleDisplayMode = useInlineTitleDisplayMode(for: effectiveTitleDisplayMode, safeArea: arguments.safeArea)
        let toolbarItems = ToolbarItems(content: arguments.toolbarPreferences.content ?? [])

        let searchFieldPadding = 16.dp
        let density = LocalDensity.current
        let searchFieldHeightPx = with(density) { searchFieldHeight.dp.toPx() + searchFieldPadding.toPx() }
        let searchFieldOffsetPx = rememberSaveable(stateSaver: context.stateSaver as! Saver<Float, Any>) { mutableStateOf(Float(0.0)) }
        let searchFieldScrollConnection = remember { SearchFieldScrollConnection(heightPx: searchFieldHeightPx, offsetPx: searchFieldOffsetPx) }

        let searchableStatePreference = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<SearchableState?>, Any>) { mutableStateOf(Preference<SearchableState?>(key: SearchableStatePreferenceKey.self)) }
        let searchableStateCollector = PreferenceCollector<SearchableState?>(key: SearchableStatePreferenceKey.self, state: searchableStatePreference)

        let scrollToTop = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<() -> Void>, Any>) { mutableStateOf(Preference<() -> Void>(key: ScrollToTopPreferenceKey.self)) }
        let scrollToTopCollector = PreferenceCollector<() -> Void>(key: ScrollToTopPreferenceKey.self, state: scrollToTop)

        let scrollBehavior = isInlineTitleDisplayMode ? TopAppBarDefaults.pinnedScrollBehavior() : TopAppBarDefaults.exitUntilCollapsedScrollBehavior(rememberTopAppBarState())
        var modifier = Modifier.nestedScroll(searchFieldScrollConnection)
        if topBarPreferences?.visibility != Visibility.hidden {
            modifier = modifier.nestedScroll(scrollBehavior.nestedScrollConnection)
        }
        modifier = modifier.then(context.modifier)

        // Intercept system back button to keep our state in sync
        BackHandler(enabled: !navigator.value.isRoot) {
            if arguments.toolbarPreferences.backButtonHidden != true {
                navigator.value.navigateBack()
            }
        }

        let topBarBottomPx = remember {
            // Default our initial value to the expected value, which helps avoid visual artifacts as we measure actual values and
            // recompose with adjusted layouts
            let safeAreaTopPx = arguments.safeArea?.safeBoundsPx.top ?? Float(0.0)
            mutableStateOf(with(density) { safeAreaTopPx + 112.dp.toPx() })
        }
        let topBarBackgroundColor: androidx.compose.ui.graphics.Color
        let topBarBackgroundBrush: androidx.compose.ui.graphics.Brush?
        if topBarPreferences?.backgroundVisibility == Visibility.hidden {
            topBarBackgroundColor = Color.clear.colorImpl()
            topBarBackgroundBrush = nil
        } else if let background = topBarPreferences?.background {
            if let color = background.asColor(opacity: 1.0, animationContext: nil) {
                topBarBackgroundColor = color
                topBarBackgroundBrush = nil
            } else {
                topBarBackgroundColor = Color.clear.colorImpl()
                topBarBackgroundBrush = background.asBrush(opacity: 1.0, animationContext: nil)
            }
        } else {
            topBarBackgroundColor = Color.systemBarBackground.colorImpl()
            topBarBackgroundBrush = nil
        }
        let topBar: @Composable () -> Void = {
            guard topBarPreferences?.visibility != Visibility.hidden else {
                SideEffect { topBarBottomPx.value = Float(0.0) }
                return
            }
            let topLeadingItems = toolbarItems.filterTopBarLeading()
            let topTrailingItems = toolbarItems.filterTopBarTrailing()
            guard !arguments.isRoot || arguments.title != NavigationTitlePreferenceKey.defaultValue || !topLeadingItems.isEmpty || !topTrailingItems.isEmpty || topBarPreferences?.visibility == Visibility.visible else {
                SideEffect { topBarBottomPx.value = Float(0.0) }
                return
            }
            let materialColorScheme = topBarPreferences?.colorScheme?.asMaterialTheme() ?? MaterialTheme.colorScheme
            MaterialTheme(colorScheme: materialColorScheme) {
                let tint = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.onSurface })
                let placement = EnvironmentValues.shared._placement
                EnvironmentValues.shared.setValues {
                    $0.set_placement(placement.union(ViewPlacement.toolbar))
                    $0.set_tint(tint)
                } in: {
                    let interactionSource = remember { MutableInteractionSource() }
                    var topBarModifier = Modifier.zIndex(Float(1.1))
                        .clickable(interactionSource: interactionSource, indication: nil, onClick: {
                            scrollToTop.value.reduced()
                        })
                        .onGloballyPositioned {
                            let bottomPx = $0.boundsInWindow().bottom
                            if bottomPx > Float(0.0) { // Sometimes we see random 0 values
                                topBarBottomPx.value = bottomPx
                            }
                        }
                    if let topBarBackgroundBrush {
                        topBarModifier = topBarModifier.background(topBarBackgroundBrush)
                    }
                    let topBarColors = TopAppBarDefaults.topAppBarColors(
                        containerColor: topBarBackgroundColor,
                        scrolledContainerColor: topBarBackgroundColor,
                        titleContentColor: MaterialTheme.colorScheme.onSurface
                    )
                    let topBarTitle: @Composable () -> Void = {
                        androidx.compose.material3.Text(arguments.title.localizedTextString(), maxLines: 1, overflow: TextOverflow.Ellipsis)
                    }
                    let topBarNavigationIcon: @Composable () -> Void = {
                        let hasBackButton = !arguments.isRoot && arguments.toolbarPreferences.backButtonHidden != true
                        if hasBackButton || !topLeadingItems.isEmpty {
                            let toolbarItemContext = context.content(modifier: Modifier.padding(start: 12.dp, end: 12.dp))
                            Row(verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                                if hasBackButton {
                                    IconButton(onClick: {
                                        navigator.value.navigateBack()
                                    }) {
                                        let isRTL = EnvironmentValues.shared.layoutDirection == LayoutDirection.rightToLeft
                                        Icon(imageVector: (isRTL ? Icons.Filled.ArrowForward : Icons.Filled.ArrowBack), contentDescription: "Back", tint: tint.colorImpl())
                                    }
                                }
                                topLeadingItems.forEach { $0.Compose(context: toolbarItemContext) }
                            }
                        }
                    }
                    let topBarActions: @Composable () -> Void = {
                        let toolbarItemContext = context.content(modifier: Modifier.padding(start: 12.dp, end: 12.dp))
                        topTrailingItems.forEach { $0.Compose(context: toolbarItemContext) }
                    }
                    if isInlineTitleDisplayMode {
                        TopAppBar(modifier: topBarModifier, colors: topBarColors, title: topBarTitle, navigationIcon: topBarNavigationIcon, actions: { topBarActions() }, scrollBehavior: scrollBehavior)
                    } else {
                        // Force a larger, bold title style in the uncollapsed state by replacing the headlineSmall style the bar uses
                        let typography = MaterialTheme.typography
                        let appBarTitleStyle = typography.headlineLarge.copy(fontWeight: FontWeight.Bold)
                        let appBarTypography = typography.copy(headlineSmall: appBarTitleStyle)
                        MaterialTheme(colorScheme: MaterialTheme.colorScheme, typography: appBarTypography, shapes: MaterialTheme.shapes) {
                            MediumTopAppBar(modifier: topBarModifier, colors: topBarColors, title: topBarTitle, navigationIcon: topBarNavigationIcon, actions: { topBarActions() }, scrollBehavior: scrollBehavior)
                        }
                    }
                }
            }
        }

        let bottomBarTopPx = remember { mutableStateOf(Float(0.0)) }
        let bottomBarHeightPx = remember { mutableStateOf(Float(0.0)) }
        let bottomBar: @Composable () -> Void = {
            guard bottomBarPreferences?.visibility != Visibility.hidden else {
                SideEffect {
                    bottomBarTopPx.value = Float(0.0)
                    bottomBarHeightPx.value = Float(0.0)
                }
                return
            }
            let bottomItems = toolbarItems.filterBottomBar()
            guard !bottomItems.isEmpty || bottomBarPreferences?.visibility == Visibility.visible else {
                SideEffect {
                    bottomBarTopPx.value = Float(0.0)
                    bottomBarHeightPx.value = Float(0.0)
                }
                return
            }
            let materialColorScheme = bottomBarPreferences?.colorScheme?.asMaterialTheme() ?? MaterialTheme.colorScheme
            MaterialTheme(colorScheme: materialColorScheme) {
                let tint = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.onSurface })
                let placement = EnvironmentValues.shared._placement
                EnvironmentValues.shared.setValues {
                    $0.set_tint(tint)
                    $0.set_placement(placement.union(ViewPlacement.toolbar))
                } in: {
                    var bottomBarModifier = Modifier.zIndex(Float(1.1))
                        .onGloballyPositioned {
                            let bounds = $0.boundsInWindow()
                            if bounds.top > Float(0.0) { // Sometimes we see random 0 values
                                bottomBarTopPx.value = bounds.top
                                bottomBarHeightPx.value = bounds.bottom - bounds.top
                            }
                        }
                    let bottomBarBackgroundColor: androidx.compose.ui.graphics.Color
                    if bottomBarPreferences?.backgroundVisibility == Visibility.hidden {
                        bottomBarBackgroundColor = Color.clear.colorImpl()
                    } else if let background = bottomBarPreferences?.background {
                        if let color = background.asColor(opacity: 1.0, animationContext: nil) {
                            bottomBarBackgroundColor = color
                        } else {
                            bottomBarBackgroundColor = Color.clear.colorImpl()
                            if let brush = background.asBrush(opacity: 1.0, animationContext: nil) {
                                bottomBarModifier = bottomBarModifier.background(brush)
                            }
                        }
                    } else {
                        bottomBarBackgroundColor = Color.systemBarBackground.colorImpl()
                    }
                    // Pull the bottom bar below the keyboard
                    let bottomPadding = with(density) { min(bottomBarHeightPx.value, Float(WindowInsets.ime.getBottom(density))).toDp() }
                    PaddingLayout(padding: EdgeInsets(top: 0.0, leading: 0.0, bottom: Double(-bottomPadding.value), trailing: 0.0), context: context.content()) { context in
                        BottomAppBar(modifier: context.modifier.then(bottomBarModifier),
                                 containerColor: bottomBarBackgroundColor,
                                 contentPadding: PaddingValues.Absolute(left: 16.dp, right: 16.dp),
                                     windowInsets = WindowInsets(bottom: 0.dp)) {
                            // Use an HStack so that it sets up the environment for bottom toolbar Spacers
                            HStack(spacing: 24.0) {
                                ComposeBuilder { itemContext in
                                    bottomItems.forEach { $0.Compose(context: itemContext) }
                                    return ComposeResult.ok
                                }
                            }.Compose(context)
                        }
                    }
                }
            }
        }

        // We place nav bars within each entry rather than at the navigation controller level. There isn't a fluid animation
        // between navigation bar states on Android, and it is simpler to only hoist navigation bar preferences to this level
        Column(modifier: modifier.background(Color.background.colorImpl())) {
            // Calculate safe area for content
            let contentSafeArea = arguments.safeArea?
                .insetting(.top, to: topBarBottomPx.value)
                .insetting(.bottom, to: bottomBarTopPx.value)
            // Inset manually for any edge where our container ignored the safe area, but we aren't showing a bar
            let topPadding = topBarBottomPx.value <= Float(0.0) && arguments.ignoresSafeAreaEdges.contains(.top) ? WindowInsets.safeDrawing.asPaddingValues().calculateTopPadding() : 0.dp
            var bottomPadding = 0.dp
            if bottomBarTopPx.value <= Float(0.0) && arguments.ignoresSafeAreaEdges.contains(.bottom) {
                bottomPadding = max(0.dp, WindowInsets.safeDrawing.asPaddingValues().calculateBottomPadding() - WindowInsets.ime.asPaddingValues().calculateBottomPadding())
            }
            let contentModifier = Modifier.fillMaxWidth().weight(Float(1.0)).padding(top: topPadding, bottom: bottomPadding)

            topBar()
            Box(modifier: contentModifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
                var topPadding = 0.dp
                let searchableState: SearchableState? = arguments.isRoot ? (EnvironmentValues.shared._searchableState ?? searchableStatePreference.value.reduced) : nil
                if let searchableState {
                    let searchFieldModifier = Modifier.height(searchFieldHeight.dp + searchFieldPadding).align(androidx.compose.ui.Alignment.TopCenter).offset({ IntOffset(0, Int(searchFieldOffsetPx.value)) }).background(topBarBackgroundColor).padding(start: searchFieldPadding, bottom: searchFieldPadding, end: searchFieldPadding).fillMaxWidth()
                    SearchField(state: searchableState, context: context.content(modifier: searchFieldModifier))
                    let searchFieldPlaceholderPadding = searchFieldHeight.dp + searchFieldPadding + (with(LocalDensity.current) { searchFieldOffsetPx.value.toDp() })
                    topPadding = searchFieldPlaceholderPadding
                }
                EnvironmentValues.shared.setValues {
                    if let contentSafeArea {
                        $0.set_safeArea(contentSafeArea)
                    }
                    if arguments.isRoot {
                        $0.set_searchableState(searchableState)
                    }
                } in: {
                    // Elevate the top padding modifier so that content always has the same context, allowing it to avoid recomposition
                    Box(modifier: Modifier.padding(top: topPadding)) {
                        PreferenceValues.shared.collectPreferences([searchableStateCollector, scrollToTopCollector]) {
                            content(context.content())
                        }
                    }
                }
            }
            bottomBar()
        }
    }

    @Composable private func ComposeDestination(_ destination: ((Any) -> View)?, arguments: NavigationDestinationArguments, context: ComposeContext) {
        // Break out this function to give it stable arguments and avoid recomosition on push/pop
        destination?(arguments.targetValue).Compose(context: context)
    }

    @Composable private func useInlineTitleDisplayMode(for titleDisplayMode: ToolbarTitleDisplayMode, safeArea: SafeArea?) -> Bool {
        guard titleDisplayMode == .automatic else {
            return titleDisplayMode == ToolbarTitleDisplayMode.inline
        }
        // Default to inline if in landscape or a sheet
        if let safeArea, safeArea.presentationBoundsPx.width > safeArea.presentationBoundsPx.height {
            return true
        }
        return EnvironmentValues.shared._sheetDepth > 0
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
@Stable struct NavigationEntryArguments: Equatable {
    let isRoot: Bool
    let state: Navigator.BackStackState
    let safeArea: SafeArea?
    let ignoresSafeAreaEdges: Edge.Set
    let title: Text
    let toolbarPreferences: ToolbarPreferences
}

@Stable struct NavigationDestinationArguments: Equatable {
    let targetValue: Any
}

typealias NavigationDestinations = Dictionary<Any.Type, NavigationDestination>
struct NavigationDestination {
    let destination: (Any) -> any View
    // No way to compare closures. Assume equal so we don't think our destinations are constantly updating
    public override func equals(other: Any?) -> Bool {
        return true
    }
}

// SKIP INSERT: @OptIn(ExperimentalComposeUiApi::class)
@Stable final class Navigator {
    /// Route for the root of the navigation stack.
    static let rootRoute = "navigationroot"

    /// Number of possible destiation routes.
    ///
    /// We route to destinations by static index rather than a dynamic system based on the provided destination
    /// keys because changing the destinations of a `NavHost` wipes out its back stack. By using a fixed set of
    /// indexes, we can maintain the back stack even as we add destination mappings.
    static let destinationCount = 100

    /// Route for the given destination index and value string.
    static func route(for destinationIndex: Int, valueString: String) -> String {
        return String(describing: destinationIndex) + "/" + valueString
    }

    private var navController: NavHostController
    private var keyboardController: SoftwareKeyboardController?
    private var destinations: NavigationDestinations
    private var destinationIndexes: [Any.Type: Int] = [:]

    // We reserve the last destination index for static destinations. Every time we navigate to a static destination view, we increment the
    // destination value to give it a unique navigation path of e.g. 99/0, 99/1, 99/2, etc
    private let viewDestinationIndex = Self.destinationCount - 1
    private var viewDestinationValue = 0

    private var path: Binding<[Any]>?
    private var navigationPath: Binding<NavigationPath>?

    private var backStackState: [String: BackStackState] = [:]
    final class BackStackState {
        let id: String
        let route: String
        let destination: ((Any) -> any View)?
        let targetValue: Any?
        let stateSaver: ComposeStateSaver
        var titleDisplayMode: ToolbarTitleDisplayMode?

        init(id: String, route: String, destination: ((Any) -> any View)? = nil, targetValue: Any? = nil, stateSaver: ComposeStateSaver = ComposeStateSaver()) {
            self.id = id
            self.route = route
            self.destination = destination
            self.targetValue = targetValue
            self.stateSaver = stateSaver
        }
    }

    init(navController: NavHostController, destinations: NavigationDestinations) {
        self.navController = navController
        self.destinations = destinations
        updateDestinationIndexes()
    }

    /// Call with updated state on recompose.
    @Composable func didCompose(navController: NavHostController, destinations: NavigationDestinations, path: Binding<[Any]>?, navigationPath: Binding<NavigationPath>?, keyboardController: SoftwareKeyboardController?) {
        self.navController = navController
        self.destinations = destinations
        self.path = path
        self.navigationPath = navigationPath
        self.keyboardController = keyboardController
        updateDestinationIndexes()
        syncState()
        navigateToPath()
    }

    /// Whether we're at the root of the navigation stack.
    var isRoot: Bool {
        return navController.currentBackStack.value.size <= 2 // graph entry, root entry
    }

    /// Navigate to a target value specified in a `NavigationLink`.
    func navigate(to targetValue: Any) {
        if let path {
            path.wrappedValue.append(targetValue)
        } else if let navigationPath {
            navigationPath.wrappedValue.append(targetValue)
        } else {
            let _ = navigate(to: targetValue, type: type(of: targetValue))
        }
    }

    /// Navigate to a destination view.
    func navigateToView(_ view: any View) {
        let targetValue = viewDestinationValue
        viewDestinationValue += 1

        let route = Self.route(for: viewDestinationIndex, valueString: String(describing: targetValue))
        navigate(route: route, destination: { _ in view }, targetValue: targetValue)
    }

    /// Pop the back stack.
    func navigateBack() {
        if let path {
            path.wrappedValue.popLast()
        } else if let navigationPath {
            navigationPath.wrappedValue.removeLast()
        } else if !isRoot {
            navController.popBackStack()
        }
    }

    /// The entry being navigated to.
    func state(for entry: NavBackStackEntry) -> BackStackState? {
        if let state = backStackState[entry.id] {
            return state
        }
        // Need to establish the root state?
        guard navController.currentBackStack.value.count() > 1 && entry.id == navController.currentBackStack.value[1].id else {
            return nil
        }
        let rootState = BackStackState(id: entry.id, route: Self.rootRoute)
        backStackState[entry.id] = rootState
        return rootState
    }

    /// The effective title display mode for the given preference value.
    func titleDisplayMode(for state: BackStackState, preference: ToolbarTitleDisplayMode?) -> ToolbarTitleDisplayMode {
        if let preference {
            state.titleDisplayMode = preference
            return preference
        }

        // Base the display mode on the back stack
        var titleDisplayMode: ToolbarTitleDisplayMode? = nil
        for entry in navController.currentBackStack.value {
            if entry.id == state.id {
                break
            } else if let entryTitleDisplayMode = backStackState[entry.id]?.titleDisplayMode {
                titleDisplayMode = entryTitleDisplayMode
            }
        }
        return titleDisplayMode ?? ToolbarTitleDisplayMode.automatic
    }

    /// Sync our back stack state with the nav controller.
    @Composable private func syncState() {
        // Collect as state to ensure we get re-called on change
        let entryList = navController.currentBackStack.collectAsState()
        // Sync the back stack with remaining states. We delay this to allow views that receive compose calls while animating away to find their state
        LaunchedEffect(entryList.value) {
            delay(1000) // 1 second
            var syncedBackStackState: [String: BackStackState] = [:]
            for entry in entryList.value {
                if let state = backStackState[entry.id] {
                    syncedBackStackState[entry.id] = state
                }
            }
            backStackState = syncedBackStackState
        }
    }

    private func navigateToPath() {
        guard let path = (self.path?.wrappedValue ?? navigationPath?.wrappedValue.path) else {
            return
        }
        let backStack = navController.currentBackStack.value
        guard !backStack.isEmpty() else {
            return
        }

        // Figure out where the path and back stack first differ
        var pathIndex = 0
        var backStackIndex = 2 // graph, root
        while pathIndex < path.count {
            if backStackIndex >= backStack.count() {
                break
            }
            let state = backStackState[backStack[backStackIndex].id]
            if state?.targetValue != path[pathIndex] {
                break
            }
            pathIndex += 1
            backStackIndex += 1
        }
        // Pop back to last common value
        for _ in 0..<(backStack.count() - backStackIndex) {
            navController.popBackStack()
        }
        // Navigate to any new path values
        for i in pathIndex..<path.count {
            let _ = navigate(to: path[i], type: type(of: path[i]))
        }
    }

    private func navigate(to targetValue: Any, type: Any.Type?) -> Bool {
        guard let type else {
            return false
        }
        guard let destination = destinations[type] else {
            for supertype in type.superclasses {
                if navigate(to: targetValue, type: supertype as? Any.Type) {
                    return true
                }
            }
            return false
        }

        let route = route(for: type, value: targetValue)
        navigate(route: route, destination: destination.destination, targetValue: targetValue)
        return true
    }

    private func navigate(route: String, destination: ((Any) -> any View)?, targetValue: Any) {
        // We see a top app bar glitch when the keyboard animates away after push, so manually dismiss it first
        keyboardController?.hide()
        navController.navigate(route)
        if let entry = navController.currentBackStackEntry, backStackState[entry.id] == nil {
            backStackState[entry.id] = BackStackState(id: entry.id, route: route, destination: destination, targetValue: targetValue)
        }
    }

    private func route(for targetType: Any.Type, value: Any) -> String {
        guard let index = destinationIndexes[targetType] else {
            return String(describing: targetType) + "?"
        }
        // Escape '/' because it is meaningful in navigation routes
        var valueString = composeBundleString(for: value)
        valueString = valueString.replacingOccurrences(of: "/", with: "%2F")
        return route(for: index, valueString: valueString)
    }

    private func updateDestinationIndexes() {
        for type in destinations.keys {
            if destinationIndexes[type] == nil {
                destinationIndexes[type] = destinationIndexes.count
            }
        }
    }
}

let LocalNavigator: ProvidableCompositionLocal<Navigator?> = compositionLocalOf { nil as Navigator? }
#endif

public struct NavigationSplitViewStyle: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static var automatic = NavigationSplitViewStyle(rawValue: 0)
    public static var balanced = NavigationSplitViewStyle(rawValue: 1)
    public static var prominentDetail = NavigationSplitViewStyle(rawValue: 2)
}

public struct NavigationBarItem : Hashable, Sendable {
    public enum TitleDisplayMode : Equatable, Sendable {
        case automatic
        case inline
        case large
    }
}

extension View {
    public func navigationBarBackButtonHidden(_ hidesBackButton: Bool = true) -> some View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(backButtonHidden: hidesBackButton))
        #else
        return self
        #endif
    }

    public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        #if SKIP
        let toolbarTitleDisplayMode: ToolbarTitleDisplayMode
        switch displayMode {
        case .automatic:
            toolbarTitleDisplayMode = .automatic
        case .inline:
            toolbarTitleDisplayMode = .inline
        case .large:
            toolbarTitleDisplayMode = .large
        }
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(titleDisplayMode: toolbarTitleDisplayMode))
        #else
        return self
        #endif
    }

    public func navigationDestination<D>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> any View) -> some View where D: Any {
        #if SKIP
        let destinations: NavigationDestinations = [data: NavigationDestination(destination: { destination($0 as! D) })]
        return preference(key: NavigationDestinationsPreferenceKey.self, value: destinations)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func navigationDestination<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V : View {
        return self
    }

    @available(*, unavailable)
    public func navigationDestination<D, C>(item: Binding<D?>, @ViewBuilder destination: @escaping (D) -> any View) -> some View where D : Hashable {
        return self
    }

    @available(*, unavailable)
    public func navigationDocument(_ url: URL) -> some View {
        return self
    }

    @available(*, unavailable)
    public func navigationSplitViewColumnWidth(_ width: CGFloat) -> some View {
        return self
    }

    @available(*, unavailable)
    public func navigationSplitViewColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View {
        return self
    }

    @available(*, unavailable)
    public func navigationSplitViewStyle(_ style: NavigationSplitViewStyle) -> some View {
        return self
    }

    public func navigationTitle(_ title: Text) -> some View {
        #if SKIP
        return preference(key: NavigationTitlePreferenceKey.self, value: title)
        #else
        return self
        #endif
    }

    public func navigationTitle(_ title: LocalizedStringKey) -> some View {
        #if SKIP
        return preference(key: NavigationTitlePreferenceKey.self, value: Text(title))
        #else
        return self
        #endif
    }

    public func navigationTitle(_ title: String) -> some View {
        #if SKIP
        return preference(key: NavigationTitlePreferenceKey.self, value: Text(verbatim: title))
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func navigationTitle(_ title: Binding<String>) -> some View {
        return self
    }
}

#if SKIP
struct NavigationDestinationsPreferenceKey: PreferenceKey {
    typealias Value = NavigationDestinations

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<NavigationDestinations>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue: NavigationDestinations = [:]
        func reduce(value: inout NavigationDestinations, nextValue: () -> NavigationDestinations) {
            for (type, destination) in nextValue() {
                value[type] = destination
            }
        }
    }
}

struct NavigationTitlePreferenceKey: PreferenceKey {
    typealias Value = Text

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<Text>
    final class Companion: PreferenceKeyCompanion {
        let defaultValue = Text("")
        func reduce(value: inout Text, nextValue: () -> Text) {
            value = nextValue()
        }
    }
}
#endif

public struct NavigationLink : View, ListItemAdapting {
    let value: Any?
    let destination: ComposeBuilder?
    let label: ComposeBuilder

    private static let minimumNavigationInterval = 0.35
    private static var lastNavigationTime = 0.0

    public init(value: Any?, @ViewBuilder label: () -> any View) {
        self.value = value
        self.destination = nil
        self.label = ComposeBuilder.from(label)
    }

    public init(_ title: String, value: Any?) {
        self.init(value: value, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, value: Any?) {
        self.init(value: value, label: { Text(titleKey) })
    }

    public init(@ViewBuilder destination: () -> any View, @ViewBuilder label: () -> any View) {
        self.value = nil
        self.destination = ComposeBuilder.from(destination)
        self.label = ComposeBuilder.from(label)
    }

    public init(destination: any View, @ViewBuilder label: () -> any View) {
        self.init(destination: { destination }, label: label)
    }

    public init(_ titleKey: LocalizedStringKey, @ViewBuilder destination: () -> any View) {
        self.init(destination: destination, label: { Text(titleKey) })
    }

    public init(_ title: String, @ViewBuilder destination: () -> any View) {
        self.init(destination: destination, label: { Text(verbatim: title) })
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        Button.ComposeButton(label: label, context: context, isEnabled: isNavigationEnabled(), action: navigationAction())
    }

    @Composable func shouldComposeListItem() -> Bool {
        let buttonStyle = EnvironmentValues.shared._buttonStyle
        return buttonStyle == nil || buttonStyle == .automatic || buttonStyle == .plain
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        let isEnabled = isNavigationEnabled()
        let modifier = Modifier.clickable(onClick: navigationAction(), enabled: isEnabled).then(contentModifier)
        Row(modifier: modifier, horizontalArrangement: Arrangement.spacedBy(8.dp), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            Box(modifier: Modifier.weight(Float(1.0))) {
                // Continue to specialize for list rendering within the content (e.g. Label)
                label.Compose(context: context.content(composer: ListItemComposer(contentModifier: Modifier)))
            }
            Self.ComposeChevron()
        }
    }

    @Composable static func ComposeChevron() {
        let isRTL = EnvironmentValues.shared.layoutDirection == .rightToLeft
        Icon(imageVector: isRTL ? Icons.Outlined.KeyboardArrowLeft : Icons.Outlined.KeyboardArrowRight, contentDescription: nil, tint: androidx.compose.ui.graphics.Color.Gray)
    }

    @Composable private func isNavigationEnabled() -> Bool {
        return (value != nil || destination != nil) && EnvironmentValues.shared.isEnabled
    }

    @Composable private func navigationAction() -> () -> Void {
        let navigator = LocalNavigator.current
        return {
            // Hack to prevent multiple quick taps from pushing duplicate entries
            let now = CFAbsoluteTimeGetCurrent()
            guard NavigationLink.lastNavigationTime + NavigationLink.minimumNavigationInterval <= now else {
                return
            }
            NavigationLink.lastNavigationTime = now

            if let value {
                navigator?.navigate(to: value)
            } else if let destination {
                navigator?.navigateToView(destination)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public struct NavigationPath: Equatable {
    var path: [Any] = []

    public init() {
    }

    public init(_ elements: any Sequence) {
        #if SKIP
        path.append(contentsOf: elements as! Sequence<Any>)
        #endif
    }

    @available(*, unavailable)
    public init(_ codable: NavigationPath.CodableRepresentation) {
    }

    public var count: Int {
        return path.count
    }

    public var isEmpty: Bool {
        return path.isEmpty
    }

    @available(*, unavailable)
    public var codable: NavigationPath.CodableRepresentation? {
        fatalError()
    }

    public mutating func append(_ value: Any) {
        path.append(value)
    }

    public mutating func removeLast(_ k: Int = 1) {
        path.removeLast(k)
    }

    public static func ==(lhs: NavigationPath, rhs: NavigationPath) -> Bool {
        #if SKIP
        return lhs.path == rhs.path
        #else
        return false
        #endif
    }

    public struct CodableRepresentation : Codable {
        public init(from decoder: Decoder) throws {
        }

        public func encode(to encoder: Encoder) throws {
        }
    }
}

#if false

// TODO: Process for use in SkipUI

import struct CoreGraphics.CGFloat
import struct Foundation.URL

@available(iOS 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension NavigationLink {

    /// Sets the navigation link to present its destination as the detail
    /// component of the containing navigation view.
    ///
    /// This method sets the behavior when the navigation link is used in a
    /// ``NavigationSplitView``, or a
    /// multi-column navigation view, such as one using
    /// ``ColumnNavigationViewStyle``.
    ///
    /// For example, in a two-column navigation split view, if `isDetailLink` is
    /// `true`, triggering the link in the sidebar column sets the contents of
    /// the detail column to be the link's destination view. If `isDetailLink`
    /// is `false`, the link navigates to the destination view within the
    /// primary column.
    ///
    /// If you do not set the detail link behavior with this method, the
    /// behavior defaults to `true`.
    ///
    /// The `isDetailLink` modifier only affects view-destination links. Links
    /// that present data values always search for a matching navigation
    /// destination beginning in the column that contains the link.
    ///
    /// - Parameter isDetailLink: A Boolean value that specifies whether this
    /// link presents its destination as the detail component when used in a
    /// multi-column navigation view.
    /// - Returns: A view that applies the specified detail link behavior.
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func isDetailLink(_ isDetailLink: Bool) -> some View { return stubView() }

}

/// A view that presents views in two or three columns, where selections in
/// leading columns control presentations in subsequent columns.
///
/// You create a navigation split view with two or three columns, and typically
/// use it as the root view in a ``Scene``. People choose one or more
/// items in a leading column to display details about those items in
/// subsequent columns.
///
/// To create a two-column navigation split view, use the
/// ``init(sidebar:detail:)`` initializer:
///
///     @State private var employeeIds: Set<Employee.ID> = []
///
///     var body: some View {
///         NavigationSplitView {
///             List(model.employees, selection: $employeeIds) { employee in
///                 Text(employee.name)
///             }
///         } detail: {
///             EmployeeDetails(for: employeeIds)
///         }
///     }
///
/// In the above example, the navigation split view coordinates with the
/// ``List`` in its first column, so that when people make a selection, the
/// detail view updates accordingly. Programmatic changes that you make to the
/// selection property also affect both the list appearance and the presented
/// detail view.
///
/// To create a three-column view, use the ``init(sidebar:content:detail:)``
/// initializer. The selection in the first column affects the second, and the
/// selection in the second column affects the third. For example, you can show
/// a list of departments, the list of employees in the selected department,
/// and the details about all of the selected employees:
///
///     @State private var departmentId: Department.ID? // Single selection.
///     @State private var employeeIds: Set<Employee.ID> = [] // Multiple selection.
///
///     var body: some View {
///         NavigationSplitView {
///             List(model.departments, selection: $departmentId) { department in
///                 Text(department.name)
///             }
///         } content: {
///             if let department = model.department(id: departmentId) {
///                 List(department.employees, selection: $employeeIds) { employee in
///                     Text(employee.name)
///                 }
///             } else {
///                 Text("Select a department")
///             }
///         } detail: {
///             EmployeeDetails(for: employeeIds)
///         }
///     }
///
/// You can also embed a ``NavigationStack`` in a column. Tapping or clicking a
/// ``NavigationLink`` that appears in an earlier column sets the view that the
/// stack displays over its root view. Activating a link in the same column
/// adds a view to the stack. Either way, the link must present a data type
/// for which the stack has a corresponding
/// ``View/navigationDestination(for:destination:)`` modifier.
///
/// On watchOS and tvOS, and with narrow sizes like on iPhone or on iPad in
/// Slide Over, the navigation split view collapses all of its columns
/// into a stack, and shows the last column that displays useful information.
/// For example, the three-column example above shows the list of departments to
/// start, the employees in the department after someone selects a department,
/// and the employee details when someone selects an employee. For rows in a
/// list that have ``NavigationLink`` instances, the list draws disclosure
/// chevrons while in the collapsed state.
///
/// ### Control column visibility
///
/// You can programmatically control the visibility of navigation split view
/// columns by creating a ``State`` value of type
/// ``NavigationSplitViewVisibility``. Then pass a ``Binding`` to that state to
/// the appropriate initializer --- such as
/// ``init(columnVisibility:sidebar:detail:)`` for two columns, or
/// the ``init(columnVisibility:sidebar:content:detail:)`` for three columns.
///
/// The following code updates the first example above to always hide the
/// first column when the view appears:
///
///     @State private var employeeIds: Set<Employee.ID> = []
///     @State private var columnVisibility =
///         NavigationSplitViewVisibility.detailOnly
///
///     var body: some View {
///         NavigationSplitView(columnVisibility: $columnVisibility) {
///             List(model.employees, selection: $employeeIds) { employee in
///                 Text(employee.name)
///             }
///         } detail: {
///             EmployeeDetails(for: employeeIds)
///         }
///     }
///
/// The split view ignores the visibility control when it collapses its columns
/// into a stack.
///
/// ### Collapsed split views
///
/// At narrow size classes, such as on iPhone or Apple Watch, a navigation split
/// view collapses into a single stack. Typically SkipUI automatically chooses
/// the view to show on top of this single stack, based on the content of the
/// split view's columns.
///
/// For custom navigation experiences, you can provide more information to help
/// SkipUI choose the right column. Create a `State` value of type
/// ``NavigationSplitViewColumn``. Then pass a `Binding` to that state to the
/// appropriate initializer, such as
/// ``init(preferredCompactColumn:sidebar:detail:)`` or
/// ``init(preferredCompactColumn:sidebar:content:detail:)``.
///
/// The following code shows the blue detail view when run on iPhone. When the
/// person using the app taps the back button, they'll see the yellow view. The
/// value of `preferredPreferredCompactColumn` will change from `.detail` to
/// `.sidebar`:
///
///     @State private var preferredColumn =
///         NavigationSplitViewColumn.detail
///
///     var body: some View {
///         NavigationSplitView(preferredCompactColumn: $preferredColumn) {
///             Color.yellow
///         } detail: {
///             Color.blue
///         }
///     }
///
/// ### Customize a split view
///
/// To specify a preferred column width in a navigation split view, use the
/// ``View/navigationSplitViewColumnWidth(_:)`` modifier. To set minimum,
/// maximum, and ideal sizes for a column, use
/// ``View/navigationSplitViewColumnWidth(min:ideal:max:)``. You can specify a
/// different modifier in each column. The navigation split view does its
/// best to accommodate the preferences that you specify, but might make
/// adjustments based on other constraints.
///
/// To specify how columns in a navigation split view interact, use the
/// ``View/navigationSplitViewStyle(_:)`` modifier with a
/// ``NavigationSplitViewStyle`` value. For example, you can specify
/// whether to emphasize the detail column or to give all of the columns equal
/// prominence.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct NavigationSplitView<Sidebar, Content, Detail> : View where Sidebar : View, Content : View, Detail : View {

    /// Creates a three-column navigation split view.
    ///
    /// - Parameters:
    ///   - sidebar: The view to show in the leading column.
    ///   - content: The view to show in the middle column.
    ///   - detail: The view to show in the detail area.
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) { fatalError() }

    /// Creates a three-column navigation split view that enables programmatic
    /// control of leading columns' visibility.
    ///
    /// - Parameters:
    ///   - columnVisibility: A ``Binding`` to state that controls the
    ///     visibility of the leading columns.
    ///   - sidebar: The view to show in the leading column.
    ///   - content: The view to show in the middle column.
    ///   - detail: The view to show in the detail area.
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) { fatalError() }

    /// Creates a two-column navigation split view.
    ///
    /// - Parameters:
    ///   - sidebar: The view to show in the leading column.
    ///   - detail: The view to show in the detail area.
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView { fatalError() }

    /// Creates a two-column navigation split view that enables programmatic
    /// control of the sidebar's visibility.
    ///
    /// - Parameters:
    ///   - columnVisibility: A ``Binding`` to state that controls the
    ///     visibility of the leading column.
    ///   - sidebar: The view to show in the leading column.
    ///   - detail: The view to show in the detail area.
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView { fatalError() }

    @MainActor public var body: some View { get { return stubView() } }

//    public typealias Body = some View
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension NavigationSplitView {

    /// Creates a three-column navigation split view that enables programmatic
    /// control over which column appears on top when the view collapses into a
    /// single column in narrow sizes.
    ///
    /// - Parameters:
    ///   - preferredCompactColumn: A ``Binding`` to state that controls which
    ///     column appears on top when the view collapses.
    ///   - sidebar: The view to show in the leading column.
    ///   - content: The view to show in the middle column.
    ///   - detail: The view to show in the detail area.
    public init(preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) { fatalError() }

    /// Creates a three-column navigation split view that enables programmatic
    /// control of leading columns' visibility in regular sizes and which column
    /// appears on top when the view collapses into a single column in narrow
    /// sizes.
    ///
    /// - Parameters:
    ///   - columnVisibility: A ``Binding`` to state that controls the
    ///     visibility of the leading columns.
    ///   - preferredCompactColumn: A ``Binding`` to state that controls which
    ///     column appears on top when the view collapses.
    ///   - sidebar: The view to show in the leading column.
    ///   - content: The view to show in the middle column.
    ///   - detail: The view to show in the detail area.
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder content: () -> Content, @ViewBuilder detail: () -> Detail) { fatalError() }

    /// Creates a two-column navigation split view that enables programmatic
    /// control over which column appears on top when the view collapses into a
    /// single column in narrow sizes.
    ///
    /// - Parameters:
    ///   - preferredCompactColumn: A ``Binding`` to state that controls which
    ///     column appears on top when the view collapses.
    ///   - sidebar: The view to show in the leading column.
    ///   - detail: The view to show in the detail area.
    public init(preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView { fatalError() }

    /// Creates a two-column navigation split view that enables programmatic
    /// control of the sidebar's visibility in regular sizes and which column
    /// appears on top when the view collapses into a single column in narrow
    /// sizes.
    ///
    /// - Parameters:
    ///   - columnVisibility: A ``Binding`` to state that controls the
    ///     visibility of the leading column.
    ///   - preferredCompactColumn: A ``Binding`` to state that controls which
    ///     column appears on top when the view collapses.
    ///   - sidebar: The view to show in the leading column.
    ///   - detail: The view to show in the detail area.
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>, preferredCompactColumn: Binding<NavigationSplitViewColumn>, @ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) where Content == EmptyView { fatalError() }
}

/// A view that represents a column in a navigation split view.
///
/// A ``NavigationSplitView`` collapses into a single stack in some contexts,
/// like on iPhone or Apple Watch. Use this type with the
/// `preferredCompactColumn` parameter to control which column of the navigation
/// split view appears on top of the collapsed stack.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct NavigationSplitViewColumn : Hashable, Sendable {

    public static var sidebar: NavigationSplitViewColumn { get { fatalError() } }

    public static var content: NavigationSplitViewColumn { get { fatalError() } }

    public static var detail: NavigationSplitViewColumn { get { fatalError() } }
}

/// The properties of a navigation split view instance.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct NavigationSplitViewStyleConfiguration {
}

/// The visibility of the leading columns in a navigation split view.
///
/// Use a value of this type to control the visibility of the columns of a
/// ``NavigationSplitView``. Create a ``State`` property with a
/// value of this type, and pass a ``Binding`` to that state to the
/// ``NavigationSplitView/init(columnVisibility:sidebar:detail:)`` or
/// ``NavigationSplitView/init(columnVisibility:sidebar:content:detail:)``
/// initializer when you create the navigation split view. You can then
/// modify the value elsewhere in your code to:
///
/// * Hide all but the trailing column with ``detailOnly``.
/// * Hide the leading column of a three-column navigation split view
///   with ``doubleColumn``.
/// * Show all the columns with ``all``.
/// * Rely on the automatic behavior for the current context with ``automatic``.
///
/// >Note: Some platforms don't respect every option. For example, macOS always
/// displays the content column.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct NavigationSplitViewVisibility : Equatable, Codable, Sendable {

    /// Hide the leading two columns of a three-column navigation split view, so
    /// that just the detail area shows.
    public static var detailOnly: NavigationSplitViewVisibility { get { fatalError() } }

    /// Show the content column and detail area of a three-column navigation
    /// split view, or the sidebar column and detail area of a two-column
    /// navigation split view.
    ///
    /// For a two-column navigation split view, `doubleColumn` is equivalent
    /// to `all`.
    public static var doubleColumn: NavigationSplitViewVisibility { get { fatalError() } }

    /// Show all the columns of a three-column navigation split view.
    public static var all: NavigationSplitViewVisibility { get { fatalError() } }

    /// Use the default leading column visibility for the current device.
    ///
    /// This computed property returns one of the three concrete cases:
    /// ``detailOnly``, ``doubleColumn``, or ``all``.
    public static var automatic: NavigationSplitViewVisibility { get { fatalError() } }

    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws { fatalError() }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: Decoder) throws { fatalError() }
}

#endif
