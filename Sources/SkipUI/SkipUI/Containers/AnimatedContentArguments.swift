// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.runtime.Stable
import androidx.compose.ui.Modifier

/// Used in our containers to prevent recomposing animated content unnecessarily.
@Stable
struct AnimatedContentArguments {
    let views: Array<View>
    let idMap: (View) -> Any?
    let ids: Array<Any>
    let rememberedIds: MutableSet<Any>
    let newIds: Array<Any>
    let rememberedNewIds: MutableSet<Any>
    let composer: RenderingComposer?

    static func ==(lhs: AnimatedContentArguments, rhs: AnimatedContentArguments) -> Bool {
        return lhs.ids == rhs.ids && lhs.rememberedIds == rhs.rememberedIds && lhs.newIds == rhs.newIds && lhs.rememberedNewIds == rhs.rememberedNewIds
    }
}
#endif
