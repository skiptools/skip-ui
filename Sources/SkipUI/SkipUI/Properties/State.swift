// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// We model State as a class rather than struct to avoid copy overhead on mutation

// SKIP NOWARN
@propertyWrapper public final class State<Value> {
    private var onUpdate: ((Value) -> Void)?

    @available(*, unavailable)
    public init() {
        fatalError()
    }

    public init(initialValue: Value) {
        wrappedValue = initialValue
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: Value {
        didSet {
            onUpdate?(wrappedValue)
        }
    }

    public var projectedValue: Binding<Value> {
        return Binding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }

    /// Used to keep the state value synchronized with an external Compose value.
    public func sync(value: Value, onUpdate: @escaping (Value) -> Void) {
        self.wrappedValue = value
        self.onUpdate = onUpdate
    }
}
