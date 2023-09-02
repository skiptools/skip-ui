// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP
import struct Foundation.URL
import struct Foundation.Data
import class Foundation.UserDefaults

/// A property wrapper type that reflects a value from `UserDefaults` and
/// invalidates a view on a change in value in that user default.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen @propertyWrapper public struct AppStorage<Value> : DynamicProperty {

    public var wrappedValue: Value { get { fatalError() } nonmutating set { } }

    public var projectedValue: Binding<Value> { get { fatalError() } }

    public init(wrappedValue: Value) { fatalError() }
}

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
    public init<RowValue>(wrappedValue: Value = TableColumnCustomization<RowValue>(), _ key: String, store: UserDefaults? = nil) where Value == TableColumnCustomization<RowValue>, RowValue : Identifiable { fatalError() }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension AppStorage {

    /// Creates a property that can read and write to a boolean user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a boolean value is not specified
    ///     for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Bool { fatalError() }

    /// Creates a property that can read and write to an integer user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if an integer value is not specified
    ///     for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Int { fatalError() }

    /// Creates a property that can read and write to a double user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a double value is not specified
    ///     for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Double { fatalError() }

    /// Creates a property that can read and write to a string user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a string value is not specified
    ///     for the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == String { fatalError() }

    /// Creates a property that can read and write to a url user default.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a url value is not specified for
    ///     the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == URL { fatalError() }

    /// Creates a property that can read and write to a user default as data.
    ///
    /// Avoid storing large data blobs in user defaults, such as image data,
    /// as it can negatively affect performance of your app. On tvOS, a
    /// `NSUserDefaultsSizeLimitExceededNotification` notification is posted
    /// if the total user default size reaches 512kB.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value if a data value is not specified for
    ///    the given key.
    ///   - key: The key to read and write the value to in the user defaults
    ///     store.
    ///   - store: The user defaults store to read and write to. A value
    ///     of `nil` will use the user default store from the environment.
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value == Data { fatalError() }

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
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == Int { fatalError() }

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
    public init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) where Value : RawRepresentable, Value.RawValue == String { fatalError() }
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
    public init(_ key: String, store: UserDefaults? = nil) where Value == Bool? { fatalError() }

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
    public init(_ key: String, store: UserDefaults? = nil) where Value == Int? { fatalError() }

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
    public init(_ key: String, store: UserDefaults? = nil) where Value == Double? { fatalError() }

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
    public init(_ key: String, store: UserDefaults? = nil) where Value == String? { fatalError() }

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
    public init(_ key: String, store: UserDefaults? = nil) where Value == URL? { fatalError() }

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
    public init(_ key: String, store: UserDefaults? = nil) where Value == Data? { fatalError() }
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
    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == String { fatalError() }

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
    public init<R>(_ key: String, store: UserDefaults? = nil) where Value == R?, R : RawRepresentable, R.RawValue == Int { fatalError() }
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

