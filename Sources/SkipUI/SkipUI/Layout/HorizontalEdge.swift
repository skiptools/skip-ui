// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum HorizontalEdge : Int, CaseIterable, Codable, Hashable {
    case leading = 1
    case trailing = 2

    public struct Set : OptionSet {
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
