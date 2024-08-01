// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
