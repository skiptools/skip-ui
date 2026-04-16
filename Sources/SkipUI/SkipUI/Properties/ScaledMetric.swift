// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import SkipModel

import android.content.res.Resources
import androidx.compose.ui.unit.fontscaling.FontScaleConverterFactory
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf

// SwiftUI ScaledMetric accetps a `BinaryFloatingPoint`, implemented by Double, Float, and Float80.
// We're only supporting Double for now.
public final class ScaledMetric<Value: Double>: StateTracker {
    private var _wrappedValue: Value
    private var wrappedValueState: MutableState<Value>?

    public init(wrappedValue: Value) {
        _wrappedValue = wrappedValue
        StateTracking.register(self)
    }

    public init(wrappedValue: Value, relativeTo textStyle: Font.TextStyle) {
        _wrappedValue = wrappedValue
        // Compose doesn't scale differently based on text style, so we ignore it.
        _ = textStyle
        StateTracking.register(self)
    }

    public var wrappedValue: Value {
        let value = wrappedValueState?.value ?? _wrappedValue
        return ScaledMetricBridge.scaledValue(for: value) as! Value
    }

    public func trackState() {
        wrappedValueState = mutableStateOf(_wrappedValue)
    }
}

// SKIP @bridgeMembers
public enum ScaledMetricBridge {

    public static func scaledValue(for value: Double) -> Double {
        let scale: Float = Resources.getSystem().configuration.fontScale
        let scaled: Double
        if FontScaleConverterFactory.isNonLinearFontScalingActive(fontScale: scale),
            let converter = FontScaleConverterFactory.forScale(fontScale: scale) {
            scaled = Double(converter.convertSpToDp(sp: Float(value)))
        } else {
            scaled = value * scale
        }
        return scaled
    }
}
#endif
#endif
