// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
#endif

/// Used to directly wrap user Compose content.
///
/// - Seealso: `ComposeBuilder`
// SKIP @bridge
public struct ComposeView: View {
    #if SKIP
    private let content: @Composable (ComposeContext) -> Void

    /// Constructor.
    ///
    /// The supplied `content` is the content to compose.
    public init(content: @Composable (ComposeContext) -> Void) {
        self.content = content
    }
    #endif

    // SKIP @bridge
    public init(bridgedContent: Any) {
        #if SKIP
        self.content = { (bridgedContent as? ContentComposer)?.Compose(context: $0) }
        #endif
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        content(context)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#if SKIP
/// Encapsulation of Composable content.
public protocol ContentComposer {
    @Composable func Compose(context: ComposeContext)
}

extension View {
    /// Add the given modifier to the underlying Compose view.
    public func composeModifier(_ modifier: (Modifier) -> Modifier) -> View {
        return ComposeModifierView(targetView: self) {
            $0.modifier = modifier($0.modifier)
            return ComposeResult.ok
        }
    }
}
#endif
#endif
