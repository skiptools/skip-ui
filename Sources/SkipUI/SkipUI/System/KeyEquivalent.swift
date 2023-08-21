// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

/// Key equivalents consist of a letter, punctuation, or function key that can
/// be combined with an optional set of modifier keys to specify a keyboard
/// shortcut.
///
/// Key equivalents are used to establish keyboard shortcuts to app
/// functionality. Any key can be used as a key equivalent as long as pressing
/// it produces a single character value. Key equivalents are typically
/// initialized using a single-character string literal, with constants for
/// unprintable or hard-to-type values.
///
/// The modifier keys necessary to type a key equivalent are factored in to the
/// resulting keyboard shortcut. That is, a key equivalent whose raw value is
/// the capitalized string "A" corresponds with the keyboard shortcut
/// Command-Shift-A. The exact mapping may depend on the keyboard layout—for
/// example, a key equivalent with the character value "}" produces a shortcut
/// equivalent to Command-Shift-] on ANSI keyboards, but would produce a
/// different shortcut for keyboard layouts where punctuation characters are in
/// different locations.
@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public struct KeyEquivalent : Sendable {

    /// Up Arrow (U+F700)
    public static let upArrow: KeyEquivalent = { fatalError() }()

    /// Down Arrow (U+F701)
    public static let downArrow: KeyEquivalent = { fatalError() }()

    /// Left Arrow (U+F702)
    public static let leftArrow: KeyEquivalent = { fatalError() }()

    /// Right Arrow (U+F703)
    public static let rightArrow: KeyEquivalent = { fatalError() }()

    /// Escape (U+001B)
    public static let escape: KeyEquivalent = { fatalError() }()

    /// Delete (U+0008)
    public static let delete: KeyEquivalent = { fatalError() }()

    /// Delete Forward (U+F728)
    public static let deleteForward: KeyEquivalent = { fatalError() }()

    /// Home (U+F729)
    public static let home: KeyEquivalent = { fatalError() }()

    /// End (U+F72B)
    public static let end: KeyEquivalent = { fatalError() }()

    /// Page Up (U+F72C)
    public static let pageUp: KeyEquivalent = { fatalError() }()

    /// Page Down (U+F72D)
    public static let pageDown: KeyEquivalent = { fatalError() }()

    /// Clear (U+F739)
    public static let clear: KeyEquivalent = { fatalError() }()

    /// Tab (U+0009)
    public static let tab: KeyEquivalent = { fatalError() }()

    /// Space (U+0020)
    public static let space: KeyEquivalent = { fatalError() }()

    /// Return (U+000D)
    public static let `return`: KeyEquivalent = { fatalError() }()

    /// The character value that the key equivalent represents.
    public var character: Character { get { fatalError() } }

    /// Creates a new key equivalent from the given character value.
    public init(_ character: Character) { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent : Hashable {


    

}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent : ExpressibleByExtendedGraphemeClusterLiteral {

    /// Creates an instance initialized to the given value.
    ///
    /// - Parameter value: The value of the new instance.
    public init(extendedGraphemeClusterLiteral: Character) { fatalError() }

    /// A type that represents an extended grapheme cluster literal.
    ///
    /// Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`,
    /// `String`, and `StaticString`.
    public typealias ExtendedGraphemeClusterLiteralType = Character

    /// A type that represents a Unicode scalar literal.
    ///
    /// Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`,
    /// `Character`, `String`, and `StaticString`.
    public typealias UnicodeScalarLiteralType = Character
}

#endif
