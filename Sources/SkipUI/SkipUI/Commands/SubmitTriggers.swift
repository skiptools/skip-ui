// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

public struct SubmitTriggers : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let text = SubmitTriggers(rawValue: 1 << 0) // For bridging
    public static let search = SubmitTriggers(rawValue: 1 << 1) // For bridging
}

#endif
