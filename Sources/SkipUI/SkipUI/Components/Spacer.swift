// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

public struct Spacer : View {
    private let minLength: CGFloat?

    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
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

#endif
