// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.ProvidedValue
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshotFlow
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import kotlin.reflect.full.companionObjectInstance
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.distinctUntilChanged
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
final class PreferenceValues {
    static let shared = PreferenceValues()

    /// Return a preference collector for the given `PreferenceKey` type.
    @Composable func collector(key: Any) -> PreferenceCollector<Any?>? {
        return EnvironmentValues.shared.compositionLocals[key]?.current as? PreferenceCollector<Any?>
    }

    /// Collect the values of the given preferences while composing the given content.
    // SKIP DECLARE: @Composable internal fun collectPreferences(collectors: Array<PreferenceCollector<*>>, in_: @Composable () -> Unit)
    @Composable func collectPreferences(_ collectors: [PreferenceCollector], in content: @Composable () -> Void) {
        let provided = collectors.map { collector in
            var compositionLocal = EnvironmentValues.shared.compositionLocals[collector.key]
            if compositionLocal == nil {
                compositionLocal = compositionLocalOf { Unit }
                EnvironmentValues.shared.compositionLocals[collector.key] = compositionLocal
            }
            // SKIP INSERT: val element = compositionLocal!! provides collector
            element
        }
        // SKIP INSERT: val kprovided = (provided.kotlin(nocopy = true) as MutableList<ProvidedValue<*>>).toTypedArray()
        CompositionLocalProvider(*kprovided) {
            content()
        }
    }

    /// Update the value of the given preference, as if by calling .preference(key:value:).
    @Composable func contribute(context: ComposeContext, key: Any, value: Any?) {
        // Use a saveable value because the preferences themselves and their node IDs are saved
        let id = rememberSaveable(stateSaver: context.stateSaver as! Saver<Int?, Any>) { mutableStateOf<Int?>(nil) }
        let collector = rememberUpdatedState(PreferenceValues.shared.collector(key: key))
        if let collector = collector.value {
            // A side effect is required to ensure that a state change during composition causes a recomposition
            SideEffect {
                id.value = collector.contribute(value, id: id.value)
            }
        }
        DisposableEffect(true) {
            onDispose {
                collector.value?.erase(id: id.value)
            }
        }
    }
}

/// Used internally by our preferences system to collect preferences and recompose on change.
struct PreferenceCollector<Value> {
    let key: Any
    let state: MutableState<Preference<Value>>
    let isErasable: Bool

    init(key: Any, state: MutableState<Preference<Value>>, isErasable: Bool = true) {
        self.key = key
        self.state = state
        self.isErasable = isErasable
    }

    /// Contribute a value to the collected preference.
    ///
    /// - Parameter id: The id of this value in the value chain, or nil if no id has been assigned.
    /// - Returns: The id to use for future contributions.
    func contribute(_ value: Value, id: Int?) -> Int {
        var preference = state.value
        guard let id, let index = preference.nodes.firstIndex(where: { $0.id == id }) else {
            let maxID = preference.nodes.reduce(-1) { result, node in
                return max(result, node.id)
            }
            let nextID = maxID + 1
            preference.nodes.append(PreferenceNode(id: nextID, value: value))
            state.value = preference
            return nextID
        }
        preference.nodes[index] = PreferenceNode(id: id, value: value)
        state.value = preference
        return id
    }

    /// Remove the contribution by the given id.
    func erase(id: Int?) {
        guard isErasable else {
            return
        }
        var preference = state.value
        if let id, let index = preference.nodes.firstIndex(where: { $0.id == id }) {
            preference.nodes.remove(at: index)
            state.value = preference
        }
    }
}

/// The collected preference values that are reduced to achieve the final value.
@Stable struct Preference<Value>: Equatable {
    var nodes: [PreferenceNode<Value>] = []

    init(key: Any.Type, initialValue: Value? = nil) {
        self.key = key
        let companion = key.companionObjectInstance as! PreferenceKeyCompanion<Value>
        self.initialValue = initialValue ?? companion.defaultValue
        self.reducer = { value, nextValue in
            var updatedValue = value
            companion.reduce(value: &updatedValue, nextValue: { nextValue })
            return updatedValue
        }
    }

    init(key: Any, initialValue: Value, reducer: (Value, Value) -> Value) {
        self.key = key
        self.initialValue = initialValue
        self.reducer = reducer
    }

    let key: Any
    let initialValue: Value
    let reducer: (Value, Value) -> Value

    /// The reduced preference value.
    var reduced: Value {
        var value = initialValue
        for node in nodes {
            value = reducer(value, node.value as! Value)
        }
        return value
    }
}

struct PreferenceNode<Value>: Equatable {
    let id: Int
    let value: Value

    public static func ==(lhs: PreferenceNode<Value>, rhs: PreferenceNode<Value>) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        // Consider lambdas as always equal, otherwise we'll never compare equal
        guard !(lhs.value is Function<Any>) || !(rhs.value is Function<Any>) else {
            return true
        }
        return lhs.value == rhs.value
    }
}
#endif

extension View {
    // SKIP @bridge
    public func preference(key: Any, value: Any?) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SideEffectModifier { context in
            PreferenceValues.shared.contribute(context: context, key: key, value: value)
            return ComposeResult.ok
        })
        #else
        return self
        #endif
    }

    // SKIP DECLARE: public fun <K: PreferenceKey<V>, V> onPreferenceChange(key: KClass<K>, perform: (V) -> Unit): View
    public func onPreferenceChange<K>(_ key: K.Type /* = K.self */, perform action: @escaping (K.Value) -> Void) -> any View where K : PreferenceKey {
        #if SKIP
        // Work around transpiler bug
        // SKIP REPLACE: val companion = key.companionObjectInstance as PreferenceKeyCompanion<V>
        let companion = key.companionObjectInstance as! PreferenceKeyCompanion<V>
        return onPreferenceChange(key: key, defaultValue: companion.defaultValue, reducer: { value, nextValue in
            var updatedValue = value as! V
            companion.reduce(value: &updatedValue, nextValue: { nextValue as! V })
            return updatedValue
        }, action: { value in
            action(value as! V)
        })
        #else
        return self
        #endif
    }

    // SKIP @bridge
    public func onPreferenceChange(key: Any, defaultValue: Any?, reducer: @escaping (Any?, Any?) -> Any?, action: @escaping (Any?) -> Void) -> any View {
        #if SKIP
        return ModifiedContent(content: self, modifier: RenderModifier { renderable, context in
            let preference = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<Any?>, Any>) {
                mutableStateOf(Preference<Any?>(key: key, initialValue: defaultValue, reducer: reducer))
            }
            let preferenceCollector = PreferenceCollector<Any?>(key: key, state: preference)
            let currentAction = rememberUpdatedState(action)
            LaunchedEffect(true) {
                snapshotFlow {
                    preference.value.reduced
                }
                .distinctUntilChanged()
                .collect { newValue in
                    currentAction.value(newValue)
                }
            }

            PreferenceValues.shared.collectPreferences([preferenceCollector]) {
                renderable.Render(context: context)
            }
        })
        #else
        return self
        #endif
    }
}

/*
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

    /// Applies a transformation to a preference value.
    public func transformPreference<K>(_ key: K.Type = K.self, _ callback: @escaping (inout K.Value) -> Void) -> some View where K : PreferenceKey { return stubView() }

}
*/
#endif
