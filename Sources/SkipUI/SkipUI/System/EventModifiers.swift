// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

@frozen public struct EventModifiers : OptionSet, Hashable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let capsLock = EventModifiers(rawValue: 1)
    public static let shift = EventModifiers(rawValue: 2)
    public static let control = EventModifiers(rawValue: 4)
    public static let option = EventModifiers(rawValue: 8)
    public static let command = EventModifiers(rawValue: 16)
    public static let numericPad = EventModifiers(rawValue: 32)
    public static let all = EventModifiers(rawValue: 63)
}

#endif
