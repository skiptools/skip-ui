// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.runtime.Composable
#endif

/// Used to directly wrap user Compose content.
///
/// - Seealso: `ComposeBuilder`
public struct ComposeView: View {
    #if SKIP
    private let content: @Composable (ComposeContext) -> Void

    /// Constructor.
    ///
    /// The supplied `content` is the content to compose.
    public init(content: @Composable (ComposeContext) -> Void) {
        self.content = content
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        content(context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}
