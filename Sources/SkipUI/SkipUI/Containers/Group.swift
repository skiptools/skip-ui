// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct Group : View {
    let content: ComposeView

    public init(@ViewBuilder content: () -> ComposeView) {
        self.content = content()
    }

    #if SKIP
    @Composable public override func Compose(context: ComposeContext) -> ComposeResult {
        ComposeContent(context: context)
        return ComposeResult.ok
    }
    
    @Composable public override func ComposeContent(context: ComposeContext) {
        content.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
