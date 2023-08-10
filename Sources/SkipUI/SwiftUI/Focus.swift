// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP
import protocol Combine.ObservableObject

/// Values describe different focus interactions that a view can support.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct FocusInteractions : OptionSet, Sendable {

    /// The view has a primary action that can be activated via focus gestures.
    ///
    /// On macOS and iOS, focus-driven activation interactions are only possible
    /// when all-controls keyboard navigation is enabled. On tvOS and watchOS,
    /// focus-driven activation interactions are always possible.
    public static let activate: FocusInteractions = { fatalError() }()

    /// The view captures input from non-spatial sources like a keyboard or
    /// Digital Crown.
    ///
    /// Views that support focus-driven editing interactions become focused when
    /// the user taps or clicks on them, or when the user issues a focus
    /// movement command.
    public static let edit: FocusInteractions = { fatalError() }()

    /// The view supports whatever focus-driven interactions are commonly
    /// expected for interactive content on the current platform.
    public static var automatic: FocusInteractions { get { fatalError() } }

    /// The corresponding value of the raw type.
    ///
    /// A new instance initialized with `rawValue` will be equivalent to this
    /// instance. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     let selectedSize = PaperSize.Letter
    ///     print(selectedSize.rawValue)
    ///     // Prints "Letter"
    ///
    ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
    ///     // Prints "true"
    public var rawValue: Int { get { fatalError() } }

    /// Creates a new option set from the given raw value.
    ///
    /// This initializer always succeeds, even if the value passed as `rawValue`
    /// exceeds the static properties declared as part of the option set. This
    /// example creates an instance of `ShippingOptions` with a raw value beyond
    /// the highest element, with a bit mask that effectively contains all the
    /// declared static members.
    ///
    ///     let extraOptions = ShippingOptions(rawValue: 255)
    ///     print(extraOptions.isStrictSuperset(of: .all))
    ///     // Prints "true"
    ///
    /// - Parameter rawValue: The raw value of the option set to create. Each bit
    ///   of `rawValue` potentially represents an element of the option set,
    ///   though raw values may include bits that are not defined as distinct
    ///   values of the `OptionSet` type.
    public init(rawValue: Int) { fatalError() }

    /// The type of the elements of an array literal.
    public typealias ArrayLiteralElement = FocusInteractions

    /// The element type of the option set.
    ///
    /// To inherit all the default implementations from the `OptionSet` protocol,
    /// the `Element` type must be `Self`, the default.
    public typealias Element = FocusInteractions

    /// The raw type that can be used to represent all values of the conforming
    /// type.
    ///
    /// Every distinct value of the conforming type has a corresponding unique
    /// value of the `RawValue` type, but there may be values of the `RawValue`
    /// type that don't have a corresponding value of the conforming type.
    public typealias RawValue = Int
}

/// A property wrapper type that can read and write a value that SkipUI updates
/// as the placement of focus within the scene changes.
///
/// Use this property wrapper in conjunction with ``View/focused(_:equals:)``
/// and ``View/focused(_:)`` to
/// describe views whose appearance and contents relate to the location of
/// focus in the scene. When focus enters the modified view, the wrapped value
/// of this property updates to match a given prototype value. Similarly, when
/// focus leaves, the wrapped value of this property resets to `nil`
/// or `false`. Setting the property's value programmatically has the reverse
/// effect, causing focus to move to the view associated with the
/// updated value.
///
/// In the following example of a simple login screen, when the user presses the
/// Sign In button and one of the fields is still empty, focus moves to that
/// field. Otherwise, the sign-in process proceeds.
///
///     struct LoginForm {
///         enum Field: Hashable {
///             case username
///             case password
///         }
///
///         @State private var username = ""
///         @State private var password = ""
///         @FocusState private var focusedField: Field?
///
///         var body: some View {
///             Form {
///                 TextField("Username", text: $username)
///                     .focused($focusedField, equals: .username)
///
///                 SecureField("Password", text: $password)
///                     .focused($focusedField, equals: .password)
///
///                 Button("Sign In") {
///                     if username.isEmpty {
///                         focusedField = .username
///                     } else if password.isEmpty {
///                         focusedField = .password
///                     } else {
///                         handleLogin(username, password)
///                     }
///                 }
///             }
///         }
///     }
///
/// To allow for cases where focus is completely absent from a view tree, the
/// wrapped value must be either an optional or a Boolean. Set the focus binding
/// to `false` or `nil` as appropriate to remove focus from all bound fields.
/// You can also use this to remove focus from a ``TextField`` and thereby
/// dismiss the keyboard.
///
/// ### Avoid ambiguous focus bindings
///
/// The same view can have multiple focus bindings. In the following example,
/// setting `focusedField` to either `name` or `fullName` causes the field
/// to receive focus:
///
///     struct ContentView: View {
///         enum Field: Hashable {
///             case name
///             case fullName
///         }
///         @FocusState private var focusedField: Field?
///
///         var body: some View {
///             TextField("Full Name", ...)
///                 .focused($focusedField, equals: .name)
///                 .focused($focusedField, equals: .fullName)
///         }
///     }
///
/// On the other hand, binding the same value to two views is ambiguous. In
/// the following example, two separate fields bind focus to the `name` value:
///
///     struct ContentView: View {
///         enum Field: Hashable {
///             case name
///             case fullName
///         }
///         @FocusState private var focusedField: Field?
///
///         var body: some View {
///             TextField("Name", ...)
///                 .focused($focusedField, equals: .name)
///             TextField("Full Name", ...)
///                 .focused($focusedField, equals: .name) // incorrect re-use of .name
///         }
///     }
///
/// If the user moves focus to either field, the `focusedField` binding updates
/// to `name`. However, if the app programmatically sets the value to `name`,
/// SkipUI chooses the first candidate, which in this case is the "Name"
/// field. SkipUI also emits a runtime warning in this case, since the repeated
/// binding is likely a programmer error.
///
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@frozen @propertyWrapper public struct FocusState<Value> : DynamicProperty where Value : Hashable {

    /// A property wrapper type that can read and write a value that indicates
    /// the current focus location.
    @frozen @propertyWrapper public struct Binding {

        /// The underlying value referenced by the bound property.
        public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

        /// A projection of the binding value that returns a binding.
        ///
        /// Use the projected value to pass a binding value down a view
        /// hierarchy.
        public var projectedValue: FocusState<Value>.Binding { get { fatalError() } }

        public init(wrappedValue: Value) { fatalError() }

    }

    /// The current state value, taking into account whatever bindings might be
    /// in effect due to the current location of focus.
    ///
    /// When focus is not in any view that is bound to this state, the wrapped
    /// value will be `nil` (for optional-typed state) or `false` (for `Bool`-
    /// typed state).
    public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

    /// A projection of the focus state value that returns a binding.
    ///
    /// When focus is outside any view that is bound to this state, the wrapped
    /// value is `nil` for optional-typed state or `false` for Boolean state.
    ///
    /// In the following example of a simple navigation sidebar, when the user
    /// presses the Filter Sidebar Contents button, focus moves to the sidebar's
    /// filter text field. Conversely, if the user moves focus to the sidebar's
    /// filter manually, then the value of `isFiltering` automatically
    /// becomes `true`, and the sidebar view updates.
    ///
    ///     struct Sidebar: View {
    ///         @State private var filterText = ""
    ///         @FocusState private var isFiltering: Bool
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Button("Filter Sidebar Contents") {
    ///                     isFiltering = true
    ///                 }
    ///
    ///                 TextField("Filter", text: $filterText)
    ///                     .focused($isFiltering)
    ///             }
    ///         }
    ///     }
    public var projectedValue: FocusState<Value>.Binding { get { fatalError() } }

    /// Creates a focus state that binds to a Boolean.
    public init() where Value == Bool { fatalError() }

    /// Creates a focus state that binds to an optional type.
    public init<T>() where Value == T?, T : Hashable { fatalError() }
}

/// A convenience property wrapper for observing and automatically unwrapping
/// state bindings from the focused view or one of its ancestors.
///
/// If multiple views publish bindings using the same key, the wrapped property
/// will reflect the value of the binding from the view closest to focus.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper public struct FocusedBinding<Value> : DynamicProperty {

    /// A new property wrapper for the given key path.
    ///
    /// The value of the property wrapper is updated dynamically as focus
    /// changes and different published bindings go in and out of scope.
    ///
    /// - Parameter keyPath: The key path for the focus value to read.
    public init(_ keyPath: KeyPath<FocusedValues, Binding<Value>?>) { fatalError() }

    /// The unwrapped value for the focus key given the current scope and state
    /// of the focused view hierarchy.
    @inlinable public var wrappedValue: Value? { get { fatalError() } nonmutating set { fatalError() } }

    /// A binding to the optional value.
    ///
    /// The unwrapped value is `nil` when no focused view hierarchy has
    /// published a corresponding binding.
    public var projectedValue: Binding<Value?> { get { fatalError() } }
}

/// A property wrapper type for an observable object supplied by the focused
/// view or one of its ancestors.
///
/// Focused objects invalidate the current view whenever the observable object
/// changes. If multiple views publish a focused object using the same key, the
/// wrapped property will reflect the object that's closest to the focused view.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@frozen @propertyWrapper public struct FocusedObject<ObjectType> : DynamicProperty where ObjectType : ObservableObject {

    /// A wrapper around the underlying focused object that can create bindings
    /// to its properties using dynamic member lookup.
    @dynamicMemberLookup @frozen public struct Wrapper {

        /// Returns a binding to the value of a given key path.
        ///
        /// - Parameter keyPath: A key path to a specific value on the
        ///   wrapped object.
        /// - Returns: A new binding.
        public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, T>) -> Binding<T> { get { fatalError() } }
    }

    /// The underlying value referenced by the focused object.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the ``FocusedObject`` attribute.
    ///
    /// When a mutable value changes, the new value is immediately available.
    /// However, a view displaying the value is updated asynchronously and may
    /// not show the new value immediately.
    @MainActor @inlinable public var wrappedValue: ObjectType? { get { fatalError() } }

    /// A projection of the focused object that creates bindings to its
    /// properties using dynamic member lookup.
    ///
    /// Use the projected value to pass a focused object down a view hierarchy.
    @MainActor public var projectedValue: FocusedObject<ObjectType>.Wrapper? { get { fatalError() } }

    /// Creates a focused object.
    public init() { fatalError() }
}

/// A property wrapper for observing values from the focused view or one of its
/// ancestors.
///
/// If multiple views publish values using the same key, the wrapped property
///  will reflect the value from the view closest to focus.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper public struct FocusedValue<Value> : DynamicProperty {

    /// A new property wrapper for the given key path.
    ///
    /// The value of the property wrapper is updated dynamically as focus
    /// changes and different published values go in and out of scope.
    ///
    /// - Parameter keyPath: The key path for the focus value to read.
    public init(_ keyPath: KeyPath<FocusedValues, Value?>) { fatalError() }

    /// The value for the focus key given the current scope and state of the
    /// focused view hierarchy.
    ///
    /// Returns `nil` when nothing in the focused view hierarchy exports a
    /// value.
    @inlinable public var wrappedValue: Value? { get { fatalError() } }
}

/// A protocol for identifier types used when publishing and observing focused
/// values.
///
/// Unlike ``EnvironmentKey``, `FocusedValueKey` has no default value
/// requirement, because the default value for a key is always `nil`.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol FocusedValueKey {

    associatedtype Value
}

/// A collection of state exported by the focused view and its ancestors.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct FocusedValues {

    /// Reads and writes values associated with a given focused value key.
    public subscript<Key>(key: Key.Type) -> Key.Value? where Key : FocusedValueKey { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension FocusedValues : Equatable {
}

#endif
