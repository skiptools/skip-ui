// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.material.IconButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MediumTopAppBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberTopAppBarState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.ProvidableCompositionLocal
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
import androidx.compose.ui.unit.dp
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.platform.SoftwareKeyboardController
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.IntOffset
import androidx.navigation.NavBackStackEntry
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.navArgument
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import kotlinx.coroutines.delay
#endif

public struct NavigationStack<Root> : View where Root: View {
    let root: Root

    public init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    @available(*, unavailable)
    public init(path: Any, @ViewBuilder root: () -> Root) {
        self.root = root()
    }

    #if SKIP
    // SKIP INSERT: @OptIn(ExperimentalComposeUiApi::class)
    @Composable public override func ComposeContent(context: ComposeContext) {
        let preferenceUpdates = remember { mutableStateOf(0) }
        let _ = preferenceUpdates.value // Read so that it can trigger recompose on change
        let preferencesDidChange = { preferenceUpdates.value += 1 }

        // Have to use rememberSaveable for e.g. a nav stack in each tab
        let destinations = rememberSaveable(stateSaver: context.stateSaver as! Saver<NavigationDestinations, Any>) { mutableStateOf(NavigationDestinationsPreferenceKey.defaultValue) }
        let navController = rememberNavController()
        let navigator = rememberSaveable(stateSaver: context.stateSaver as! Saver<Navigator, Any>) { mutableStateOf(Navigator(navController: navController, destinations: destinations.value)) }
        navigator.value.didCompose(navController: navController, destinations: destinations.value, keyboardController: LocalSoftwareKeyboardController.current)

        // SKIP INSERT: val providedNavigator = LocalNavigator provides navigator.value
        CompositionLocalProvider(providedNavigator) {
            ComposeContainer(modifier: context.modifier, fillWidth: true, fillHeight: true) { modifier in
                NavHost(navController: navController, startDestination: Navigator.rootRoute, modifier: modifier) {
                    composable(route: Navigator.rootRoute,
                               exitTransition: { slideOutHorizontally(targetOffsetX: { $0 * -1 / 3 }) },
                               popEnterTransition: { slideInHorizontally(initialOffsetX: { $0 * -1 / 3 }) }) { entry in
                        if let state = navigator.value.state(for: entry) {
                            let entryContext = context.content(stateSaver: state.stateSaver)
                            ComposeEntry(navController: navController, destinations: destinations, destinationsDidChange: preferencesDidChange, isRoot: true, context: entryContext) { context in
                                root.Compose(context: context)
                            }
                        }
                    }
                    for destinationIndex in 0..<Navigator.destinationCount {
                        composable(route: Navigator.route(for: destinationIndex, valueString: "{identifier}"),
                                   arguments: listOf(navArgument("identifier") { type = NavType.StringType }),
                                   enterTransition: { slideInHorizontally(initialOffsetX: { $0 }) },
                                   exitTransition: { slideOutHorizontally(targetOffsetX: { $0 * -1 / 3 }) },
                                   popEnterTransition: { slideInHorizontally(initialOffsetX: { $0 * -1 / 3 }) },
                                   popExitTransition: { slideOutHorizontally(targetOffsetX: { $0 }) }) { entry in
                            if let state = navigator.value.state(for: entry), let targetValue = state.targetValue {
                                let entryContext = context.content(stateSaver: state.stateSaver)
                                EnvironmentValues.shared.setValues {
                                    $0.setdismiss({ navController.popBackStack() })
                                } in: {
                                    ComposeEntry(navController: navController,
                                                 destinations: destinations,
                                                 destinationsDidChange: preferencesDidChange,
                                                 isRoot: false,
                                                 context: entryContext) { context in
                                        state.destination?(targetValue).Compose(context: context)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // SKIP INSERT: @OptIn(ExperimentalMaterial3Api::class)
    @Composable private func ComposeEntry(navController: NavHostController, destinations: MutableState<NavigationDestinations>, destinationsDidChange: () -> Void, isRoot: Bool, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
        let preferenceUpdates = remember { mutableStateOf(0) }
        let _ = preferenceUpdates.value // Read so that it can trigger recompose on change

        let uncomposedTitle = "__UNCOMPOSED__"
        let title = rememberSaveable(stateSaver: context.stateSaver as! Saver<String, Any>) { mutableStateOf(uncomposedTitle) }
        let backButtonHidden = rememberSaveable(stateSaver: context.stateSaver as! Saver<Bool, Any>) { mutableStateOf(false) }
        let toolbarContent = rememberSaveable(stateSaver: context.stateSaver as! Saver<[View], Any>) { mutableStateOf(Array<View>()) }
        let toolbarItems = ToolbarItems(content: toolbarContent)

        let searchFieldPadding = 16.dp
        let searchFieldHeightPx = with(LocalDensity.current) { searchFieldHeight.dp.toPx() + searchFieldPadding.toPx() }
        let searchFieldOffsetPx = rememberSaveable(stateSaver: context.stateSaver as! Saver<Float, Any>) { mutableStateOf(Float(0.0)) }
        let searchFieldScrollConnection = remember { SearchFieldScrollConnection(heightPx: searchFieldHeightPx, offsetPx: searchFieldOffsetPx) }

        let scrollBehavior = TopAppBarDefaults.exitUntilCollapsedScrollBehavior(rememberTopAppBarState())
        var modifier = Modifier.nestedScroll(searchFieldScrollConnection).nestedScroll(scrollBehavior.nestedScrollConnection).then(context.modifier)
        // Perform an invisible compose pass to gather preference information. Otherwise we may see the content render one way, then
        // immediately re-render with an updated top bar
        if title.value == uncomposedTitle {
            modifier = modifier.alpha(Float(0.0))
        }

        // We place the top bar scaffold within each entry rather than at the navigation controller level. There isn't a fluid animation
        // between navigation bar states on Android, and it is simpler to only hoist navigation bar preferences to this level
        Scaffold(
            modifier: modifier,
            topBar: {
                let topLeadingItems = toolbarItems.filterTopBarLeading()
                let topTrailingItems = toolbarItems.filterTopBarTrailing()
                guard !isRoot || !title.value.isEmpty || !topLeadingItems.isEmpty || !topTrailingItems.isEmpty else {
                    return
                }
                let tint = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.onSurface })
                EnvironmentValues.shared.setValues {
                    $0.set_tint(tint)
                } in: {
                    MediumTopAppBar(
                        colors: TopAppBarDefaults.topAppBarColors(
                            containerColor: Color.systemBarBackground.colorImpl(),
                            titleContentColor: MaterialTheme.colorScheme.onSurface
                        ), title: {
                            androidx.compose.material3.Text(title.value, maxLines: 1, overflow: TextOverflow.Ellipsis)
                        }, navigationIcon: {
                            let hasBackButton = !isRoot && !backButtonHidden.value
                            if hasBackButton || !topLeadingItems.isEmpty {
                                let toolbarItemContext = context.content(modifier: Modifier.padding(start: 12.dp, end: 12.dp))
                                Row(verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                                    if hasBackButton {
                                        IconButton(onClick: { navController.popBackStack() }) {
                                            Icon(imageVector: Icons.Filled.ArrowBack, contentDescription: "Back", tint: tint.colorImpl())
                                        }
                                    }
                                    topLeadingItems.forEach { $0.Compose(context: toolbarItemContext) }
                                }
                            }
                        }, actions: {
                            let toolbarItemContext = context.content(modifier: Modifier.padding(start: 12.dp, end: 12.dp))
                            topTrailingItems.forEach { $0.Compose(context: toolbarItemContext) }
                        },
                        scrollBehavior: scrollBehavior
                    )
                }
            }, bottomBar: {
                let bottomItems = toolbarItems.filterBottomBar()
                if !bottomItems.isEmpty {
                    let tint = EnvironmentValues.shared._tint ?? Color(colorImpl: { MaterialTheme.colorScheme.onSurface })
                    EnvironmentValues.shared.setValues {
                        $0.set_tint(tint)
                    } in: {
                        BottomAppBar(
                            containerColor: Color.systemBarBackground.colorImpl(),
                            contentPadding: PaddingValues.Absolute(left: 16.dp, right: 16.dp)) {
                            // Use an HStack so that it sets up the environment for bottom toolbar Spacers
                            HStack(spacing: 24.0) {
                                ComposeView { itemContext in
                                    bottomItems.forEach { $0.Compose(context: itemContext) }
                                    return .ok
                                }
                            }.Compose(context.content())
                        }
                    }
                }
            }
        ) { padding in
            let bottomSystemBarPadding = EnvironmentValues.shared._bottomSystemBarPadding
            Box(modifier: Modifier.padding(top: padding.calculateTopPadding(), bottom: padding.calculateBottomPadding() - bottomSystemBarPadding).fillMaxSize(), contentAlignment: androidx.compose.ui.Alignment.Center) {

                let contentContext: ComposeContext
                if isRoot, let searchableState = EnvironmentValues.shared._searchableState {
                    let searchFieldModifier = Modifier.background(Color.systemBarBackground.colorImpl()).height(searchFieldHeight.dp + searchFieldPadding).align(androidx.compose.ui.Alignment.TopCenter).offset({ IntOffset(0, Int(searchFieldOffsetPx.value)) }).padding(start: searchFieldPadding, bottom: searchFieldPadding, end: searchFieldPadding).fillMaxWidth()
                    SearchField(state: searchableState, context: context.content(modifier: searchFieldModifier))
                    let searchFieldPlaceholderPadding = searchFieldHeight.dp + searchFieldPadding + (with(LocalDensity.current) { searchFieldOffsetPx.value.toDp() })
                    contentContext = context.content(modifier: Modifier.padding(top: searchFieldPlaceholderPadding))
                } else {
                    contentContext = context.content()
                }

                // Provide our current destinations as the initial value so that we don't forget previous destinations. Only one navigation entry
                // will be composed, and we want to retain destinations from previous entries
                let destinationsPreference = Preference<NavigationDestinations>(key: NavigationDestinationsPreferenceKey.self, initialValue: destinations.value, update: { destinations.value = $0 }, didChange: destinationsDidChange)
                let titlePreference = Preference<String>(key: NavigationTitlePreferenceKey.self, update: { title.value = $0 }, didChange: { preferenceUpdates.value += 1 })
                let backButtonHiddenPreference = Preference<Bool>(key: NavigationBarBackButtonHiddenPreferenceKey.self, update: { backButtonHidden.value = $0 }, didChange: { preferenceUpdates.value += 1 })
                let toolbarContentPreference = Preference<[View]>(key: ToolbarContentPreferenceKey.self, update: { toolbarContent.value = $0 }, didChange: { preferenceUpdates.value += 1 })
                PreferenceValues.shared.collectPreferences([destinationsPreference, titlePreference, backButtonHiddenPreference, toolbarContentPreference]) {
                    content(contentContext)
                }
                if title.value == uncomposedTitle {
                    title.value = NavigationTitlePreferenceKey.defaultValue
                }
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
typealias NavigationDestinations = Dictionary<Any.Type, NavigationDestination>
struct NavigationDestination {
    let destination: (Any) -> View
    // No way to compare closures. Assume equal so we don't think our destinations are constantly updating
    public override func equals(other: Any?) -> Bool {
        return true
    }
}

// SKIP INSERT: @OptIn(ExperimentalComposeUiApi::class)
@Stable
class Navigator {
    /// Route for the root of the navigation stack.
    static let rootRoute = "navigationroot"

    /// Number of possible destiation routes.
    ///
    /// We route to destinations by static index rather than a dynamic system based on the provided destination keys because changing the destinations of a `NavHost`
    /// wipes out its back stack. By using a fixed set of indexes, we can maintain the back stack even as we add destination mappings.
    static let destinationCount = 100

    /// Route for the given destination index and value string.
    static func route(for destinationIndex: Int, valueString: String) -> String {
        return String(describing: destinationIndex) + "/" + valueString
    }

    private var navController: NavHostController
    private var destinations: NavigationDestinations
    private var keyboardController: SoftwareKeyboardController?

    private var destinationIndexes: [Any.Type: Int] = [:]
    private var backStackState: [String: BackStackState] = [:]
    private var navigatingToState: BackStackState? = BackStackState(route: Self.rootRoute)
    struct BackStackState {
        let id: String?
        let route: String
        let destination: ((Any) -> View)?
        let targetValue: Any?
        let stateSaver: ComposeStateSaver

        init(id: String? = nil, route: String, destination: ((Any) -> View)? = nil, targetValue: Any? = nil, stateSaver: ComposeStateSaver = ComposeStateSaver()) {
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
    @Composable func didCompose(navController: NavHostController, destinations: NavigationDestinations, keyboardController: SoftwareKeyboardController?) {
        self.navController = navController
        self.destinations = destinations
        self.keyboardController = keyboardController
        updateDestinationIndexes()
        syncState()
    }

    /// Whether we're at the root of the navigation stack.
    var isRoot: Bool {
        return navController.currentBackStack.value.size <= 2 // graph entry, root entry
    }

    /// Navigate to a target value specified in a `NavigationLink`.
    func navigate(to targetValue: Any) {
        let _ = navigate(to: targetValue, type: type(of: targetValue))
    }

    /// The entry being navigated to.
    func state(for entry: NavBackStackEntry) -> BackStackState? {
        return backStackState[entry.id]
    }

    @Composable private func syncState() {
        let entryList = navController.currentBackStack.collectAsState()

        // Fill in ID of state we were navigating to if possible
        if let navigatingToState, let lastEntry = entryList.value.lastOrNull() {
            let state = BackStackState(id: lastEntry.id, route: navigatingToState.route, destination: navigatingToState.destination, targetValue: navigatingToState.targetValue, stateSaver: navigatingToState.stateSaver)
            self.navigatingToState = nil
            backStackState[lastEntry.id] = state
        }

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

    private func navigate(to targetValue: Any, type: Any.Type?) -> Bool {
        guard let type else {
            return false
        }
        guard let destination = destinations[type] else {
            for supertype in type.supertypes {
                if navigate(to: targetValue, type: supertype as? Any.Type) {
                    return true
                }
            }
            return false
        }
        
        // We see a top app bar glitch when the keyboard animates away after push, so manually dismiss it first
        keyboardController?.hide()

        let route = route(for: type, value: targetValue)
        navigatingToState = BackStackState(route: route, destination: destination.destination, targetValue: targetValue)
        navController.navigate(route)
        return true
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
    public enum TitleDisplayMode : Sendable {
        case automatic
        case inline
        case large
    }
}

extension View {
    public func navigationBarBackButtonHidden(_ hidesBackButton: Bool = true) -> some View {
        #if SKIP
        return preference(key: NavigationBarBackButtonHiddenPreferenceKey.self, value: hidesBackButton)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        return self
    }

    public func navigationDestination<D, V>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> V) -> some View where D: Any, V : View {
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

    @available(*, unavailable)
    public func navigationTitle(_ title: Text) -> some View {
        //return navigationTitle(title.text) // TODO: we would need to change NavigationTitlePreferenceKey from String to Text in order to be able to defer localization lookup
        return self
    }

    public func navigationTitle(_ title: String) -> some View {
        #if SKIP
        return preference(key: NavigationTitlePreferenceKey.self, value: title)
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
    class Companion: PreferenceKeyCompanion {
        let defaultValue: NavigationDestinations = [:]
        func reduce(value: inout NavigationDestinations, nextValue: () -> NavigationDestinations) {
            for (type, destination) in nextValue() {
                value[type] = destination
            }
        }
    }
}

struct NavigationTitlePreferenceKey: PreferenceKey {
    typealias Value = String

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<String>
    class Companion: PreferenceKeyCompanion {
        let defaultValue = ""
        func reduce(value: inout String, nextValue: () -> String) {
            value = nextValue()
        }
    }
}

struct NavigationBarBackButtonHiddenPreferenceKey: PreferenceKey {
    typealias Value = Bool

    // SKIP DECLARE: companion object: PreferenceKeyCompanion<Boolean>
    class Companion: PreferenceKeyCompanion {
        let defaultValue = false
        func reduce(value: inout Bool, nextValue: () -> Bool) {
            value = nextValue()
        }
    }
}
#endif

public struct NavigationLink : View, ListItemAdapting {
    let value: Any?
    let label: any View

    public init(value: Any?, @ViewBuilder label: () -> any View) {
        self.value = value
        self.label = label()
    }

    public init(_ title: String, value: Any?) {
        self.init(value: value, label: { Text(verbatim: title) })
    }

    public init(_ titleKey: LocalizedStringKey, value: Any?) {
        self.init(value: value, label: { Text(titleKey) })
    }

    @available(*, unavailable)
    public init(@ViewBuilder destination: () -> any View, @ViewBuilder label: () -> any View) {
        self.value = nil
        self.label = label()
    }

    @available(*, unavailable)
    public init(_ title: String, @ViewBuilder destination: () -> any View) {
        self.label = EmptyView()
        self.value = nil
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = label.Compose(context: context.content(modifier: NavigationModifier(context.modifier)))
    }

    @Composable func shouldComposeListItem() -> Bool {
        return true
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        Row(modifier: NavigationModifier(modifier: Modifier).then(contentModifier), horizontalArrangement: Arrangement.spacedBy(8.dp), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
            Box(modifier: Modifier.weight(Float(1.0))) {
                // Continue to specialize for list rendering within the NavigationLink (e.g. Label)
                label.Compose(context: context.content(composer: ListItemComposer(contentModifier: Modifier)))
            }
            // Chevron
            androidx.compose.material3.Text("\u{203A}", color: androidx.compose.ui.graphics.Color.LightGray, fontWeight: androidx.compose.ui.text.font.FontWeight.Bold, style: MaterialTheme.typography.titleLarge)
        }
    }

    @Composable private func NavigationModifier(modifier: Modifier) -> Modifier {
        let navigator = LocalNavigator.current
        return modifier.clickable(enabled: value != nil && EnvironmentValues.shared.isEnabled) {
            if let value, let navigator  {
                navigator.navigate(to: value)
            }
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if !SKIP

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

/// A type-erased list of data representing the content of a navigation stack.
///
/// You can manage the state of a ``NavigationStack`` by initializing the stack
/// with a binding to a collection of data. The stack stores data items in the
/// collection for each view on the stack. You also can read and write the
/// collection to observe and alter the stack's state.
///
/// When a stack displays views that rely on only one kind of data, you can use
/// a standard collection, like an array, to hold the data. If you need to
/// present different kinds of data in a single stack, use a navigation path
/// instead. The path uses type erasure so you can manage a collection of
/// heterogeneous elements. The path also provides the usual collection
/// controls for adding, counting, and removing data elements.
///
/// ### Serialize the path
///
/// When the values you present on the navigation stack conform to
/// the  protocol,
/// you can use the path's ``codable`` property to get a serializable
/// representation of the path. Use that representation to save and restore
/// the contents of the stack. For example, you can define an
/// 
/// that handles serializing and deserializing the path:
///
///     class MyModelObject: ObservableObject {
///         @Published var path: NavigationPath
///
///         static func readSerializedData() -> Data? {
///             // Read data representing the path from app's persistent storage.
///         }
///
///         static func writeSerializedData(_ data: Data) {
///             // Write data representing the path to app's persistent storage.
///         }
///
///         init() {
///             if let data = Self.readSerializedData() {
///                 do {
///                     let representation = try JSONDecoder().decode(
///                         NavigationPath.CodableRepresentation.self,
///                         from: data)
///                     self.path = NavigationPath(representation)
///                 } catch {
///                     self.path = NavigationPath()
///                 }
///             } else {
///                 self.path = NavigationPath()
///             }
///         }
///
///         func save() {
///             guard let representation = path.codable else { return }
///             do {
///                 let encoder = JSONEncoder()
///                 let data = try encoder.encode(representation)
///                 Self.writeSerializedData(data)
///             } catch {
///                 // Handle error.
///             }
///         }
///     }
///
/// Then, using that object in your view, you can save the state of
/// the navigation path when the ``Scene`` enters the ``ScenePhase/background``
/// state:
///
///     @StateObject private var pathState = MyModelObject()
///     @Environment(\.scenePhase) private var scenePhase
///
///     var body: some View {
///         NavigationStack(path: $pathState.path) {
///             // Add a root view here.
///         }
///         .onChange(of: scenePhase) { phase in
///             if phase == .background {
///                 pathState.save()
///             }
///         }
///     }
///
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct NavigationPath {

    /// The number of elements in this path.
    public var count: Int { get { fatalError() } }

    /// A Boolean that indicates whether this path is empty.
    public var isEmpty: Bool { get { fatalError() } }

    /// A value that describes the contents of this path in a serializable
    /// format.
    ///
    /// This value is `nil` if any of the type-erased elements of the path
    /// don't conform to the
    ///  protocol.
    public var codable: NavigationPath.CodableRepresentation? { get { fatalError() } }

    /// Creates a new, empty navigation path.
    public init() { fatalError() }

    /// Creates a new navigation path from the contents of a sequence.
    ///
    /// - Parameters:
    ///   - elements: A sequence used to create the navigation path.
    public init<S>(_ elements: S) where S : Sequence, S.Element : Hashable { fatalError() }

    /// Creates a new navigation path from the contents of a sequence that
    /// contains codable elements.
    ///
    /// - Parameters:
    ///   - elements: A sequence used to create the navigation path.
    public init<S>(_ elements: S) where S : Sequence, S.Element : Decodable, S.Element : Encodable, S.Element : Hashable { fatalError() }

    /// Creates a new navigation path from a serializable version.
    ///
    /// - Parameters:
    ///   - codable: A value describing the contents of the new path in a
    ///     serializable format.
    public init(_ codable: NavigationPath.CodableRepresentation) { fatalError() }

    /// Appends a new value to the end of this path.
    public mutating func append<V>(_ value: V) where V : Hashable { fatalError() }

    /// Appends a new codable value to the end of this path.
    public mutating func append<V>(_ value: V) where V : Decodable, V : Encodable, V : Hashable { fatalError() }

    /// Removes values from the end of this path.
    ///
    /// - Parameters:
    ///   - k: The number of values to remove. The default value is `1`.
    ///
    /// - Precondition: The input parameter `k` must be greater than or equal
    ///   to zero, and must be less than or equal to the number of elements in
    ///   the path.
    public mutating func removeLast(_ k: Int = 1) { fatalError() }

    /// A serializable representation of a navigation path.
    ///
    /// When a navigation path contains elements the conform to the
    ///  protocol,
    /// you can use the path's `CodableRepresentation` to convert the path to an
    /// external representation and to convert an external representation back
    /// into a navigation path.
    public struct CodableRepresentation : Codable {

        /// Creates a new instance by decoding from the given decoder.
        ///
        /// This initializer throws an error if reading from the decoder fails, or
        /// if the data read is corrupted or otherwise invalid.
        ///
        /// - Parameter decoder: The decoder to read data from.
        public init(from decoder: Decoder) throws { fatalError() }

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
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationPath : Equatable {

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationPath.CodableRepresentation : Equatable {

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
