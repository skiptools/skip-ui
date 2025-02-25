// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
    #if SKIP
    private var state: MutableState<Int>? = nil
    #endif

    /// Supply a Swift pointer to an object that holds the `@State` value and a block to release the object on finalize.
    // SKIP @bridge
    public init(valueHolder: Int64) {
        self.valueHolder = valueHolder
        StateTracking.register(self)
    }

    #if SKIP
    deinit {
        valueHolder = Swift_release(valueHolder)
    }

    /// - Seealso `SkipFuseUI.BridgedStateBox`
    // SKIP EXTERN
    private func Swift_release(Swift_valueHolder: Int64) -> Int64
    #endif

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
