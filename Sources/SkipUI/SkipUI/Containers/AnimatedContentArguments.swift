// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.runtime.Stable
import androidx.compose.ui.Modifier

/// Used in our containers to prevent recomposing animated content unnecessarily.
@Stable
struct AnimatedContentArguments: Equatable {
    let views: Array<View>
    let idMap: (View) -> Any?
    let ids: Array<Any>
    let rememberedIds: MutableSet<Any>
    let newIds: Array<Any>
    let rememberedNewIds: MutableSet<Any>
    let composer: RenderingComposer?
    let isBridged: Bool

    static func ==(lhs: AnimatedContentArguments, rhs: AnimatedContentArguments) -> Bool {
        // In bridged mode there are cases where a content view (e.g. List/ForEach) will not recompose on its own
        // when the view's state changes, so shortcutting the AnimatedContent when the IDs compare equal results in
        // showing stale content. We have to shortcut in non-bridged mode, however, because otherwise we may see glitches
        // in animated content when the keyboard hides/shows. The reason for this is unknown, as is the reason we do
        // not see these glitches in bridged mode
        guard !isBridged else {
            return lhs === rhs
        }
        return lhs.ids == rhs.ids && lhs.rememberedIds == rhs.rememberedIds && lhs.newIds == rhs.newIds && lhs.rememberedNewIds == rhs.rememberedNewIds
    }
}
#endif
