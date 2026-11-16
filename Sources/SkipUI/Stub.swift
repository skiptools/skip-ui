// Copyright 2023–2026 Skip
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
