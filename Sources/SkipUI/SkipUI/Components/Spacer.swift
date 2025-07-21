// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#elseif canImport(CoreGraphics)
import struct CoreGraphics.CGFloat
#endif

// SKIP @bridge
public struct Spacer : View, Renderable {
    private let minLength: CGFloat?

    // SKIP @bridge
    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        // We haven't found a way that works to get a minimum size and expanding behavior on a spacer, so use two spacers: the
        // first to enforce the minimum, and the second to expand. Note that this will cause some modifiers to behave incorrectly

        let axis = EnvironmentValues.shared._layoutAxis
        if let minLength, minLength > 0.0 {
            let minModifier: Modifier
            switch axis {
            case .horizontal:
                minModifier = Modifier.width(minLength.dp)
            case .vertical:
                minModifier = Modifier.height(minLength.dp)
            case nil:
                minModifier = Modifier
            }
            androidx.compose.foundation.layout.Spacer(modifier: minModifier.then(context.modifier))
        }

        let fillModifier: Modifier
        switch axis {
        case .horizontal:
            fillModifier = EnvironmentValues.shared._fillWidth?() ?? Modifier
        case .vertical:
            fillModifier = EnvironmentValues.shared._fillHeight?() ?? Modifier
        case nil:
            fillModifier = Modifier
        }
        androidx.compose.foundation.layout.Spacer(modifier: fillModifier.then(context.modifier))
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

public enum SpacerSizing: Int {
    case flexible = 1 // For bridging
    case fixed = 2 // For bridging
}

#endif
