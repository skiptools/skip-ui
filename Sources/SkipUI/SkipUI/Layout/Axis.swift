// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

public enum Axis : Int, Hashable, CaseIterable {
    case horizontal = 1 // For bridging
    case vertical = 2 // For bridging

    public struct Set : OptionSet, Hashable, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let horizontal: Axis.Set = Axis.Set(Axis.horizontal)
        public static let vertical: Axis.Set = Axis.Set(Axis.vertical)

        public init(_ axis: Axis) {
            self.rawValue = axis.rawValue
        }
    }
}

#endif
