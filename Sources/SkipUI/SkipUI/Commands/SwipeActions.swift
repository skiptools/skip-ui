// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation

extension View {
    public func swipeActions(edge: HorizontalEdge = .trailing, allowsFullSwipe: Bool = true, @ViewBuilder content: () -> any View) -> some View {
        #if SKIP
        return ModifiedContent(content: self, modifier: SwipeActionsModifier(edge: edge, allowsFullSwipe: allowsFullSwipe, content: ComposeBuilder.from(content)))
        #else
        return self
        #endif
    }
}

#if SKIP
/// Holds a single edge's swipe action configuration.
struct SwipeActionsConfig {
    let allowsFullSwipe: Bool
    let content: ComposeBuilder
}

final class SwipeActionsModifier: RenderModifier {
    let edge: HorizontalEdge
    let allowsFullSwipe: Bool
    let content: ComposeBuilder

    init(edge: HorizontalEdge, allowsFullSwipe: Bool, content: ComposeBuilder) {
        self.edge = edge
        self.allowsFullSwipe = allowsFullSwipe
        self.content = content
        super.init()
    }

    /// Walk the modifier chain and collect leading + trailing swipe configs.
    /// Innermost modifier on a given edge wins (matches SwiftUI semantics).
    static func combined(for renderable: Renderable) -> (leading: SwipeActionsConfig?, trailing: SwipeActionsConfig?) {
        var leading: SwipeActionsConfig? = nil
        var trailing: SwipeActionsConfig? = nil
        renderable.forEachModifier {
            if let mod = $0 as? SwipeActionsModifier {
                let config = SwipeActionsConfig(allowsFullSwipe: mod.allowsFullSwipe, content: mod.content)
                if mod.edge == .leading {
                    leading = leading ?? config
                } else {
                    trailing = trailing ?? config
                }
            }
            return nil
        }
        return (leading: leading, trailing: trailing)
    }
}
#endif
#endif
