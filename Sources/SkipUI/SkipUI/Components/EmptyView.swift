// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct EmptyView : View {
    public init() {
    }
    
    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

extension EmptyView : Sendable {
}
