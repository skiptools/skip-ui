// Copyright 2023–2026 Skip
#if !SKIP_BRIDGE

public struct Namespace /* : DynamicProperty */ {
    public init() {
    }

    public var wrappedValue: Namespace.ID {
        fatalError()
    }

    public struct ID : Hashable {
    }
}

#endif
