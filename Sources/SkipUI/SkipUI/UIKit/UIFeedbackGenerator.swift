// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

public protocol UIFeedbackGenerator {
}

extension UIFeedbackGenerator {
    #if SKIP
    // note that this needs AndroidManifest.xml permission:
    // <uses-permission android:name="android.permission.VIBRATE"/>
    private var vibrator: android.os.Vibrator? {
        let context = ProcessInfo.processInfo.androidContext // Android-specific extension to get the global Context

        guard let vibratorManager = context.getSystemService(android.content.Context.VIBRATOR_MANAGER_SERVICE) as? android.os.VibratorManager else {
            logger.log("vibratorManager: returned null")
            return nil
        }

        logger.log("vibratorManager: \(vibratorManager)")

        // https://developer.android.com/reference/android/os/Vibrator
        return vibratorManager.getDefaultVibrator()
    }
    #endif
}

/// UIImpactFeedbackGenerator is used to give user feedback when an impact between UI elements occurs
@MainActor open class UIImpactFeedbackGenerator : UIFeedbackGenerator {
    private let style: UIImpactFeedbackGenerator.FeedbackStyle

    public init() {
        self.style = .medium
    }

    public init(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.style = style
    }

    /// call when your UI element impacts something else
    open func impactOccurred() {
        #if SKIP
        self.vibrator?.vibrate(style.vibrationEffect)
        #endif
    }

    /// call when your UI element impacts something else with a specific intensity [0.0, 1.0]
    open func impactOccurred(intensity: CGFloat) {
        #if SKIP
        if intensity <= 0.0 { return }

        let effect = android.os.VibrationEffect.startComposition()
            .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(intensity), 0)
            .compose()
        self.vibrator?.vibrate(effect)
        #endif
    }

    open func impactOccurred(intensity: CGFloat, at location: CGPoint) {
        impactOccurred(intensity: intensity)
    }

    public enum FeedbackStyle : Int, @unchecked Sendable {
        case light = 0
        case medium = 1
        case heavy = 2

        case soft = 3
        case rigid = 4

        #if SKIP
        var vibrationEffect: android.os.VibrationEffect {
            switch self {
            case .light:
                return android.os.VibrationEffect.createPredefined(android.os.VibrationEffect.EFFECT_TICK)
            case .medium:
                return android.os.VibrationEffect.createPredefined(android.os.VibrationEffect.EFFECT_CLICK)
            case .heavy:
                return android.os.VibrationEffect.createPredefined(android.os.VibrationEffect.EFFECT_HEAVY_CLICK)

            case .soft:
                return android.os.VibrationEffect.createPredefined(android.os.VibrationEffect.EFFECT_TICK)
            case .rigid:
                return android.os.VibrationEffect.createPredefined(android.os.VibrationEffect.EFFECT_CLICK)
            }
        }
        #endif
    }
}

/// UINotificationFeedbackGenerator is used to give user feedback when an notification is displayed
@MainActor open class UINotificationFeedbackGenerator : UIFeedbackGenerator {

    public init() {
    }

    /// call when a notification is displayed, passing the corresponding type
    open func notificationOccurred(_ notificationType: FeedbackType) {
        #if SKIP
        // amplitude parameter: “The strength of the vibration. This must be a value between 1 and 255”
        self.vibrator?.vibrate(notificationType.vibrationEffect)
        #endif
    }

    /// call when a notification is displayed, passing the corresponding type
    open func notificationOccurred(_ notificationType: FeedbackType, at location: CGPoint) {
        notificationOccurred(notificationType)
    }

    public enum FeedbackType : Int, @unchecked Sendable {
        case success = 0
        case warning = 1
        case error = 2

        #if SKIP
        var vibrationEffect: android.os.VibrationEffect {
            switch self {
            case .success:
                return android.os.VibrationEffect.startComposition()
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.8), 0)
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.8), 150)
                    .compose()
            case .warning: // feels the same as .success on iOS 17
                return android.os.VibrationEffect.startComposition()
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.8), 0)
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.8), 150)
                    .compose()
            case .error:
                return android.os.VibrationEffect.startComposition()
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.5), 0)
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.7), 100)
                    .addPrimitive(android.os.VibrationEffect.Composition.PRIMITIVE_CLICK, Float(0.9), 150)
                    .compose()
            }
        }
        #endif
    }
}


/// UINotificationFeedbackGenerator is used to give user feedback when an notification is displayed
@MainActor open class UISelectionFeedbackGenerator : UIFeedbackGenerator {

    public init() {
    }

    /// call when a notification is displayed, passing the corresponding type
    open func selectionChanged() {
        #if SKIP
        self.vibrator?.vibrate(android.os.VibrationEffect.createPredefined(android.os.VibrationEffect.EFFECT_TICK))
        #endif
    }

    open func selectionChanged(at location: CGPoint) {
        selectionChanged()
    }
}
