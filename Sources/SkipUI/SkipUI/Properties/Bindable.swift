// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import Observation
//import protocol Observation.Observable

/// A property wrapper type that supports creating bindings to the mutable
/// properties of observable objects.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@dynamicMemberLookup @propertyWrapper public struct Bindable<Value> {

    /// The wrapped object.
    public var wrappedValue: Value { get { fatalError() } }

    /// The bindable wrapper for the object that creates bindings to its
    /// properties using dynamic member lookup.
    public var projectedValue: Bindable<Value> { get { fatalError() } }

    public init(wrappedValue: Value) { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable where Value : AnyObject {

    /// Returns a binding to the value of a given key path.
    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>) -> Binding<Subject> { get { fatalError() } }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable : Identifiable where Value : Identifiable {

    /// The stable identity of the entity associated with this instance.
    public var id: Value.ID { get { fatalError() } }

    /// A type representing the stable identity of the entity associated with
    /// an instance.
    public typealias ID = Value.ID
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable : Sendable where Value : Sendable {
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Bindable where Value : AnyObject, Value : Observable {

    /// Creates a bindable object from an observable object.
    ///
    /// You should not call this initializer directly. Instead, declare a
    /// property with the `@Bindable` attribute, and provide an initial value.
    public init(wrappedValue: Value) { fatalError() }

    /// Creates a bindable object from an observable object.
    ///
    /// This initializer is equivalent to `init(wrappedValue:)`, but is more
    /// succinct when directly creating bindable objects, e.g.
    /// `Bindable(myModel)`.
    public init(_ wrappedValue: Value) { fatalError() }

    /// Creates a bindable from the value of another bindable.
    public init(projectedValue: Bindable<Value>) { fatalError() }
}

#endif

