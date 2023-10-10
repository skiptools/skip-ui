// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public enum TextInputAutocapitalization : Sendable {
    case never
    case words
    case sentences
    case characters
}

#if !SKIP

// TODO: Process for use in SkipUI

@available(iOS 17.0, xrOS 1.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TextInputDictationActivation : Equatable, Sendable {

    /// A configuration that activates dictation when someone selects the
    /// microphone.
    @available(iOS 17.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let onSelect: TextInputDictationActivation = { fatalError() }()

    /// A configuration that activates dictation when someone selects the
    /// microphone or looks at the entry field.
    @available(iOS 17.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let onLook: TextInputDictationActivation = { fatalError() }()

    
}

@available(iOS 17.0, xrOS 1.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TextInputDictationBehavior : Equatable, Sendable {

    /// A platform-appropriate default text input dictation behavior.
    ///
    /// The automatic behavior uses a ``TextInputDictationActivation`` value of
    /// ``TextInputDictationActivation/onLook`` for visionOS apps and
    /// ``TextInputDictationActivation/onSelect`` for iOS apps.
    @available(iOS 17.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static let automatic: TextInputDictationBehavior = { fatalError() }()

    /// Adds a dictation microphone in the search bar.
    @available(iOS 17.0, xrOS 1.0, *)
    @available(macOS, unavailable)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    public static func inline(activation: TextInputDictationActivation) -> TextInputDictationBehavior { fatalError() }

    
}

#endif
