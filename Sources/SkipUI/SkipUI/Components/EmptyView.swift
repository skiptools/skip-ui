// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// SKIP INSERT: import androidx.compose.runtime.Composable

public struct EmptyView : View {
    public init() {
    }
    
    #if SKIP
    @Composable public override func Compose(ctx: ComposeContext) {
    }
    #else
    public var body: some View {
        Never()
    }
    #endif
}

extension EmptyView : Sendable {
}
