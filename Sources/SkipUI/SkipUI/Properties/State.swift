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
                // Report this slot's write-transaction so a transformer-instrumented animatable
                // modifier consuming this read can decide animate-vs-snap. Skip the call entirely
                // for un-stamped slots — the common case for state never written in withAnimation.
                if let tx = lastWriteTransaction {
                    StateTracking.recordRead(tx)
                }
                return _wrappedValueState.value
            }
            #endif
            return _wrappedValue
        }
        set {
            #if SKIP
            // Stamp the slot with the active withAnimation/withTransaction scope's transaction;
            // a plain write clears a stale stamp so later reads don't wrongly animate.
            let tx = StateTracking.currentTransaction
            if tx != nil || lastWriteTransaction != nil {
                lastWriteTransaction = tx
            }
            #endif
            _wrappedValue = newValue
            #if SKIP
            _wrappedValueState?.value = _wrappedValue
            #endif
        }
    }
    private var _wrappedValue: Value
    #if SKIP
    private var _wrappedValueState: MutableState<Value>?
    private var lastWriteTransaction: StateMutationTransaction?
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
