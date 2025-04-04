// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
import SkipModel
#if SKIP
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
#endif

/// Support for bridged`SwiftUI.@AppStorage`.
///
/// The Compose side manages object lifecycles, so we hold references to the value as a `MutableState` recomposition trigger.
/// We also monitor the underlying defautls key using a preferences listener.
// SKIP @bridge
public final class AppStorageSupport: StateTracker {
    private let key: String
    private let store: UserDefaults?
    private var value: Any
    private let get: (UserDefaults, Any) -> Any
    private let set: (UserDefaults, Any) -> Void
    #if SKIP
    private var state: MutableState<Any>? = nil
    #endif
    /// The property change listener from the UserDefaults
    private var listener: Any? = nil

    // SKIP @bridge
    public init(_ value: Bool, key: String, store: Any? /* UserDefaults? */) {
        self.key = key
        self.store = store as? UserDefaults
        self.value = value
        self.get = { $1 as? Bool ?? $0.bool(forKey: key) }
        self.set = { $0.set($1 as? Bool ?? false, forKey: key) }
        StateTracking.register(self)
    }

    // SKIP @bridge
    public init(_ value: Double, key: String, store: Any? /* UserDefaults? */) {
        self.key = key
        self.store = store as? UserDefaults
        self.value = value
        self.get = { $1 as? Double ?? $0.double(forKey: key) }
        self.set = { $0.set($1 as? Double ?? 0.0, forKey: key) }
        StateTracking.register(self)
    }

    // SKIP @bridge
    public init(_ value: Int, key: String, store: Any? /* UserDefaults? */) {
        self.key = key
        self.store = store as? UserDefaults
        self.value = value
        self.get = { $1 as? Int ?? $0.integer(forKey: key) }
        self.set = { $0.set($1 as? Int ?? 0, forKey: key) }
        StateTracking.register(self)
    }

    // SKIP @bridge
    public init(_ value: String, key: String, store: Any? /* UserDefaults? */) {
        self.key = key
        self.store = store as? UserDefaults
        self.value = value
        self.get = { $1 as? String ?? $0.string(forKey: key) ?? "" }
        self.set = { $0.set($1 as? String ?? "", forKey: key) }
        StateTracking.register(self)
    }

    // SKIP @bridge
    public init(_ value: URL, key: String, store: Any? /* UserDefaults? */) {
        self.key = key
        self.store = store as? UserDefaults
        self.value = value
        self.get = { $1 as? URL ?? $0.url(forKey: key) ?? URL(string: "http://localhost")! }
        self.set = { $0.set($1 as? String ?? "", forKey: key) }
        StateTracking.register(self)
    }

    // SKIP @bridge
    public init(_ value: Data, key: String, store: Any? /* UserDefaults? */) {
        self.key = key
        self.store = store as? UserDefaults
        self.value = value
        self.get = { $1 as? Data ?? $0.data(forKey: key) ?? Data() }
        self.set = { $0.set($1 as? Data ?? Data(), forKey: key) }
        StateTracking.register(self)
    }

    // SKIP @bridge
    public var boolValue: Bool {
        get {
            #if SKIP
            if let state {
                return state.value as? Bool ?? false
            }
            #endif
            return value as? Bool ?? false
        }
        set {
            #if SKIP
            set(currentStore, newValue)
            #endif
            if listener == nil {
                value = newValue
            }
        }
    }

    // SKIP @bridge
    public var doubleValue: Double {
        get {
            #if SKIP
            if let state {
                return state.value as? Double ?? 0.0
            }
            #endif
            return value as? Double ?? 0.0
        }
        set {
            #if SKIP
            set(currentStore, newValue)
            #endif
            if listener == nil {
                value = newValue
            }
        }
    }

    // SKIP @bridge
    public var intValue: Int {
        get {
            #if SKIP
            if let state {
                return state.value as? Int ?? 0
            }
            #endif
            return value as? Int ?? 0
        }
        set {
            #if SKIP
            set(currentStore, newValue)
            #endif
            if listener == nil {
                value = newValue
            }
        }
    }

    // SKIP @bridge
    public var stringValue: String {
        get {
            #if SKIP
            if let state {
                return state.value as? String ?? ""
            }
            #endif
            return value as? String ?? ""
        }
        set {
            #if SKIP
            set(currentStore, newValue)
            #endif
            if listener == nil {
                value = newValue
            }
        }
    }

    // SKIP @bridge
    public var urlValue: URL {
        get {
            #if SKIP
            if let state {
                return state.value as? URL ?? URL(string: "http://localhost")!
            }
            #endif
            return value as? URL ?? URL(string: "http://localhost")!
        }
        set {
            #if SKIP
            set(currentStore, newValue)
            #endif
            if listener == nil {
                value = newValue
            }
        }
    }

    // SKIP @bridge
    public var dataValue: Data {
        get {
            #if SKIP
            if let state {
                return state.value as? Data ?? Data()
            }
            #endif
            return value as? Data ?? Data()
        }
        set {
            #if SKIP
            set(currentStore, newValue)
            #endif
            if listener == nil {
                value = newValue
            }
        }
    }

    /// The current active store
    private var currentStore: UserDefaults {
        #if SKIP
        // TODO: handle Scene.defaultAppStorage() and View.defaultAppStorage() by storing it in the environment
        return store ?? UserDefaults.standard
        #else
        fatalError("unsupported outside of skip")
        #endif
    }

    // SKIP @bridge
    public func trackState() {
        #if SKIP
        // Create our Compose-trackable backing state and keep it in sync with the store. Note that we have to seed the store with a value
        // for the key in order for our listener to work
        let store = self.currentStore
        let object = store.object(forKey: key)
        if let object {
            value = get(store, object)
        } else {
            set(store, value)
        }
        state = mutableStateOf(value)

        // Caution: The preference manager does not currently store a strong reference to the listener. You must store a strong reference to the listener, or it will be susceptible to garbage collection. We recommend you keep a reference to the listener in the instance data of an object that will exist as long as you need the listener.
        // https://developer.android.com/reference/android/content/SharedPreferences.html#registerOnSharedPreferenceChangeListener(android.content.SharedPreferences.OnSharedPreferenceChangeListener)
        self.listener = store.registerOnSharedPreferenceChangeListener(key: key) {
            if let obj = store.object(forKey: key) {
                value = get(store, obj)
                state?.value = value
            }
        }
        #endif
    }
}

#endif
