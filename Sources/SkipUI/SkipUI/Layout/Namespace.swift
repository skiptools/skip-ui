// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
