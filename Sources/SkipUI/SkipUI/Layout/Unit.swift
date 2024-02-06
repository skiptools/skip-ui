// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public struct UnitPoint : Hashable, Sendable {
    public var x = 0.0
    public var y = 0.0

    public static let zero = UnitPoint(x: 0.0, y: 0.0)
    public static let center = UnitPoint(x: 0.5, y: 0.5)
    public static let leading = UnitPoint(x: 0.0, y: 0.5)
    public static let trailing = UnitPoint(x: 1.0, y: 0.5)
    public static let top = UnitPoint(x: 0.5, y: 0.0)
    public static let bottom = UnitPoint(x: 0.5, y: 1.0)
    public static let topLeading = UnitPoint(x: 0.0, y: 0.0)
    public static let topTrailing = UnitPoint(x: 1.0, y: 0.0)
    public static let bottomLeading = UnitPoint(x: 0.0, y: 1.0)
    public static let bottomTrailing = UnitPoint(x: 1.0, y: 1.0)
}

public struct UnitCurve: Hashable, Sendable {
    private let startControlPoint: UnitPoint
    private let endControlPoint: UnitPoint

    public init(startControlPoint: UnitPoint, endControlPoint: UnitPoint) {
        self.startControlPoint = startControlPoint
        self.endControlPoint = endControlPoint
    }

    public static func bezier(startControlPoint: UnitPoint, endControlPoint: UnitPoint) -> UnitCurve {
        return UnitCurve(startControlPoint: startControlPoint, endControlPoint: endControlPoint)
    }

    @available(*, unavailable)
    public func value(at progress: Double) -> Double {
        fatalError()
    }

    @available(*, unavailable)
    public func velocity(at progress: Double) -> Double {
        fatalError()
    }

    @available(*, unavailable)
    public var inverse: UnitCurve {
        fatalError()
    }

    public static let easeInOut = UnitCurve(startControlPoint: UnitPoint(x: 0.42, y: 0.0), endControlPoint: UnitPoint(x: 0.58, y: 1.0))

    public static let easeIn = UnitCurve(startControlPoint: UnitPoint(x: 0.42, y: 0.0), endControlPoint: UnitPoint(x: 1.0, y: 1.0))

    public static let easeOut = UnitCurve(startControlPoint: UnitPoint(x: 0.0, y: 0.0), endControlPoint: UnitPoint(x: 0.58, y: 1.0))

    @available(*, unavailable)
    public static var circularEaseIn: UnitCurve {
        fatalError()
    }

    @available(*, unavailable)
    public static var circularEaseOut: UnitCurve {
        fatalError()
    }

    @available(*, unavailable)
    public static var circularEaseInOut: UnitCurve {
        fatalError()
    }

    public static let linear = UnitCurve(startControlPoint: UnitPoint(x: 0.0, y: 0.0), endControlPoint: UnitPoint(x: 1.0, y: 1.0))
}
