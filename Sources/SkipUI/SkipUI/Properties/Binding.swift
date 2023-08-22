// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP NOWARN
@propertyWrapper public struct Binding<Value> {
    let get: () -> Value
    let set: (Value) -> Void

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.get = get
        self.set = set
    }

    public init(projectedValue: Binding<Value>) {
        self.get = projectedValue.get
        self.set = projectedValue.set
    }

    @available(*, unavailable)
    public init(get: @escaping () -> Value, set: @escaping (Value, Any /* Transaction */) -> Void) {
        self.get = get
        self.set = { _ in }
    }

    public var wrappedValue: Value {
        get {
            return get()
        }
        set {
            set(newValue)
        }
    }

    public var projectedValue: Binding<Value> {
        return self
    }

    @available(*, unavailable)
    public var transaction: Any /* Transaction */ {
        fatalError()
    }

    public static func constant(_ value: Value) -> Binding<Value> {
        // SKIP NOWARN
        return Binding(get: { value }, set: { _ in })
    }

//    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> { get { fatalError() } }
}

#if SKIP
/// This type is used to implement `@Bindable` in Kotlin.
public struct InstanceBinding<Object, Value> {
    let object: Object
    let get: (Object) -> Value
    let set: (Object, Value) -> Void

    public init(object: Object, get: @escaping (Object) -> Value, set: @escaping (Object, Value) -> Void) {
        self.object = object
        self.get = get
        self.set = set
    }
}
#endif

#if !SKIP

// These stubs are necessary to compile this package:

extension Binding : Identifiable where Value : Identifiable {
    public var id: Value.ID { get { fatalError() } }
    public typealias ID = Value.ID
}

extension Binding : Sequence where Value : MutableCollection {
    public typealias Element = Binding<Value.Element>
    public typealias Iterator = IndexingIterator<Binding<Value>>
    public typealias SubSequence = Slice<Binding<Value>>
}

extension Binding : Collection where Value : MutableCollection {
    public typealias Index = Value.Index
    public typealias Indices = Value.Indices

    public var startIndex: Binding<Value>.Index { get { fatalError() } }
    public var endIndex: Binding<Value>.Index { get { fatalError() } }
    public var indices: Value.Indices { get { fatalError() } }
    public func index(after i: Binding<Value>.Index) -> Binding<Value>.Index { fatalError() }
    public func formIndex(after i: inout Binding<Value>.Index) { fatalError() }
    public subscript(position: Binding<Value>.Index) -> Binding<Value>.Element { get { fatalError() } }
}

extension Binding : BidirectionalCollection where Value : BidirectionalCollection, Value : MutableCollection {
    public func index(before i: Binding<Value>.Index) -> Binding<Value>.Index { fatalError() }
    public func formIndex(before i: inout Binding<Value>.Index) { fatalError() }
}

extension Binding : RandomAccessCollection where Value : MutableCollection, Value : RandomAccessCollection {
}

// Unused stubs:

//@frozen @propertyWrapper @dynamicMemberLookup public struct Binding<Value> {
//}

//extension Binding {
//    public init<V>(_ base: Binding<V>) where Value == V? { fatalError() }
//    public init?(_ base: Binding<Value?>) { fatalError() }
//    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V : Hashable { fatalError() }
//}

//extension Binding {
//    public func transaction(_ transaction: Transaction) -> Binding<Value> { fatalError() }
//    public func animation(_ animation: Animation? = .default) -> Binding<Value> { fatalError() }
//}

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Binding : DynamicProperty {
//}

#endif
