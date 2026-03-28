// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import android.os.VibrationEffect
#endif

public struct SensoryFeedback : RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let success = SensoryFeedback(rawValue: 1) // For bridging
    public static let warning = SensoryFeedback(rawValue: 2) // For bridging
    public static let error = SensoryFeedback(rawValue: 3) // For bridging
    public static let selection = SensoryFeedback(rawValue: 4) // For bridging
    public static let increase = SensoryFeedback(rawValue: 5) // For bridging
    public static let decrease = SensoryFeedback(rawValue: 6) // For bridging
    public static let start = SensoryFeedback(rawValue: 7) // For bridging
    public static let stop = SensoryFeedback(rawValue: 8) // For bridging
    public static let alignment = SensoryFeedback(rawValue: 9) // For bridging
    public static let levelChange = SensoryFeedback(rawValue: 10) // For bridging
    public static let impact = SensoryFeedback(rawValue: 11) // For bridging

    public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback {
        return SensoryFeedback.impact
    }

    public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback {
        return SensoryFeedback.impact
    }

    public enum Weight : Equatable {
        case light
        case medium
        case heavy
    }

    public enum Flexibility : Equatable {
        case rigid
        case solid
        case soft
    }

    public func activate() {
        #if SKIP
        guard let systemVibratorService else { return }

        // Custom haptic feedback compositions designed to approximate iOS UIFeedbackGenerator behavior.
        // Uses VibrationEffect.Composition primitives (API 30+) rather than HapticFeedbackConstants
        // (which require API 34+ for many constants).
        // See: https://developer.android.com/develop/ui/views/haptics/custom-haptic-effects
        let composition = VibrationEffect.startComposition()

        switch self {
        case .success:
            // iOS: UINotificationFeedbackGenerator.success - a strong tap then a lighter confirmation tap
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 0)
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5), 100)
        case .warning:
            // iOS: UINotificationFeedbackGenerator.warning - two strong, heavy beats
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_SLOW_RISE, Float(1.0), 0)
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0), 100)
        case .error:
            // iOS: UINotificationFeedbackGenerator.error - three rapid taps with decreasing intensity
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0), 0)
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(0.75), 100)
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(0.5), 200)
        case .selection:
            // iOS: UISelectionFeedbackGenerator - very light, subtle single tick
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.3), 0)
        case .increase:
            // iOS: a quick upward-feeling tap for incrementing a value
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(0.7), 0)
        case .decrease:
            // iOS: a quick downward-feeling tap for decrementing a value
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.7), 0)
        case .start:
            // iOS: rising intensity to indicate an activity beginning
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(1.0), 0)
        case .stop:
            // iOS: falling intensity to indicate an activity ending
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0), 0)
        case .alignment:
            // iOS: two quick, light taps for snapping to a guide or grid
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5), 0)
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5), 50)
        case .levelChange:
            // iOS: two distinct taps for notching into a discrete position
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.8), 0)
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.8), 100)
        case .impact:
            // iOS: UIImpactFeedbackGenerator.medium - a single strong thud
            composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_THUD, Float(1.0), 0)
        }

        systemVibratorService.vibrate(composition.compose())
        #endif
    }
}

extension View {
    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T) -> any View {
        return onChange(of: trigger) {
            feedback.activate()
        }
    }

    // SKIP @bridge
    public func sensoryFeedback(bridgedFeedback: Int, trigger: Any?) -> any View {
        let feedback = SensoryFeedback(rawValue: bridgedFeedback)
        return self.sensoryFeedback(feedback, trigger: trigger)
    }

    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T, condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool) -> any View {
        return onChange(of: trigger) { oldValue, newValue in
            if condition(oldValue, newValue) {
                feedback.activate()
            }
        }
    }

    public func sensoryFeedback<T>(trigger: T, _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> SensoryFeedback?) -> any View {
        return onChange(of: trigger) { oldValue, newValue in
            feedback(oldValue, newValue)?.activate()
        }
    }

    // SKIP @bridge
    public func sensoryFeedbackClosure(trigger: Any?, bridgedFeedback: @escaping (_ oldValue: Any?, _ newValue: Any?) -> Int?) -> any View {
        return self.sensoryFeedback(trigger: trigger) { oldValue, newValue in
            if let feedback = bridgedFeedback(oldValue, newValue) {
                return SensoryFeedback(rawValue: feedback)
            } else {
                return nil
            }
        }
    }
}

#endif
