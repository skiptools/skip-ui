// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public struct SubmitTriggers : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let text = SubmitTriggers(rawValue: 1 << 0) // For bridging
    public static let search = SubmitTriggers(rawValue: 1 << 1) // For bridging
}

#endif
