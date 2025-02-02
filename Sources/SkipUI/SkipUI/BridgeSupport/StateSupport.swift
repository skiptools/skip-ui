// Copyright 2025 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP_BRIDGE
import SkipModel
#if SKIP
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
#endif

/// Support for bridged`SwiftUI.@State`.
///
/// The Compose side manages object lifecycles, so we hold references to the native value and a `MutableState` recomposition trigger.
/// State values are not necessarily bridged or bridgable, so we use an opaque pointer. This support object is `remembered` and synced to
/// and from the native view.
// SKIP @bridge
public final class StateSupport: StateTracker {
    private let finalizer: (Int64) -> Int64
    #if SKIP
    private var state: MutableState<Int>? = nil
    #endif

    /// Supply a Swift pointer to an object that holds the `@State` value and a block to release the object on finalize.
    // SKIP @bridge
    public init(valueHolder: Int64, finalizer: @escaping (Int64) -> Int64) {
        self.valueHolder = valueHolder
        self.finalizer = finalizer
        StateTracking.register(self)
    }

    deinit {
        valueHolder = finalizer(valueHolder)
    }

    // SKIP @bridge
    public private(set) var valueHolder: Int64

    // SKIP @bridge
    public func access() {
        #if SKIP
        let _ = state?.value
        #endif
    }

    // SKIP @bridge
    public func update() {
        #if SKIP
        state?.value += 1
        #endif
    }

    // SKIP @bridge
    public func trackState() {
        #if SKIP
        state = mutableStateOf(0)
        #endif
    }
}

#endif
