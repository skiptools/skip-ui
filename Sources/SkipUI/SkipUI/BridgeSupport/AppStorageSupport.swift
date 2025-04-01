// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import SkipModel
#if SKIP
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
#endif

//~~~ APPSTORAGE

/// Support for bridged state trackers that do not require value storage.
///
/// For example, `SwiftUI.@AppStorage` stores the value in `UserDefaults`.
// SKIP @bridge
public final class StateTrackingSupport: StateTracker {
    #if SKIP
    private var state: MutableState<Int>? = nil
    #endif

    // SKIP @bridge
    public init() {
        StateTracking.register(self)
    }

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
