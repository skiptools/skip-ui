// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.IconButton
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
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
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.text.style.TextOverflow
import androidx.navigation.NavBackStackEntry
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.navArgument
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import kotlinx.coroutines.delay
#endif

#if SKIP
typealias NavigationDestinations = Dictionary<Any.Type, NavigationDestination>
struct NavigationDestination {
    let destination: (Any) -> View
    // No way to compare closures. Assume equal so we don't think our destinations are constantly updating
    public override func equals(other: Any?) -> Bool {
        return true
    }
}

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
    @Composable func didCompose(navController: NavHostController, destinations: NavigationDestinations) {
        self.navController = navController
        self.destinations = destinations
        updateDestinationIndexes()
        syncState()
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
        let route = route(for: type, value: targetValue)
        navigatingToState = BackStackState(route: route, destination: destination.destination, targetValue: targetValue)
        navController.navigate(route)
        return true
    }

    private func route(for targetType: Any.Type, value: Any) -> String {
        guard let index = destinationIndexes[targetType] else {
            return String(describing: targetType) + "?"
        }
        let valueString: String
        if let identifiable = value as? Identifiable {
            valueString = String(describing: identifiable.id)
        } else if let rawRepresentable = value as? RawRepresentable {
            valueString = String(describing: rawRepresentable.rawValue)
        } else {
            valueString = String(describing: value)
        }
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

public struct NavigationStack<Root> : View where Root: View {
    private let root: Root

    public init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    @available(*, unavailable)
    public init(path: Any, @ViewBuilder root: () -> Root) {
        self.root = root()
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let preferenceUpdates = remember { mutableStateOf(0) }
        let _ = preferenceUpdates.value // Read so that it can trigger recompose on change
        let preferencesDidChange = { preferenceUpdates.value += 1 }

        // Have to use rememberSaveable for e.g. a nav stack in each tab
        let destinations = rememberSaveable(stateSaver: context.stateSaver as! Saver<NavigationDestinations, Any>) { mutableStateOf(NavigationDestinationsPreferenceKey.defaultValue) }
        let navController = rememberNavController()
        let navigator = rememberSaveable(stateSaver: context.stateSaver as! Saver<Navigator, Any>) { mutableStateOf(Navigator(navController: navController, destinations: destinations.value)) }
        navigator.value.didCompose(navController: navController, destinations: destinations.value)

        // SKIP INSERT: val providedNavigator = LocalNavigator provides navigator.value
        CompositionLocalProvider(providedNavigator) {
            NavHost(navController: navController, startDestination: Navigator.rootRoute, modifier: context.modifier) {
                composable(route: Navigator.rootRoute) { entry in
                    if let state = navigator.value.state(for: entry) {
                        let entryContext = context.content(stateSaver: state.stateSaver)
                        ComposeEntry(navController: navController, destinations: destinations, destinationsDidChange: preferencesDidChange, isRoot: true, context: entryContext) { context in
                            root.Compose(context: context)
                        }
                    }
                }
                for destinationIndex in 0..<Navigator.destinationCount {
                    composable(route: Navigator.route(for: destinationIndex, valueString: "{identifier}"), arguments: listOf(navArgument("identifier") { type = NavType.StringType })) { entry in
                        if let state = navigator.value.state(for: entry), let targetValue = state.targetValue {
                            let entryContext = context.content(stateSaver: state.stateSaver)
                            ComposeEntry(navController: navController, destinations: destinations, destinationsDidChange: preferencesDidChange, isRoot: false, context: entryContext) { context in
                                state.destination?(targetValue).Compose(context: context)
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

        let title = rememberSaveable(stateSaver: context.stateSaver as! Saver<String, Any>) { mutableStateOf(NavigationTitlePreferenceKey.defaultValue) }

        // We place the top bar scaffold within each entry rather than at the navigation controller level. There isn't a fluid animation
        // between navigation bar states on Android, and it is simpler to only hoist navigation bar preferences to this level
        let scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior(rememberTopAppBarState())
        Scaffold(
            modifier: Modifier.nestedScroll(scrollBehavior.nestedScrollConnection).then(context.modifier),
            topBar: {
                MediumTopAppBar(
                    colors: TopAppBarDefaults.topAppBarColors(
                        containerColor: Color.systemBackground.colorImpl(),
                        titleContentColor: MaterialTheme.colorScheme.onSurface
                    ),
                    title: {
                        androidx.compose.material3.Text(title.value, maxLines: 1, overflow: TextOverflow.Ellipsis)
                    },
                    navigationIcon: {
                        if !isRoot {
                            IconButton(onClick: { navController.popBackStack() }) {
                                Icon(imageVector: Icons.Filled.ArrowBack, contentDescription: "Back")
                            }
                        }
                    },
                    scrollBehavior: scrollBehavior
                )
            }
        ) { padding in
            // Provide our current destinations as the initial value so that we don't forget previous destinations. Only one navigation entry
            // will be composed, and we want to retain destinations from previous entries
            let destinationsPreference = Preference<NavigationDestinations>(key: NavigationDestinationsPreferenceKey.self, initialValue: destinations.value, update: { destinations.value = $0 }, didChange: destinationsDidChange)
            let titlePreference = Preference<String>(key: NavigationTitlePreferenceKey.self, update: { title.value = $0 }, didChange: { preferenceUpdates.value += 1 })
            PreferenceValues.shared.collectPreferences([destinationsPreference, titlePreference]) {
                Box(modifier: Modifier.padding(padding).fillMaxSize().then(context.modifier), contentAlignment: androidx.compose.ui.Alignment.Center) {
                    content(context.content())
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

extension View {
    public func navigationDestination<D, V>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> V) -> some View where D: Any, V : View {
        #if SKIP
        let destinations: NavigationDestinations = [data: NavigationDestination(destination: { destination($0 as! D) })]
        // SKIP REPLACE: return preference(NavigationDestinationsPreferenceKey::class, destinations)
        return preference(key: NavigationDestinationsPreferenceKey.self, value: destinations)
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func navigationDestination<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V : View {
        return self
    }

    public func navigationTitle(_ title: Text) -> some View {
        return navigationTitle(title.text)
    }

    public func navigationTitle(_ title: String) -> some View {
        #if SKIP
        // SKIP REPLACE: return preference(NavigationTitlePreferenceKey::class, title)
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
#endif

public struct NavigationLink : View, ListItemAdapting {
    let value: Any?
    let label: any View

    public init(value: Any?, @ViewBuilder label: () -> any View) {
        self.value = value
        self.label = label()
    }

    public init(_ title: String, value: Any?) {
        self.init(value: value, label: { Text(title) })
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
        label.Compose(context: context.content(modifier: NavigationModifier(context.modifier)))
    }

    @Composable func shouldComposeListItem() -> Bool {
        return true
    }

    @Composable func ComposeListItem(context: ComposeContext, contentModifier: Modifier) {
        Box(modifier: NavigationModifier(modifier: Modifier)) {
            Row(modifier: contentModifier, horizontalArrangement: Arrangement.spacedBy(8.dp), verticalAlignment: androidx.compose.ui.Alignment.CenterVertically) {
                label.Compose(context: context.content(modifier: Modifier.weight(Float(1.0))))
                // Chevron
                androidx.compose.material3.Text("\u{203A}", color: androidx.compose.ui.graphics.Color.LightGray, fontWeight: androidx.compose.ui.text.font.FontWeight.Bold, style: MaterialTheme.typography.titleLarge)
            }
        }
    }

    @Composable private func NavigationModifier(modifier: Modifier) -> Modifier {
        let navigator = LocalNavigator.current
        return modifier.clickable(enabled: value != nil) {
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

/// A picker style represented by a navigation link that presents the options
/// by pushing a List-style picker view.
///
/// In navigation stacks, prefer the default ``PickerStyle/menu`` style.
/// Consider the navigation link style when you have a large number of
/// options or your design is better expressed by pushing onto a stack.
///
/// You can also use ``PickerStyle/navigationLink`` to construct this style.
@available(iOS 16.0, tvOS 16.0, watchOS 9.0, *)
@available(macOS, unavailable)
public struct NavigationLinkPickerStyle : PickerStyle {

    /// Creates a navigation link picker style.
    public init() { fatalError() }
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

/// A navigation view style represented by a series of views in columns.
///
/// You can also use ``NavigationViewStyle/columns`` to construct this style.
@available(iOS, introduced: 15.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
@available(macOS, introduced: 12.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
public struct ColumnNavigationViewStyle : NavigationViewStyle {
}

/// A navigation split style that resolves its appearance automatically
/// based on the current context.
///
/// Use ``NavigationSplitViewStyle/automatic`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AutomaticNavigationSplitViewStyle : NavigationSplitViewStyle {

    /// Creates an instance of the automatic navigation split view style.
    ///
    /// Use ``NavigationSplitViewStyle/automatic`` to construct this style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    public func makeBody(configuration: AutomaticNavigationSplitViewStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a navigation split view.
//    public typealias Body = some View
}

/// A navigation split style that reduces the size of the detail content
/// to make room when showing the leading column or columns.
///
/// Use ``NavigationSplitViewStyle/balanced`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct BalancedNavigationSplitViewStyle : NavigationSplitViewStyle {

    /// Creates an instance of ``BalancedNavigationSplitViewStyle``.
    ///
    /// You can also use ``NavigationSplitViewStyle/balanced`` to construct this
    /// style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    public func makeBody(configuration: BalancedNavigationSplitViewStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a navigation split view.
//    public typealias Body = some View
}

/// A type that specifies the appearance and interaction of navigation split
/// views within a view hierarchy.
///
/// To configure the navigation split view style for a view hierarchy, use the
/// ``View/navigationSplitViewStyle(_:)`` modifier.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public protocol NavigationSplitViewStyle {

    /// A view that represents the body of a navigation split view.
    associatedtype Body : View

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a navigation split view instance.
    typealias Configuration = NavigationSplitViewStyleConfiguration
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationSplitViewStyle where Self == ProminentDetailNavigationSplitViewStyle {

    /// A navigation split style that attempts to maintain the size of the
    /// detail content when hiding or showing the leading columns.
    public static var prominentDetail: ProminentDetailNavigationSplitViewStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationSplitViewStyle where Self == AutomaticNavigationSplitViewStyle {

    /// A navigation split style that resolves its appearance automatically
    /// based on the current context.
    public static var automatic: AutomaticNavigationSplitViewStyle { get { fatalError() } }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationSplitViewStyle where Self == BalancedNavigationSplitViewStyle {

    /// A navigation split style that reduces the size of the detail content
    /// to make room when showing the leading column or columns.
    public static var balanced: BalancedNavigationSplitViewStyle { get { fatalError() } }
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

/// A view for presenting a stack of views that represents a visible path in a
/// navigation hierarchy.
///
/// Use a `NavigationView` to create a navigation-based app in which the user
/// can traverse a collection of views. Users navigate to a destination view
/// by selecting a ``NavigationLink`` that you provide. On iPadOS and macOS, the
/// destination content appears in the next column. Other platforms push a new
/// view onto the stack, and enable removing items from the stack with
/// platform-specific controls, like a Back button or a swipe gesture.
///
/// ![A diagram showing a multicolumn navigation view on
/// macOS, and a stack of views on iOS.](NavigationView-1)
///
/// Use the ``init(content:)`` initializer to create a
/// navigation view that directly associates navigation links and their
/// destination views:
///
///     NavigationView {
///         List(model.notes) { note in
///             NavigationLink(note.title, destination: NoteEditor(id: note.id))
///         }
///         Text("Select a Note")
///     }
///
/// Style a navigation view by modifying it with the
/// ``View/navigationViewStyle(_:)`` view modifier. Use other modifiers, like
/// ``View/navigationTitle(_:)-avgj``, on views presented by the navigation
/// view to customize the navigation interface for the presented view.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "use NavigationStack or NavigationSplitView instead")
public struct NavigationView<Content> : View where Content : View {

    /// Creates a destination-based navigation view.
    ///
    /// Perform navigation by initializing a link with a destination view.
    /// For example, consider a `ColorDetail` view that displays a color sample:
    ///
    ///     struct ColorDetail: View {
    ///         var color: Color
    ///
    ///         var body: some View {
    ///             color
    ///                 .frame(width: 200, height: 200)
    ///                 .navigationTitle(color.description.capitalized)
    ///         }
    ///     }
    ///
    /// The following ``NavigationView`` presents three links to color detail
    /// views:
    ///
    ///     NavigationView {
    ///         List {
    ///             NavigationLink("Purple", destination: ColorDetail(color: .purple))
    ///             NavigationLink("Pink", destination: ColorDetail(color: .pink))
    ///             NavigationLink("Orange", destination: ColorDetail(color: .orange))
    ///         }
    ///         .navigationTitle("Colors")
    ///
    ///         Text("Select a Color") // A placeholder to show before selection.
    ///     }
    ///
    /// When the horizontal size class is ``UserInterfaceSizeClass/regular``,
    /// like on an iPad in landscape mode, or on a Mac,
    /// the navigation view presents itself as a multicolumn view,
    /// using its second and later content views --- a single ``Text``
    /// view in the example above --- as a placeholder for the corresponding
    /// column:
    ///
    /// ![A screenshot of a Mac window showing a multicolumn navigation view.
    /// The left column lists the colors Purple, Pink, and Orange, with
    /// none selected. The right column presents a placeholder view that says
    /// Select a Color.](NavigationView-init-content-1)
    ///
    /// When the user selects one of the navigation links from the
    /// list, the linked destination view replaces the placeholder
    /// text in the detail column:
    ///
    /// ![A screenshot of a Mac window showing a multicolumn navigation view.
    /// The left column lists the colors Purple, Pink, and Orange, with
    /// Purple selected. The right column presents a detail view that shows a
    /// purple square.](NavigationView-init-content-2)
    ///
    /// When the size class is ``UserInterfaceSizeClass/compact``, like
    /// on an iPhone in portrait orientation, the navigation view presents
    /// itself as a single column that the user navigates as a stack. Tapping
    /// one of the links replaces the list with the detail view, which
    /// provides a back button to return to the list:
    ///
    /// ![Two screenshots of an iPhone in portrait orientation connected by an
    /// arrow. The first screenshot shows a single column consisting of a list
    /// of colors with the names Purple, Pink, and Orange. The second
    /// screenshot has the title Purple, and contains a purple square.
    /// The arrow connects the Purple item in the list on the left to the
    /// screenshot on the right.](NavigationView-init-content-3)
    ///
    /// - Parameter content: A ``ViewBuilder`` that produces the content that
    ///   the navigation view wraps. Any views after the first act as
    ///   placeholders for corresponding columns in a multicolumn display.
    public init(@ViewBuilder content: () -> Content) { fatalError() }

    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

/// A specification for the appearance and interaction of a `NavigationView`.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
public protocol NavigationViewStyle {
}

@available(iOS, introduced: 15.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
@available(macOS, introduced: 12.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView")
extension NavigationViewStyle where Self == ColumnNavigationViewStyle {

    /// A navigation view style represented by a series of views in columns.
    public static var columns: ColumnNavigationViewStyle { get { fatalError() } }
}

@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
extension NavigationViewStyle where Self == DefaultNavigationViewStyle {

    /// The default navigation view style in the current context of the view
    /// being styled.
    public static var automatic: DefaultNavigationViewStyle { get { fatalError() } }
}

@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(macOS, unavailable)
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
extension NavigationViewStyle where Self == StackNavigationViewStyle {

    /// A navigation view style represented by a view stack that only shows a
    /// single top view at a time.
    public static var stack: StackNavigationViewStyle { get { fatalError() } }
}

/// A configuration for a navigation bar that represents a view at the top of a
/// navigation stack.
///
/// Use one of the ``TitleDisplayMode`` values to configure a navigation bar
/// title's display mode with the ``View/navigationBarTitleDisplayMode(_:)``
/// view modifier.
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
public struct NavigationBarItem : Sendable {

    /// A style for displaying the title of a navigation bar.
    ///
    /// Use one of these values with the
    /// ``View/navigationBarTitleDisplayMode(_:)`` view modifier to configure
    /// the title of a navigation bar.
    public enum TitleDisplayMode : Sendable {

        /// Inherit the display mode from the previous navigation item.
        case automatic

        /// Display the title within the standard bounds of the navigation bar.
        case inline

        /// Display a large title within an expanded navigation bar.
        @available(watchOS 8.0, *)
        @available(tvOS, unavailable)
        case large

        

    
        }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension NavigationBarItem.TitleDisplayMode : Equatable {
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension NavigationBarItem.TitleDisplayMode : Hashable {
}

/// The navigation control group style.
///
/// You can also use ``ControlGroupStyle/navigation`` to construct this style.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct NavigationControlGroupStyle : ControlGroupStyle {

    /// Creates a navigation control group style.
    public init() { fatalError() }

    /// Creates a view representing the body of a control group.
    ///
    /// - Parameter configuration: The properties of the control group instance
    ///   being created.
    ///
    /// This method will be called for each instance of ``ControlGroup`` created
    /// within a view hierarchy where this style is the current
    /// `ControlGroupStyle`.
    @MainActor public func makeBody(configuration: NavigationControlGroupStyle.Configuration) -> some View { return stubView() }


    /// A view representing the body of a control group.
//    public typealias Body = some View
}

/// The default navigation view style.
///
/// You can also use ``NavigationViewStyle/automatic`` to construct this style.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
public struct DefaultNavigationViewStyle : NavigationViewStyle {

    public init() { fatalError() }
}

/// A navigation split style that attempts to maintain the size of the
/// detail content when hiding or showing the leading columns.
///
/// Use ``NavigationSplitViewStyle/prominentDetail`` to construct this style.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct ProminentDetailNavigationSplitViewStyle : NavigationSplitViewStyle {

    /// Creates an instance of ``ProminentDetailNavigationSplitViewStyle``.
    ///
    /// You can also use ``NavigationSplitViewStyle/prominentDetail`` to
    /// construct this style.
    public init() { fatalError() }

    /// Creates a view that represents the body of a navigation split view.
    ///
    /// SkipUI calls this method for each instance of ``NavigationSplitView``,
    /// where this style is the current ``NavigationSplitViewStyle``.
    ///
    /// - Parameter configuration: The properties of the instance to create.
    public func makeBody(configuration: ProminentDetailNavigationSplitViewStyle.Configuration) -> some View { return stubView() }


    /// A view that represents the body of a navigation split view.
//    public typealias Body = some View
}

/// A navigation view style represented by a view stack that only shows a
/// single top view at a time.
///
/// You can also use ``NavigationViewStyle/stack`` to construct this style.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(macOS, unavailable)
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace stack-styled NavigationView with NavigationStack")
public struct StackNavigationViewStyle : NavigationViewStyle {

    public init() { fatalError() }
}


/// A navigation view style represented by a primary view stack that
/// navigates to a detail view.
@available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationSplitView instead")
@available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
@available(watchOS, unavailable)
@available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
public struct DoubleColumnNavigationViewStyle : NavigationViewStyle {

    public init() { fatalError() }
}


extension View {

    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    public func navigationBarItems<L, T>(leading: L, trailing: T) -> some View where L : View, T : View { return stubView() }


    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    public func navigationBarItems<L>(leading: L) -> some View where L : View { return stubView() }


    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement")
    public func navigationBarItems<T>(trailing: T) -> some View where T : View { return stubView() }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension View {

    /// Associates a destination view with a bound value for use within a
    /// navigation stack or navigation split view
    ///
    /// Add this view modifer to a view inside a ``NavigationStack`` or
    /// ``NavigationSplitView`` to describe the view that the stack displays
    /// when presenting a particular kind of data. Use a ``NavigationLink`` to
    /// present the data, which updates the binding. Programmatically update
    /// the binding to display or remove the view. For example, you can replace
    /// the view showing in the detail column of a navigation split view:
    ///
    ///     @State private var colorShown: Color?
    ///
    ///     NavigationSplitView {
    ///         List {
    ///             NavigationLink("Mint", value: Color.mint)
    ///             NavigationLink("Pink", value: Color.pink)
    ///             NavigationLink("Teal", value: Color.teal)
    ///         }
    ///         .navigationDestination(item: $colorShown) { color in
    ///             ColorDetail(color: color)
    ///         }
    ///     } detail: {
    ///         Text("Select a color")
    ///     }
    ///
    /// When the person using the app taps on the Mint link, the mint color
    /// shows in the detail and `colorShown` gets the value `Color.mint`. You
    /// can reset the navigation split view to show the message "Select a color"
    /// by setting `colorShown` back to `nil`.
    ///
    /// You can add more than one navigation destination modifier to the stack
    /// if it needs to present more than one kind of data.
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation split view can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - item: A binding to the data presented, or `nil` if nothing is
    ///     currently presented.
    ///   - destination: A view builder that defines a view to display
    ///     when `item` is not `nil`.
    public func navigationDestination<D, C>(item: Binding<D?>, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View { return stubView() }

}

extension View {
    /// Hides the navigation bar back button for the view.
    ///
    /// Use `navigationBarBackButtonHidden(_:)` to hide the back button for this
    /// view.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// - Parameter hidesBackButton: A Boolean value that indicates whether to
    ///   hide the back button. The default value is `true`.
    public func navigationBarBackButtonHidden(_ hidesBackButton: Bool = true) -> some View { return stubView() }

}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Sets a fixed, preferred width for the column containing this view.
    ///
    /// Apply this modifier to the content of a column in a
    /// ``NavigationSplitView`` to specify a fixed preferred width for the
    /// column. Use ``View/navigationSplitViewColumnWidth(min:ideal:max:)`` if
    /// you need to specify a flexible width.
    ///
    /// The following example shows a three-column navigation split view where
    /// the first column has a preferred width of 150 points, and the second
    /// column has a flexible, preferred width between 150 and 400 points:
    ///
    ///     NavigationSplitView {
    ///         MySidebar()
    ///             .navigationSplitViewColumnWidth(150)
    ///     } contents: {
    ///         MyContents()
    ///             .navigationSplitViewColumnWidth(
    ///                 min: 150, ideal: 200, max: 400)
    ///     } detail: {
    ///         MyDetail()
    ///     }
    ///
    /// Only some platforms enable resizing columns. If
    /// you specify a width that the current presentation environment doesn't
    /// support, SkipUI may use a different width for your column.
    public func navigationSplitViewColumnWidth(_ width: CGFloat) -> some View { return stubView() }


    /// Sets a flexible, preferred width for the column containing this view.
    ///
    /// Apply this modifier to the content of a column in a
    /// ``NavigationSplitView`` to specify a preferred flexible width for the
    /// column. Use ``View/navigationSplitViewColumnWidth(_:)`` if you need to
    /// specify a fixed width.
    ///
    /// The following example shows a three-column navigation split view where
    /// the first column has a preferred width of 150 points, and the second
    /// column has a flexible, preferred width between 150 and 400 points:
    ///
    ///     NavigationSplitView {
    ///         MySidebar()
    ///             .navigationSplitViewColumnWidth(150)
    ///     } contents: {
    ///         MyContents()
    ///             .navigationSplitViewColumnWidth(
    ///                 min: 150, ideal: 200, max: 400)
    ///     } detail: {
    ///         MyDetail()
    ///     }
    ///
    /// Only some platforms enable resizing columns. If
    /// you specify a width that the current presentation environment doesn't
    /// support, SkipUI may use a different width for your column.
    public func navigationSplitViewColumnWidth(min: CGFloat? = nil, ideal: CGFloat, max: CGFloat? = nil) -> some View { return stubView() }

}

extension View {

    /// Sets the style for navigation split views within this view.
    ///
    /// - Parameter style: The style to set.
    ///
    /// - Returns: A view that uses the specified navigation split view style.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func navigationSplitViewStyle<S>(_ style: S) -> some View where S : NavigationSplitViewStyle { return stubView() }

}

extension View {

    /// Configures the view's document for purposes of navigation.
    ///
    /// In iOS, iPadOS, this populates the title menu with a header
    /// previewing the document. In macOS, this populates a proxy icon.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation document modifiers.
    ///
    /// - Parameters:
    ///   - document: The URL content associated to the
    ///     navigation title.
    ///   - preview: The preview of the document to use when sharing.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    public func navigationDocument(_ url: URL) -> some View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, *)
extension View {

    /// Sets the style for navigation views within this view.
    ///
    /// Use this modifier to change the appearance and behavior of navigation
    /// views. For example, by default, navigation views appear with multiple
    /// columns in wider environments, like iPad in landscape orientation:
    ///
    /// ![A screenshot of an iPad in landscape orientation mode showing a
    /// multicolumn navigation view. The left column lists the colors Purple,
    /// Pink, and Orange, with Purple selected. The right column presents a
    /// detail view that shows a purple square.](View-navigationViewStyle-1)
    ///
    /// You can apply the ``NavigationViewStyle/stack`` style to force
    /// single-column stack navigation in these environments:
    ///
    ///     NavigationView {
    ///         List {
    ///             NavigationLink("Purple", destination: ColorDetail(color: .purple))
    ///             NavigationLink("Pink", destination: ColorDetail(color: .pink))
    ///             NavigationLink("Orange", destination: ColorDetail(color: .orange))
    ///         }
    ///         .navigationTitle("Colors")
    ///
    ///         Text("Select a Color") // A placeholder to show before selection.
    ///     }
    ///     .navigationViewStyle(.stack)
    ///
    /// ![A screenshot of an iPad in landscape orientation mode showing a
    /// single column containing the list Purple, Pink, and
    /// Orange.](View-navigationViewStyle-2)
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(watchOS, introduced: 7.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "replace styled NavigationView with NavigationStack or NavigationSplitView instead")
    public func navigationViewStyle<S>(_ style: S) -> some View where S : NavigationViewStyle { return stubView() }

}

@available(iOS 14.0, watchOS 8.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
extension View {

    /// Configures the title display mode for this view.
    ///
    /// - Parameter displayMode: The style to use for displaying the title.
    public func navigationBarTitleDisplayMode(_ displayMode: NavigationBarItem.TitleDisplayMode) -> some View { return stubView() }

}

#endif
