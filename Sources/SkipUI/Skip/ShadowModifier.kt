// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// This is based on code from:
// https://gist.github.com/Andrew0000/3edb9c25ebc20a2935c9ff4805e05f5d

package skip.ui

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.draw.BlurredEdgeTreatment
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ColorMatrix
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.layout.Layout
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Constraints
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlin.math.ceil

/// Compose the given content with a drop shadow on all non-transparent pixels.
@Composable fun Shadowed(context: ComposeContext, color: Color, offsetX: Dp, offsetY: Dp, blurRadius: Dp, content: @Composable (ComposeContext) -> Unit) {
    val contentContext = context.content()
    val density = LocalDensity.current
    val offsetXPx = with(density) { offsetX.toPx() }.toInt()
    val offsetYPx = with(density) { offsetY.toPx() }.toInt()
    // Pad by the shadow layer by the radius to prevent clipping the blur
    val paddingPx = ceil(with(density) { blurRadius.toPx() }).toInt()
    Layout(modifier = context.modifier, content = {
        // Render content normally
        content(contentContext)
        ComposeContainer(fixedWidth = true, fixedHeight = true) { modifier ->
            Box(modifier = modifier
                .drawWithContent {
                    val matrix = shadowColorMatrix(color)
                    val filter = ColorFilter.colorMatrix(matrix)
                    val paint = Paint().apply {
                        colorFilter = filter
                    }
                    drawIntoCanvas { canvas ->
                        canvas.saveLayer(Rect(0f, 0f, size.width, size.height), paint)
                        drawContent()
                        canvas.restore()
                    }
                }
                .blur(radius = blurRadius, BlurredEdgeTreatment.Unbounded)
                .padding(all = blurRadius)
            ) {
                content(contentContext)
            }
        }
    }) { measurables, constraints ->
        val contentPlaceable = measurables[0].measure(constraints)
        val shadowPlaceable = measurables[1].measure(Constraints(maxWidth = contentPlaceable.width + paddingPx * 2, maxHeight = contentPlaceable.height + paddingPx * 2))
        layout(width = contentPlaceable.width, height = contentPlaceable.height) {
            shadowPlaceable.placeRelative(x = offsetXPx - paddingPx, y = offsetYPx - paddingPx)
            contentPlaceable.placeRelative(x = 0, y = 0)
        }
    }
}

/// Return a color matrix with which to paint our content as a shadow of the given color.
private fun shadowColorMatrix(color: Color): ColorMatrix {
    return ColorMatrix().apply {
        set(0, 0, 0f) // Do not preserve original R
        set(1, 1, 0f) // Do not preserve original G
        set(2, 2, 0f) // Do not preserve original B

        set(0, 4, color.red * 255) // Use given color's R
        set(1, 4, color.green * 255) // Use given color's G
        set(2, 4, color.blue * 255) // Use given color's B
        set(3, 3, color.alpha) // Multiply original alpha by shadow alpha
    }
}