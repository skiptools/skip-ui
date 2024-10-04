// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import OSLog
#if SKIP
import android.content.Intent
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import java.lang.ref.WeakReference
#endif

let logger: Logger = Logger(subsystem: "skip.ui", category: "SkipUI") // adb logcat '*:S' 'skip.ui.SkipUI:V'

@MainActor public class UIApplication /* : UIResponder */ {
    public static let shared = UIApplication()

    private init() {
        #if SKIP
        let lifecycle = ProcessLifecycleOwner.get().lifecycle
        lifecycle.addObserver(UIApplicationLifecycleEventObserver(application: self))
        #endif
    }

    #if SKIP
    /// The Android main activity.
    ///
    /// This API mirrors `ProcessInfo.androidContext` for the application context.
    public private(set) var androidActivity: AppCompatActivity? {
        get {
            let activity = androidActivityReference?.get()
            return activity?.isDestroyed == false ? activity : nil
        }
        set {
            if let newValue {
                androidActivityReference = WeakReference(newValue)
            } else {
                androidActivityReference = nil
            }
            if isIdleTimerDisabled {
                setWindowFlagsForIsIdleTimerDisabled()
            }
        }
    }
    private var androidActivityReference: WeakReference<AppCompatActivity>?

    /// Setup the Android main activity.
    ///
    /// This API mirrors `ProcessInfo.launch` for the application context.
    public static func launch(_ activity: AppCompatActivity) {
        if activity !== shared.androidActivity {
            shared.androidActivity = activity
            UNUserNotificationCenter.launch(activity)
        }
    }
    #endif

    @available(*, unavailable)
    public var delegate: Any? {
        get {
            fatalError()
        }
        set {
        }
    }

    public var isIdleTimerDisabled = false {
        didSet {
            setWindowFlagsForIsIdleTimerDisabled()
        }
    }

    private func setWindowFlagsForIsIdleTimerDisabled() {
        #if SKIP
        let flags = WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        if isIdleTimerDisabled {
            androidActivity?.window?.addFlags(flags)
        } else {
            androidActivity?.window?.clearFlags(flags)
        }
        #endif
    }

    @available(*, unavailable)
    public func canOpenURL(_ url: URL) -> Bool {
        fatalError()
    }

    public func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:]) async -> Bool {
        #if SKIP
        let context = ProcessInfo.processInfo.androidContext
        do {
            let intent = Intent(Intent.ACTION_VIEW, android.net.Uri.parse(url.absoluteString))
            // needed or else: android.util.AndroidRuntimeException: Calling startActivity() from outside of an Activity context requires the FLAG_ACTIVITY_NEW_TASK flag. Is this really what you want?
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            return true
        } catch {
            logger.warning("UIApplication.launch error: \(error)")
            return false
        }
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func sendEvent(_ event: Any) {
    }
    @available(*, unavailable)
    public func sendAction(_ action: Any /* Selector */, to target: Any?, from sender: Any?, for event: Any?) -> Bool {
        fatalError()
    }
    @available(*, unavailable)
    public func supportedInterfaceOrientations(for window: Any?) -> Any /* UIInterfaceOrientationMask */ {
        fatalError()
    }
    @available(*, unavailable)
    public var applicationSupportsShakeToEdit: Bool {
        get {
            fatalError()
        }
        set {
        }
    }

    #if SKIP
    public internal(set) var applicationState: UIApplication.State {
        get {
            return _applicationState.value
        }
        set {
            _applicationState.value = newValue
        }
    }
    private let _applicationState: MutableState<UIApplication.State> = mutableStateOf(UIApplication.State.active)
    #else
    private let applicationState = UIApplication.State.active
    #endif

    @available(*, unavailable)
    public var backgroundTimeRemaining: TimeInterval {
        fatalError()
    }
    @available(*, unavailable)
    public func beginBackgroundTask(expirationHandler handler: (() -> Void)? = nil) -> Any /* UIBackgroundTaskIdentifier */ {
        fatalError()
    }
    @available(*, unavailable)
    public func beginBackgroundTask(withName taskName: String?, expirationHandler handler: (() -> Void)? = nil) -> Any /* UIBackgroundTaskIdentifier */ {
        fatalError()
    }
    @available(*, unavailable)
    public func endBackgroundTask(_ identifier: Any /* UIBackgroundTaskIdentifier */) {
    }
    @available(*, unavailable)
    public var backgroundRefreshStatus: Any /* UIBackgroundRefreshStatus */ {
        fatalError()
    }
    @available(*, unavailable)
    public var isProtectedDataAvailable: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public var userInterfaceLayoutDirection: Any /* UIUserInterfaceLayoutDirection */ {
        fatalError()
    }
    @available(*, unavailable)
    public var preferredContentSizeCategory: Any /* UIContentSizeCategory */ {
        fatalError()
    }
    @available(*, unavailable)
    public var connectedScenes: Set<AnyHashable /* UIScene */> {
        fatalError()
    }
    @available(*, unavailable)
    public var openSessions: Set<AnyHashable /* UISceneSession */> {
        fatalError()
    }
    @available(*, unavailable)
    public var supportsMultipleScenes: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public func requestSceneSessionDestruction(_ sceneSession: Any /* UISceneSession */, options: Any? /* UISceneDestructionRequestOptions? */, errorHandler: ((Error) -> Void)? = nil) {
    }
    @available(*, unavailable)
    public func requestSceneSessionRefresh(_ sceneSession: Any /* UISceneSession */) {
    }
    @available(*, unavailable)
    public func activateSceneSession(for request: Any /* UISceneSessionActivationRequest */, errorHandler: ((Error) -> Void)? = nil) {
    }
    @available(*, unavailable)
    public static var openNotificationSettingsURLString: String {
        fatalError()
    }
    @available(*, unavailable)
    public func registerForRemoteNotifications() {
    }
    @available(*, unavailable)
    public func unregisterForRemoteNotifications() {
    }
    @available(*, unavailable)
    public var isRegisteredForRemoteNotifications: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public func beginReceivingRemoteControlEvents() {
    }
    @available(*, unavailable)
    public func endReceivingRemoteControlEvents() {
    }
    @available(*, unavailable)
    public var shortcutItems: Any? /* [UIApplicationShortcutItem]? */ {
        fatalError()
    }
    @available(*, unavailable)
    public var supportsAlternateIcons: Bool {
        fatalError()
    }
    @available(*, unavailable)
    public func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)? = nil) {
    }
    @available(*, unavailable)
    public func setAlternateIconName(_ alternateIconName: String?) async throws {
    }
    @available(*, unavailable)
    public var alternateIconName: String? {
        fatalError()
    }
    @available(*, unavailable)
    public func extendStateRestoration() {
    }
    @available(*, unavailable)
    public func completeStateRestoration() {
    }
    @available(*, unavailable)
    public func ignoreSnapshotOnNextApplicationLaunch() {
    }
    @available(*, unavailable)
    public static func registerObject(forStateRestoration object: Any /* UIStateRestoring */, restorationIdentifier: String) {
    }
    @available(*, unavailable)
    public static var didEnterBackgroundNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var willEnterForegroundNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var didFinishLaunchingNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var didBecomeActiveNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var willResignActiveNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var didReceiveMemoryWarningNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var willTerminateNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var significantTimeChangeNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var backgroundRefreshStatusDidChangeNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var protectedDataWillBecomeUnavailableNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var protectedDataDidBecomeAvailableNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var openSettingsURLString: String {
        fatalError()
    }
    @available(*, unavailable)
    public static var userDidTakeScreenshotNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var invalidInterfaceOrientationException: Any {
        fatalError()
    }

    public enum State : Int {
        case active = 0
        case inactive = 1
        case background = 2
    }

    @available(*, unavailable)
    public static var backgroundFetchIntervalMinimum: TimeInterval {
        fatalError()
    }
    @available(*, unavailable)
    public static var backgroundFetchIntervalNever: TimeInterval {
        fatalError()
    }

    public struct OpenExternalURLOptionsKey : Hashable, Equatable, RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static let universalLinksOnly = OpenExternalURLOptionsKey(rawValue: "universalLinksOnly")
        public static let eventAttribution = OpenExternalURLOptionsKey(rawValue: "eventAttribution")
    }
}

#if SKIP
struct UIApplicationLifecycleEventObserver: LifecycleEventObserver, DefaultLifecycleObserver {
    let application: UIApplication

    override func onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
        switch event {
        case Lifecycle.Event.ON_CREATE:
            break
        case Lifecycle.Event.ON_START:
            break
        case Lifecycle.Event.ON_RESUME:
            application.applicationState = .active
        case Lifecycle.Event.ON_PAUSE:
            application.applicationState = .inactive
        case Lifecycle.Event.ON_STOP:
            application.applicationState = .background
        case Lifecycle.Event.ON_DESTROY:
            break
        case Lifecycle.Event.ON_ANY:
            break
        }
    }
}
#endif
