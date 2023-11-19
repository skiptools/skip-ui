// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

#if canImport(CoreData)
import CoreData

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {

    public var managedObjectContext: NSManagedObjectContext { get { fatalError() } }
}


extension EnvironmentValues {

    /// The undo manager used to register a view's undo operations.
    ///
    /// This value is `nil` when the environment represents a context that
    /// doesn't support undo and redo operations. You can skip registration of
    /// an undo operation when this value is `nil`.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public var undoManager: UndoManager? { get { fatalError() } }
}


/// A property wrapper type that retrieves entities from a Core Data persistent
/// store.
///
/// Use a `FetchRequest` property wrapper to declare a ``FetchedResults``
/// property that provides a collection of Core Data managed objects to a
/// SkipUI view. The request infers the entity type from the `Result`
/// placeholder type that you specify. Condition the request with an optional
/// predicate and sort descriptors. For example, you can create a request to
/// list all `Quake` managed objects that the
/// 
/// sample code project defines to store earthquake data, sorted by their
/// `time` property:
///
///     @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)])
///     private var quakes: FetchedResults<Quake> // Define Quake in your model.
///
/// Alternatively, when you need more flexibility, you can initialize the
/// request with a configured
/// 
/// instance:
///
///     @FetchRequest(fetchRequest: request)
///     private var quakes: FetchedResults<Quake>
///
/// Always declare properties that have a fetch request wrapper as private.
/// This lets the compiler help you avoid accidentally setting
/// the property from the memberwise initializer of the enclosing view.
///
/// The fetch request and its results use the managed object context stored
/// in the environment, which you can access using the
/// ``EnvironmentValues/managedObjectContext`` environment value. To
/// support user interface activity, you typically rely on the
/// 
/// property of a shared
/// 
/// instance. For example, you can set a context on your top level content
/// view using a shared container that you define as part of your model:
///
///     ContentView()
///         .environment(
///             \.managedObjectContext,
///             QuakesProvider.shared.container.viewContext)
///
/// When you need to dynamically change the predicate or sort descriptors,
/// access the request's ``FetchRequest/Configuration`` structure.
/// To create a request that groups the fetched results according to a
/// characteristic that they share, use ``SectionedFetchRequest`` instead.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@MainActor @propertyWrapper public struct FetchRequest<Result> where Result : NSFetchRequestResult {

    public init() {
        fatalError()
    }

    /// The fetched results of the fetch request.
    ///
    /// SkipUI returns the value associated with this property
    /// when you use ``FetchRequest`` as a property wrapper, and then access
    /// the wrapped property by name. For example, consider the following
    /// `quakes` property declaration that fetches a `Quake` type that the
    /// sample code project defines:
    ///
    ///     @FetchRequest(fetchRequest: request)
    ///     private var quakes: FetchedResults<Quake>
    ///
    /// You access the request's `wrappedValue`, which contains a
    /// ``FetchedResults`` instance, by referring to the `quakes` property
    /// by name:
    ///
    ///     Text("Found \(quakes.count) earthquakes")
    ///
    /// If you need to separate the request and the result
    /// entities, you can declare `quakes` in two steps by
    /// using the request's `wrappedValue` to obtain the results:
    ///
    ///     var fetchRequest = FetchRequest<Quake>(fetchRequest: request)
    ///     var quakes: FetchedResults<Quake> { fetchRequest.wrappedValue }
    ///
    /// The `wrappedValue` property returns an empty array when there are no
    /// fetched results --- for example, because no entities satisfy the
    /// predicate, or because the data store is empty.
    @MainActor public var wrappedValue: FetchedResults<Result> { get { fatalError() } }

    /// The request's configurable properties.
    ///
    /// You initialize a ``FetchRequest`` with an optional predicate and
    /// sort descriptors, either explicitly or using a configured
    /// .
    /// Later, you can dynamically update the predicate and sort
    /// parameters using the request's configuration structure.
    ///
    /// You access or bind to a request's configuration components through
    /// properties on the associated ``FetchedResults`` instance.
    ///
    /// ### Configure using a binding
    ///
    /// Get a ``Binding`` to a fetch request's configuration structure
    /// by accessing the request's ``FetchRequest/projectedValue``, which you
    /// do by using the dollar sign (`$`) prefix on the associated
    /// results property. For example, you can create a request for `Quake`
    /// entities --- a managed object type that the
    /// sample code project defines --- that initially sorts the results by time:
    ///
    ///     @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)])
    ///     private var quakes: FetchedResults<Quake>
    ///
    /// Then you can bind the request's sort descriptors,
    /// which you access through the `quakes` result, to those
    /// of a ``Table`` instance:
    ///
    ///     Table(quakes, sortOrder: $quakes.sortDescriptors) {
    ///         TableColumn("Place", value: \.place)
    ///         TableColumn("Time", value: \.time) { quake in
    ///             Text(quake.time, style: .time)
    ///         }
    ///     }
    ///
    /// A user who clicks on a table column header initiates the following
    /// sequence of events:
    /// 1. The table updates the sort descriptors through the binding.
    /// 2. The modified sort descriptors reconfigure the request.
    /// 3. The reconfigured request fetches new results.
    /// 4. SkipUI redraws the table in response to new results.
    ///
    /// ### Set configuration directly
    ///
    /// If you need to access the fetch request's configuration elements
    /// directly, use the ``FetchedResults/nsPredicate`` and
    /// ``FetchedResults/sortDescriptors`` or
    /// ``FetchedResults/nsSortDescriptors`` properties of the
    /// ``FetchedResults`` instance. Continuing the example above, to
    /// enable the user to dynamically update the predicate, declare a
    /// ``State`` property to hold a query string:
    ///
    ///     @State private var query = ""
    ///
    /// Then add an ``View/onChange(of:perform:)`` modifier to the ``Table``
    /// that sets a new predicate any time the query changes:
    ///
    ///     .onChange(of: query) { value in
    ///         quakes.nsPredicate = query.isEmpty
    ///             ? nil
    ///             : NSPredicate(format: "place CONTAINS %@", value)
    ///     }
    ///
    /// To give the user control over the string, add a ``TextField`` in your
    /// user interface that's bound to the `query` state:
    ///
    ///     TextField("Filter", text: $query)
    ///
    /// When the user types into the text field, the predicate updates,
    /// the request fetches new results, and SkipUI redraws the table.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public struct Configuration {

        /// The request's sort descriptors, accessed as reference types.
        ///
        /// Set this configuration value to cause a ``FetchRequest`` to execute
        /// a fetch with a new collection of
            /// instances. If you want to use
            /// instances, set ``FetchRequest/Configuration/sortDescriptors``
        /// instead.
        ///
        /// Access this value of a ``FetchRequest/Configuration`` structure for
        /// a given request by using the ``FetchedResults/nsSortDescriptors``
        /// property on the associated ``FetchedResults`` instance, either
        /// directly or through a ``Binding``.
        public var nsSortDescriptors: [NSSortDescriptor]

        /// The request's predicate.
        ///
        /// Set this configuration value to cause a ``FetchRequest`` to execute
        /// a fetch with a new predicate.
        ///
        /// Access this value of a ``FetchRequest/Configuration`` structure for
        /// a given request by using the ``FetchedResults/nsPredicate``
        /// property on the associated ``FetchedResults`` instance, either
        /// directly or through a ``Binding``.
        public var nsPredicate: NSPredicate?
    }

    /// A binding to the request's mutable configuration properties.
    ///
    /// SkipUI returns the value associated with this property when you use
    /// ``FetchRequest`` as a property wrapper on a ``FetchedResults`` instance,
    /// and then access the results with a dollar sign (`$`) prefix. The value
    /// that SkipUI returns is a ``Binding`` to the request's
    /// ``FetchRequest/Configuration`` structure, which dynamically
    /// configures the request.
    ///
    /// For example, consider the following fetch request for a type that the
    /// sample code project defines to store earthquake data, sorted based on
    /// the `time` property:
    ///
    ///     @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)])
    ///     private var quakes: FetchedResults<Quake>
    ///
    /// You can use the projected value to enable a ``Table`` instance to make
    /// updates:
    ///
    ///     Table(quakes, sortOrder: $quakes.sortDescriptors) {
    ///         TableColumn("Place", value: \.place)
    ///         TableColumn("Time", value: \.time) { quake in
    ///             Text(quake.time, style: .time)
    ///         }
    ///     }
    ///
    /// Because you initialize the table using a binding to the descriptors,
    /// the table can modify the sort in response to actions that the user
    /// takes, like clicking a column header.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    @MainActor public var projectedValue: Binding<FetchRequest<Result>.Configuration> { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension FetchRequest : DynamicProperty {

    /// Updates the fetched results.
    ///
    /// SkipUI calls this function before rendering a view's
    /// ``View/body-swift.property`` to ensure the view has the most recent
    /// fetched results.
    @MainActor public mutating func update() { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension FetchRequest {

    /// Creates a fetch request for a specified entity description, based on a
    /// predicate and sort parameters.
    ///
    /// Use this initializer if you need to explicitly specify the entity type
    /// for the request. If you specify a placeholder `Result` type in the
    /// request declaration, use the
    /// ``init(sortDescriptors:predicate:animation:)-4obxy`` initializer to
    /// let the request infer the entity type. If you need more control over
    /// the fetch request configuration, use ``init(fetchRequest:animation:)``.
    ///
    /// - Parameters:
    ///   - entity: The description of the Core Data entity to fetch.
    ///   - sortDescriptors: An array of sort descriptors that define the sort
    ///     order of the fetched results.
    ///   - predicate: An
    ///     
    ///     instance that defines logical conditions used to filter the fetched
    ///     results.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(entity: NSEntityDescription, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil, animation: Animation? = nil) { fatalError() }

    /// Creates a fully configured fetch request that uses the specified
    /// animation when updating results.
    ///
    /// Use this initializer when you want to configure a fetch
    /// request with more than a predicate and sort descriptors.
    /// For example, you can vend a request from a `Quake` managed object
    /// that the
    /// sample code project defines to store earthquake data.
    /// Limit the number of results to `1000` by setting a
    /// for the request:
    ///
    ///     extension Quake {
    ///         var request: NSFetchRequest<Quake> {
    ///             let request = NSFetchRequest<Quake>(entityName: "Quake")
    ///             request.sortDescriptors = [
    ///                 NSSortDescriptor(
    ///                     keyPath: \Quake.time,
    ///                     ascending: true)]
    ///             request.fetchLimit = 1000
    ///             return request
    ///         }
    ///     }
    ///
    /// Use the request to define a ``FetchedResults`` property:
    ///
    ///     @FetchRequest(fetchRequest: Quake.request)
    ///     private var quakes: FetchedResults<Quake>
    ///
    /// If you only need to configure the request's predicate and sort
    /// descriptors, use ``init(sortDescriptors:predicate:animation:)-462jp``
    /// instead. If you need to specify a ``Transaction`` rather than an
    /// optional ``Animation``, use ``init(fetchRequest:transaction:)``.
    ///
    /// - Parameters:
    ///   - fetchRequest: An
    ///     
    ///     instance that describes the search criteria for retrieving data
    ///     from the persistent store.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(fetchRequest: NSFetchRequest<Result>, animation: Animation? = nil) { fatalError() }

    /// Creates a fully configured fetch request that uses the specified
    /// transaction when updating results.
    ///
    /// Use this initializer if you need a fetch request with updates that
    /// affect the user interface based on a ``Transaction``. Otherwise, use
    /// ``init(fetchRequest:animation:)``.
    ///
    /// - Parameters:
    ///   - fetchRequest: An
    ///     
    ///     instance that describes the search criteria for retrieving data
    ///     from the persistent store.
    ///   - transaction: A transaction to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(fetchRequest: NSFetchRequest<Result>, transaction: Transaction) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension FetchRequest where Result : NSManagedObject {

    /// Creates a fetch request based on a predicate and reference type sort
    /// parameters.
    ///
    /// The request gets the entity type from the `Result` instance by calling
    /// that managed object's
    /// type method. If you need to specify the entity type explicitly, use the
    /// ``init(entity:sortDescriptors:predicate:animation:)`` initializer
    /// instead. If you need more control over the fetch request configuration,
    /// use ``init(fetchRequest:animation:)``. For value type sort
    /// descriptors, use ``init(sortDescriptors:predicate:animation:)-462jp``.
    ///
    /// - Parameters:
    ///   - sortDescriptors: An array of sort descriptors that define the sort
    ///     order of the fetched results.
    ///   - predicate: An
    ///     
    ///     instance that defines logical conditions used to filter the fetched
    ///     results.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil, animation: Animation? = nil) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension FetchRequest where Result : NSManagedObject {

    /// Creates a fetch request based on a predicate and value type sort
    /// parameters.
    ///
    /// The request gets the entity type from the `Result` instance by calling
    /// that managed object's
    /// type method. If you need to specify the entity type explicitly, use the
    /// ``init(entity:sortDescriptors:predicate:animation:)`` initializer
    /// instead. If you need more control over the fetch request configuration,
    /// use ``init(fetchRequest:animation:)``. For reference type sort
    /// descriptors, use ``init(sortDescriptors:predicate:animation:)-4obxy``.
    ///
    /// - Parameters:
    ///   - sortDescriptors: An array of sort descriptors that define the sort
    ///     order of the fetched results.
    ///   - predicate: An
    ///     
    ///     instance that defines logical conditions used to filter the fetched
    ///     results.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(sortDescriptors: [SortDescriptor<Result>], predicate: NSPredicate? = nil, animation: Animation? = nil) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension FetchRequest.Configuration where Result : NSManagedObject {

    /// The request's sort descriptors, accessed as value types.
    ///
    /// Set this configuration value to cause a ``FetchRequest`` to execute a
    /// fetch with a new collection of
    /// instances. If you want to use
    /// instances, set ``FetchRequest/Configuration/nsSortDescriptors`` instead.
    ///
    /// Access this value of a ``FetchRequest/Configuration`` structure for
    /// a given request by using the ``FetchedResults/sortDescriptors``
    /// property on the associated ``FetchedResults`` instance, either
    /// directly or through a ``Binding``.
    public var sortDescriptors: [SortDescriptor<Result>] { fatalError() }
}

/// A collection of results retrieved from a Core Data store.
///
/// Use a `FetchedResults` instance to show or edit Core Data managed objects in
/// your app's user interface. You request a particular set of results by
/// specifying a `Result` type as the entity type, and annotating the fetched
/// results property declaration with a ``FetchRequest`` property wrapper.
/// For example, you can create a request to list all `Quake` managed objects
/// that the
/// 
/// sample code project defines to store earthquake data, sorted by their
/// `time` property:
///
///     @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)])
///     private var quakes: FetchedResults<Quake>
///
/// The results instance conforms to
/// ,
/// so you access it like any other collection. For example, you can create
/// a ``List`` that iterates over all the results:
///
///     List(quakes) { quake in
///         NavigationLink(destination: QuakeDetail(quake: quake)) {
///             QuakeRow(quake: quake)
///         }
///     }
///
/// When you need to dynamically change the request's predicate or sort
/// descriptors, set the result instance's ``nsPredicate`` and
/// ``sortDescriptors`` or ``nsSortDescriptors`` properties, respectively.
///
/// The fetch request and its results use the managed object context stored
/// in the environment, which you can access using the
/// ``EnvironmentValues/managedObjectContext`` environment value. To
/// support user interface activity, you typically rely on the
/// 
/// property of a shared
/// 
/// instance. For example, you can set a context on your top level content
/// view using a container that you define as part of your model:
///
///     ContentView()
///         .environment(
///             \.managedObjectContext,
///             QuakesProvider.shared.container.viewContext)
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct FetchedResults<Result> : RandomAccessCollection where Result : NSFetchRequestResult {

    /// The request's sort descriptors, accessed as reference types.
    ///
    /// Set this value to cause the associated ``FetchRequest`` to execute
    /// a fetch with a new collection of
    /// instances.
    /// The order of managed objects stored in the results collection may change
    /// as a result.
    ///
    /// If you want to use
    /// instances, set ``FetchedResults/sortDescriptors`` instead.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var nsSortDescriptors: [NSSortDescriptor] { get { fatalError() } nonmutating set { } }

    /// The request's predicate.
    ///
    /// Set this value to cause the associated ``FetchRequest`` to execute a
    /// fetch with a new predicate, producing an updated collection of results.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var nsPredicate: NSPredicate? { get { fatalError() } nonmutating set { } }

    /// The index of the first entity in the results collection.
    public var startIndex: Int { get { fatalError() } }

    /// The index that's one greater than the last valid subscript argument.
    public var endIndex: Int { get { fatalError() } }

    /// Gets the entity at the specified index.
    public subscript(position: Int) -> Result { get { fatalError() } }

    /// A type representing the sequence's elements.
    public typealias Element = Result

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Range<Int>

    /// A type that provides the collection's iteration interface and
    /// encapsulates its iteration state.
    ///
    /// By default, a collection conforms to the `Sequence` protocol by
    /// supplying `IndexingIterator` as its associated `Iterator`
    /// type.
    public typealias Iterator = IndexingIterator<FetchedResults<Result>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<FetchedResults<Result>>
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension FetchedResults where Result : NSManagedObject {

    /// The request's sort descriptors, accessed as value types.
    ///
    /// Set this value to cause the associated ``FetchRequest`` to execute a
    /// fetch with a new collection of
    /// instances.
    /// The order of entities stored in the results collection may change
    /// as a result.
    ///
    /// If you want to use
    /// instances, set ``FetchedResults/nsSortDescriptors`` instead.
    public var sortDescriptors: [SortDescriptor<Result>] { get { fatalError() } nonmutating set { } }
}


/// A property wrapper type that retrieves entities, grouped into sections,
/// from a Core Data persistent store.
///
/// Use a `SectionedFetchRequest` property wrapper to declare a
/// ``SectionedFetchResults`` property that provides a grouped collection of
/// Core Data managed objects to a SkipUI view. If you don't need sectioning,
/// use ``FetchRequest`` instead.
///
/// Configure a sectioned fetch request with an optional predicate and sort
/// descriptors, and include a `sectionIdentifier` parameter to indicate how
/// to group the fetched results. Be sure that you choose sorting and sectioning
/// that work together to avoid discontiguous sections. For example, you can
/// request a list of earthquakes, composed of `Quake` managed objects that the
/// 
/// sample code project defines to store earthquake data, sorted by time and
/// grouped by date:
///
///     @SectionedFetchRequest<String, Quake>(
///         sectionIdentifier: \.day,
///         sortDescriptors: [SortDescriptor(\.time, order: .reverse)]
///     )
///     private var quakes: SectionedFetchResults<String, Quake>
///
/// Always declare properties that have a sectioned fetch request wrapper as
/// private. This lets the compiler help you avoid accidentally setting
/// the property from the memberwise initializer of the enclosing view.
///
/// The request infers the entity type from the `Result` type that you specify,
/// which is `Quake` in the example above. Indicate a `SectionIdentifier` type
/// to declare the type found at the fetched object's `sectionIdentifier`
/// key path. The section identifier type must conform to the
///  protocol.
///
/// The example above depends on the `Quake` type having a `day` property that's
/// either a stored or computed string. Be sure to mark any computed property
/// with the `@objc` attribute for it to function as a section identifier.
/// For best performance with large data sets, use stored properties.
///
/// The sectioned fetch request and its results use the managed object context
/// stored in the environment, which you can access using the
/// ``EnvironmentValues/managedObjectContext`` environment value. To
/// support user interface activity, you typically rely on the
/// 
/// property of a shared
/// 
/// instance. For example, you can set a context on your top-level content
/// view using a shared container that you define as part of your model:
///
///     ContentView()
///         .environment(
///             \.managedObjectContext,
///             QuakesProvider.shared.container.viewContext)
///
/// When you need to dynamically change the section identifier, predicate,
/// or sort descriptors, access the request's
/// ``SectionedFetchRequest/Configuration`` structure, either directly or with
/// a binding.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@MainActor @propertyWrapper public struct SectionedFetchRequest<SectionIdentifier, Result> where SectionIdentifier : Hashable, Result : NSFetchRequestResult {
    public init() { fatalError() }

    /// The fetched results of the fetch request.
    ///
    /// This property behaves like the ``FetchRequest/wrappedValue`` of a
    /// ``FetchRequest``. In particular, SkipUI returns the value associated
    /// with this property when you use ``SectionedFetchRequest`` as a property
    /// wrapper and then access the wrapped property by name. For example,
    /// consider the following `quakes` property declaration that fetches a
    /// `Quake` type that the
    /// sample code project defines:
    ///
    ///     @SectionedFetchRequest<String, Quake>(
    ///         sectionIdentifier: \.day,
    ///         sortDescriptors: [SortDescriptor(\.time, order: .reverse)]
    ///     )
    ///     private var quakes: SectionedFetchResults<String, Quake>
    ///
    /// You access the request's `wrappedValue`, which contains a
    /// ``SectionedFetchResults`` instance, by referring to the `quakes`
    /// property by name. That value is a collection
    /// of sections, each of which contains a group of managed objects:
    ///
    ///     Text("Found \(quakes.count) days of earthquakes")
    ///
    /// If you need to separate the request and the result
    /// entities, you can declare `quakes` in two steps by
    /// using the request's `wrappedValue` to obtain the results:
    ///
    ///     var fetchRequest = SectionedFetchRequest<String, Quake>(
    ///         fetchRequest: request,
    ///         sectionIdentifier: \.day)
    ///     var quakes: SectionedFetchedResults<String, Quake> { fetchRequest.wrappedValue }
    ///
    /// The `wrappedValue` property returns an empty array when there are no
    /// fetched results; for example, because no entities satisfy the
    /// predicate, or because the data store is empty.
    @MainActor public var wrappedValue: SectionedFetchResults<SectionIdentifier, Result> { get { fatalError() } }

    /// The request's configurable properties.
    ///
    /// You initialize a ``SectionedFetchRequest`` with a section identifier,
    /// an optional predicate, and sort descriptors, either explicitly or with
    /// a configured
    /// .
    /// Later, you can dynamically update the identifier, predicate, and sort
    /// parameters using the request's configuration structure.
    ///
    /// You access or bind to a request's configuration components through
    /// properties on the associated ``SectionedFetchResults`` instance,
    /// just like you do for a ``FetchRequest`` using
    /// ``FetchRequest/Configuration``.
    ///
    /// When configuring a sectioned fetch request, ensure that the
    /// combination of the section identifier and the primary sort descriptor
    /// doesn't create discontiguous sections.
    public struct Configuration {

        /// The request's section identifier key path.
        ///
        /// Set this configuration value to cause a ``SectionedFetchRequest``
        /// to execute a fetch with a new section identifier. You can't change
        /// the section identifier type without creating a new fetch request.
        /// Use care to coordinate section and sort updates, as described
        /// in ``SectionedFetchRequest/Configuration``.
        ///
        /// Access this value for a given request by using the
        /// ``SectionedFetchResults/sectionIdentifier`` property on the
        /// associated ``SectionedFetchResults`` instance, either directly or
        /// with a ``Binding``.
        public var sectionIdentifier: KeyPath<Result, SectionIdentifier>

        /// The request's sort descriptors, accessed as reference types.
        ///
        /// Set this configuration value to cause a ``SectionedFetchRequest``
        /// to execute a fetch with a new collection of
            /// instances. If you want to use
            /// instances, set ``SectionedFetchRequest/Configuration/sortDescriptors``
        /// instead. Use care to coordinate section and sort updates, as
        /// described in ``SectionedFetchRequest/Configuration``.
        ///
        /// Access this value for a given request by using the
        /// ``SectionedFetchResults/nsSortDescriptors`` property on the
        /// associated ``SectionedFetchResults`` instance, either directly or
        /// with a ``Binding``.
        public var nsSortDescriptors: [NSSortDescriptor]

        /// The request's predicate.
        ///
        /// Set this configuration value to cause a ``SectionedFetchRequest``
        /// to execute a fetch with a new predicate.
        ///
        /// Access this value for a given request by using the
        /// ``SectionedFetchResults/nsPredicate`` property on the associated
        /// ``SectionedFetchResults`` instance, either directly or with a
        /// ``Binding``.
        public var nsPredicate: NSPredicate?
    }

    /// A binding to the request's mutable configuration properties.
    ///
    /// This property behaves like the ``FetchRequest/projectedValue``
    /// of a ``FetchRequest``. In particular,
    /// SkipUI returns the value associated with this property when you use
    /// ``SectionedFetchRequest`` as a property wrapper on a
    /// ``SectionedFetchResults`` instance and then access the results with
    /// a dollar sign (`$`) prefix. The value that SkipUI returns is a
    /// ``Binding`` to the request's ``SectionedFetchRequest/Configuration``
    /// structure, which dynamically configures the request.
    @MainActor public var projectedValue: Binding<SectionedFetchRequest<SectionIdentifier, Result>.Configuration> { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SectionedFetchRequest : DynamicProperty {

    /// Updates the fetched results.
    ///
    /// SkipUI calls this function before rendering a view's
    /// ``View/body-swift.property`` to ensure the view has the most recent
    /// fetched results.
    @MainActor public func update() { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SectionedFetchRequest {

    /// Creates a sectioned fetch request for a specified entity description,
    /// based on a section identifier, a predicate, and sort parameters.
    ///
    /// Use this initializer if you need to explicitly specify the entity type
    /// for the request. If you specify a placeholder `Result` type in the
    /// request declaration, use the
    /// ``init(sectionIdentifier:sortDescriptors:predicate:animation:)-5lpfo``
    /// initializer to let the request infer the entity type. If you need more
    /// control over the fetch request configuration, use
    /// ``init(fetchRequest:sectionIdentifier:animation:)``.
    ///
    /// - Parameters:
    ///   - entity: The description of the Core Data entity to fetch.
    ///   - sectionIdentifier: A key path that SkipUI applies to the `Result`
    ///     type to get an object's section identifier.
    ///   - sortDescriptors: An array of sort descriptors that define the sort
    ///     order of the fetched results.
    ///   - predicate: An
    ///     
    ///     instance that defines logical conditions used to filter the fetched
    ///     results.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(entity: NSEntityDescription, sectionIdentifier: KeyPath<Result, SectionIdentifier>, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil, animation: Animation? = nil) { fatalError() }

    /// Creates a fully configured sectioned fetch request that uses the
    /// specified animation when updating results.
    ///
    /// Use this initializer when you want to configure a fetch
    /// request with more than a predicate and sort descriptors.
    /// For example, you can vend a request from a `Quake` managed object
    /// that the
    /// sample code project defines to store earthquake data.
    /// Limit the number of results to `1000` by setting a
    /// for the request:
    ///
    ///     extension Quake {
    ///         var request: NSFetchRequest<Quake> {
    ///             let request = NSFetchRequest<Quake>(entityName: "Quake")
    ///             request.sortDescriptors = [
    ///                 NSSortDescriptor(
    ///                     keyPath: \Quake.time,
    ///                     ascending: true)]
    ///             request.fetchLimit = 1000
    ///             return request
    ///         }
    ///     }
    ///
    /// Use the request to define a ``SectionedFetchedResults`` property:
    ///
    ///     @SectionedFetchRequest<String, Quake>(
    ///         fetchRequest: Quake.request,
    ///         sectionIdentifier: \.day)
    ///     private var quakes: FetchedResults<String, Quake>
    ///
    /// If you only need to configure the request's section identifier,
    /// predicate, and sort descriptors, use
    /// ``init(sectionIdentifier:sortDescriptors:predicate:animation:)-5lpfo``
    /// instead. If you need to specify a ``Transaction`` rather than an
    /// optional ``Animation``, use
    /// ``init(fetchRequest:sectionIdentifier:transaction:)``.
    ///
    /// - Parameters:
    ///   - fetchRequest: An
    ///     
    ///     instance that describes the search criteria for retrieving data
    ///     from the persistent store.
    ///   - sectionIdentifier: A key path that SkipUI applies to the `Result`
    ///     type to get an object's section identifier.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(fetchRequest: NSFetchRequest<Result>, sectionIdentifier: KeyPath<Result, SectionIdentifier>, animation: Animation? = nil) { fatalError() }

    /// Creates a fully configured sectioned fetch request that uses the
    /// specified transaction when updating results.
    ///
    /// Use this initializer if you need a fetch request with updates that
    /// affect the user interface based on a ``Transaction``. Otherwise, use
    /// ``init(fetchRequest:sectionIdentifier:animation:)``.
    ///
    /// - Parameters:
    ///   - fetchRequest: An
    ///     
    ///     instance that describes the search criteria for retrieving data
    ///     from the persistent store.
    ///   - sectionIdentifier: A key path that SkipUI applies to the `Result`
    ///     type to get an object's section identifier.
    ///   - transaction: A transaction to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(fetchRequest: NSFetchRequest<Result>, sectionIdentifier: KeyPath<Result, SectionIdentifier>, transaction: Transaction) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SectionedFetchRequest where Result : NSManagedObject {

    /// Creates a sectioned fetch request based on a section identifier, a
    /// predicate, and reference type sort parameters.
    ///
    /// The request gets the entity type from the `Result` instance by calling
    /// that managed object's
    /// type method. If you need to specify the entity type explicitly, use the
    /// ``init(entity:sectionIdentifier:sortDescriptors:predicate:animation:)``
    /// initializer instead. If you need more control over the fetch request
    /// configuration, use ``init(fetchRequest:sectionIdentifier:animation:)``.
    /// For value type sort descriptors, use
    /// ``init(sectionIdentifier:sortDescriptors:predicate:animation:)-5l7hu``.
    ///
    /// - Parameters:
    ///   - sectionIdentifier: A key path that SkipUI applies to the `Result`
    ///     type to get an object's section identifier.
    ///   - sortDescriptors: An array of sort descriptors that define the sort
    ///     order of the fetched results.
    ///   - predicate: An
    ///     
    ///     instance that defines logical conditions used to filter the fetched
    ///     results.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(sectionIdentifier: KeyPath<Result, SectionIdentifier>, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil, animation: Animation? = nil) { fatalError() }

    /// Creates a sectioned fetch request based on a section identifier,
    /// a predicate, and value type sort parameters.
    ///
    /// The request gets the entity type from the `Result` instance by calling
    /// that managed object's
    /// type method. If you need to specify the entity type explicitly, use the
    /// ``init(entity:sectionIdentifier:sortDescriptors:predicate:animation:)``
    /// initializer instead. If you need more control over the fetch request
    /// configuration, use ``init(fetchRequest:sectionIdentifier:animation:)``.
    /// For reference type sort descriptors, use
    /// ``init(sectionIdentifier:sortDescriptors:predicate:animation:)-5lpfo``.
    ///
    /// - Parameters:
    ///   - sectionIdentifier: A key path that SkipUI applies to the `Result`
    ///     type to get an object's section identifier.
    ///   - sortDescriptors: An array of sort descriptors that define the sort
    ///     order of the fetched results.
    ///   - predicate: An
    ///     
    ///     instance that defines logical conditions used to filter the fetched
    ///     results.
    ///   - animation: The animation to use for user interface changes that
    ///     result from changes to the fetched results.
    @MainActor public init(sectionIdentifier: KeyPath<Result, SectionIdentifier>, sortDescriptors: [SortDescriptor<Result>], predicate: NSPredicate? = nil, animation: Animation? = nil) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SectionedFetchRequest.Configuration where Result : NSManagedObject {

    /// The request's sort descriptors, accessed as value types.
    ///
    /// Set this configuration value to cause a ``SectionedFetchRequest`` to
    /// execute a fetch with a new collection of
    /// instances. If you want to use
    /// instances, set ``SectionedFetchRequest/Configuration/nsSortDescriptors``
    /// instead. Use care to coordinate section and sort updates, as described
    /// in ``SectionedFetchRequest/Configuration``.
    ///
    /// Access this value for a given request by using the
    /// ``SectionedFetchResults/sortDescriptors`` property on the associated
    /// ``SectionedFetchResults`` instance, either directly or with a
    /// ``Binding``.
    public var sortDescriptors: [SortDescriptor<Result>] { get { fatalError() } }
}

/// A collection of results retrieved from a Core Data persistent store,
/// grouped into sections.
///
/// Use a `SectionedFetchResults` instance to show or edit Core Data managed
/// objects, grouped into sections, in your app's user interface. If you
/// don't need sectioning, use ``FetchedResults`` instead.
///
/// You request a particular set of results by annotating the fetched results
/// property declaration with a ``SectionedFetchRequest`` property wrapper.
/// Indicate the type of the fetched entities with a `Results` type,
/// and the type of the identifier that distinguishes the sections with
/// a `SectionIdentifier` type. For example, you can create a request to list
/// all `Quake` managed objects that the
/// 
/// sample code project defines to store earthquake data, sorted by their `time`
/// property and grouped by a string that represents the days when earthquakes
/// occurred:
///
///     @SectionedFetchRequest<String, Quake>(
///         sectionIdentifier: \.day,
///         sortDescriptors: [SortDescriptor(\.time, order: .reverse)]
///     )
///     private var quakes: SectionedFetchResults<String, Quake>
///
/// The `quakes` property acts as a collection of ``Section`` instances, each
/// containing a collection of `Quake` instances. The example above depends
/// on the `Quake` model object declaring both `time` and `day`
/// properties, either stored or computed. For best performance with large
/// data sets, use stored properties.
///
/// The collection of sections, as well as the collection of managed objects in
/// each section, conforms to the
/// 
/// protocol, so you can access them as you would any other collection. For
/// example, you can create nested ``ForEach`` loops inside a ``List`` to
/// iterate over the results:
///
///     List {
///         ForEach(quakes) { section in
///             Section(header: Text(section.id)) {
///                 ForEach(section) { quake in
///                     QuakeRow(quake: quake) // Displays information about a quake.
///                 }
///             }
///         }
///     }
///
/// Don't confuse the ``SkipUI/Section`` view that you use to create a
/// hierarchical display with the ``SectionedFetchResults/Section``
/// instances that hold the fetched results.
///
/// When you need to dynamically change the request's section identifier,
/// predicate, or sort descriptors, set the result instance's
/// ``sectionIdentifier``, ``nsPredicate``, and ``sortDescriptors`` or
/// ``nsSortDescriptors`` properties, respectively. Be sure that the sorting
/// and sectioning work together to avoid discontinguous sections.
///
/// The fetch request and its results use the managed object context stored
/// in the environment, which you can access using the
/// ``EnvironmentValues/managedObjectContext`` environment value. To
/// support user interface activity, you typically rely on the
/// 
/// property of a shared
/// 
/// instance. For example, you can set a context on your top-level content
/// view using a container that you define as part of your model:
///
///     ContentView()
///         .environment(
///             \.managedObjectContext,
///             QuakesProvider.shared.container.viewContext)
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct SectionedFetchResults<SectionIdentifier, Result> : RandomAccessCollection where SectionIdentifier : Hashable, Result : NSFetchRequestResult {

    /// A collection of fetched results that share a specified identifier.
    ///
    /// Examine a `Section` instance to find the entities that satisfy a
    /// ``SectionedFetchRequest`` predicate, and that have a particular property
    /// with the value stored in the section's ``id-swift.property-1h7qm``
    /// parameter. You specify which property by setting the fetch request's
    /// `sectionIdentifier` parameter during initialization, or by modifying
    /// the corresponding ``SectionedFetchResults`` instance's
    /// ``SectionedFetchResults/sectionIdentifier`` property.
    ///
    /// Obtain specific sections by treating the fetch results as a collection.
    /// For example, consider the following property declaration
    /// that fetches `Quake` managed objects that the
    /// sample code project defines to store earthquake data:
    ///
    ///     @SectionedFetchRequest<String, Quake>(
    ///         sectionIdentifier: \.day,
    ///         sortDescriptors: [SortDescriptor(\.time, order: .reverse)]
    ///     )
    ///     private var quakes: SectionedFetchResults<String, Quake>
    ///
    /// Get the first section using a subscript:
    ///
    ///     let firstSection = quakes[0]
    ///
    /// Alternatively, you can loop over the sections to create a list of
    /// sections.
    ///
    ///     ForEach(quakes) { section in
    ///         Text("Section \(section.id) has \(section.count) elements")
    ///     }
    ///
    /// The sections also act as collections, which means you can use operations
    /// like the ``Section/count`` method in the example above.
    public struct Section : Identifiable, RandomAccessCollection {

        /// The index of the first entity in the section.
        public var startIndex: Int { get { fatalError() } }

        /// The index that's one greater than that of the last entity in the
        /// section.
        public var endIndex: Int { get { fatalError() } }

        /// Gets the entity at the specified index within the section.
        public subscript(position: Int) -> Result { get { fatalError() } }

        /// The value that all entities in the section share for a specified
        /// key path.
        ///
        /// Specify the key path that the entities share this value with
        /// by setting the ``SectionedFetchRequest``
        /// instance's `sectionIdentifier` parameter during initialization,
        /// or by modifying the corresponding ``SectionedFetchResults``
        /// instance's ``SectionedFetchResults/sectionIdentifier`` property.
        public let id: SectionIdentifier = { fatalError() }()

        /// A type representing the sequence's elements.
        public typealias Element = Result

        /// A type representing the stable identity of the entity associated with
        /// an instance.
        public typealias ID = SectionIdentifier

        /// A type that represents a position in the collection.
        ///
        /// Valid indices consist of the position of every element and a
        /// "past the end" position that's not valid for use as a subscript
        /// argument.
        public typealias Index = Int

        /// A type that represents the indices that are valid for subscripting the
        /// collection, in ascending order.
        public typealias Indices = Range<Int>

        /// A type that provides the collection's iteration interface and
        /// encapsulates its iteration state.
        ///
        /// By default, a collection conforms to the `Sequence` protocol by
        /// supplying `IndexingIterator` as its associated `Iterator`
        /// type.
        public typealias Iterator = IndexingIterator<SectionedFetchResults<SectionIdentifier, Result>.Section>

        /// A collection representing a contiguous subrange of this collection's
        /// elements. The subsequence shares indices with the original collection.
        ///
        /// The default subsequence type for collections that don't define their own
        /// is `Slice`.
        public typealias SubSequence = Slice<SectionedFetchResults<SectionIdentifier, Result>.Section>
    }

    /// The request's sort descriptors, accessed as reference types.
    ///
    /// Set this value to cause the associated ``SectionedFetchRequest`` to
    /// execute a fetch with a new collection of
    /// instances.
    /// The order of managed objects stored in the results collection may change
    /// as a result. Use care to coordinate section and sort updates, as
    /// described in ``SectionedFetchRequest/Configuration``.
    ///
    /// If you want to use
    /// instances, set ``SectionedFetchResults/sortDescriptors`` instead.
    public var nsSortDescriptors: [NSSortDescriptor] { get { fatalError() } nonmutating set { } }

    /// The request's predicate.
    ///
    /// Set this value to cause the associated ``SectionedFetchRequest`` to
    /// execute a fetch with a new predicate, producing an updated collection
    /// of results.
    public var nsPredicate: NSPredicate? { get { fatalError() } nonmutating set { } }

    /// The key path that the system uses to group fetched results into sections.
    ///
    /// Set this value to cause the associated ``SectionedFetchRequest`` to
    /// execute a fetch with a new section identifier, producing an updated
    /// collection of results. Changing this value produces a new set of
    /// sections. Use care to coordinate section and sort updates, as described
    /// in ``SectionedFetchRequest/Configuration``.
    public var sectionIdentifier: KeyPath<Result, SectionIdentifier> { get { fatalError() } nonmutating set { } }

    /// The index of the first section in the results collection.
    public var startIndex: Int { get { fatalError() } }

    /// The index that's one greater than that of the last section.
    public var endIndex: Int { get { fatalError() } }

    /// Gets the section at the specified index.
    public subscript(position: Int) -> SectionedFetchResults<SectionIdentifier, Result>.Section { get { fatalError() } }

    /// A type representing the sequence's elements.
    public typealias Element = SectionedFetchResults<SectionIdentifier, Result>.Section

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Int

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Range<Int>

    /// A type that provides the collection's iteration interface and
    /// encapsulates its iteration state.
    ///
    /// By default, a collection conforms to the `Sequence` protocol by
    /// supplying `IndexingIterator` as its associated `Iterator`
    /// type.
    public typealias Iterator = IndexingIterator<SectionedFetchResults<SectionIdentifier, Result>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<SectionedFetchResults<SectionIdentifier, Result>>
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension SectionedFetchResults where Result : NSManagedObject {

    /// The request's sort descriptors, accessed as value types.
    ///
    /// Set this value to cause the associated ``SectionedFetchRequest`` to
    /// execute a fetch with a new collection of
    /// instances. The order of entities stored in the results collection may
    /// change as a result. Use care to coordinate section and sort updates, as
    /// described in ``SectionedFetchRequest/Configuration``.
    ///
    /// If you want to use
    /// instances, set ``SectionedFetchResults/nsSortDescriptors`` instead.
    public var sortDescriptors: [SortDescriptor<Result>] { get { fatalError() } nonmutating set { } }
}

#endif


#endif
