// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
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
import androidx.compose.material3.BottomAppBarDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MediumTopAppBar
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.LargeTopAppBar
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarColors
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.TopAppBarScrollBehavior
import androidx.compose.material3.contentColorFor
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
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.platform.SoftwareKeyboardController
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
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

// SKIP @bridge
public struct NavigationStack : View {
    let root: ComposeBuilder
    let path: Binding<[Any]>?
    let navigationPath: Binding<NavigationPath>?
    let destinationKeyTransformer: ((Any) -> String)?

    public init(@ViewBuilder root: () -> any View) {
        self.root = ComposeBuilder.from(root)
        self.path = nil
        self.navigationPath = nil
        self.destinationKeyTransformer = nil
    }

    public init(path: Binding<NavigationPath>, @ViewBuilder root: () -> any View) {
        self.root = ComposeBuilder.from(root)
        self.path = nil
        self.navigationPath = path
        self.destinationKeyTransformer = nil
    }

    public init(path: Any, @ViewBuilder root: () -> any View) {
        self.root = ComposeBuilder.from(root)
        self.path = path as! Binding<[Any]>?
        self.navigationPath = nil
        self.destinationKeyTransformer = nil
    }

    // SKIP @bridge
    public init(getData: (() -> [Any])?, setData: (([Any]) -> Void)?, bridgedRoot: any View, destinationKeyTransformer: @escaping (Any) -> String) {
        self.root = ComposeBuilder.from { bridgedRoot }
        self.navigationPath = nil
        if let getData, let setData {
            self.path = Binding(get: getData, set: setData)
        } else {
            self.path = nil
        }
        self.destinationKeyTransformer = destinationKeyTransformer
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
        let navigator = rememberSaveable(stateSaver: context.stateSaver as! Saver<Navigator, Any>) { mutableStateOf(Navigator(navController: navController, destinations: reducedDestinations, destinationKeyTransformer: destinationKeyTransformer)) }
        navigator.value.didCompose(navController: navController, destinations: reducedDestinations, path: path, navigationPath: navigationPath, keyboardController: LocalSoftwareKeyboardController.current)

        // SKIP INSERT: val providedNavigator = LocalNavigator provides navigator.value
        CompositionLocalProvider(providedNavigator) {
            let safeArea = EnvironmentValues.shared._safeArea
            // We have to ignore the safe area around the entire NavHost to prevent push/pop animation issues with the system bars.
            // When we layout, only extend into safe areas that are due to system bars, not into any app chrome
            var ignoresSafeAreaEdges: Edge.Set = [.top, .bottom]
            ignoresSafeAreaEdges.formIntersection(safeArea?.absoluteSystemBarEdges ?? [])
            IgnoresSafeAreaLayout(expandInto: ignoresSafeAreaEdges) { _, _ in
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
                            let toolbarContentPreferences = rememberSaveable(stateSaver: state.stateSaver as! Saver<Preference<ToolbarContentPreferences>, Any>) { mutableStateOf(Preference<ToolbarContentPreferences>(key: ToolbarContentPreferenceKey.self)) }
                            let toolbarContentPreferencesCollector = PreferenceCollector<ToolbarContentPreferences>(key: ToolbarContentPreferenceKey.self, state: toolbarContentPreferences)
                            let arguments = NavigationEntryArguments(isRoot: true, state: state, safeArea: safeArea, ignoresSafeAreaEdges: ignoresSafeAreaEdges, title: title.value.reduced, toolbarPreferences: toolbarPreferences.value.reduced)
                            PreferenceValues.shared.collectPreferences([titleCollector, toolbarPreferencesCollector, toolbarContentPreferencesCollector, destinationsCollector]) {
                                ComposeEntry(navigator: navigator, toolbarContent: toolbarContentPreferences, arguments: arguments, context: context) { context in
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
                                let toolbarContentPreferences = rememberSaveable(stateSaver: state.stateSaver as! Saver<Preference<ToolbarContentPreferences>, Any>) { mutableStateOf(Preference<ToolbarContentPreferences>(key: ToolbarContentPreferenceKey.self)) }
                                let toolbarContentPreferencesCollector = PreferenceCollector<ToolbarContentPreferences>(key: ToolbarContentPreferenceKey.self, state: toolbarContentPreferences)
                                EnvironmentValues.shared.setValues {
                                    $0.setdismiss(DismissAction(action: { navigator.value.navigateBack() }))
                                } in: {
                                    let arguments = NavigationEntryArguments(isRoot: false, state: state, safeArea: safeArea, ignoresSafeAreaEdges: ignoresSafeAreaEdges, title: title.value.reduced, toolbarPreferences: toolbarPreferences.value.reduced)
                                    PreferenceValues.shared.collectPreferences([titleCollector, toolbarPreferencesCollector, toolbarContentPreferencesCollector, destinationsCollector]) {
                                        ComposeEntry(navigator: navigator, toolbarContent: toolbarContentPreferences, arguments: arguments, context: context) { context in
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
    @Composable private func ComposeEntry(navigator: MutableState<Navigator>, toolbarContent: MutableState<Preference<ToolbarContentPreferences>>, arguments: NavigationEntryArguments, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
        let state = arguments.state
        let context = context.content(stateSaver: state.stateSaver)

        let topBarPreferences = arguments.toolbarPreferences.navigationBar
        let topBarHidden = remember { mutableStateOf(false) }
        let bottomBarPreferences = arguments.toolbarPreferences.bottomBar
        let hasTitle = arguments.title != NavigationTitlePreferenceKey.defaultValue
        let effectiveTitleDisplayMode = navigator.value.titleDisplayMode(for: state, hasTitle: hasTitle, preference: arguments.toolbarPreferences.titleDisplayMode)
        let isInlineTitleDisplayMode = useInlineTitleDisplayMode(for: effectiveTitleDisplayMode, safeArea: arguments.safeArea)

        // We would like to only process toolbar content in our topBar/bottomBar Composables, but composing
        // custom ToolbarContent multiple times (in order to process the placement of the items in its body
        // content for each bar) prevents it from updating properly on recompose
        let toolbarItems = ToolbarItems(content: toolbarContent.value.reduced.content ?? [])
        let (topLeadingItems, topTrailingItems, bottomItems) = toolbarItems.process(context: context)

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
        if !topBarHidden.value {
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

        let isSystemBackground = topBarPreferences?.isSystemBackground == true
        let topBar: @Composable () -> Void = {
            guard topBarPreferences?.visibility != Visibility.hidden else {
                SideEffect {
                    topBarHidden.value = true
                    topBarBottomPx.value = Float(0.0)
                }
                return
            }

            guard !arguments.isRoot || hasTitle || !topLeadingItems.isEmpty || !topTrailingItems.isEmpty || topBarPreferences?.visibility == Visibility.visible else {
                SideEffect {
                    topBarHidden.value = true
                    topBarBottomPx.value = Float(0.0)
                }
                return
            }
            topBarHidden.value = false

            let isOverlapped = scrollBehavior.state.overlappedFraction > 0
            let materialColorScheme: androidx.compose.material3.ColorScheme
            if isOverlapped, let customColorScheme = topBarPreferences?.colorScheme?.asMaterialTheme() {
                materialColorScheme = customColorScheme
            } else {
                materialColorScheme = MaterialTheme.colorScheme
            }
            MaterialTheme(colorScheme: materialColorScheme) {
                let topBarBackgroundColor: androidx.compose.ui.graphics.Color
                let unscrolledTopBarBackgroundColor: androidx.compose.ui.graphics.Color
                let topBarBackgroundForBrush: ShapeStyle?
                // If there is a custom color scheme, we also always show any custom background even when unscrolled, because we can't
                // properly interpolate between the title text colors
                let topBarHasColorScheme = topBarPreferences?.colorScheme != nil
                let isSystemBackground = topBarPreferences?.isSystemBackground == true
                if topBarPreferences?.backgroundVisibility == Visibility.hidden {
                    topBarBackgroundColor = androidx.compose.ui.graphics.Color.Transparent
                    unscrolledTopBarBackgroundColor = androidx.compose.ui.graphics.Color.Transparent
                    topBarBackgroundForBrush = nil
                } else if let background = topBarPreferences?.background {
                    if let color = background.asColor(opacity: 1.0, animationContext: nil) {
                        topBarBackgroundColor = color
                        unscrolledTopBarBackgroundColor = isSystemBackground ? Color.systemBarBackground.colorImpl() : color.copy(alpha: Float(0.0))
                        topBarBackgroundForBrush = nil
                    } else {
                        unscrolledTopBarBackgroundColor = isSystemBackground ? Color.systemBarBackground.colorImpl() : androidx.compose.ui.graphics.Color.Transparent
                        topBarBackgroundColor = !topBarHasColorScheme || isOverlapped ? unscrolledTopBarBackgroundColor.copy(alpha: Float(0.0)) : unscrolledTopBarBackgroundColor
                        topBarBackgroundForBrush = background
                    }
                } else {
                    topBarBackgroundColor = Color.systemBarBackground.colorImpl()
                    unscrolledTopBarBackgroundColor = isSystemBackground ? topBarBackgroundColor : topBarBackgroundColor.copy(alpha: Float(0.0))
                    topBarBackgroundForBrush = nil
                }

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
                        .onGloballyPositionedInWindow {
                            topBarBottomPx.value = $0.bottom
                        }
                    if !topBarHasColorScheme || isOverlapped, let topBarBackgroundForBrush {
                        let opacity = topBarHasColorScheme ? 1.0 : isInlineTitleDisplayMode ? min(1.0, Double(scrollBehavior.state.overlappedFraction * 5)) : Double(scrollBehavior.state.collapsedFraction)
                        if let topBarBackgroundBrush = topBarBackgroundForBrush.asBrush(opacity: opacity, animationContext: nil) {
                            topBarModifier = topBarModifier.background(topBarBackgroundBrush)
                        }
                    }
                    let alwaysShowScrolledBackground = topBarPreferences?.backgroundVisibility == Visibility.visible
                    let topBarColors = TopAppBarDefaults.topAppBarColors(
                        containerColor: alwaysShowScrolledBackground ? topBarBackgroundColor : unscrolledTopBarBackgroundColor,
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
                    var options = Material3TopAppBarOptions(title: topBarTitle, modifier: topBarModifier, navigationIcon: topBarNavigationIcon, colors: topBarColors, scrollBehavior: scrollBehavior)
                    if let updateOptions = EnvironmentValues.shared._material3TopAppBar {
                        options = updateOptions(options)
                    }
                    if isInlineTitleDisplayMode {
                        if options.preferCenterAlignedStyle {
                            CenterAlignedTopAppBar(title: options.title, modifier: options.modifier, navigationIcon: options.navigationIcon, actions: { topBarActions() }, colors: options.colors, scrollBehavior: options.scrollBehavior)
                        } else {
                            TopAppBar(title: options.title, modifier: options.modifier, navigationIcon: options.navigationIcon, actions: { topBarActions() }, colors: options.colors, scrollBehavior: options.scrollBehavior)
                        }
                    } else {
                        // Force a larger, bold title style in the uncollapsed state by replacing the headlineSmall style the bar uses
                        let typography = MaterialTheme.typography
                        let appBarTitleStyle = typography.headlineLarge.copy(fontWeight: FontWeight.Bold)
                        let appBarTypography = typography.copy(headlineSmall: appBarTitleStyle)
                        MaterialTheme(colorScheme: MaterialTheme.colorScheme, typography: appBarTypography, shapes: MaterialTheme.shapes) {
                            if options.preferLargeStyle {
                                LargeTopAppBar(title: options.title, modifier: options.modifier, navigationIcon: options.navigationIcon, actions: { topBarActions() }, colors: options.colors, scrollBehavior: options.scrollBehavior)
                            } else {
                                MediumTopAppBar(title: options.title, modifier: options.modifier, navigationIcon: options.navigationIcon, actions: { topBarActions() }, colors: options.colors, scrollBehavior: options.scrollBehavior)
                            }
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
            guard !bottomItems.isEmpty || bottomBarPreferences?.visibility == Visibility.visible else {
                SideEffect {
                    bottomBarTopPx.value = Float(0.0)
                    bottomBarHeightPx.value = Float(0.0)
                }
                return
            }

            let showScrolledBackground = bottomBarPreferences?.backgroundVisibility == Visibility.visible || bottomBarPreferences?.scrollableState.canScrollForward == true
            let materialColorScheme: androidx.compose.material3.ColorScheme
            if showScrolledBackground, let customColorScheme = bottomBarPreferences?.colorScheme?.asMaterialTheme() {
                materialColorScheme = customColorScheme
            } else {
                materialColorScheme = MaterialTheme.colorScheme
            }
            MaterialTheme(colorScheme: materialColorScheme) {
                let bottomBarBackgroundColor: androidx.compose.ui.graphics.Color
                let unscrolledBottomBarBackgroundColor: androidx.compose.ui.graphics.Color
                let bottomBarBackgroundForBrush: ShapeStyle?
                let bottomBarHasColorScheme = bottomBarPreferences?.colorScheme != nil
                if bottomBarPreferences?.backgroundVisibility == Visibility.hidden {
                    bottomBarBackgroundColor = androidx.compose.ui.graphics.Color.Transparent
                    unscrolledBottomBarBackgroundColor = androidx.compose.ui.graphics.Color.Transparent
                    bottomBarBackgroundForBrush = nil
                } else if let background = bottomBarPreferences?.background {
                    if let color = background.asColor(opacity: 1.0, animationContext: nil) {
                        bottomBarBackgroundColor = color
                        unscrolledBottomBarBackgroundColor = isSystemBackground ? Color.systemBarBackground.colorImpl() : color.copy(alpha: Float(0.0))
                        bottomBarBackgroundForBrush = nil
                    } else {
                        unscrolledBottomBarBackgroundColor = isSystemBackground ? Color.systemBarBackground.colorImpl() : androidx.compose.ui.graphics.Color.Transparent
                        bottomBarBackgroundColor = unscrolledBottomBarBackgroundColor.copy(alpha: Float(0.0))
                        bottomBarBackgroundForBrush = background
                    }
                } else {
                    bottomBarBackgroundColor = Color.systemBarBackground.colorImpl()
                    unscrolledBottomBarBackgroundColor = isSystemBackground ? bottomBarBackgroundColor : bottomBarBackgroundColor.copy(alpha: Float(0.0))
                    bottomBarBackgroundForBrush = nil
                }

                let tint = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.onSurface })
                let placement = EnvironmentValues.shared._placement
                EnvironmentValues.shared.setValues {
                    $0.set_tint(tint)
                    $0.set_placement(placement.union(ViewPlacement.toolbar))
                } in: {
                    var bottomBarModifier = Modifier.zIndex(Float(1.1))
                        .onGloballyPositionedInWindow { bounds in
                            bottomBarTopPx.value = bounds.top
                            bottomBarHeightPx.value = bounds.bottom - bounds.top
                        }
                    if showScrolledBackground, let bottomBarBackgroundForBrush {
                        if let bottomBarBackgroundBrush = bottomBarBackgroundForBrush.asBrush(opacity: 1.0, animationContext: nil) {
                            bottomBarModifier = bottomBarModifier.background(bottomBarBackgroundBrush)
                        }
                    }
                    // Pull the bottom bar below the keyboard
                    let bottomPadding = with(density) { min(bottomBarHeightPx.value, Float(WindowInsets.ime.getBottom(density))).toDp() }
                    PaddingLayout(padding: EdgeInsets(top: 0.0, leading: 0.0, bottom: Double(-bottomPadding.value), trailing: 0.0), context: context.content()) { context in
                        let containerColor = showScrolledBackground ? bottomBarBackgroundColor : unscrolledBottomBarBackgroundColor
                        let windowInsets = EnvironmentValues.shared._isEdgeToEdge == true ? BottomAppBarDefaults.windowInsets : WindowInsets(bottom: 0.dp)
                        var options = Material3BottomAppBarOptions(modifier: context.modifier.then(bottomBarModifier), containerColor: containerColor, contentColor: MaterialTheme.colorScheme.contentColorFor(containerColor), contentPadding: PaddingValues.Absolute(left: 16.dp, right: 16.dp))
                        if let updateOptions = EnvironmentValues.shared._material3BottomAppBar {
                            options = updateOptions(options)
                        }
                        BottomAppBar(modifier: options.modifier, containerColor: options.containerColor, contentColor: options.contentColor, tonalElevation: options.tonalElevation, contentPadding: options.contentPadding, windowInsets: windowInsets) {
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
                    let searchFieldBackground = isSystemBackground ? Color.systemBarBackground.colorImpl() : androidx.compose.ui.graphics.Color.Transparent
                    let searchFieldFadeOffset = searchFieldHeightPx / 3
                    let searchFieldModifier = Modifier.height(searchFieldHeight.dp + searchFieldPadding)
                        .align(androidx.compose.ui.Alignment.TopCenter)
                        .offset({ IntOffset(0, Int(searchFieldOffsetPx.value)) })
                        .background(searchFieldBackground)
                        .padding(start: searchFieldPadding, bottom: searchFieldPadding, end: searchFieldPadding)
                        // Offset is negative. Fade out quickly as it scrolls in case it is moving up under transparent nav bar
                        .graphicsLayer { alpha = max(Float(0.0), (searchFieldFadeOffset + searchFieldOffsetPx.value) / searchFieldFadeOffset) }
                        .fillMaxWidth()
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

typealias NavigationDestinations = Dictionary<AnyHashable, NavigationDestination>
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
    private var destinationIndexes: [AnyHashable: Int] = [:]
    private var destinationKeyTransformer: ((Any) -> String)?

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
        var binding: Binding<Bool>?

        init(id: String, route: String, destination: ((Any) -> any View)? = nil, targetValue: Any? = nil, stateSaver: ComposeStateSaver = ComposeStateSaver()) {
            self.id = id
            self.route = route
            self.destination = destination
            self.targetValue = targetValue
            self.stateSaver = stateSaver
        }
    }

    init(navController: NavHostController, destinations: NavigationDestinations, destinationKeyTransformer: ((Any) -> String)?) {
        self.navController = navController
        self.destinations = destinations
        self.destinationKeyTransformer = destinationKeyTransformer
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
            navigate(toKeyed: targetValue)
        }
    }

    private func navigate(toKeyed targetValue: Any) {
        let key: AnyHashable
        if let destinationKeyTransformer {
            key = destinationKeyTransformer(targetValue)
        } else {
            key = type(of: targetValue)
        }
        let _ = navigate(toKeyed: targetValue, key: key)
    }

    /// Navigate to a destination view.
    ///
    /// - Parameter binding: Optional binding to toggle to `false` when the view is popped.
    /// - Returns: The navigation stack entry ID of the pushed view.
    func navigateToView(_ view: any View, binding: Binding<Bool>? = nil) -> String? {
        let targetValue = viewDestinationValue
        viewDestinationValue += 1

        let route = Self.route(for: viewDestinationIndex, valueString: String(describing: targetValue))
        return navigate(route: route, destination: { _ in view }, targetValue: targetValue, binding: binding)
    }

    /// Pop the back stack.
    func navigateBack() {
        // Check for a view destination before we pop our path bindings, because the user could push arbitrary views
        // that are not represented in the bound path
        let viewDestinationPrefix = Self.route(for: viewDestinationIndex, valueString: "")
        if navController.currentBackStackEntry?.destination.route?.hasPrefix(viewDestinationPrefix) == true {
            navController.popBackStack()
        } else if let path {
            path.wrappedValue.popLast()
        } else if let navigationPath {
            navigationPath.wrappedValue.removeLast()
        } else if !isRoot {
            navController.popBackStack()
        }
    }

    /// Whether the given view entry ID is presented.
    func isViewPresented(id: String, asTop: Bool = false) -> Bool {
        let stack = navController.currentBackStack.value
        guard !stack.isEmpty() else {
            return false
        }
        guard !asTop else {
            return stack.last().id == id
        }
        return stack.any { $0.id == id }
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
    func titleDisplayMode(for state: BackStackState, hasTitle: Bool, preference: ToolbarTitleDisplayMode?) -> ToolbarTitleDisplayMode {
        if let preference {
            state.titleDisplayMode = preference
            return preference
        }

        // Never add large title space when `title` and `titleDisplayMode` are unset in the current stack
        guard hasTitle else {
            return .inline
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

        // Toggle any presented bindings for popped states back to false. Do this immediately so that we don't
        // re-present views that were removed from the stack
        let entryIDs = Set(entryList.value.map { $0.id })
        for (id, state) in backStackState {
            if !entryIDs.contains(id) {
                state.binding?.wrappedValue = false
            }
        }

        // Sync the back stack with remaining states. We delay this to allow views that receive compose calls while
        // animating away to find their state
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

        // If we exhausted the path and the back stack contains only post-path views, keep them in place. This allows
        // users to have a path binding but then append arbitrary views as leaves
        var hasOnlyTrailingViews = false
        if pathIndex == path.count {
            hasOnlyTrailingViews = true
            let viewDestinationPrefix = Self.route(for: viewDestinationIndex, valueString: "")
            for i in 0..<(backStack.count() - backStackIndex) {
                if backStack[backStackIndex + i].destination.route?.hasPrefix(viewDestinationPrefix) != true {
                    hasOnlyTrailingViews = false
                    break
                }
            }
        }
        guard !hasOnlyTrailingViews else {
            return
        }

        // Pop back to last common value
        for _ in 0..<(backStack.count() - backStackIndex) {
            navController.popBackStack()
        }
        // Navigate to any new path values
        for i in pathIndex..<path.count {
            let _ = navigate(toKeyed: path[i])
        }
    }

    private func navigate(toKeyed targetValue: Any, key: AnyHashable?) -> Bool {
        guard let key else {
            return false
        }
        guard let destination = destinations[key] else {
            if let type = key as? Any.Type {
                for supertype in type.superclasses {
                    if navigate(toKeyed: targetValue, key: supertype) {
                        return true
                    }
                }
            }
            return false
        }

        let route = route(for: key, value: targetValue)
        navigate(route: route, destination: destination.destination, targetValue: targetValue)
        return true
    }

    private func navigate(route: String, destination: ((Any) -> any View)?, targetValue: Any, binding: Binding<Bool>? = nil) -> String? {
        // We see a top app bar glitch when the keyboard animates away after push, so manually dismiss it first
        keyboardController?.hide()
        navController.navigate(route)
        guard let entry = navController.currentBackStackEntry else {
            return nil
        }
        var state = backStackState[entry.id]
        if state == nil {
            state = BackStackState(id: entry.id, route: route, destination: destination, targetValue: targetValue)
            backStackState[entry.id] = state
        }
        if let binding {
            state?.binding = binding
        }
        return entry.id
    }

    private func route(for key: AnyHashable, value: Any) -> String {
        guard let index = destinationIndexes[key] else {
            return String(describing: key) + "?"
        }
        // Escape '/' because it is meaningful in navigation routes
        let valueString = composeBundleString(for: value).replacingOccurrences(of: "/", with: "%2F")
        return route(for: index, valueString: valueString)
    }

    private func updateDestinationIndexes() {
        for key in destinations.keys {
            if destinationIndexes[key] == nil {
                destinationIndexes[key] = destinationIndexes.count
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

public struct NavigationBarItem : Hashable {
    public enum TitleDisplayMode : Int, Equatable {
        case automatic = 0 // For bridging
        case inline = 1 // For bridging
        case large = 2 // For bridging
    }
}

extension View {
    // SKIP @bridge
    public func navigationBarBackButtonHidden(_ hidesBackButton: Bool = true) -> any View {
        #if SKIP
        return preference(key: ToolbarPreferenceKey.self, value: ToolbarPreferences(backButtonHidden: hidesBackButton))
        #else
        return self
        #endif
    }

    public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> any View {
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

    // SKIP @bridge
    public func navigationBarTitleDisplayMode(bridgedDisplayMode: Int) -> any View {
        return navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode(rawValue: bridgedDisplayMode) ?? NavigationBarItem.TitleDisplayMode.automatic)
    }

    public func navigationDestination<D>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> any View) -> any View where D: Any {
        #if SKIP
        let destinations: NavigationDestinations = [data: NavigationDestination(destination: { destination($0 as! D) })]
        return preference(key: NavigationDestinationsPreferenceKey.self, value: destinations)
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func navigationDestination(destinationKey: String, bridgedDestination: @escaping (Any) -> any View) -> any View {
        #if SKIP
        let destinations: NavigationDestinations = [destinationKey: NavigationDestination(destination: { bridgedDestination($0) })]
        return preference(key: NavigationDestinationsPreferenceKey.self, value: destinations)
        #else
        return self
        #endif
    }

    public func navigationDestination(isPresented: Binding<Bool>, @ViewBuilder destination: () -> any View) -> any View {
        #if SKIP
        let destinationView = ComposeBuilder.from(destination)
        return ComposeModifierView(targetView: self) { context in
            let id = rememberSaveable(stateSaver: context.stateSaver as! Saver<String?, Any>) { mutableStateOf<String?>(nil) }
            guard let navigator = LocalNavigator.current else {
                return ComposeResult.ok
            }
            if isPresented.wrappedValue {
                if id.value == nil || !navigator.isViewPresented(id: id.value!) {
                    id.value = navigator.navigateToView(destinationView, binding: isPresented)
                }
            } else {
                if let idValue = id.value, navigator.isViewPresented(id: idValue, asTop: true) {
                    navigator.navigateBack()
                }
                id.value = nil
            }
            return ComposeResult.ok
        }
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func navigationDestination(getIsPresented: @escaping () -> Bool, setIsPresented: @escaping (Bool) -> Void, bridgedDestination: any View) -> any View {
        return navigationDestination(isPresented: Binding(get: getIsPresented, set: setIsPresented), destination: { bridgedDestination })
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

    // SKIP @bridge
    public func navigationTitle(_ title: Text) -> any View {
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

    #if SKIP
    public func material3TopAppBar(_ options: @Composable (Material3TopAppBarOptions) -> Material3TopAppBarOptions) -> View {
        return environment(\._material3TopAppBar, options)
    }

    public func material3BottomAppBar(_ options: @Composable (Material3BottomAppBarOptions) -> Material3BottomAppBarOptions) -> View {
        return environment(\._material3BottomAppBar, options)
    }
    #endif
}

#if SKIP
// SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
public struct Material3TopAppBarOptions {
    public var title: @Composable () -> Void
    public var modifier: Modifier = Modifier
    public var navigationIcon: @Composable () -> Void = {}
    public var colors: TopAppBarColors
    public var scrollBehavior: TopAppBarScrollBehavior? = nil
    public var preferCenterAlignedStyle = false
    public var preferLargeStyle = false

    public func copy(
        title: @Composable () -> Void = self.title,
        modifier: Modifier = self.modifier,
        navigationIcon: @Composable () -> Void = self.navigationIcon,
        colors: TopAppBarColors = self.colors,
        scrollBehavior: TopAppBarScrollBehavior? = self.scrollBehavior,
        preferCenterAlignedStyle: Bool = self.preferCenterAlignedStyle,
        preferLargeStyle: Bool = self.preferLargeStyle
    ) -> Material3TopAppBarOptions {
        return Material3TopAppBarOptions(title: title, modifier: modifier, navigationIcon: navigationIcon, colors: colors, scrollBehavior: scrollBehavior, preferCenterAlignedStyle: preferCenterAlignedStyle, preferLargeStyle: preferLargeStyle)
    }
}

public struct Material3BottomAppBarOptions {
    public var modifier: Modifier = Modifier
    public var containerColor: androidx.compose.ui.graphics.Color
    public var contentColor: androidx.compose.ui.graphics.Color
    public var tonalElevation: Dp = BottomAppBarDefaults.ContainerElevation
    public var contentPadding: PaddingValues = BottomAppBarDefaults.ContentPadding

    public func copy(
        modifier: Modifier = self.modifier,
        containerColor: androidx.compose.ui.graphics.Color = self.containerColor,
        contentColor: androidx.compose.ui.graphics.Color = self.contentColor,
        tonalElevation: Dp = self.tonalElevation,
        contentPadding: PaddingValues = self.contentPadding
    ) -> Material3BottomAppBarOptions {
        return Material3BottomAppBarOptions(modifier: modifier, containerColor: containerColor, contentColor: contentColor, tonalElevation: tonalElevation, contentPadding: contentPadding)
    }
}

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

// SKIP @bridge
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

    // SKIP @bridge
    public init(bridgedDestination: (any View)?, value: Any?, bridgedLabel: any View) {
        self.destination = bridgedDestination == nil ? nil : ComposeBuilder.from { bridgedDestination! }
        self.value = value
        self.label = ComposeBuilder.from { bridgedLabel }
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
        Icon(imageVector: isRTL ? Icons.Outlined.KeyboardArrowLeft : Icons.Outlined.KeyboardArrowRight, contentDescription: nil, tint: MaterialTheme.colorScheme.outlineVariant)
    }

    @Composable private func isNavigationEnabled() -> Bool {
        return (value != nil || destination != nil) && EnvironmentValues.shared.isEnabled
    }

    @Composable internal func navigationAction() -> () -> Void {
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
#endif
