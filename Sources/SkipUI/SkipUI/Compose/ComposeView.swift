// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
#endif

/// Used to directly wrap user Compose content.
///
/// - Seealso: `ComposeBuilder`
// SKIP @bridge
public struct ComposeView: View, Renderable {
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
    @Composable override func Render(context: ComposeContext) {
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

/// Encapsulation of a Compose modifier.
public protocol ContentModifier {
    func modify(view: any View) -> any View
}
#endif

extension View {
    #if SKIP
    /// Add the given modifier to the underlying Compose view.
    public func composeModifier(_ modifier: (Modifier) -> Modifier) -> View {
        return ModifiedContent(content: self, modifier: RenderModifier {
            return modifier($0.modifier)
        })
    }
    
    /// Add the given scoped modifier to the underlying Compose view.
    // SKIP DECLARE: fun <S: Any> composeModifier(scope: KClass<S>, modifier: S.(Modifier) -> Modifier): View
    public func composeModifier<S>(scope: S.Type, _ modifier: (Modifier) -> Modifier) throws -> View {
        return ModifiedContent(content: self, modifier: RenderModifier { context in
            let scope = try context.scope as S
            return scope.run { modifier(context.modifier) }
        })
    }
    #endif

    /// Apply the given `ContentModifier`.
    // SKIP @bridge
    public func applyContentModifier(bridgedContent: Any) -> any View {
        #if SKIP
        return (bridgedContent as? ContentModifier)?.modify(view: self) ?? self
        #else
        return self
        #endif
    }
}
#endif
