// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
#endif

public struct Divider : View {
    public init() {
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        let dividerColor = Color.separator.colorImpl()
        let modifier: Modifier
        switch EnvironmentValues.shared._layoutAxis {
        case .horizontal:
            // If in a horizontal container, create a vertical divider
            modifier = Modifier.width(1.dp).then(context.modifier.fillHeight())
        case .vertical, nil:
            modifier = context.modifier
        }
        androidx.compose.material3.Divider(modifier: modifier, color: dividerColor)
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif
}

#endif
