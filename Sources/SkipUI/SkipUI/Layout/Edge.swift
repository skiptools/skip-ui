// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum Edge : Int, Hashable, CaseIterable {
    case top = 1 // For bridging
    case leading = 2 // For bridging
    case bottom = 4 // For bridging
    case trailing = 8 // For bridging

    public struct Set : OptionSet, Equatable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let top: Edge.Set = Edge.Set(Edge.top)
        public static let leading: Edge.Set = Edge.Set(Edge.leading)
        public static let bottom: Edge.Set = Edge.Set(Edge.bottom)
        public static let trailing: Edge.Set = Edge.Set(Edge.trailing)

        public static let all: Edge.Set = Edge.Set(rawValue: 15)
        public static let horizontal: Edge.Set = Edge.Set(rawValue: 10)
        public static let vertical: Edge.Set = Edge.Set(rawValue: 5)

        public init(_ e: Edge) {
            self.rawValue = e.rawValue
        }
    }
}

#endif
