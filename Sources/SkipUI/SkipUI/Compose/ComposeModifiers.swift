// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import androidx.compose.ui.draw.DrawModifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.ColorMatrix
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.drawscope.ContentDrawScope
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas

class ColorInvertModifier : DrawModifier {
    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        let invertMatrix = ColorMatrix().apply { setToInvert() }
        let invertFilter = ColorFilter.colorMatrix(invertMatrix)
        let paint = Paint().apply {
            colorFilter = invertFilter
        }
        drawIntoCanvas {
            $0.saveLayer(Rect(Float(0.0), Float(0.0), size.width, size.height), paint)
            drawContent()
            $0.restore()
        }
    }
}

extension ColorMatrix {
    func setToInvert() {
        set(ColorMatrix(floatArrayOf(
            Float(-1), Float(0), Float(0), Float(0), Float(255),
            Float(0), Float(-1), Float(0), Float(0), Float(255),
            Float(0), Float(0), Float(-1), Float(0), Float(255),
            Float(0), Float(0), Float(0), Float(1), Float(0)
        )))
    }
}

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
