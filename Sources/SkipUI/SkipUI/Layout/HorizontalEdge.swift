// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

public enum HorizontalEdge : Int, CaseIterable, Codable, Hashable, Sendable {
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
