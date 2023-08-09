// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import struct Foundation.Locale

/// Defines how typesetting language is determined for text.
///
/// Use ``View/typesettingLanguage(_:isEnabled:)`` or
/// ``Text/typesettingLanguage(_:isEnabled:)`` to specify
/// the typesetting language .
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct TypesettingLanguage : Sendable, Equatable {

    /// Automatic language behavior.
    ///
    /// When determining the language to use for typesetting the current UI
    /// language and preferred languages will be considiered. For example, if
    /// the current UI locale is for English and Thai is included in the
    /// preferred languages then line heights will be taller to accommodate the
    /// taller glyphs used by Thai.
    public static let automatic: TypesettingLanguage = { fatalError() }()

    /// Use explicit language.
    ///
    /// An explicit language will be used for typesetting. For example, if used
    /// with Thai language the line heights will be as tall as needed to
    /// accommodate Thai.
    ///
    /// - Parameters:
    ///   - language: The language to use for typesetting.
    /// - Returns: A `TypesettingLanguage`.
    public static func explicit(_ language: Locale.Language) -> TypesettingLanguage { fatalError() }

    public static func == (a: TypesettingLanguage, b: TypesettingLanguage) -> Bool { fatalError() }
}
