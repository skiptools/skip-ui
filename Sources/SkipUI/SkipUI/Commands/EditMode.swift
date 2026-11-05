// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE

public enum EditMode : Hashable {
    case inactive
    case transient
    case active

    public var isEditing: Bool {
        return self != .inactive
    }
}

#endif
