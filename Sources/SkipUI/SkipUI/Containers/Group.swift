// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct Group<Content> : View where Content : View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = content.Compose(context: context)
    }

    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        ComposeContent(context: context)
        return .ok
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
