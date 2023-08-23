// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public enum Axis : Int, Hashable, CaseIterable {
    case horizontal = 1
    case vertical = 2

    public struct Set : OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let horizontal: Axis.Set = Axis.Set(rawValue: Axis.horizontal.rawValue)
        public static let vertical: Axis.Set = Axis.Set(rawValue: Axis.vertical.rawValue)
    }
}

extension Axis: Sendable {
}

extension Axis.Set: Sendable {
}
