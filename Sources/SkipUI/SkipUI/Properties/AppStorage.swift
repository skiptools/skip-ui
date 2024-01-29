// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipModel
#if SKIP
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
#endif

public final class AppStorage<Value>: StateTracker {
    public let key: String
    public let store: UserDefaults?
    private let serializer: ((Value) -> Any)?
    private let deserializer: ((Any) -> Value?)?
    /// The property change listener from the UserDefaults
    private var listener: AnyObject? = nil

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil, serializer: ((Value) -> Any)? = nil, deserializer: ((Any) -> Value?)? = nil) {
        self.key = key
        self.store = store
        self.serializer = serializer
        self.deserializer = deserializer
        _wrappedValue = wrappedValue
        StateTracking.register(self)
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
            #if SKIP
            // Changing the store value should trigger our listener to update our own state
            if let serializer {
                currentStore.set(serializer(newValue), forKey: key)
            } else {
                currentStore.set(newValue, forKey: key)
            }
            #endif
            // Unless we haven't started tracking
            if listener == nil {
                _wrappedValue = newValue
            }
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
        // Create our Compose-trackable backing state and keep it in sync with the store. Note that we have to seed the store with a value
        // for the key in order for our listener to work
        let store = self.currentStore
        let object = store.object(forKey: key)
        let value: Value?
        if let object, let deserializer {
            value = deserializer(object)
        } else {
            value = object as? Value
        }
        if let value {
            _wrappedValue = value
        } else if let serializer {
            store.set(serializer(_wrappedValue), forKey: key)
        } else {
            store.set(_wrappedValue, forKey: key)
        }
        _wrappedValueState = mutableStateOf(_wrappedValue)

        // Caution: The preference manager does not currently store a strong reference to the listener. You must store a strong reference to the listener, or it will be susceptible to garbage collection. We recommend you keep a reference to the listener in the instance data of an object that will exist as long as you need the listener.
        // https://developer.android.com/reference/android/content/SharedPreferences.html#registerOnSharedPreferenceChangeListener(android.content.SharedPreferences.OnSharedPreferenceChangeListener)
        self.listener = store.registerOnSharedPreferenceChangeListener(key: key) {
            let object = store.object(forKey: key)
            let value: Value?
            if let object, let deserializer {
                value = deserializer(object)
            } else {
                value = object as? Value
            }
            if let value {
                _wrappedValue = value
                _wrappedValueState?.value = value
            }
        }
        #endif
    }

    #if SKIP
    /// The current active store
    private var currentStore: UserDefaults {
        // TODO: handle Scene.defaultAppStorage() and View.defaultAppStorage() by storing it in the environment
        return store ?? UserDefaults.standard
    }
    #endif
}

extension View {
    @available(*, unavailable)
    public func defaultAppStorage(_ store: UserDefaults) -> some View {
        return self
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

@available(iOS 17.0, macOS 14.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension AppStorage {

    /// Creates a property that can save and restore table column state.
    ///
    /// Table column state is typically not bound from a table directly to
    /// `AppStorage`, but instead indirecting through `State` or `SceneStorage`,
    /// and using the app storage value as its initial value kept up to date
    /// on changes to the direcr backing.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if table column state is not
    ///   available for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init<RowValue>(wrappedValue: Value = TableColumnCustomization<RowValue>(), _ key: String, store: UserDefaults? = nil) where Value == TableColumnCustomization<RowValue>, RowValue : Identifiable { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension AppStorage where Value : ExpressibleByNilLiteral {

    /// Creates a property that can read and write an Optional boolean user
    /// default.
    ///
    /// Defaults to nil if there is no restored value.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(_ key: String, store: UserDefaults? = nil) where Value == Bool? { fatalError() }

    /// Creates a property that can read and write an Optional integer user
    /// default.
    ///
    /// Defaults to nil if there is no restored value.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(_ key: String, store: UserDefaults? = nil) where Value == Int? { fatalError() }

    /// Creates a property that can read and write an Optional double user
    /// default.
    ///
    /// Defaults to nil if there is no restored value.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(_ key: String, store: UserDefaults? = nil) where Value == Double? { fatalError() }

    /// Creates a property that can read and write an Optional string user
    /// default.
    ///
    /// Defaults to nil if there is no restored value.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(_ key: String, store: UserDefaults? = nil) where Value == String? { fatalError() }

    /// Creates a property that can read and write an Optional URL user
    /// default.
    ///
    /// Defaults to nil if there is no restored value.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(_ key: String, store: UserDefaults? = nil) where Value == URL? { fatalError() }

    /// Creates a property that can read and write an Optional data user
    /// default.
    ///
    /// Defaults to nil if there is no restored value.
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(_ key: String, store: UserDefaults? = nil) where Value == Data? { fatalError() }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension AppStorage {

    /// Creates a property that can save and restore an Optional string,
    /// transforming it to an Optional `RawRepresentable` data type.
    ///
    /// Defaults to nil if there is no restored value
    ///
    /// A common usage is with enumerations:
    ///
    ///     enum MyEnum: String {
    ///         case a
    ///         case b
    ///         case c
    ///     }
    ///     struct MyView: View {
    ///         @AppStorage("MyEnumValue") private var value: MyEnum?
    ///         var body: some View { ... }
    ///     }
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == String { fatalError() }

    /// Creates a property that can save and restore an Optional integer,
    /// transforming it to an Optional `RawRepresentable` data type.
    ///
    /// Defaults to nil if there is no restored value
    ///
    /// A common usage is with enumerations:
    ///
    ///     enum MyEnum: Int {
    ///         case a
    ///         case b
    ///         case c
    ///     }
    ///     struct MyView: View {
    ///         @AppStorage("MyEnumValue") private var value: MyEnum?
    ///         var body: some View { ... }
    ///     }
    ///
    /// - Parameters:
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == Int { fatalError() }
}

#endif

