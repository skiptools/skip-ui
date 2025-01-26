// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
