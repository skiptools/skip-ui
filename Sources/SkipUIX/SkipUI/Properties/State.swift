// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import Observation
//import protocol Observation.Observable

/// A property wrapper type that can read and write a value managed by SkipUI.
///
/// Use state as the single source of truth for a given value type that you
/// store in a view hierarchy. Create a state value in an ``App``, ``Scene``,
/// or ``View`` by applying the `@State` attribute to a property declaration
/// and providing an initial value. Declare state as private to prevent setting
/// it in a memberwise initializer, which can conflict with the storage
/// management that SkipUI provides:
///
///     struct PlayButton: View {
///         @State private var isPlaying: Bool = false // Create the state.
///
///         var body: some View {
///             Button(isPlaying ? "Pause" : "Play") { // Read the state.
///                 isPlaying.toggle() // Write the state.
///             }
///         }
///     }
///
/// SkipUI manages the property's storage. When the value changes, SkipUI
/// updates the parts of the view hierarchy that depend on the value.
/// To access a state's underlying value, you use its ``wrappedValue`` property.
/// However, as a shortcut Swift enables you to access the wrapped value by
/// referring directly to the state instance. The above example reads and
/// writes the `isPlaying` state property's wrapped value by referring to the
/// property directly.
///
/// Declare state as private in the highest view in the view hierarchy that
/// needs access to the value. Then share the state with any subviews that also
/// need access, either directly for read-only access, or as a binding for
/// read-write access. You can safely mutate state properties from any thread.
///
/// > Note: If you need to store a reference type, like an instance of a class,
///   use a ``StateObject`` instead.
///
/// ### Share state with subviews
///
/// If you pass a state property to a subview, SkipUI updates the subview
/// any time the value changes in the container view, but the subview can't
/// modify the value. To enable the subview to modify the state's stored value,
/// pass a ``Binding`` instead. You can get a binding to a state value by
/// accessing the state's ``projectedValue``, which you get by prefixing the
/// property name with a dollar sign (`$`).
///
/// For example, you can remove the `isPlaying` state from the play button in
/// the above example, and instead make the button take a binding:
///
///     struct PlayButton: View {
///         @Binding var isPlaying: Bool // Play button now receives a binding.
///
///         var body: some View {
///             Button(isPlaying ? "Pause" : "Play") {
///                 isPlaying.toggle()
///             }
///         }
///     }
///
/// Then you can define a player view that declares the state and creates a
/// binding to the state using the dollar sign prefix:
///
///     struct PlayerView: View {
///         @State private var isPlaying: Bool = false // Create the state here now.
///
///         var body: some View {
///             VStack {
///                 PlayButton(isPlaying: $isPlaying) // Pass a binding.
///
///                 // ...
///             }
///         }
///     }
///
/// Like you do for a ``StateObject``, declare ``State`` as private to prevent
/// setting it in a memberwise initializer, which can conflict with the storage
/// management that SkipUI provides. Unlike a state object, always
/// initialize state by providing a default value in the state's
/// declaration, as in the above examples. Use state only for storage that's
/// local to a view and its subviews.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen @propertyWrapper public struct State<Value> : DynamicProperty {

    /// Creates a state property that stores an initial wrapped value.
    ///
    /// You don't call this initializer directly. Instead, SkipUI
    /// calls it for you when you declare a property with the `@State`
    /// attribute and provide an initial value:
    ///
    ///     struct MyView: View {
    ///         @State private var isPlaying: Bool = false
    ///
    ///         // ...
    ///     }
    ///
    /// SkipUI initializes the state's storage only once for each
    /// container instance that you declare. In the above code, SkipUI
    /// creates `isPlaying` only the first time it initializes a particular
    /// instance of `MyView`. On the other hand, each instance of `MyView`
    /// creates a distinct instance of the state. For example, each of
    /// the views in the following ``VStack`` has its own `isPlaying` value:
    ///
    ///     var body: some View {
    ///         VStack {
    ///             MyView()
    ///             MyView()
    ///         }
    ///     }
    ///
    /// - Parameter value: An initial value to store in the state
    ///   property.
    public init(wrappedValue value: Value) { fatalError() }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init(wrappedValue thunk: @autoclosure @escaping () -> Value) where Value : AnyObject, Value : Observable { fatalError() }

    /// Creates a state property that stores an initial value.
    ///
    /// This initializer has the same behavior as the ``init(wrappedValue:)``
    /// initializer. See that initializer for more information.
    ///
    /// - Parameter value: An initial value to store in the state
    ///   property.
    public init(initialValue value: Value) { fatalError() }

    /// The underlying value referenced by the state variable.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't typically access `wrappedValue` explicitly. Instead, you gain
    /// access to the wrapped value by referring to the property variable that
    /// you create with the `@State` attribute.
    ///
    /// In the following example, the button's label depends on the value of
    /// `isPlaying` and the button's action toggles the value of `isPlaying`.
    /// Both of these accesses implicitly access the state property's wrapped
    /// value:
    ///
    ///     struct PlayButton: View {
    ///         @State private var isPlaying: Bool = false
    ///
    ///         var body: some View {
    ///             Button(isPlaying ? "Pause" : "Play") {
    ///                 isPlaying.toggle()
    ///             }
    ///         }
    ///     }
    ///
    public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

    /// A binding to the state value.
    ///
    /// Use the projected value to get a ``Binding`` to the stored value. The
    /// binding provides a two-way connection to the stored value. To access
    /// the `projectedValue`, prefix the property variable with a dollar
    /// sign (`$`).
    ///
    /// In the following example, `PlayerView` projects a binding of the state
    /// property `isPlaying` to the `PlayButton` view using `$isPlaying`. That
    /// enables the play button to both read and write the value:
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var isPlaying: Bool = false
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                     .foregroundStyle(isPlaying ? .primary : .secondary)
    ///                 PlayButton(isPlaying: $isPlaying)
    ///             }
    ///         }
    ///     }
    ///
    public var projectedValue: Binding<Value> { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension State where Value : ExpressibleByNilLiteral {

    /// Creates a state property without an initial value.
    ///
    /// This initializer behaves like the ``init(wrappedValue:)`` initializer
    /// with an input of `nil`. See that initializer for more information.
    @inlinable public init() { fatalError() }
}

#endif
