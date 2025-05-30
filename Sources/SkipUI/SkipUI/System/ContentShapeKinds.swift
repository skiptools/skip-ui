// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public struct ContentShapeKinds : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let interaction = ContentShapeKinds(rawValue: 1 << 0)
    public static let dragPreview = ContentShapeKinds(rawValue: 1 << 1)
    public static let contextMenuPreview = ContentShapeKinds(rawValue: 1 << 2)
    public static let hoverEffect = ContentShapeKinds(rawValue: 1 << 3)
    public static let accessibility = ContentShapeKinds(rawValue: 1 << 4)
}

#endif
