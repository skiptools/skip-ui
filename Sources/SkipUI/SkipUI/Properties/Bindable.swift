// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE

// Model Bindable as a class rather than struct to avoid copy overhead on mutation
public final class Bindable<Value> {
    public init(_ wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: Value

    public var projectedValue: Bindable<Value> {
        return Bindable(wrappedValue: wrappedValue)
    }
}

#endif
