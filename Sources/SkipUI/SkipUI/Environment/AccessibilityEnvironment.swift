// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import android.accessibilityservice.AccessibilityServiceInfo
import android.app.Activity
import android.app.Application
import android.app.UiModeManager
import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
#endif

#if SKIP
private let disableWindowBlursSetting = "disable_window_blurs"
private let highTextContrastEnabledSetting = "high_text_contrast_enabled"

/// Observes Android accessibility settings and exposes per-value Compose state.
final class AccessibilityEnvironment: ContentObserver {
    private static let _shared = AccessibilityEnvironment()

    static var shared: AccessibilityEnvironment {
        _shared.installObserversIfNeeded()
        return _shared
    }

    private let enabled: MutableState<Bool> = mutableStateOf(false)
    private let invertColors: MutableState<Bool> = mutableStateOf(false)
    private let reduceMotion: MutableState<Bool> = mutableStateOf(false)
    private let reduceTransparency: MutableState<Bool> = mutableStateOf(false)
    private let switchControlEnabled: MutableState<Bool> = mutableStateOf(false)
    private let voiceOverEnabled: MutableState<Bool> = mutableStateOf(false)
    private let colorSchemeContrast: MutableState<ColorSchemeContrast> = mutableStateOf(ColorSchemeContrast.standard)

    private var observersInstalled = false

    private let appContext: android.content.Context
    private let accessibilityManager: AccessibilityManager
    private let uiModeManager: UiModeManager
    private let contentResolver: android.content.ContentResolver

    private init() {
        let context = ProcessInfo.processInfo.androidContext.applicationContext
        appContext = context
        accessibilityManager = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as! AccessibilityManager
        uiModeManager = context.getSystemService(Context.UI_MODE_SERVICE) as! UiModeManager
        contentResolver = context.contentResolver
        super.init(Handler(Looper.getMainLooper()))
    }

    @Composable func accessibilityEnabled() -> Bool { enabled.value }
    @Composable func accessibilityInvertColors() -> Bool { invertColors.value }
    @Composable func accessibilityReduceMotion() -> Bool { reduceMotion.value }
    @Composable func accessibilityReduceTransparency() -> Bool { reduceTransparency.value }
    @Composable func accessibilitySwitchControlEnabled() -> Bool { switchControlEnabled.value }
    @Composable func accessibilityVoiceOverEnabled() -> Bool { voiceOverEnabled.value }
    @Composable func colorSchemeContrast() -> ColorSchemeContrast { colorSchemeContrast.value }

    private func refreshEnabled() {
        enabled.value = accessibilityManager.isEnabled
        refreshVoiceOverEnabled()
        refreshSwitchControlEnabled()
    }

    private func refreshInvertColors() {
        invertColors.value = Settings.Secure.getInt(
            contentResolver,
            Settings.Secure.ACCESSIBILITY_DISPLAY_INVERSION_ENABLED,
            0
        ) == 1
    }

    private func refreshReduceMotion() {
        reduceMotion.value = Settings.Global.getFloat(
            contentResolver,
            Settings.Global.ANIMATOR_DURATION_SCALE,
            Float(1.0)
        ) == Float(0.0)
    }

    private func refreshReduceTransparency() {
        reduceTransparency.value = Settings.Global.getInt(contentResolver, disableWindowBlursSetting, 0) == 1
    }

    private func refreshSwitchControlEnabled() {
        let am = accessibilityManager
        var switchEnabled = false
        if am.isEnabled {
            for service in am.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_GENERIC) {
                if let name = service.settingsActivityName, name.lowercased().contains("switchaccess") {
                    switchEnabled = true
                    break
                }
            }
        }
        switchControlEnabled.value = switchEnabled
    }

    private func refreshVoiceOverEnabled() {
        let am = accessibilityManager
        voiceOverEnabled.value = am.isEnabled && am.isTouchExplorationEnabled
    }

    private func refreshColorSchemeContrast() {
        if Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE {
            let contrast = uiModeManager.getContrast()
            colorSchemeContrast.value = contrast > Float(0.0)
                ? ColorSchemeContrast.increased
                : ColorSchemeContrast.standard
        } else {
            let highContrastTextEnabled =
                Settings.Secure.getInt(contentResolver, highTextContrastEnabledSetting, 0) == 1
            colorSchemeContrast.value = highContrastTextEnabled
                ? ColorSchemeContrast.increased
                : ColorSchemeContrast.standard
        }
    }

    private func refreshAll() {
        refreshEnabled()
        refreshInvertColors()
        refreshReduceMotion()
        refreshReduceTransparency()
        refreshColorSchemeContrast()
    }

    private func installObserversIfNeeded() {
        if observersInstalled {
            return
        }
        observersInstalled = true
        refreshAll()

        let resolver = contentResolver
        let invertUri = Settings.Secure.getUriFor(Settings.Secure.ACCESSIBILITY_DISPLAY_INVERSION_ENABLED)
        let motionUri = Settings.Global.getUriFor(Settings.Global.ANIMATOR_DURATION_SCALE)
        let blurUri = Settings.Global.getUriFor(disableWindowBlursSetting)
        let secureUri = Settings.Secure.getUriFor("secure")

        resolver.registerContentObserver(motionUri, false, self)
        resolver.registerContentObserver(invertUri, true, self)
        resolver.registerContentObserver(blurUri, false, self)
        resolver.registerContentObserver(secureUri, true, self)

        let am = accessibilityManager
        am.addAccessibilityStateChangeListener(
            AccessibilityManager.AccessibilityStateChangeListener { _ in self.refreshEnabled() }
        )
        am.addTouchExplorationStateChangeListener(
            AccessibilityManager.TouchExplorationStateChangeListener { _ in self.refreshVoiceOverEnabled() }
        )
        if Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU {
            am.addAccessibilityServicesStateChangeListener(
                AccessibilityManager.AccessibilityServicesStateChangeListener { _ in
                    self.refreshSwitchControlEnabled()
                }
            )
        }
        if Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE {
            uiModeManager.addContrastChangeListener(
                appContext.mainExecutor,
                UiModeManager.ContrastChangeListener { _ in
                    self.refreshColorSchemeContrast()
                }
            )
        }

        if let application = appContext as? Application {
            application.registerActivityLifecycleCallbacks(self)
        }
    }
}

extension AccessibilityEnvironment {
    override func onChange(selfChange: Bool) {
        refreshAll()
    }

    override func onChange(selfChange: Bool, uri: Uri?) {
        guard let uri = uri else {
            refreshAll()
            return
        }
        let motionUri = Settings.Global.getUriFor(Settings.Global.ANIMATOR_DURATION_SCALE)
        let invertUri = Settings.Secure.getUriFor(Settings.Secure.ACCESSIBILITY_DISPLAY_INVERSION_ENABLED)
        let blurUri = Settings.Global.getUriFor(disableWindowBlursSetting)
        let contrastUri = Settings.Secure.getUriFor(highTextContrastEnabledSetting)
        if uri == motionUri {
            refreshReduceMotion()
        } else if uri == invertUri {
            refreshInvertColors()
        } else if uri == blurUri {
            refreshReduceTransparency()
        } else if uri == contrastUri {
            refreshColorSchemeContrast()
        } else {
            refreshAll()
        }
    }
}

extension AccessibilityEnvironment: Application.ActivityLifecycleCallbacks {
    override func onActivityResumed(activity: Activity) {
        refreshAll()
    }

    override func onActivityCreated(activity: Activity, savedInstanceState: android.os.Bundle?) {}
    override func onActivityStarted(activity: Activity) {}
    override func onActivityPaused(activity: Activity) {}
    override func onActivityStopped(activity: Activity) {}
    override func onActivitySaveInstanceState(activity: Activity, outState: android.os.Bundle) {}
    override func onActivityDestroyed(activity: Activity) {}
}
#endif

#endif
