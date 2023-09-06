// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT:
// import androidx.compose.foundation.background
// import androidx.compose.foundation.border
// import androidx.compose.foundation.layout.height
// import androidx.compose.foundation.layout.padding
// import androidx.compose.foundation.layout.width
// import androidx.compose.runtime.Composable
// import androidx.compose.ui.Modifier
// import androidx.compose.ui.draw.alpha
// import androidx.compose.ui.draw.rotate
// import androidx.compose.ui.draw.scale
// import androidx.compose.ui.platform.testTag
// import androidx.compose.ui.semantics.contentDescription
// import androidx.compose.ui.semantics.semantics
// import androidx.compose.ui.unit.dp

public protocol View {
    #if SKIP
    // SKIP DECLARE: fun body(): View = EmptyView()
    @ViewBuilder var body: any View { get }
    #else
    associatedtype Body : View
    @ViewBuilder @MainActor var body: Body { get }
    #endif
}

#if SKIP
extension View {
    /// Compose this view without an existing context - typically called when integrating a SwiftUI view tree into pure Compose.
    @Composable public func Compose() {
        Compose(context: ComposeContext())
    }

    /// Calls to `Compose` are added by the transpiler.
    @Composable public func Compose(context: ComposeContext) {
        if let composer = context.composer {
            var context = context
            context.composer = nil
            composer(&self, context)
        } else {
            ComposeContent(context: context)
        }
    }

    /// Compose this view's content.
    @Composable public func ComposeContent(context: ComposeContext) -> Void {
        body.ComposeContent(context)
    }
}
#endif

#if !SKIP

// Stubs needed to compile this package:

extension Optional : View where Wrapped : View {
    public var body: some View {
        stubView()
    }
}

extension Never : View {
}
#endif
