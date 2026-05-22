// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

public enum HorizontalEdge : Int, CaseIterable, Codable, Hashable {
    case leading = 1
    case trailing = 2

    public struct Set : OptionSet, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let leading: HorizontalEdge.Set = HorizontalEdge.Set(rawValue: 1)
        public static let trailing: HorizontalEdge.Set = HorizontalEdge.Set(rawValue: 2)
        public static let all: HorizontalEdge.Set = HorizontalEdge.Set(rawValue: 3)

        public init(_ edge: HorizontalEdge) {
            self.rawValue = edge.rawValue
        }
    }
}

#endif
