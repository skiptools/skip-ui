// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf
import kotlin.reflect.full.companionObjectInstance
#endif

public protocol PreferenceKey {
    associatedtype Value
}

#if SKIP
/// Added to `PreferenceKey` companion objects.
public protocol PreferenceKeyCompanion {
    associatedtype Value
    var defaultValue: Value { get }
    func reduce(value: inout Value, nextValue: () -> Value)
}

/// Internal analog to `EnvironmentValues` for preferences.
///
/// Uses environment `CompositionLocals` internally.
///
/// - Seealso: `EnvironmentValues`
class PreferenceValues {
    static let shared = PreferenceValues()

    // SKIP DECLARE: @Composable internal fun preference(key: KClass<*>): Preference<*>?
    /// Return a preference for the given `PreferenceKey` type.
    func preference(key: Any.Type) -> any Preference? {
        return EnvironmentValues.shared.compositionLocals[key]?.current as? Preference
    }

    // SKIP DECLARE: @Composable internal fun collectPreferences(preferences: Array<Preference<*>>, in_: @Composable () -> Unit)
    /// Collect the values of the given preferences while composing the given content.
    func collectPreferences(_ preferences: [any Preference], in content: @Composable () -> Void) {
        let provided = preferences.map { preference in
            var compositionLocal = EnvironmentValues.shared.compositionLocals[preference.key]
            if compositionLocal == nil {
                compositionLocal = compositionLocalOf { Unit }
                EnvironmentValues.shared.compositionLocals[preference.key] = compositionLocal
            }
            // SKIP INSERT: val element = compositionLocal!! provides preference
            element
        }.kotlin(nocopy: true).toTypedArray()
        
        preferences.forEach { $0.beginCollecting() }
        CompositionLocalProvider(*provided) {
            content()
        }
        preferences.forEach { $0.endCollecting() }
    }
}

/// Used internally by our preferences system to collect preferences and recompose on change.
class Preference<Value> {
    let key: Any.Type
    private let update: (Value) -> Void
    private let didChange: () -> Void
    private let initialValue: Value
    private var isCollecting = false
    private var collectedValue: Value?

    /// Create a preference for the given `PreferenceKey` type.
    ///
    /// - Parameter update: Block to call to change the value of this preference.
    /// - Parameter didChange: Block to call if this preference changes. Should force a recompose of the relevant content, collecting the new value via `collectPreferences`
    init(key: Any.Type, initialValue: Value? = nil, update: (Value) -> Void, didChange: () -> Void) {
        self.key = key
        self.update = update
        self.didChange = didChange
        self.initialValue = initialValue ?? (key.companionObjectInstance as! PreferenceKeyCompanion<Value>).defaultValue
    }

    /// The current preference value.
    var value: Value {
        return collectedValue ?? initialValue
    }

    /// Reduce the current value and the given values.
    func reduce(savedValue: Any?, newValue: Any) {
        if isCollecting {
            var value = self.value
            (key.companionObjectInstance as! PreferenceKeyCompanion<Value>).reduce(value: &value, nextValue: { newValue as! Value })
            collectedValue = value
        } else if savedValue != newValue {
            didChange()
        }
    }

    /// Begin collecting the current value.
    ///
    /// Call this before composing content.
    func beginCollecting() {
        isCollecting = true
        collectedValue = nil
    }

    /// End collecting the current value.
    ///
    /// Call this after composing content.
    func endCollecting() {
        isCollecting = false
        update(value)
    }
}
#endif

extension View {
    public func preference(key: Any.Type, value: Any) -> some View {
        #if SKIP
        return ComposeModifierView(targetView: self) { _ in
            syncPreference(key: key, value: value)
        }
        #else
        return self
        #endif
    }

    #if SKIP
    @Composable public func syncPreference(key: Any.Type, value: Any) {
        let pvalue = remember { mutableStateOf<Any?>(nil) }
        PreferenceValues.shared.preference(key: key)?.reduce(savedValue: pvalue.value, newValue: value)
        pvalue.value = value
    }
    #endif
}

#if !SKIP

// TODO: Process for use in SkipUI

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

#endif
