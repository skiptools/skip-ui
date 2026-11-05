// Copyright 2023–2026 Skip
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
    @Composable override func Evaluate(context: ComposeContext, options: Int) -> kotlin.collections.List<Renderable> {
        return view.Evaluate(context: context, options: options)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
