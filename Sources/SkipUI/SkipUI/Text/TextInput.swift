// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.ui.text.input.KeyboardCapitalization
#endif

public enum TextInputAutocapitalization: Int {
    case never = 0 // For bridging
    case words = 1 // For bridging
    case sentences = 2 // For bridging
    case characters = 3 // For bridging

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

public struct TextInputFormattingControlPlacement {
    public struct Set : OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let contextMenu = TextInputFormattingControlPlacement.Set(rawValue: 1 << 0)
        public static let inputAssistant = TextInputFormattingControlPlacement.Set(rawValue: 1 << 1)
        public static let all = TextInputFormattingControlPlacement.Set(rawValue: 1 << 2)
        public static let `default` = TextInputFormattingControlPlacement.Set(rawValue: 1 << 3)
    }
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
