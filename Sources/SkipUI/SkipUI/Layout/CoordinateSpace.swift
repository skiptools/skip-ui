// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

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

func CoordinateSpaceProtocolFrom(bridged: Int, name: AnyHashable?) -> CoordinateSpaceProtocol {
    switch bridged {
    case 0:
        return GlobalCoordinateSpace.global
    case 1:
        return LocalCoordinateSpace.local
    default:
        return NamedCoordinateSpace.named(name ?? "" as AnyHashable)
    }
}

extension CoordinateSpaceProtocol {
    public static func scrollView(axis: Axis) -> NamedCoordinateSpace {
        return named("_scrollView_axis_\(axis.rawValue)_")
    }

    public static var scrollView: NamedCoordinateSpace {
        return named("_scrollView_")
    }

    public static func named(_ name: some Hashable) -> NamedCoordinateSpace {
        return NamedCoordinateSpace(coordinateSpace: .named(name))
    }
}

extension CoordinateSpaceProtocol where Self == LocalCoordinateSpace {
    public static var local: LocalCoordinateSpace {
        return LocalCoordinateSpace()
    }
}

extension CoordinateSpaceProtocol where Self == GlobalCoordinateSpace {
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

#endif
