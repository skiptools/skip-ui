// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
