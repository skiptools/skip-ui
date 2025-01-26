// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE

public enum DynamicTypeSize : Int, Hashable, Comparable, CaseIterable, Sendable {
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge
    case accessibility1
    case accessibility2
    case accessibility3
    case accessibility4
    case accessibility5

    public var isAccessibilitySize: Bool {
        return rawValue >= DynamicTypeSize.accessibility1.rawValue
    }

    public static func < (a: DynamicTypeSize, b: DynamicTypeSize) -> Bool {
        return a.rawValue < b.rawValue
    }
}

#endif
