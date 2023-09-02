// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct Angle: Hashable, Sendable {
    public static var zero = Angle()

    public var radians: Double
    public var degrees: Double {
        get {
            return Self.radiansToDegrees(radians)
        }
        set {
            radians = Self.degreesToRadians(newValue)
        }
    }

    public init() {
        self.radians = 0.0
    }

    public init(radians: Double) {
        self.radians = radians
    }

    public init(degrees: Double) {
        self.radians = Self.degreesToRadians(degrees)
    }

    public static func radians(_ radians: Double) -> Angle {
        return Angle(radians: radians)
    }

    public static func degrees(_ degrees: Double) -> Angle {
        return Angle(degrees: degrees)
    }

    private static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / Double.pi
    }

    private static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
}

extension Angle: Comparable {
    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians < rhs.radians
    }
}

#if !SKIP

// Stubs needed to compile this package:

extension Angle : Animatable {
    public var animatableData: AnimatableData { get { fatalError() } set { } }
    public typealias AnimatableData = Double
}

#endif
