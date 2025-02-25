// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import android.os.VibrationEffect
#endif

public struct SensoryFeedback : RawRepresentable, Equatable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let success = SensoryFeedback(rawValue: 1)
    public static let warning = SensoryFeedback(rawValue: 2)
    public static let error = SensoryFeedback(rawValue: 3)
    public static let selection = SensoryFeedback(rawValue: 4)
    public static let increase = SensoryFeedback(rawValue: 5)
    public static let decrease = SensoryFeedback(rawValue: 6)
    public static let start = SensoryFeedback(rawValue: 7)
    public static let stop = SensoryFeedback(rawValue: 8)
    public static let alignment = SensoryFeedback(rawValue: 9)
    public static let levelChange = SensoryFeedback(rawValue: 10)
    public static let impact = SensoryFeedback(rawValue: 11)

    @available(*, unavailable)
    public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback {
        fatalError()
    }

    @available(*, unavailable)
    public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback {
        fatalError()
    }

    public enum Weight : Equatable, Sendable {
        case light
        case medium
        case heavy
    }

    public enum Flexibility : Equatable, Sendable {
        case rigid
        case solid
        case soft
    }

    public func activate() {
        #if SKIP
        guard let systemVibratorService else { return }

        // see: https://developer.android.com/develop/ui/views/haptics/custom-haptic-effects
        let composition = VibrationEffect.startComposition()

        // we create custom haptic feedback; we don't use https://developer.android.com/reference/android/view/HapticFeedbackConstants because many of those constants are only available in API 34+

        // various experimental implementations; we may eventually expose this to the user to be able to configure their "haptics style"
        let impl = 3

        if impl == 0 {
            switch self {
            case .success:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(0.7))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.5))
            case .warning:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.9))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.6))
            case .error:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.7))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.5))
            case .selection:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.4))
            case .increase:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(0.6))
            case .decrease:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.6))
            case .start:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(0.7))
            case .stop:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.7))
            case .alignment:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.4))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.3))
            case .levelChange:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5))
            case .impact:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.8))
            }
        } else if impl == 1 {
            switch self {
            case .success:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.5))
            case .warning:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(0.7))
            case .error:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0))
            case .selection:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0))
            case .increase:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(0.7))
            case .decrease:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(0.7))
            case .start:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(1.0))
            case .stop:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0))
            case .alignment:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.5))
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5))
            case .levelChange:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0))
            case .impact:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0))
            }
        } else if impl == 3 {
            switch self {
            case .success:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 100)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0), 200)
            case .warning:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0), 100)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0), 200)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0), 300)
            case .error:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_SLOW_RISE, Float(1.0), 100)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0), 200)
            case .selection:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0), 50)
            case .increase:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 100)
            case .decrease:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 100)
            case .start:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(1.0), 100)
            case .stop:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0), 100)
            case .alignment:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0), 50)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(1.0), 100)
            case .levelChange:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 100)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 200)
            case .impact:
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_THUD, Float(1.0), 100)
            }
        } else if impl == 4 {
            switch self {
            case .success:
                // iOS success: A strong tap followed by a lighter tap after 100ms
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 0) // Strong tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5), 100) // Light tap after 100ms
            case .warning:
                // iOS warning: A strong, sharp tap followed by a quick fade after 100ms
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_SLOW_RISE, Float(1.0), 0) // Strong rise
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0), 100) // Quick fall after 100ms
            case .error:
                // iOS error: Three sequential taps with decreasing intensity and 100ms delays
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(1.0), 0) // Strong tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(0.75), 100) // Medium tap after 100ms
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_LOW_TICK, Float(0.5), 200) // Light tap after 200ms
            case .selection:
                // iOS selection: A light, subtle tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.3), 0) // Light tap
            case .increase:
                // iOS increase: A single, sharp tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 0) // Strong tap
            case .decrease:
                // iOS decrease: A single, sharp tap (same as increase)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 0) // Strong tap
            case .start:
                // iOS start: A quick rise in intensity
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_RISE, Float(1.0), 0) // Quick rise
            case .stop:
                // iOS stop: A quick fall in intensity
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_QUICK_FALL, Float(1.0), 0) // Quick fall
            case .alignment:
                // iOS alignment: Two light taps in quick succession (50ms delay)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5), 0) // First tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_TICK, Float(0.5), 50) // Second tap after 50ms
            case .levelChange:
                // iOS levelChange: Two sharp taps in quick succession (100ms delay)
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 0) // First tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_CLICK, Float(1.0), 100) // Second tap after 100ms
            case .impact:
                // iOS impact: A strong, heavy tap
                composition.addPrimitive(VibrationEffect.Composition.PRIMITIVE_THUD, Float(1.0), 0) // Heavy tap
            }
        }

        systemVibratorService.vibrate(composition.compose())
        #endif
    }
}

extension View {
    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T) -> some View {
        return onChange(of: trigger) {
            feedback.activate()
        }
    }

    public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T, condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool) -> some View {
        return onChange(of: trigger) { oldValue, newValue in
            if condition(oldValue, newValue) {
                feedback.activate()
            }
        }
    }

    public func sensoryFeedback<T>(trigger: T, _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> SensoryFeedback?) -> some View {
        return onChange(of: trigger) { oldValue, newValue in
            feedback(oldValue, newValue)?.activate()
        }
    }
}

#endif
