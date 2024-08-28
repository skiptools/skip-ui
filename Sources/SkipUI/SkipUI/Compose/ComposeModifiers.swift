// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.ui.draw.DrawModifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ColorMatrix
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.drawscope.ContentDrawScope
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas

class GrayscaleModifier : DrawModifier {
    let amount: Double

    init(amount: Double) {
        self.amount = amount
    }

    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        let saturationMatrix = ColorMatrix().apply { setToSaturation(Float(max(0.0, 1.0 - amount))) }
        let saturationFilter = ColorFilter.colorMatrix(saturationMatrix)
        let paint = Paint().apply {
            colorFilter = saturationFilter
        }
        drawIntoCanvas {
            $0.saveLayer(Rect(Float(0.0), Float(0.0), size.width, size.height), paint)
            drawContent()
            $0.restore()
        }
    }
}
#endif
