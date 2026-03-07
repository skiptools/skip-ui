// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.ui.unit.dp
#endif

public enum ContentMarginPlacement: Int {
    case automatic = 0
    case scrollContent = 1
    case scrollIndicators = 2
}

/// Holds the content margin values for each placement type.
public struct ContentMargins {
    public var automatic: EdgeInsets?
    public var scrollContent: EdgeInsets?
    public var scrollIndicators: EdgeInsets?

    public init(automatic: EdgeInsets? = nil, scrollContent: EdgeInsets? = nil, scrollIndicators: EdgeInsets? = nil) {
        self.automatic = automatic
        self.scrollContent = scrollContent
        self.scrollIndicators = scrollIndicators
    }

    /// Returns the effective content margin for the given placement.
    /// For `.automatic`, returns `scrollContent` if set, otherwise `automatic`.
    public func effectiveContentMargin(for placement: ContentMarginPlacement) -> EdgeInsets? {
        switch placement {
        case .automatic:
            // For automatic, prefer scrollContent if set, then fall back to automatic
            return scrollContent ?? automatic
        case .scrollContent:
            return scrollContent ?? automatic
        case .scrollIndicators:
            return scrollIndicators ?? automatic
        }
    }

    #if SKIP
    /// Converts the content margins to Compose PaddingValues for the given placement.
    func asComposePaddingValues(for placement: ContentMarginPlacement) -> PaddingValues? {
        guard let insets = effectiveContentMargin(for: placement) else {
            return nil
        }
        return androidx.compose.foundation.layout.PaddingValues(
            start: Double(insets.leading).dp,
            top: Double(insets.top).dp,
            end: Double(insets.trailing).dp,
            bottom: Double(insets.bottom).dp
        )
    }
    #endif
}

#endif
