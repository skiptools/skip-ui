// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum VerticalEdge : Int, Hashable, CaseIterable, Codable {
    case top = 1
    case bottom = 2

    public struct Set : OptionSet, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let top: VerticalEdge.Set = VerticalEdge.Set(VerticalEdge.top)
        public static let bottom: VerticalEdge.Set = VerticalEdge.Set(VerticalEdge.bottom)
        public static let all: VerticalEdge.Set = VerticalEdge.Set(rawValue: 3)

        public init(_ e: VerticalEdge) {
            self.init(rawValue: e.rawValue)
        }
    }
}

#endif
