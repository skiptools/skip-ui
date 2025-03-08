// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum DynamicTypeSize : Int, Hashable, Comparable, CaseIterable {
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
