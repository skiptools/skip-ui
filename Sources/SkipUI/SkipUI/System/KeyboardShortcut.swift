// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
