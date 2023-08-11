// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP

import Combine
import Observation


/// A property wrapper type that can read and write a value owned by a source of
/// truth.
///
/// Use a binding to create a two-way connection between a property that stores
/// data, and a view that displays and changes the data. A binding connects a
/// property to a source of truth stored elsewhere, instead of storing data
/// directly. For example, a button that toggles between play and pause can
/// create a binding to a property of its parent view using the `Binding`
/// property wrapper.
///
///     struct PlayButton: View {
///         @Binding var isPlaying: Bool
///
///         var body: some View {
///             Button(isPlaying ? "Pause" : "Play") {
///                 isPlaying.toggle()
///             }
///         }
///     }
///
/// The parent view declares a property to hold the playing state, using the
/// ``State`` property wrapper to indicate that this property is the value's
/// source of truth.
///
///     struct PlayerView: View {
///         var episode: Episode
///         @State private var isPlaying: Bool = false
///
///         var body: some View {
///             VStack {
///                 Text(episode.title)
///                     .foregroundStyle(isPlaying ? .primary : .secondary)
///                 PlayButton(isPlaying: $isPlaying) // Pass a binding.
///             }
///         }
///     }
///
/// When `PlayerView` initializes `PlayButton`, it passes a binding of its state
/// property into the button's binding property. Applying the `$` prefix to a
/// property wrapped value returns its ``State/projectedValue``, which for a
/// state property wrapper returns a binding to the value.
///
/// Whenever the user taps the `PlayButton`, the `PlayerView` updates its
/// `isPlaying` state.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {

    /// The binding's transaction.
    ///
    /// The transaction captures the information needed to update the view when
    /// the binding value changes.
    public var transaction: Transaction { get { fatalError() } }

    /// Creates a binding with closures that read and write the binding value.
    ///
    /// - Parameters:
    ///   - get: A closure that retrieves the binding value. The closure has no
    ///     parameters, and returns a value.
    ///   - set: A closure that sets the binding value. The closure has the
    ///     following parameter:
    ///       - newValue: The new value of the binding value.
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) { fatalError() }

    /// Creates a binding with a closure that reads from the binding value, and
    /// a closure that applies a transaction when writing to the binding value.
    ///
    /// - Parameters:
    ///   - get: A closure to retrieve the binding value. The closure has no
    ///     parameters, and returns a value.
    ///   - set: A closure to set the binding value. The closure has the
    ///     following parameters:
    ///       - newValue: The new value of the binding value.
    ///       - transaction: The transaction to apply when setting a new value.
    public init(get: @escaping () -> Value, set: @escaping (Value, Transaction) -> Void) { fatalError() }

    /// Creates a binding with an immutable value.
    ///
    /// Use this method to create a binding to a value that cannot change.
    /// This can be useful when using a ``PreviewProvider`` to see how a view
    /// represents different values.
    ///
    ///     // Example of binding to an immutable value.
    ///     PlayButton(isPlaying: Binding.constant(true))
    ///
    /// - Parameter value: An immutable value.
    public static func constant(_ value: Value) -> Binding<Value> { fatalError() }

    /// The underlying value referenced by the binding variable.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the ``Binding`` attribute. In the
    /// following code example, the binding variable `isPlaying` returns the
    /// value of `wrappedValue`:
    ///
    ///     struct PlayButton: View {
    ///         @Binding var isPlaying: Bool
    ///
    ///         var body: some View {
    ///             Button(isPlaying ? "Pause" : "Play") {
    ///                 isPlaying.toggle()
    ///             }
    ///         }
    ///     }
    ///
    /// When a mutable binding value changes, the new value is immediately
    /// available. However, updates to a view displaying the value happens
    /// asynchronously, so the view may not show the change immediately.
    public var wrappedValue: Value { get { fatalError() } nonmutating set { fatalError() } }

    /// A projection of the binding value that returns a binding.
    ///
    /// Use the projected value to pass a binding value down a view hierarchy.
    /// To get the `projectedValue`, prefix the property variable with `$`. For
    /// example, in the following code example `PlayerView` projects a binding
    /// of the state property `isPlaying` to the `PlayButton` view using
    /// `$isPlaying`.
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

    /// Creates a binding from the value of another binding.
    public init(projectedValue: Binding<Value>) { fatalError() }

    /// Returns a binding to the resulting value of a given key path.
    ///
    /// - Parameter keyPath: A key path to a specific resulting value.
    ///
    /// - Returns: A new binding.
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> { get { fatalError() } }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Creates a binding by projecting the base value to an optional value.
    ///
    /// - Parameter base: A value to project to an optional value.
    public init<V>(_ base: Binding<V>) where Value == V? { fatalError() }

    /// Creates a binding by projecting the base value to an unwrapped value.
    ///
    /// - Parameter base: A value to project to an unwrapped value.
    ///
    /// - Returns: A new binding or `nil` when `base` is `nil`.
    public init?(_ base: Binding<Value?>) { fatalError() }

    /// Creates a binding by projecting the base value to a hashable value.
    ///
    /// - Parameters:
    ///   - base: A `Hashable` value to project to an `AnyHashable` value.
    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Identifiable where Value : Identifiable {

    /// The stable identity of the entity associated with this instance,
    /// corresponding to the `id` of the binding's wrapped value.
    public var id: Value.ID { get { fatalError() } }

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = Value.ID
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Sequence where Value : MutableCollection {

    /// A type representing the sequence's elements.
    public typealias Element = Binding<Value.Element>

    /// A type that provides the sequence's iteration interface and
    /// encapsulates its iteration state.
    public typealias Iterator = IndexingIterator<Binding<Value>>

    /// A collection representing a contiguous subrange of this collection's
    /// elements. The subsequence shares indices with the original collection.
    ///
    /// The default subsequence type for collections that don't define their own
    /// is `Slice`.
    public typealias SubSequence = Slice<Binding<Value>>
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Collection where Value : MutableCollection {

    /// A type that represents a position in the collection.
    ///
    /// Valid indices consist of the position of every element and a
    /// "past the end" position that's not valid for use as a subscript
    /// argument.
    public typealias Index = Value.Index

    /// A type that represents the indices that are valid for subscripting the
    /// collection, in ascending order.
    public typealias Indices = Value.Indices

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: Binding<Value>.Index { get { fatalError() } }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    ///
    /// When you need a range that includes the last element of a collection, use
    /// the half-open range operator (`..<`) with `endIndex`. The `..<` operator
    /// creates a range that doesn't include the upper bound, so it's always
    /// safe to use with `endIndex`. For example:
    ///
    ///     let numbers = [10, 20, 30, 40, 50]
    ///     if let index = numbers.firstIndex(of: 30) {
    ///         print(numbers[index ..< numbers.endIndex])
    ///     }
    ///     // Prints "[30, 40, 50]"
    ///
    /// If the collection is empty, `endIndex` is equal to `startIndex`.
    public var endIndex: Binding<Value>.Index { get { fatalError() } }

    /// The indices that are valid for subscripting the collection, in ascending
    /// order.
    ///
    /// A collection's `indices` property can hold a strong reference to the
    /// collection itself, causing the collection to be nonuniquely referenced.
    /// If you mutate the collection while iterating over its indices, a strong
    /// reference can result in an unexpected copy of the collection. To avoid
    /// the unexpected copy, use the `index(after:)` method starting with
    /// `startIndex` to produce indices instead.
    ///
    ///     var c = MyFancyCollection([10, 20, 30, 40, 50])
    ///     var i = c.startIndex
    ///     while i != c.endIndex {
    ///         c[i] /= 5
    ///         i = c.index(after: i)
    ///     }
    ///     // c == MyFancyCollection([2, 4, 6, 8, 10])
    public var indices: Value.Indices { get { fatalError() } }

    /// Returns the position immediately after the given index.
    ///
    /// The successor of an index must be well defined. For an index `i` into a
    /// collection `c`, calling `c.index(after: i)` returns the same index every
    /// time.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Binding<Value>.Index) -> Binding<Value>.Index { fatalError() }

    /// Replaces the given index with its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    public func formIndex(after i: inout Binding<Value>.Index) { fatalError() }

    /// Accesses the element at the specified position.
    ///
    /// The following example accesses an element of an array through its
    /// subscript to print its value:
    ///
    ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
    ///     print(streets[1])
    ///     // Prints "Bryant"
    ///
    /// You can subscript a collection with any valid index other than the
    /// collection's end index. The end index refers to the position one past
    /// the last element of a collection, so it doesn't correspond with an
    /// element.
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the collection that is not equal to the
    ///   `endIndex` property.
    ///
    /// - Complexity: O(1)
    public subscript(position: Binding<Value>.Index) -> Binding<Value>.Element { get { fatalError() } }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : BidirectionalCollection where Value : BidirectionalCollection, Value : MutableCollection {

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    public func index(before i: Binding<Value>.Index) -> Binding<Value>.Index { fatalError() }

    /// Replaces the given index with its predecessor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    public func formIndex(before i: inout Binding<Value>.Index) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : RandomAccessCollection where Value : MutableCollection, Value : RandomAccessCollection {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Specifies a transaction for the binding.
    ///
    /// - Parameter transaction  : An instance of a ``Transaction``.
    ///
    /// - Returns: A new binding.
    public func transaction(_ transaction: Transaction) -> Binding<Value> { fatalError() }

    /// Specifies an animation to perform when the binding value changes.
    ///
    /// - Parameter animation: An animation sequence performed when the binding
    ///   value changes.
    ///
    /// - Returns: A new binding.
    public func animation(_ animation: Animation? = .default) -> Binding<Value> { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding : DynamicProperty {
}

#endif
