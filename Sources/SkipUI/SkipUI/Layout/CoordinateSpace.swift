// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

public enum CoordinateSpace: Hashable {
    case global
    case local
    case named(AnyHashable)

    public var isGlobal: Bool {
        return self == .global
    }

    public var isLocal: Bool {
        return self == .local
    }
}

// Model `CoordinateSpaceProtocol` as a class. Kotlin does not support static members of protocols
public class CoordinateSpaceProtocol {
    public var coordinateSpace: CoordinateSpace {
        return .global
    }

    public static func scrollView(axis: Axis) -> NamedCoordinateSpace {
        return named("_scrollView_axis_\(axis.rawValue)_")
    }

    public static var scrollView: NamedCoordinateSpace {
        return named("_scrollView_")
    }

    public static func named(_ name: some Hashable) -> NamedCoordinateSpace {
        return NamedCoordinateSpace(coordinateSpace: .named(name))
    }

    public static let local = LocalCoordinateSpace()
    public static let global = GlobalCoordinateSpace()
}

public class NamedCoordinateSpace : CoordinateSpaceProtocol, Equatable {
    public override var coordinateSpace: CoordinateSpace {
        return _coordinateSpace
    }

    private let _coordinateSpace: CoordinateSpace

    init(coordinateSpace: CoordinateSpace) {
        _coordinateSpace = coordinateSpace
    }

    public static func ==(lhs: NamedCoordinateSpace, rhs: NamedCoordinateSpace) -> Bool {
        return lhs.coordinateSpace == rhs.coordinateSpace
    }
}

public class LocalCoordinateSpace : CoordinateSpaceProtocol {
    public override var coordinateSpace: CoordinateSpace {
        return .local
    }
}

public class GlobalCoordinateSpace : CoordinateSpaceProtocol {
}
