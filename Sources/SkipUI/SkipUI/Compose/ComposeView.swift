// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
// SKIP INSERT: import androidx.compose.runtime.Composable

/// View that wraps `Composable` content.
///
/// Used to wrap the content of SwiftUI `@ViewBuilders`, and may be used manually to embed raw Compose code.
public struct ComposeView: View {
    private let content: @Composable (ComposeContext) -> Void

    public init(content: @Composable (ComposeContext) -> Void) {
        self.content = content
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        content(context)
    }

    @Composable public override func Compose(context: ComposeContext) {
        ComposeContent(context)
    }
}
#endif
