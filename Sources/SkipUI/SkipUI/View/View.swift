// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
// SKIP INSERT: import androidx.compose.foundation.background
// SKIP INSERT: import androidx.compose.foundation.layout.height
// SKIP INSERT: import androidx.compose.foundation.layout.width
// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.ui.Modifier
// SKIP INSERT: import androidx.compose.ui.draw.alpha
// SKIP INSERT: import androidx.compose.ui.draw.rotate
// SKIP INSERT: import androidx.compose.ui.draw.scale
// SKIP INSERT: import androidx.compose.ui.platform.testTag
// SKIP INSERT: import androidx.compose.ui.semantics.contentDescription
// SKIP INSERT: import androidx.compose.ui.semantics.semantics
// SKIP INSERT: import androidx.compose.ui.unit.dp
#endif

public protocol View {
    #if SKIP
    /// The transpiler adds `Compose(ctx)` tail calls to compose each view.
    // SKIP INSERT: @Composable fun Compose(ctx: ComposeContext): Unit = body().Compose(ctx)

    // SKIP DECLARE: fun body(): View = EmptyView()
    @ViewBuilder var body: any View { get }
    #else
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
    #endif
}

#if SKIP
extension View {
    @Composable public func Compose() {
        Compose(ComposeContext())
    }
}
#endif

#if !SKIP

// These conformances are necessary to compile this package.

extension Optional : View where Wrapped : View {
    public var body: some View { Never() }
}

extension Never : View {
}
#endif
