// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.geometry.Rect
#endif

public struct SafeAreaRegions : OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let container = SafeAreaRegions(rawValue: 1)
    public static let keyboard = SafeAreaRegions(rawValue: 2)
    public static let all = SafeAreaRegions(rawValue: 3)
}

#if SKIP
import androidx.compose.ui.geometry.Rect

/// Track safe area.
struct SafeArea: Equatable {
    /// Total bounds of presentation root.
    let presentationBoundsPx: Rect

    /// Safe bounds of presentation root.
    let safeBoundsPx: Rect

    /// The edges whose safe area is solely due to system bars.
    let absoluteSystemBarEdges: Edge.Set

    init(presentation: Rect, safe: Rect, absoluteSystemBars: Edge.Set = []) {
        self.presentationBoundsPx = presentation
        self.safeBoundsPx = safe
        self.absoluteSystemBarEdges = absoluteSystemBars
    }

    /// Update the safe area.
    @Composable func insetting(_ edge: Edge, to value: Float) -> SafeArea {
        guard value > Float(0.0) else {
            return self
        }
        var systemBarEdges = absoluteSystemBarEdges
        var (safeLeft, safeTop, safeRight, safeBottom) = safeBoundsPx
        switch edge {
        case .top:
            safeTop = value
            systemBarEdges.remove(.top)
        case .bottom:
            safeBottom = value
            systemBarEdges.remove(.bottom)
        case .leading:
            safeLeft = value
            systemBarEdges.remove(.leading)
        case .trailing:
            safeRight = value
            systemBarEdges.remove(.trailing)
        }
        return SafeArea(presentation: presentationBoundsPx, safe: Rect(top: safeTop, left: safeLeft, bottom: safeBottom, right: safeRight), absoluteSystemBars: systemBarEdges)
    }
}
#endif
#endif
