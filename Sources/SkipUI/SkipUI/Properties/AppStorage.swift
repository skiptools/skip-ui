// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import struct Foundation.URL
import struct Foundation.Data
import class Foundation.UserDefaults

public final class AppStorage<Value> {
    public let key: String
    public let store: UserDefaults?
    private var onUpdate: ((Value) -> Void)?
    /// The property change listener from the UserDefaults
    private var listener: AnyObject? = nil

    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
        self.key = key
        self.store = store
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: Value {
        didSet {
            onUpdate?(wrappedValue)
        }
    }

    public var projectedValue: Binding<Value> {
        return Binding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }

    #if SKIP
    /// The current active store
    private var currentStore: UserDefaults {
        // TODO: handle Scene.defaultAppStorage() and View.defaultAppStorage() by storing it in the environment
        return store ?? UserDefaults.standard
    }

    /// Used to keep the state value synchronized with an external Compose value.
    public func sync(value initialValue: Value, onUpdate: @escaping (Value) -> Void) {
        let store = self.currentStore

        func currentValue() -> Value {
            store.object(forKey: key) as? Value ?? initialValue
        }

        self.wrappedValue = currentValue()
        onUpdate(currentValue())

        // Caution: The preference manager does not currently store a strong reference to the listener. You must store a strong reference to the listener, or it will be susceptible to garbage collection. We recommend you keep a reference to the listener in the instance data of an object that will exist as long as you need the listener.
        // https://developer.android.com/reference/android/content/SharedPreferences.html#registerOnSharedPreferenceChangeListener(android.content.SharedPreferences.OnSharedPreferenceChangeListener)
        self.listener = store.registerOnSharedPreferenceChangeListener(key: key) {
            onUpdate(currentValue())
        }

        self.onUpdate = { value in
            onUpdate(value)
            currentStore.set(value, forKey: key)
        }
    }
    #endif
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

extension AppStorage {
    /// Creates a property that can read and write to an integer user default,
    /// transforming that to `RawRepresentable` data type.
    ///
    /// A common usage is with enumerations:
    ///
    ///    enum MyEnum: Int {
    ///        case a
    ///        case b
    ///        case c
    ///    }
    ///    struct MyView: View {
    ///        @AppStorage("MyEnumValue") private var value = MyEnum.a
    ///        var body: some View { ... }
    ///    }
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if an integer value
    ///     is not specified for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int { fatalError() }

    /// Creates a property that can read and write to a string user default,
    /// transforming that to `RawRepresentable` data type.
    ///
    /// A common usage is with enumerations:
    ///
    ///    enum MyEnum: String {
    ///        case a
    ///        case b
    ///        case c
    ///    }
    ///    struct MyView: View {
    ///        @AppStorage("MyEnumValue") private var value = MyEnum.a
    ///        var body: some View { ... }
    ///    }
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a string value
    ///     is not specified for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public convenience init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String { fatalError() }
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

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// The default store used by `AppStorage` contained within the view.
    ///
    /// If unspecified, the default store for a view hierarchy is
    /// `UserDefaults.standard`, but can be set a to a custom one. For example,
    /// sharing defaults between an app and an extension can override the
    /// default store to one created with `UserDefaults.init(suiteName:_)`.
    ///
    /// - Parameter store: The user defaults to use as the default
    ///   store for `AppStorage`.
    public func defaultAppStorage(_ store: UserDefaults) -> some View { return stubView() }

}

#endif

