// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP


/// Keyboard shortcuts describe combinations of keys on a keyboard that the user
/// can press in order to activate a button or toggle.
@available(iOS 14.0, macOS 11.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct KeyboardShortcut : Sendable {

    /// Options for how a keyboard shortcut participates in automatic localization.
    ///
    /// A shortcut's `key` that is defined on an US-English keyboard
    /// layout might not be reachable on international layouts.
    /// For example the shortcut `⌘[` works well for the US layout but is
    /// hard to reach for German users.
    /// On the German keyboard layout, pressing `⌥5` will produce
    /// `[`, which causes the shortcut to become `⌥⌘5`.
    /// If configured, which is the default behavior, automatic shortcut
    /// remapping will convert it to `⌘Ö`.
    ///
    /// In addition to that, some keyboard shortcuts carry information
    /// about directionality.
    /// Right-aligning a block of text or seeking forward in context of music
    /// playback are such examples. These kinds of shortcuts benefit from the option
    /// ``KeyboardShortcut/Localization-swift.struct/withoutMirroring``
    /// to tell the system that they won't be flipped when running in a
    /// right-to-left context.
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public struct Localization : Sendable {

        /// Remap shortcuts to their international counterparts, mirrored for
        /// right-to-left usage if appropriate.
        ///
        /// This is the default configuration.
        public static let automatic: KeyboardShortcut.Localization = { fatalError() }()

        /// Don't mirror shortcuts.
        ///
        /// Use this for shortcuts that always have a specific directionality, like
        /// aligning something on the right.
        ///
        /// Don't use this option for navigational shortcuts like "Go Back" because navigation
        /// is flipped in right-to-left contexts.
        public static let withoutMirroring: KeyboardShortcut.Localization = { fatalError() }()

        /// Don't use automatic shortcut remapping.
        ///
        /// When you use this mode, you have to take care of international use-cases separately.
        public static let custom: KeyboardShortcut.Localization = { fatalError() }()
    }

    /// The standard keyboard shortcut for the default button, consisting of
    /// the Return (↩) key and no modifiers.
    ///
    /// On macOS, the default button is designated with special coloration. If
    /// more than one control is assigned this shortcut, only the first one is
    /// emphasized.
    public static let defaultAction: KeyboardShortcut = { fatalError() }()

    /// The standard keyboard shortcut for cancelling the in-progress action
    /// or dismissing a prompt, consisting of the Escape (⎋) key and no
    /// modifiers.
    public static let cancelAction: KeyboardShortcut = { fatalError() }()

    /// The key equivalent that the user presses in conjunction with any
    /// specified modifier keys to activate the shortcut.
    public var key: KeyEquivalent { get { fatalError() } }

    /// The modifier keys that the user presses in conjunction with a key
    /// equivalent to activate the shortcut.
    public var modifiers: EventModifiers { get { fatalError() } }

    /// The localization strategy to apply to this shortcut.
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public var localization: KeyboardShortcut.Localization { get { fatalError() } }

    /// Creates a new keyboard shortcut with the given key equivalent and set of
    /// modifier keys.
    ///
    /// The localization configuration defaults to ``KeyboardShortcut/Localization-swift.struct/automatic``.
    public init(_ key: KeyEquivalent, modifiers: EventModifiers = .command) { fatalError() }

    /// Creates a new keyboard shortcut with the given key equivalent and set of
    /// modifier keys.
    ///
    /// Use the `localization` parameter to specify a localization strategy
    /// for this shortcut.
    @available(iOS 15.0, macOS 12.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(_ key: KeyEquivalent, modifiers: EventModifiers = .command, localization: KeyboardShortcut.Localization) { fatalError() }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension KeyboardShortcut : Hashable {


}

#endif
