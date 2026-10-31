// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import android.graphics.Paint
import android.graphics.Typeface
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFontFamilyResolver
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontSynthesis
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.BaselineShift
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.isUnspecified
import androidx.compose.ui.unit.sp

/** Converts point offsets to Compose's ascent multiplier using the resolved font. */
internal object AttributedTextBaseline {
    @Composable
    fun apply(span: SpanStyle, offset: Double, baseStyle: TextStyle): SpanStyle {
        val density = LocalDensity.current
        val effective = baseStyle.toSpanStyle().merge(span)
        val typeface = LocalFontFamilyResolver.current.resolve(
            effective.fontFamily,
            effective.fontWeight ?: FontWeight.Normal,
            effective.fontStyle ?: FontStyle.Normal,
            effective.fontSynthesis ?: FontSynthesis.All
        ).value as Typeface
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.typeface = typeface
            // Compose applies baseline shifts before a run's font-size span, but
            // after its typeface span. Use the paragraph size for this calculation.
            textSize = with(density) {
                (if (baseStyle.fontSize.isUnspecified) 14.sp else baseStyle.fontSize).toPx()
            }
        }
        val offsetPx = with(density) { offset.toFloat().dp.toPx() }
        return span.copy(baselineShift = BaselineShift(offsetPx / -paint.ascent()))
    }
}
