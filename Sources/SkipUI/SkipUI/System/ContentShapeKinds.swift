// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

public struct ContentShapeKinds : OptionSet, Sendable {
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
