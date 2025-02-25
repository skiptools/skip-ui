// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if false
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

    
}

extension View {

    /// Specifies the language for typesetting.
    ///
    /// In some cases `Text` may contain text of a particular language which
    /// doesn't match the device UI language. In that case it's useful to
    /// specify a language so line height, line breaking and spacing will
    /// respect the script used for that language. For example:
    ///
    ///     Text(verbatim: "แอปเปิล")
    ///         .typesettingLanguage(.init(languageCode: .thai))
    ///
    /// Note: this language does not affect text localization.
    ///
    /// - Parameters:
    ///   - language: The explicit language to use for typesetting.
    ///   - isEnabled: A Boolean value that indicates whether text langauge is
    ///     added
    /// - Returns: A view with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: Locale.Language, isEnabled: Bool = true) -> some View { return stubView() }


    /// Specifies the language for typesetting.
    ///
    /// In some cases `Text` may contain text of a particular language which
    /// doesn't match the device UI language. In that case it's useful to
    /// specify a language so line height, line breaking and spacing will
    /// respect the script used for that language. For example:
    ///
    ///     Text(verbatim: "แอปเปิล").typesettingLanguage(
    ///         .explicit(.init(languageCode: .thai)))
    ///
    /// Note: this language does not affect text localized localization.
    ///
    /// - Parameters:
    ///   - language: The language to use for typesetting.
    ///   - isEnabled: A Boolean value that indicates whether text language is
    ///     added
    /// - Returns: A view with the typesetting language set to the value you
    ///   supply.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public func typesettingLanguage(_ language: TypesettingLanguage, isEnabled: Bool = true) -> some View { return stubView() }
}
#endif
