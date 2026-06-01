// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import SkipModel
#if SKIP
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
#endif

// Model State as a class rather than struct to mutate by reference and avoid copy overhead.
public final class State<Value>: StateTracker {
    public init(initialValue: Value) {
        _wrappedValue = initialValue
        StateTracking.register(self)
    }

    public convenience init(wrappedValue: Value) {
        self.init(initialValue: wrappedValue)
    }

    public var wrappedValue: Value {
        get {
            #if SKIP
            if let _wrappedValueState {
                StateTracking.recordMutationRead(lastAnimationTransaction)
                return _wrappedValueState.value
            }
            #endif
            return _wrappedValue
        }
        set {
            _wrappedValue = newValue
            #if SKIP
            lastAnimationTransaction = StateTracking.currentMutationTransaction as? AnimationTransaction
            Animation.debugLog("State write transaction=\(Animation.debugDescription(for: lastAnimationTransaction))")
            _wrappedValueState?.value = _wrappedValue
            #endif
        }
    }
    private var _wrappedValue: Value
    #if SKIP
    private var _wrappedValueState: MutableState<Value>?
    var lastAnimationTransaction: AnimationTransaction?
    #endif

    public var projectedValue: Binding<Value> {
        return Binding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }

    public func trackState() {
        #if SKIP
        _wrappedValueState = mutableStateOf(_wrappedValue)
        #endif
    }
}

#if SKIP
// extension State where Value : ExpressibleByNilLiteral {
    // public init() {
    @available(*, unavailable)
    public func State() {
        fatalError()
    }
// }
#endif
#endif
