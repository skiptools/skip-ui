// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.foundation.clickable
// SKIP INSERT: import androidx.compose.runtime.getValue
// SKIP INSERT: import androidx.compose.runtime.mutableStateOf
// SKIP INSERT: import androidx.compose.runtime.remember
// SKIP INSERT: import androidx.compose.runtime.setValue
// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.navigation.NavController
// SKIP INSERT: import androidx.navigation.navArgument
// SKIP INSERT: import androidx.navigation.compose.composable
// SKIP INSERT: import androidx.navigation.compose.rememberNavController

#if SKIP
let LocalNavController: androidx.compose.runtime.ProvidableCompositionLocal<NavController?> = androidx.compose.runtime.compositionLocalOf { nil as NavController? }
#endif

private typealias DestinationMap = Dictionary<String, (Any) -> any View>

// SKIP ATTRIBUTES: nocopy
public struct NavigationStack<Root> : View where Root: View {
    private let root: Root
    #if SKIP
    private var destinationMap: DestinationMap?
    #endif

    public init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }

    @available(*, unavailable)
    public init(path: Any, @ViewBuilder root: () -> Root) {
        self.root = root()
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        // SKIP INSERT: var rememberedDestinationMap by remember { mutableStateOf(destinationMap) }
        destinationMap = rememberedDestinationMap
        if destinationMap == nil {
            root.Compose(context.content(of: self))
            rememberedDestinationMap = destinationMap
        }

        let navController = rememberNavController()
        // SKIP INSERT: val providedNavController = LocalNavController provides navController
        androidx.compose.runtime.CompositionLocalProvider(providedNavController) {
            androidx.navigation.compose.NavHost(navController: navController, startDestination: "navigationroot", modifier: context.modifier) {
                composable(route: "navigationroot") {
                    androidx.compose.foundation.layout.Box {
                        root.Compose(context: ComposeContext())
                    }
                }
                if let destinationMap {
                    for (route, viewBuilder) in destinationMap {
                        composable(route: route + "/{value}", arguments = listOf(navArgument("value") { type = androidx.navigation.NavType.StringType })) {
                            let value = $0.arguments?.getString("value") ?? ""
                            androidx.compose.foundation.layout.Box {
                                viewBuilder(value).Compose(context: ComposeContext())
                            }
                        }
                    }
                }
            }
        }
    }

    @Composable public override func ComposeContent(view: any View, context: ComposeContext) {
        if destinationMap == nil {
            destinationMap = (view as? NavigationDestination)?.destinationMap ?? [:]
        } else {
            super.ComposeContent(view: view, context: context)
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

extension View {
    // SKIP DECLARE: fun <D> navigationDestination(for_: KClass<D>, destination: (D) -> View): View where D: Any
    public func navigationDestination<V>(for data: Any, @ViewBuilder destination: @escaping (Any) -> V) -> some View where V : View {
        #if SKIP
        return NavigationDestination(view: self, dataType: data as Any.Type, destination: { destination($0 as! D) })
        #else
        return self
        #endif
    }

    @available(*, unavailable)
    public func navigationDestination<V>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> V) -> some View where V : View {
        return self
    }
}

#if SKIP
struct NavigationDestination: View {
    let view: any View
    let destinationMap: [String: (Any) -> any View]

    init(view: any View, dataType: Any.Type, @ViewBuilder destination: @escaping (Any) -> any View) {
        self.view = view
        if let navigationDestination = view as? NavigationDestination {
            var combinedDestinationMap = navigationDestination.destinationMap
            combinedDestinationMap[String(describing: dataType)] = destination
            self.destinationMap = combinedDestinationMap
        } else {
            self.destinationMap = [String(describing: dataType): destination]
        }
    }

    @Composable override func ComposeContent(context: ComposeContext) {
        view.Compose(context)
    }
}
#endif

public struct NavigationLink : View {
    let value: Any?
    let label: any View
    var route: String {
        guard let value else {
            return ""
        }
        let base = String(describing: type(of: value))
        return base + "/" + String(describing: value)
    }

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
        let navController = LocalNavController.current
        var context = context
        context.parent = self
        context.modifier = context.modifier.clickable(enabled: value != nil) {
            if let navController  {
                navController.navigate(route)
            }
        }
        label.Compose(context: context)
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

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
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

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
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

@available(iOS 13.0, macOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Hides the navigation bar for this view.
    ///
    /// Use `navigationBarHidden(_:)` to hide the navigation bar. This modifier
    /// only takes effect when this view is inside of and visible within a
    /// ``NavigationView``.
    ///
    /// - Parameter hidden: A Boolean value that indicates whether to hide the
    ///   navigation bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use toolbar(.hidden)")
    public func navigationBarHidden(_ hidden: Bool) -> some View { return stubView() }


    /// Sets the title in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:)` to set the title of the navigation bar.
    /// This modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// The example below shows setting the title of the navigation bar using a
    /// ``Text`` view:
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(Text("Today's Flavors"))
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot showing the title of a navigation bar configured using a
    /// text view.](SkipUI-navigationBarTitle-Text.png)
    ///
    /// - Parameter title: A description of this view to display in the
    ///   navigation bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    public func navigationBarTitle(_ title: Text) -> some View { return stubView() }


    /// Sets the title of this view's navigation bar with a localized string.
    ///
    /// Use `navigationBarTitle(_:)` to set the title of the navigation bar
    /// using a ``LocalizedStringKey`` that will be used to search for a
    /// matching localized string in the application's localizable strings
    /// assets.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// In the example below, a string constant is used to access a
    /// ``LocalizedStringKey`` that will be resolved at run time to provide a
    /// title for the navigation bar. If the localization key cannot be
    /// resolved, the text of the key name will be used as the title text.
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle("Today's Flavors")
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter titleKey: A key to a localized description of this view to
    ///   display in the navigation bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    public func navigationBarTitle(_ titleKey: LocalizedStringKey) -> some View { return stubView() }


    /// Sets the title of this view's navigation bar with a string.
    ///
    /// Use `navigationBarTitle(_:)` to set the title of the navigation bar
    /// using a `String`. This modifier only takes effect when this view is
    /// inside of and visible within a ``NavigationView``.
    ///
    /// In the example below, text for the navigation bar title is provided
    /// using a string:
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         let text = "Today's Flavors"
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(text)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter title: A title for this view to display in the navigation
    ///   bar.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(macOS, unavailable)
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, renamed: "navigationTitle(_:)")
    public func navigationBarTitle<S>(_ title: S) -> some View where S : StringProtocol { return stubView() }


    /// Sets the title and display mode in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:displayMode:)` to set the title of the
    /// navigation bar for this view and specify a display mode for the title
    /// from one of the ``NavigationBarItem/TitleDisplayMode`` styles. This
    /// modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// In the example below, text for the navigation bar title is provided
    /// using a ``Text`` view. The navigation bar title's
    /// ``NavigationBarItem/TitleDisplayMode`` is set to `.inline` which places
    /// the navigation bar title in the bounds of the navigation bar.
    ///
    ///     struct FlavorView: View {
    ///        let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                     "Pistachio"]
    ///        var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(Text("Today's Flavors", displayMode: .inline)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - title: A title for this view to display in the navigation bar.
    ///   - displayMode: The style to use for displaying the navigation bar title.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    public func navigationBarTitle(_ title: Text, displayMode: NavigationBarItem.TitleDisplayMode) -> some View { return stubView() }


    /// Sets the title and display mode in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:displayMode:)` to set the title of the
    /// navigation bar for this view and specify a display mode for the title
    /// from one of the ``NavigationBarItem/TitleDisplayMode`` styles. This
    /// modifier only takes effect when this view is inside of and visible
    /// within a ``NavigationView``.
    ///
    /// In the example below, text for the navigation bar title is provided
    /// using a string. The navigation bar title's
    /// ``NavigationBarItem/TitleDisplayMode`` is set to `.inline` which places
    /// the navigation bar title in the bounds of the navigation bar.
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle("Today's Flavors", displayMode: .inline)
    ///             }
    ///         }
    ///     }
    ///
    /// If the `titleKey` can't be found, the title uses the text of the key
    /// name instead.
    ///
    /// - Parameters:
    ///   - titleKey: A key to a localized description of this view to display
    ///     in the navigation bar.
    ///   - displayMode: The style to use for displaying the navigation bar
    ///     title.
    @available(iOS, introduced: 13.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    public func navigationBarTitle(_ titleKey: LocalizedStringKey, displayMode: NavigationBarItem.TitleDisplayMode) -> some View { return stubView() }


    /// Sets the title and display mode in the navigation bar for this view.
    ///
    /// Use `navigationBarTitle(_:displayMode:)` to set the title of the
    /// navigation bar for this view and specify a display mode for the
    /// title from one of the `NavigationBarItem.Title.DisplayMode`
    /// styles. This modifier only takes effect when this view is inside of and
    /// visible within a `NavigationView`.
    ///
    /// In the example below, `navigationBarTitle(_:displayMode:)` uses a
    /// string to provide a title for the navigation bar. Setting the title's
    /// `displayMode` to `.inline` places the navigation bar title within the
    /// bounds of the navigation bar.
    ///
    /// In the example below, text for the navigation bar title is provided using
    /// a string. The navigation bar title's `displayMode` is set to
    /// `.inline` which places the navigation bar title in the bounds of the
    /// navigation bar.
    ///
    ///     struct FlavorView: View {
    ///         let items = ["Chocolate", "Vanilla", "Strawberry", "Mint Chip",
    ///                      "Pistachio"]
    ///         let title = "Today's Flavors"
    ///         var body: some View {
    ///             NavigationView {
    ///                 List(items, id: \.self) {
    ///                     Text($0)
    ///                 }
    ///                 .navigationBarTitle(title, displayMode: .inline)
    ///             }
    ///         }
    ///     }
    ///
    /// ![A screenshot of a navigation bar, showing the title within the bounds
    ///  of the navigation bar]
    /// (SkipUI-navigationBarTitle-stringProtocol.png)
    ///
    /// - Parameters:
    ///   - title: A title for this view to display in the navigation bar.
    ///   - displayMode: The way to display the title.
    @available(iOS, introduced: 14.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    @available(xrOS, introduced: 1.0, deprecated: 100000.0, message: "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)")
    public func navigationBarTitle<S>(_ title: S, displayMode: NavigationBarItem.TitleDisplayMode) -> some View where S : StringProtocol { return stubView() }


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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Configures the view's title for purposes of navigation.
    ///
    /// A view's navigation title is used to visually display
    /// the current navigation state of an interface.
    /// On iOS and watchOS, when a view is navigated to inside
    /// of a navigation view, that view's title is displayed
    /// in the navigation bar. On iPadOS, the primary destination's
    /// navigation title is reflected as the window's title in the
    /// App Switcher. Similarly on macOS, the primary destination's title
    /// is used as the window title in the titlebar, Windows menu
    /// and Mission Control.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter title: The title to display.
    public func navigationTitle(_ title: Text) -> some View { return stubView() }


    /// Configures the view's title for purposes of navigation,
    /// using a localized string.
    ///
    /// A view's navigation title is used to visually display
    /// the current navigation state of an interface.
    /// On iOS and watchOS, when a view is navigated to inside
    /// of a navigation view, that view's title is displayed
    /// in the navigation bar. On iPadOS, the primary destination's
    /// navigation title is reflected as the window's title in the
    /// App Switcher. Similarly on macOS, the primary destination's title
    /// is used as the window title in the titlebar, Windows menu
    /// and Mission Control.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter titleKey: The key to a localized string to display.
    public func navigationTitle(_ titleKey: LocalizedStringKey) -> some View { return stubView() }


    /// Configures the view's title for purposes of navigation, using a string.
    ///
    /// A view's navigation title is used to visually display
    /// the current navigation state of an interface.
    /// On iOS and watchOS, when a view is navigated to inside
    /// of a navigation view, that view's title is displayed
    /// in the navigation bar. On iPadOS, the primary destination's
    /// navigation title is reflected as the window's title in the
    /// App Switcher. Similarly on macOS, the primary destination's title
    /// is used as the window title in the titlebar, Windows menu
    /// and Mission Control.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter title: The string to display.
    public func navigationTitle<S>(_ title: S) -> some View where S : StringProtocol { return stubView() }

}

extension View {

    /// Configures the view's title for purposes of navigation, using a string
    /// binding.
    ///
    /// In iOS, iPadOS, and macOS, this allows editing the navigation title
    /// when the title is displayed in the toolbar.
    ///
    /// Refer to the <doc:Configure-Your-Apps-Navigation-Titles> article
    /// for more information on navigation title modifiers.
    ///
    /// - Parameter title: The text of the title.
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    public func navigationTitle(_ title: Binding<String>) -> some View { return stubView() }

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
