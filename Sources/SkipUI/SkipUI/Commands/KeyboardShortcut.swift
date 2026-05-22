// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

public struct KeyboardShortcut : Hashable, Sendable {
    public enum Localization : Hashable, Sendable {
        case automatic
        case withoutMirroring
        case custom
    }

    public static let defaultAction = KeyboardShortcut(.return, modifiers: [])
    public static let cancelAction = KeyboardShortcut(.escape, modifiers: [])

    public let key: KeyEquivalent
    public let modifiers: EventModifiers
    public let localization: KeyboardShortcut.Localization

    public init(_ key: KeyEquivalent, modifiers: EventModifiers = .command, localization: KeyboardShortcut.Localization = .automatic) {
        self.key = key
        self.modifiers = modifiers
        self.localization = localization
    }
}

#endif
