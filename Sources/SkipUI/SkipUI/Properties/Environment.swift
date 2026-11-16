// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE

// Model Environment as a class rather than struct to mutate by reference and avoid copy overhead
public final class Environment<Value> where Value: Any {
    public init() {
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: Value!

    public var projectedValue: Binding<Value> {
        return Binding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }
}

#endif
