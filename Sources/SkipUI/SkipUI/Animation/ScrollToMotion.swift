// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE

/// Decides whether `ScrollViewProxy.scrollTo` moves with animation.
///
/// SwiftUI animates that call only when it happens inside `withAnimation` or
/// `withTransaction`. The recent-withAnimation marker stays set for a frame after
/// any other animated update, and a later `scrollTo` from `onChange` or a task
/// must not inherit it.
enum ScrollToMotion {
    static func shouldAnimate(activeAnimatedTransaction: Bool, recentWithAnimationMarker: Bool) -> Bool {
        if recentWithAnimationMarker && !activeAnimatedTransaction {
            return false
        }
        return activeAnimatedTransaction
    }
}

#endif
