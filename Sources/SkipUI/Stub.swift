// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if !SKIP

/// No-op
func stub<T>() -> T {
    fatalError("stub")
}

// SkipUI.kt:13:14 'Nothing' return type can't be specified with type alias
public typealias Nothing = Never

/// No-op
func stubView() -> some View {
    return EmptyView()
}

/// No-op
@usableFromInline func never() -> Nothing {
    stub()
}

public typealias NeverView = Never

/// A stub view
public struct StubView : View {
    public typealias Body = Never
    public var body: Body {
        fatalError()
    }
}

#endif
#endif
