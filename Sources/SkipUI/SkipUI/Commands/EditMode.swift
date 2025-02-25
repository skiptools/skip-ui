// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public enum EditMode : Hashable, Sendable {
    case inactive
    case transient
    case active

    public var isEditing: Bool {
        return self != .inactive
    }
}

#endif
