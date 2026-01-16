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

class BrightnessModifier : DrawModifier {
    let amount: Double

    init(amount: Double) {
        self.amount = amount
    }

    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        // Brightness adjustment: shift RGB values by amount * 255
        // amount: -1.0 (black) to 1.0 (white), 0.0 = no change
        let shift = Float(amount * 255.0)
        let brightnessMatrix = ColorMatrix(floatArrayOf(
            Float(1), Float(0), Float(0), Float(0), shift,
            Float(0), Float(1), Float(0), Float(0), shift,
            Float(0), Float(0), Float(1), Float(0), shift,
            Float(0), Float(0), Float(0), Float(1), Float(0)
        ))
        let brightnessFilter = ColorFilter.colorMatrix(brightnessMatrix)
        let paint = Paint().apply {
            colorFilter = brightnessFilter
        }
        drawIntoCanvas {
            $0.saveLayer(Rect(Float(0.0), Float(0.0), size.width, size.height), paint)
            drawContent()
            $0.restore()
        }
    }
}

class ContrastModifier : DrawModifier {
    let amount: Double

    init(amount: Double) {
        self.amount = amount
    }

    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        // Contrast adjustment: scale RGB around 0.5 (128)
        // amount: 0.0 = gray, 1.0 = no change, >1.0 = increased contrast
        let scale = Float(amount)
        let translate = Float((1.0 - amount) * 127.5)
        let contrastMatrix = ColorMatrix(floatArrayOf(
            scale, Float(0), Float(0), Float(0), translate,
            Float(0), scale, Float(0), Float(0), translate,
            Float(0), Float(0), scale, Float(0), translate,
            Float(0), Float(0), Float(0), Float(1), Float(0)
        ))
        let contrastFilter = ColorFilter.colorMatrix(contrastMatrix)
        let paint = Paint().apply {
            colorFilter = contrastFilter
        }
        drawIntoCanvas {
            $0.saveLayer(Rect(Float(0.0), Float(0.0), size.width, size.height), paint)
            drawContent()
            $0.restore()
        }
    }
}

class SaturationModifier : DrawModifier {
    let amount: Double

    init(amount: Double) {
        self.amount = amount
    }

    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        // Saturation: 0.0 = grayscale, 1.0 = no change, >1.0 = oversaturated
        let saturationMatrix = ColorMatrix().apply { setToSaturation(Float(amount)) }
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

class HueRotationModifier : DrawModifier {
    let degrees: Double

    init(degrees: Double) {
        self.degrees = degrees
    }

    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        // Hue rotation using ColorMatrix
        let radians = Float(degrees * Double.pi / 180.0)
        let cos = kotlin.math.cos(radians)
        let sin = kotlin.math.sin(radians)

        // Hue rotation matrix derived from rotation around the (1,1,1) axis in RGB space
        let lumR = Float(0.213)
        let lumG = Float(0.715)
        let lumB = Float(0.072)

        let hueMatrix = ColorMatrix(floatArrayOf(
            lumR + cos * (Float(1) - lumR) + sin * (-lumR),
            lumG + cos * (-lumG) + sin * (-lumG),
            lumB + cos * (-lumB) + sin * (Float(1) - lumB),
            Float(0), Float(0),

            lumR + cos * (-lumR) + sin * Float(0.143),
            lumG + cos * (Float(1) - lumG) + sin * Float(0.140),
            lumB + cos * (-lumB) + sin * Float(-0.283),
            Float(0), Float(0),

            lumR + cos * (-lumR) + sin * (-(Float(1) - lumR)),
            lumG + cos * (-lumG) + sin * (lumG),
            lumB + cos * (Float(1) - lumB) + sin * (lumB),
            Float(0), Float(0),

            Float(0), Float(0), Float(0), Float(1), Float(0)
        ))
        let hueFilter = ColorFilter.colorMatrix(hueMatrix)
        let paint = Paint().apply {
            colorFilter = hueFilter
        }
        drawIntoCanvas {
            $0.saveLayer(Rect(Float(0.0), Float(0.0), Float(size.width), Float(size.height)), paint)
            drawContent()
            $0.restore()
        }
    }
}

class ColorMultiplyModifier : DrawModifier {
    let color: androidx.compose.ui.graphics.Color

    init(color: androidx.compose.ui.graphics.Color) {
        self.color = color
    }

    // SKIP DECLARE: override fun ContentDrawScope.draw()
    override func draw() {
        // Color multiply: multiply each channel by the corresponding color channel
        let r = color.red
        let g = color.green
        let b = color.blue
        let a = color.alpha
        let multiplyMatrix = ColorMatrix(floatArrayOf(
            r, Float(0), Float(0), Float(0), Float(0),
            Float(0), g, Float(0), Float(0), Float(0),
            Float(0), Float(0), b, Float(0), Float(0),
            Float(0), Float(0), Float(0), a, Float(0)
        ))
        let multiplyFilter = ColorFilter.colorMatrix(multiplyMatrix)
        let paint = Paint().apply {
            colorFilter = multiplyFilter
        }
        drawIntoCanvas {
            $0.saveLayer(Rect(Float(0.0), Float(0.0), size.width, size.height), paint)
            drawContent()
            $0.restore()
        }
    }
}
#endif
