// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.text.input.KeyboardCapitalization
#endif

public enum TextInputAutocapitalization {
    case never
    case words
    case sentences
    case characters

    #if SKIP
    func asKeyboardCapitalization() -> KeyboardCapitalization {
        switch self {
        case .never:
            return KeyboardCapitalization.None
        case .words:
            return KeyboardCapitalization.Words
        case .sentences:
            return KeyboardCapitalization.Sentences
        case .characters:
            return KeyboardCapitalization.Characters
        }
    }
    #endif
}

#if false
@available(iOS 17.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TextInputDictationActivation : Equatable, Sendable {

    /// A configuration that activates dictation when someone selects the
    /// microphone.
    @available(iOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let onSelect: TextInputDictationActivation = { fatalError() }()

    /// A configuration that activates dictation when someone selects the
    /// microphone or looks at the entry field.
    @available(iOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let onLook: TextInputDictationActivation = { fatalError() }()

    
}

@available(iOS 17.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TextInputDictationBehavior : Equatable, Sendable {

    /// A platform-appropriate default text input dictation behavior.
    ///
    /// The automatic behavior uses a ``TextInputDictationActivation`` value of
    /// ``TextInputDictationActivation/onLook`` for visionOS apps and
    /// ``TextInputDictationActivation/onSelect`` for iOS apps.
    @available(iOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let automatic: TextInputDictationBehavior = { fatalError() }()

    /// Adds a dictation microphone in the search bar.
    @available(iOS 17.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static func inline(activation: TextInputDictationActivation) -> TextInputDictationBehavior { fatalError() }

    
}

#endif
#endif
