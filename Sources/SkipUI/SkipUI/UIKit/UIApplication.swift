// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
import OSLog
#if SKIP
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import android.view.WindowManager
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.core.app.ActivityCompat
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.registerForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import kotlin.coroutines.Continuation
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine
import java.lang.ref.WeakReference
#endif

let logger: Logger = Logger(subsystem: "skip.ui", category: "SkipUI") // adb logcat '*:S' 'skip.ui.SkipUI:V'

// SKIP @bridge
/* @MainActor */ public class UIApplication /* : UIResponder */ {
    // SKIP @bridge
    public static let shared = UIApplication()
    #if SKIP
    private var requestPermissionLauncher: ActivityResultLauncher<String>?
    private let waitingContinuations: MutableList<Continuation<Bool>> = mutableListOf<Continuation<Bool>>()
    #endif

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
    ///
    // SKIP @bridge
    public private(set) var androidActivity: androidx.appcompat.app.AppCompatActivity? {
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
    private var androidActivityReference: WeakReference<androidx.appcompat.app.AppCompatActivity>?

    /// Setup the Android main activity.
    ///
    /// This API mirrors `ProcessInfo.launch` for the application context.
    public static func launch(_ activity: androidx.appcompat.app.AppCompatActivity) {
        if activity !== shared.androidActivity {
            shared.androidActivity = activity

            // Must registerForActivityResult on or before Activity.onCreate
            do {
                let contract = ActivityResultContracts.RequestPermission()
                shared.requestPermissionLauncher = activity.registerForActivityResult(contract) { isGranted in
                    var continuations: ArrayList<Continuation<Bool>>? = nil
                    synchronized (shared.waitingContinuations) {
                        continuations = ArrayList(shared.waitingContinuations)
                        shared.waitingContinuations.clear()
                    }
                    continuations?.forEach { $0.resume(isGranted) }
                }
                logger.info("requestPermissionLauncher: \(shared.requestPermissionLauncher)")
            } catch {
                android.util.Log.w("SkipUI", "error initializing permission launcher", error as? Throwable)
            }
        }
    }

    func onActivityDestroy() {
        // The permission launcher appears to hold a strong reference to the activity, so we must nil it to avoid memory leaks
        self.requestPermissionLauncher = nil
    }

    /// Requests the given permission.
    /// - Parameters:
    ///   - permission: the name of the permission, such as `android.permission.POST_NOTIFICATIONS`
    ///   - showRationale: an optional async callback to invoke when the system determies that a rationale should be displayed for the permission check
    /// - Returns: true if the permission was granted, false if denied or there was an error making the request
    public func requestPermission(_ permission: String, showRationale: (() async -> Bool)?) async -> Bool {
        logger.info("requestPermission: \(permission)")
        guard let activity = self.androidActivity else {
            return false
        }
        if ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED {
            return true // already granted
        }
        guard let requestPermissionLauncher else {
            logger.warning("requestPermission: \(permission) requestPermissionLauncher is nil")
            return false
        }
        // check if we are expected to show a rationalle for the permission request, and if so,
        // and if we have a `showRationale` callback, then wait for the result
        if let showRationale, ActivityCompat.shouldShowRequestPermissionRationale(activity, permission) == true {
            if await showRationale() == false {
                return false
            }
        }
        suspendCoroutine { continuation in
            var count = 0
            synchronized(waitingContinuations) {
                waitingContinuations.add(continuation)
                count = waitingContinuations.count()
            }
            if count == 1 {
                logger.info("launch requestPermission: \(permission)")
                requestPermissionLauncher?.launch(permission)
            }
        }
    }

    /// Requests the given permission.
    /// - Parameters:
    ///   - permission: the name of the permission, such as `android.permission.POST_NOTIFICATIONS`
    /// - Returns: true if the permission was granted, false if denied or there was an error making the request
    // SKIP @bridge
    public func requestPermission(_ permission: String) async -> Bool {
        // We can't bridge the `showRationale` parameter async closure
        return await requestPermission(permission, showRationale: nil)
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

    // SKIP @bridge
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

    #if SKIP
    public static let openSettingsURLString = "intent://" + Settings.ACTION_APPLICATION_DETAILS_SETTINGS
    public static let openDefaultApplicationsSettingsURLString = "intent://android.settings.APP_OPEN_BY_DEFAULT_SETTINGS" // ACTION_APP_OPEN_BY_DEFAULT_SETTINGS added in API 31
    public static let openNotificationSettingsURLString = "intent://" + Settings.ACTION_APP_NOTIFICATION_SETTINGS
    #endif

    public func open(_ url: URL, options: [OpenExternalURLOptionsKey : Any] = [:]) async -> Bool {
        #if SKIP
        let context = ProcessInfo.processInfo.androidContext
        do {
            let intent: Intent
            if url.scheme == "intent" {
                intent = Intent(url.host(), android.net.Uri.parse("package:" + context.getPackageName()))
            } else {
                intent = Intent(Intent.ACTION_VIEW, android.net.Uri.parse(url.absoluteString))
            }
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

    // SKIP @bridge
    public func bridgedOpen(_ url: URL, options: [String : Any]) async -> Bool {
        let keyedOptions = options.reduce(into: [OpenExternalURLOptionsKey : Any]()) { result, entry in
            result[OpenExternalURLOptionsKey(rawValue: entry.key)] = entry.value
        }
        return await open(url, options: keyedOptions)
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

    // SKIP @bridge
    public var bridgedApplicationState: Int {
        return applicationState.rawValue
    }

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
    public static var userDidTakeScreenshotNotification: Notification.Name {
        fatalError()
    }
    @available(*, unavailable)
    public static var invalidInterfaceOrientationException: Any {
        fatalError()
    }

    // NOTE: Keep in sync with SkipSwiftUI.UIApplication.State
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
            application.onActivityDestroy()
        case Lifecycle.Event.ON_ANY:
            break
        }
    }
}
#endif
#endif
