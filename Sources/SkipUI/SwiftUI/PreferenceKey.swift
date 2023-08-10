// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

#endif
