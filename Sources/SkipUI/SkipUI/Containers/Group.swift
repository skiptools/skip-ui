// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.runtime.Composable

public struct Group<Content> : View where Content : View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    #if SKIP
    @Composable public override func Compose(ctx: ComposeContext) {
        content.Compose(ctx)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
