// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// A named value produced by a view.
///
/// A view with multiple children automatically combines its values for a given
/// preference into a single value visible to its ancestors.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol PreferenceKey {

    /// The type of value produced by this preference.
    associatedtype Value

    /// The default value of the preference.
    ///
    /// Views that have no explicit value for the key produce this default
    /// value. Combining child views may remove an implicit value produced by
    /// using the default. This means that `reduce(value: &x, nextValue:
    /// {defaultValue})` shouldn't change the meaning of `x`.
    static var defaultValue: Self.Value { get }

    /// Combines a sequence of values by modifying the previously-accumulated
    /// value with the result of a closure that provides the next value.
    ///
    /// This method receives its values in view-tree order. Conceptually, this
    /// combines the preference value from one tree with that of its next
    /// sibling.
    ///
    /// - Parameters:
    ///   - value: The value accumulated through previous calls to this method.
    ///     The implementation should modify this value.
    ///   - nextValue: A closure that returns the next value in the sequence.
    static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension PreferenceKey where Self.Value : ExpressibleByNilLiteral {

    /// Let nil-expressible values default-initialize to nil.
    public static var defaultValue: Self.Value { get { fatalError() } }
}

/// A key for specifying the preferred color scheme.
///
/// Don't use this key directly. Instead, set a preferred color scheme for a
/// view using the ``View/preferredColorScheme(_:)`` view modifier. Get the
/// current color scheme for a view by accessing the
/// ``EnvironmentValues/colorScheme`` value.
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
public struct PreferredColorSchemeKey : PreferenceKey {

    /// The type of value produced by this preference.
    public typealias Value = ColorScheme?

    /// Combines a sequence of values by modifying the previously-accumulated
    /// value with the result of a closure that provides the next value.
    ///
    /// This method receives its values in view-tree order. Conceptually, this
    /// combines the preference value from one tree with that of its next
    /// sibling.
    ///
    /// - Parameters:
    ///   - value: The value accumulated through previous calls to this method.
    ///     The implementation should modify this value.
    ///   - nextValue: A closure that returns the next value in the sequence.
    public static func reduce(value: inout PreferredColorSchemeKey.Value, nextValue: () -> PreferredColorSchemeKey.Value) { fatalError() }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension View {

    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as an overlay to the
    /// original view.
    ///
    /// The values of the preference key from both views
    /// are combined and made visible to the parent view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - alignment: An optional alignment to use when positioning the
    ///     overlay view relative to the original view.
    ///   - transform: A function that produces the overlay view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view in front of the view.
    public func overlayPreferenceValue<K, V>(_ key: K.Type, alignment: Alignment = .center, @ViewBuilder _ transform: @escaping (K.Value) -> V) -> some View where K : PreferenceKey, V : View { return stubView() }


    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as the background of the
    /// original view.
    ///
    /// The values of the preference key from both views
    /// are combined and made visible to the parent view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - alignment: An optional alignment to use when positioning the
    ///     background view relative to the original view.
    ///   - transform: A function that produces the background view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view behind the view.
    public func backgroundPreferenceValue<K, V>(_ key: K.Type, alignment: Alignment = .center, @ViewBuilder _ transform: @escaping (K.Value) -> V) -> some View where K : PreferenceKey, V : View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as an overlay to the
    /// original view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - transform: A function that produces the overlay view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view in front of the view.
    public func overlayPreferenceValue<Key, T>(_ key: Key.Type = Key.self, @ViewBuilder _ transform: @escaping (Key.Value) -> T) -> some View where Key : PreferenceKey, T : View { return stubView() }


    /// Reads the specified preference value from the view, using it to
    /// produce a second view that is applied as the background of the
    /// original view.
    ///
    /// - Parameters:
    ///   - key: The preference key type whose value is to be read.
    ///   - transform: A function that produces the background view from
    ///     the preference value read from the original view.
    ///
    /// - Returns: A view that layers a second view behind the view.
    public func backgroundPreferenceValue<Key, T>(_ key: Key.Type = Key.self, @ViewBuilder _ transform: @escaping (Key.Value) -> T) -> some View where Key : PreferenceKey, T : View { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a value for the specified preference key, the value is a
    /// function of the key's current value and a geometry value tied
    /// to the current coordinate space, allowing readers of the value
    /// to convert the geometry to their local coordinates.
    ///
    /// - Parameters:
    ///   - key: the preference key type.
    ///   - value: the geometry value in the current coordinate space.
    ///   - transform: the function to produce the preference value.
    ///
    /// - Returns: a new version of the view that writes the preference.
    public func transformAnchorPreference<A, K>(key _: K.Type = K.self, value: Anchor<A>.Source, transform: @escaping (inout K.Value, Anchor<A>) -> Void) -> some View where K : PreferenceKey { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a value for the specified preference key, the value is a
    /// function of a geometry value tied to the current coordinate
    /// space, allowing readers of the value to convert the geometry to
    /// their local coordinates.
    ///
    /// - Parameters:
    ///   - key: the preference key type.
    ///   - value: the geometry value in the current coordinate space.
    ///   - transform: the function to produce the preference value.
    ///
    /// - Returns: a new version of the view that writes the preference.
    public func anchorPreference<A, K>(key _: K.Type = K.self, value: Anchor<A>.Source, transform: @escaping (Anchor<A>) -> K.Value) -> some View where K : PreferenceKey { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Adds an action to perform when the specified preference key's value
    /// changes.
    ///
    /// - Parameters:
    ///   - key: The key to monitor for value changes.
    ///   - action: The action to perform when the value for `key` changes. The
    ///     `action` closure passes the new value as its parameter.
    ///
    /// - Returns: A view that triggers `action` when the value for `key`
    ///   changes.
    public func onPreferenceChange<K>(_ key: K.Type = K.self, perform action: @escaping (K.Value) -> Void) -> some View where K : PreferenceKey, K.Value : Equatable { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Applies a transformation to a preference value.
    public func transformPreference<K>(_ key: K.Type = K.self, _ callback: @escaping (inout K.Value) -> Void) -> some View where K : PreferenceKey { return stubView() }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Sets a value for the given preference.
    public func preference<K>(key: K.Type = K.self, value: K.Value) -> some View where K : PreferenceKey { return stubView() }

}

#endif
