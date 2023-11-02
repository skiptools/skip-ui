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

public protocol CoordinateSpaceProtocol {
    var coordinateSpace: CoordinateSpace { get }
}

extension CoordinateSpaceProtocol {
    // SKIP NOWARN
    public static func scrollView(axis: Axis) -> NamedCoordinateSpace {
        return named("_scrollView_axis_\(axis.rawValue)_")
    }

    // SKIP NOWARN
    public static var scrollView: NamedCoordinateSpace {
        return named("_scrollView_")
    }

    // SKIP NOWARN
    public static func named(_ name: some Hashable) -> NamedCoordinateSpace {
        return NamedCoordinateSpace(coordinateSpace: .named(name))
    }
}

extension CoordinateSpaceProtocol where Self == LocalCoordinateSpace {
    // SKIP NOWARN
    public static var local: LocalCoordinateSpace {
        return LocalCoordinateSpace()
    }
}

extension CoordinateSpaceProtocol where Self == GlobalCoordinateSpace {
    // SKIP NOWARN
    public static var global: GlobalCoordinateSpace {
        return GlobalCoordinateSpace()
    }
}

public class NamedCoordinateSpace : CoordinateSpaceProtocol, Equatable {
    private let _coordinateSpace: CoordinateSpace

    init(coordinateSpace: CoordinateSpace) {
        _coordinateSpace = coordinateSpace
    }

    public var coordinateSpace: CoordinateSpace {
        return _coordinateSpace
    }

    public static func ==(lhs: NamedCoordinateSpace, rhs: NamedCoordinateSpace) -> Bool {
        return lhs.coordinateSpace == rhs.coordinateSpace
    }
}

public class LocalCoordinateSpace : CoordinateSpaceProtocol {
    public var coordinateSpace: CoordinateSpace {
        return .local
    }
}

public class GlobalCoordinateSpace : CoordinateSpaceProtocol {
    public var coordinateSpace: CoordinateSpace {
        return .global
    }
}
