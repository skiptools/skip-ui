// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP_BRIDGE

/// Support for bridged`SwiftUI.@Environment`.
///
/// The Compose side manages object lifecycles, so we hold references to the native value.
/// Environment values are not necessarily bridged or bridgable, so we use an opaque pointer.
/// This support object is placed in the Compose environment.
// SKIP @bridge
public final class EnvironmentSupport {
    private let finalizer: ((Int64) -> Int64)?

    /// Supply a Swift pointer to an object that holds the environment value and a block to release the object on finalize.
    // SKIP @bridge
    public init(valueHolder: Int64, finalizer: @escaping (Int64) -> Int64) {
        self.valueHolder = valueHolder
        self.finalizer = finalizer
        self.builtinValue = nil
    }

    public init(builtinValue: Any?) {
        self.builtinValue = builtinValue
        self.valueHolder = nil
        self.finalizer = nil
    }

    deinit {
        if valueHolder != nil, let finalizer {
            valueHolder = finalizer(valueHolder!)
        }
    }

    // SKIP @bridge
    public private(set) var valueHolder: Int64?

    // SKIP @bridge
    public let builtinValue: Any?
}

#endif
