// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
#endif

public struct AnyView : View {
    private let view: any View

    public init(_ view: any View) {
        self.view = view
    }

    public init(erasing view: any View) {
        self.view = view
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let _ = view.Compose(context: context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
