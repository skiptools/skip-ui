// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
