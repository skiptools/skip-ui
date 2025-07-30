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

// We use a class rather than struct to be able to mutate the `positionalMinLength` for layout.
// SKIP @bridge
public final class Spacer : View, Renderable {
    let minLength: CGFloat?

    // SKIP @bridge
    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
    }

    #if SKIP
    /// When we layout an `HStack` or `VStack` we apply a positional min length to spacers between elements.
    var positionalMinLength: CGFloat?

    @Composable override func Render(context: ComposeContext) {
        let layoutImplementationVersion = EnvironmentValues.shared._layoutImplementationVersion
        let axis = EnvironmentValues.shared._layoutAxis
        let effectiveMinLength = minLength ?? positionalMinLength
        let minLengthFloat: Float? = effectiveMinLength != nil && effectiveMinLength! > 0.0 ? Float(effectiveMinLength!) : nil
        if layoutImplementationVersion == 0 {
            // Maintain previous layout behavior for users who opt in
            if let minLengthFloat {
                let minModifier: Modifier
                switch axis {
                case .horizontal:
                    minModifier = Modifier.width(minLengthFloat.dp)
                case .vertical:
                    minModifier = Modifier.height(minLengthFloat.dp)
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
                    modifier = flexibleWidth(nil, minLengthFloat, Float.flexibleSpace)
                } else {
                    modifier = Modifier
                }
            case .vertical:
                if let flexibleHeight = EnvironmentValues.shared._flexibleHeight {
                    modifier = flexibleHeight(nil, minLengthFloat, Float.flexibleSpace)
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
