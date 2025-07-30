// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.fillMaxSize
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
    let minLength: CGFloat?

    // SKIP @bridge
    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
    }

    #if SKIP
    @Composable override func Render(context: ComposeContext) {
        let axis = EnvironmentValues.shared._layoutAxis
        let minLength: Float? = minLength != nil && minLength! > 0.0 ? Float(minLength!) : nil
        let layoutImplementationVersion = EnvironmentValues.shared._layoutImplementationVersion
        if layoutImplementationVersion == 0 {
            // Maintain previous layout behavior for users who opt in
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
                fillModifier = EnvironmentValues.shared._flexibleWidth?(nil, nil, Float.flexibleSpace) ?? Modifier
            case .vertical:
                fillModifier = EnvironmentValues.shared._flexibleHeight?(nil, nil, Float.flexibleSpace) ?? Modifier
            case nil:
                fillModifier = Modifier
            }
            androidx.compose.foundation.layout.Spacer(modifier: fillModifier.then(context.modifier))
        } else {
            let modifier: Modifier
            switch axis {
            case .horizontal:
                if let flexibleWidth = EnvironmentValues.shared._flexibleWidth {
                    modifier = flexibleWidth(nil, minLength, Float.flexibleSpace)
                } else {
                    modifier = Modifier
                }
            case .vertical:
                if let flexibleHeight = EnvironmentValues.shared._flexibleHeight {
                    modifier = flexibleHeight(nil, minLength, Float.flexibleSpace)
                } else {
                    modifier = Modifier
                }
            case nil:
                modifier = Modifier.fillMaxSize()
            }
            androidx.compose.foundation.layout.Spacer(modifier: modifier.then(context.modifier))
        }
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
