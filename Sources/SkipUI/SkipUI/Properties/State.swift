// Copyright 2023 Skip
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
                return _wrappedValueState.value
            }
            #endif
            return _wrappedValue
        }
        set {
            _wrappedValue = newValue
            #if SKIP
            _wrappedValueState?.value = _wrappedValue
            #endif
        }
    }
    private var _wrappedValue: Value
    #if SKIP
    private var _wrappedValueState: MutableState<Value>?
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
