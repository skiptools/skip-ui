package skip.ui

import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ColorMatrix
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.runtime.Composable

@Composable
fun Modifier.colorInvert(): Modifier {
    return this.drawWithContent {
        val matrix = ColorMatrix().apply {
            setToInvert()
        }
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
}

private fun ColorMatrix.setToInvert() {
    this.set(ColorMatrix(floatArrayOf(
        -1f,  0f,  0f,  0f,  255f,
        0f, -1f,  0f,  0f,  255f,
        0f,  0f, -1f,  0f,  255f,
        0f,  0f,  0f,  1f,    0f
    )))
}