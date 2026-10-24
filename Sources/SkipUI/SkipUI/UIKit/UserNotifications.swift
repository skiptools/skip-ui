// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.Worker
import androidx.work.WorkInfo
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import androidx.work.ListenableWorker
import androidx.work.OneTimeWorkRequestBuilder
import java.util.HashSet
import java.util.concurrent.TimeUnit
import kotlin.random.Random
import kotlinx.coroutines.flow.first
#endif

// SKIP @bridge
public final class UNUserNotificationCenter {
    private static let shared = UNUserNotificationCenter()

    private init() {
    }

    // SKIP @bridge
    public static func current() -> UNUserNotificationCenter {
        return shared
    }

    // SKIP @bridge
    public func notificationSettings() async -> UNNotificationSettings {
        #if SKIP
        guard Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU else {
            return UNNotificationSettings(authorizationStatus: .authorized)
        }
        let status: UNAuthorizationStatus
        if let activity = UIApplication.shared.androidActivity,
           ContextCompat.checkSelfPermission(activity, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED {
            status = .authorized
        } else if UserDefaults.standard.bool(forKey: "UNNotificationPermissionDenied") {
            status = .denied
        } else {
            status = .notDetermined
        }
        return UNNotificationSettings(authorizationStatus: status)
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func setBadgeCount(_ count: Int) async throws {
    }

    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        #if SKIP
        guard Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU else {
            return true
        }
        let granted = UIApplication.shared.requestPermission(Manifest.permission.POST_NOTIFICATIONS)
        let defaults = UserDefaults.standard
        if granted {
            defaults.removeObject(forKey: "UNNotificationPermissionDenied")
        } else {
            defaults.set(true, forKey: "UNNotificationPermissionDenied")
        }
        return granted
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func requestAuthorization(bridgedOptions: Int) async throws -> Bool {
        return try await requestAuthorization(options: UNAuthorizationOptions(rawValue: bridgedOptions))
    }

    // SKIP @bridge
    public var delegate: (any UNUserNotificationCenterDelegate)? {
        didSet {
            #if SKIP
            deliverPendingResponse()
            #endif
        }
    }

    @available(*, unavailable)
    public var supportsContentExtensions: Bool {
        fatalError()
    }

    // SKIP @bridge
    public func add(_ request: UNNotificationRequest) async throws {
        #if SKIP
        // Scheduling does not require a delegate. On iOS, willPresent runs only when a
        // notification fires while the app is in the foreground. Gating enqueue on it
        // drops every request from an app that never set a delegate, and drops
        // background notifications whose presentation options are empty.
        guard let activity = UIApplication.shared.androidActivity else { return }
        
        // Build the data which should be displayed in the notification.
        let dataBuilder = Data.Builder()
            .putString("title", request.content.title)
            .putString("body", request.content.body)
            .putInt("id", request.identifier.hashValue)
            .putString(NotificationWorker.identifierKey, request.identifier)
        
        if let imageAttachment = request.content.attachments.first(where: { $0.type == "public.image" }) {
            dataBuilder.putString("image_url", imageAttachment.url.absoluteString)
        }
        
        for (key, value) in request.content.userInfo {
            if let s = value as? String {
                dataBuilder.putString(key.toString(), s)
            } else if let b = value as? Bool {
                dataBuilder.putBoolean(key.toString(), b)
            } else if let i = value as? Int {
                dataBuilder.putInt(key.toString(), i)
            } else if let d = value as? Double {
                dataBuilder.putDouble(key.toString(), d)
            } else {
                dataBuilder.putString(key.toString(), value.toString())
            }
        }
        
        // Get the next trigger date (if any).
        let nextDate = (request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ??
                       (request.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate()
        UNUserNotificationCenter.enqueueRequest(identifier: request.identifier, data: dataBuilder.build(), date: nextDate, context: activity)

        // SKIP NOWARN
        await UNUserNotificationCenter.cancelWorkOfEarlierVersions(identifiers: [request.identifier], workManager: WorkManager.getInstance(activity))
        #endif
    }

    // SKIP @bridge
    public func pendingNotificationRequests() async -> [Any /* UNNotificationRequest */] {
        #if SKIP
        // The queued work is what will fire. A saved date can say otherwise: WorkManager can run a request after its date.
        guard let activity = UIApplication.shared.androidActivity else { return [] }

        // SKIP NOWARN
        return await UNUserNotificationCenter.queuedNotificationIdentifiers(WorkManager.getInstance(activity)).map {
            UNNotificationRequest(identifier: $0, content: UNMutableNotificationContent(), trigger: nil)
        }
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        #if SKIP
        guard let activity = UIApplication.shared.androidActivity else { return }
        UNUserNotificationCenter.removePendingRequests(identifiers: identifiers, context: activity)
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func removeAllPendingNotificationRequests() {
        #if SKIP
        guard let activity = UIApplication.shared.androidActivity else { return }
        // Every notification's work carries this tag, whichever SkipUI version enqueued it, and nothing else does.
        WorkManager.getInstance(activity).cancelAllWorkByTag(UNUserNotificationCenter.notificationWorkTag)
        UNUserNotificationCenter.forgetRequests(identifiers: getAllNotificationRequests().map { $0.id }, context: activity)
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func deliveredNotifications() async -> [Any /* UNNotification */] {
        #if SKIP
        return getDeliveredNotifications()
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        #if SKIP
        guard let activity = UIApplication.shared.androidActivity else { return }
        
        // Get all notification identifiers from the shared preferences.
        let preferences = activity.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE)
        let editor = preferences.edit()
        let ids = HashSet<String>(preferences.getStringSet("ids", HashSet<String>()) ?? HashSet<String>())
        
        // Get the notification manager.
        let notificationManager = activity.getSystemService(Context.NOTIFICATION_SERVICE) as! NotificationManager
        
        // Cancel all delivered notifications using the notification manager.
        let now = System.currentTimeMillis()
        for identifier in identifiers {
            // A removed notification's tap is no longer a response.
            editor.remove(UNUserNotificationCenter.responseTokenKey(identifier))
            let triggerTime = preferences.getLong("date_" + identifier, 0)
            if triggerTime < now {
                notificationManager.cancel(identifier.hashValue)
                ids.remove(identifier)
                editor.remove("date_" + identifier)
            }
        }
        
        // Update the notification identifiers in the shared preferences.
        editor.putStringSet("ids", ids)
        editor.apply()
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func removeAllDeliveredNotifications() {
        #if SKIP
        let deliveredNotifications = getDeliveredNotifications()
        let identifiers = deliveredNotifications.compactMap { ($0 as? UNNotification)?.request.identifier }
        removeDeliveredNotifications(withIdentifiers: identifiers)
        #else
        fatalError()
        #endif
    }

    @available(*, unavailable)
    public func setNotificationCategories(_ categories: Set<AnyHashable /* UNNotificationCategory */>) {
    }

    @available(*, unavailable)
    public func getNotificationCategories() async -> Set<AnyHashable /* UNNotificationCategory */> {
        fatalError()
    }

    #if SKIP
    /// The tag WorkManager gives every notification's work: its worker's class name.
    private static let notificationWorkTag: String = NotificationWorker.self.java.name
    private static let workNamePrefix = "__skip_usernotifications."

    /// The unique work name of the request with `identifier`, which is also its work's tag.
    static func workName(_ identifier: String) -> String {
        return workNamePrefix + identifier
    }

    /// Enqueues the notification work for `identifier`, replacing the identifier's earlier request as iOS
    /// does, and saves when it is due: `date`, or now for a request with no trigger. Returns as soon as the
    /// work is handed to WorkManager, which queues it on its own executor.
    static func enqueueRequest(identifier: String, data: Data, date: Date?, context: Context) {
        let delayMillis = date != nil ? max(0, date!.currentTimeMillis - System.currentTimeMillis()) : 0
        let workRequest = OneTimeWorkRequestBuilder<NotificationWorker>()
            .setInitialDelay(delayMillis, TimeUnit.MILLISECONDS)
            .setInputData(data)
            .addTag(workName(identifier))
            .build()
        // Unique work replaces the work enqueued under its name.
        WorkManager.getInstance(context).enqueueUniqueWork(workName(identifier), ExistingWorkPolicy.REPLACE, workRequest)
        saveRequest(identifier: identifier, date: date, context: context)
    }

    /// Cancels the work of the requests with `identifiers`, whatever their saved dates: work can still be
    /// queued after its date. Returns as soon as the cancellations are handed to WorkManager; the work of
    /// earlier SkipUI versions is swept afterwards, off the caller's thread.
    static func removePendingRequests(identifiers: [String], context: Context) {
        let workManager = WorkManager.getInstance(context)
        for identifier in identifiers {
            workManager.cancelUniqueWork(workName(identifier))
        }
        forgetRequests(identifiers: identifiers, context: context)
        // Only an earlier version's work carries a bare identifier tag, so a request added after this call
        // is safe from the sweep.
        Task {
            await cancelWorkOfEarlierVersions(identifiers: identifiers, workManager: workManager)
        }
    }

    /// The identifiers of the notifications whose work has not run yet.
    static func queuedNotificationIdentifiers(_ workManager: WorkManager) async -> [String] {
        var identifiers: [String] = []
        for work in await notificationWork(taggedWith: notificationWorkTag, workManager) {
            if (work.info.state == WorkInfo.State.ENQUEUED || work.info.state == WorkInfo.State.BLOCKED) && !identifiers.contains(work.identifier) {
                identifiers.append(work.identifier)
            }
        }
        return identifiers
    }

    /// Cancels the work that earlier SkipUI versions enqueued for `identifiers`: one request per call, tagged
    /// with the bare identifier. Only NotificationWorker's work is cancelled, so the app's own work is never
    /// touched, even when it shares a tag with a notification identifier.
    static func cancelWorkOfEarlierVersions(identifiers: [String], workManager: WorkManager) async {
        for identifier in identifiers {
            for work in await notificationWork(taggedWith: identifier, workManager) {
                if !work.info.state.isFinished {
                    workManager.cancelWorkById(work.info.id)
                }
            }
        }
    }

    /// The notification work carrying `tag`, each with its request identifier: the work name tag, or the bare
    /// identifier that earlier SkipUI versions tagged it with. Only NotificationWorker's work counts. The read
    /// suspends until WorkManager answers; nothing waits on a thread.
    private static func notificationWork(taggedWith tag: String, _ workManager: WorkManager) async -> [(identifier: String, info: WorkInfo)] {
        var work: [(identifier: String, info: WorkInfo)] = []
        // SKIP NOWARN
        let workInfos = await workManager.getWorkInfosByTagFlow(tag).first()
        let iterator = workInfos.iterator()
        while iterator.hasNext() {
            let info = iterator.next() as! WorkInfo
            guard info.tags.contains(notificationWorkTag) else { continue }
            let tags = info.tags.iterator()
            while tags.hasNext() {
                let tag = tags.next() as! String
                if tag.hasPrefix(workNamePrefix) {
                    work.append((identifier: String(tag.dropFirst(workNamePrefix.count)), info: info))
                } else if tag != notificationWorkTag {
                    work.append((identifier: tag, info: info))
                }
            }
        }
        return work
    }

    /// Saves the identifier and its date, so the request can be found and removed later.
    private static func saveRequest(identifier: String, date: Date?, context: Context) {
        let preferences = context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE)
        let ids = HashSet<String>(preferences.getStringSet("ids", HashSet<String>()) ?? HashSet<String>())
        ids.add(identifier)
        preferences.edit()
            .putStringSet("ids", ids)
            .putLong("date_" + identifier, date?.currentTimeMillis ?? System.currentTimeMillis())
            .apply()
    }

    /// Drops the requests with `identifiers` that have not reached their date from the saved list, which also
    /// lists delivered notifications.
    static func forgetRequests(identifiers: [String], context: Context) {
        let preferences = context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE)
        let editor = preferences.edit()
        let ids = HashSet<String>(preferences.getStringSet("ids", HashSet<String>()) ?? HashSet<String>())
        let now = System.currentTimeMillis()
        for identifier in identifiers {
            if preferences.getLong("date_" + identifier, 0) > now {
                ids.remove(identifier)
                editor.remove("date_" + identifier)
            }
        }
        editor.putStringSet("ids", ids)
        editor.apply()
    }

    private func getAllNotificationRequests() -> [(id: String, timestamp: Long)] {
        guard let activity = UIApplication.shared.androidActivity else { return [] }
        let preferences = activity.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE)
        let ids = preferences.getStringSet("ids", nil) ?? java.util.HashSet<String>()
        
        var all: [(id: String, timestamp: Long)] = []
        let iterator = ids.iterator()
        while iterator.hasNext() {
            let id = iterator.next() as! String
            let time = preferences.getLong("date_" + id, 0)
            all.append((id: id, timestamp: time))
        }
        
        return all
    }

    private func getPendingNotificationRequests() -> [Any /* UNNotificationRequest */] {
        let now = Date().currentTimeMillis
        return getAllNotificationRequests()
            .filter { $0.timestamp > now }
            .map {
                UNNotificationRequest(identifier: $0.id, content: UNMutableNotificationContent(), trigger: nil)
            }
    }

    private func getDeliveredNotifications() -> [Any /* UNNotification */] {
        let now = Date().currentTimeMillis
        return getAllNotificationRequests()
            .filter { $0.timestamp <= now }
            .map {
                let request = UNNotificationRequest(identifier: $0.id, content: UNMutableNotificationContent(), trigger: nil)
                return UNNotification(request: request, date: Date(timeIntervalSince1970: Double($0.timestamp) / 1000.0))
            }
    }

    /// A tap that arrived before there was a delegate to receive it.
    private var pendingResponse: UNNotificationResponse?

    /// Delivers the tap on a notification this center posted, which opened the app's activity
    /// with `intent`, to the delegate's `didReceive` as the default action, as iOS does. Without a
    /// delegate yet, the tap waits for one. Any other intent is ignored. Returns whether the
    /// intent was such a tap.
    @discardableResult func receiveResponse(from intent: Intent) -> Bool {
        guard let response = UNUserNotificationCenter.response(from: intent, context: ProcessInfo.processInfo.androidContext) else {
            return false
        }
        pendingResponse = response
        deliverPendingResponse()
        return true
    }

    /// Reads the tap that launched `activity`, and the taps that reach it while it runs.
    func receiveResponses(in activity: androidx.activity.ComponentActivity) {
        if let intent = activity.intent {
            receiveResponse(from: intent)
        }
        activity.addOnNewIntentListener(NotificationResponseListener())
    }

    private func deliverPendingResponse() {
        guard let delegate, let response = pendingResponse else {
            return
        }
        pendingResponse = nil
        Task {
            await delegate.userNotificationCenter(self, didReceive: response)
        }
    }

    /// Issues the token that a tap on the notification with `identifier` must present, replacing
    /// the token of any notification posted earlier with that identifier.
    static func issueResponseToken(identifier: String, context: Context) -> String {
        let token = java.util.UUID.randomUUID().toString()
        context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE).edit()
            .putString(responseTokenKey(identifier), token)
            .commit()
        return token
    }

    static func responseTokenKey(_ identifier: String) -> String {
        return "response_token_" + identifier
    }

    /// The default-action response to the tap that opened an activity with `intent`, or nil when
    /// the intent does not present the token of a notification this center posted.
    ///
    /// The activity is exported, so any app can start it with any extras; the token, which only
    /// the notification's own pending intent carries, proves the tap. It is spent here, so the
    /// launch intent the system hands an activity again when it recreates it (after a process
    /// death, or from Recents) yields no second response.
    static func response(from intent: Intent, context: Context) -> UNNotificationResponse? {
        do {
            // Reading an extra unparcels the whole bundle, which throws on a malformed one.
            guard let extras = intent.extras, let identifier = extras.getString(NotificationWorker.identifierKey), let token = extras.getString(NotificationWorker.tokenKey) else {
                return nil
            }
            let preferences = context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE)
            guard token == preferences.getString(responseTokenKey(identifier), nil) else {
                return nil
            }
            preferences.edit().remove(responseTokenKey(identifier)).commit()

            var userInfo: [AnyHashable: Any] = [:]
            for key in extras.keySet() where key != NotificationWorker.identifierKey && key != NotificationWorker.tokenKey && key != NotificationWorker.dateKey {
                // NotificationWorker writes these types only.
                if let value = extras.get(key), value is String || value is Bool || value is Int || value is Double {
                    userInfo[key] = value
                }
            }
            let content = UNMutableNotificationContent()
            content.userInfo = userInfo
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
            let date = Date(timeIntervalSince1970: Double(extras.getLong(NotificationWorker.dateKey, 0)) / 1000.0)
            return UNNotificationResponse(actionIdentifier: UNNotificationDefaultActionIdentifier, notification: UNNotification(request: request, date: date))
        } catch {
            logger.warning("ignoring an unreadable intent: \(error)")
            return nil
        }
    }
    #endif
}

#if SKIP
struct NotificationResponseListener : androidx.core.util.Consumer<Intent> {
    override func accept(value: Intent) {
        UNUserNotificationCenter.current().receiveResponse(from: value)
    }
}
#endif

// SKIP @bridge
public protocol UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotificationResponse) async

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?)
}

extension UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotificationResponse) async {
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return []
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
}

public struct UNAuthorizationOptions : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let badge = UNAuthorizationOptions(rawValue: 1 << 0) // For bridging
    public static let sound = UNAuthorizationOptions(rawValue: 1 << 1) // For bridging
    public static let alert = UNAuthorizationOptions(rawValue: 1 << 2) // For bridging
    public static let carPlay = UNAuthorizationOptions(rawValue: 1 << 3) // For bridging
    public static let criticalAlert = UNAuthorizationOptions(rawValue: 1 << 4) // For bridging
    public static let providesAppNotificationSettings = UNAuthorizationOptions(rawValue: 1 << 5) // For bridging
    public static var provisional = UNAuthorizationOptions(rawValue: 1 << 6) // For bridging
}

// SKIP @bridge
public final class UNNotification {
    // SKIP @bridge
    public let request: UNNotificationRequest
    // SKIP @bridge
    public let date: Date

    // SKIP @bridge
    public init(request: UNNotificationRequest, date: Date) {
        self.request = request
        self.date = date
    }
}

// SKIP @bridge
public final class UNNotificationRequest : @unchecked Sendable {
    // SKIP @bridge
    public let identifier: String
    // SKIP @bridge
    public let content: UNNotificationContent
    public let trigger: UNNotificationTrigger?
    
    // SKIP @bridge
    public init(identifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger?) {
        self.identifier = identifier
        self.content = content
        self.trigger = trigger
    }

    // SKIP @bridge
    public convenience init(identifier: String, content: UNNotificationContent) {
        self.init(identifier: identifier, content: content, trigger: UNPushNotificationTrigger(repeats: false))
    }
}

public let UNNotificationDefaultActionIdentifier = "UNNotificationDefaultActionIdentifier" // For bridging
public let UNNotificationDismissActionIdentifier = "UNNotificationDismissActionIdentifier" // For bridging

// SKIP @bridge
public final class UNNotificationResponse {
    // SKIP @bridge
    public let actionIdentifier: String
    // SKIP @bridge
    public let notification: UNNotification

    @available(*, unavailable)
    public var targetScene: Any? /* UIScene? */ {
        fatalError()
    }

    // SKIP @bridge
    public init(actionIdentifier: String = "UNNotificationDefaultActionIdentifier" /* UNNotificationDefaultActionIdentifier */, notification: UNNotification) {
        self.actionIdentifier = actionIdentifier
        self.notification = notification
    }
}

// SKIP @bridge
public struct UNNotificationPresentationOptions : OptionSet {
    // SKIP @bridge
    public let rawValue: Int

    // SKIP @bridge
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let badge = UNNotificationPresentationOptions(rawValue: 1 << 0) // For bridging
    public static let banner = UNNotificationPresentationOptions(rawValue: 1 << 1) // For bridging
    public static let list = UNNotificationPresentationOptions(rawValue: 1 << 2) // For bridging
    public static let sound = UNNotificationPresentationOptions(rawValue: 1 << 3) // For bridging
    public static let alert = UNNotificationPresentationOptions(rawValue: 1 << 4) // For bridging
}

// SKIP @bridge
public class UNNotificationContent {
    // SKIP @bridge
    public var title: String
    // SKIP @bridge
    public var subtitle: String
    // SKIP @bridge
    public var body: String
    public var badge: NSNumber?
    // SKIP @bridge
    public var bridgedBadge: Int? {
        return badge?.intValue
    }
    // SKIP @bridge
    public var sound: UNNotificationSound?
    // SKIP @bridge
    public var launchImageName: String
    public var userInfo: [AnyHashable: Any]
    // SKIP @bridge
    public var bridgedUserInfo: [AnyHashable: Any] {
        return userInfo.filter { entry in
            let value = entry.value
            return value is Bool || value is Double || value is Float || value is Int || value is Int64 || value is String || value is Array<Any> || value is Dictionary<AnyHashable, Any> || value is Set<AnyHashable>
        }
    }
    // SKIP @bridge
    public var attachments: [UNNotificationAttachment]
    // SKIP @bridge
    public var categoryIdentifier: String
    // SKIP @bridge
    public var threadIdentifier: String
    // SKIP @bridge
    public var targetContentIdentifier: String?
    // SKIP @bridge
    public var summaryArgument: String
    // SKIP @bridge
    public var summaryArgumentCount: Int
    // SKIP @bridge
    public var filterCriteria: String?

    public init(title: String = "", subtitle: String = "", body: String = "", badge: NSNumber? = nil, sound: UNNotificationSound? = UNNotificationSound.default, launchImageName: String = "", userInfo: [AnyHashable: Any] = [:], attachments: [UNNotificationAttachment] = [], categoryIdentifier: String = "", threadIdentifier: String = "", targetContentIdentifier: String? = nil, summaryArgument: String = "", summaryArgumentCount: Int = 0, filterCriteria: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badge = badge
        self.sound = sound
        self.launchImageName = launchImageName
        self.userInfo = userInfo
        self.attachments = attachments
        self.categoryIdentifier = categoryIdentifier
        self.threadIdentifier = threadIdentifier
        self.targetContentIdentifier = targetContentIdentifier
        self.summaryArgument = summaryArgument
        self.summaryArgumentCount = summaryArgumentCount
        self.filterCriteria = filterCriteria
    }

    // SKIP @bridge
    public static func bridgedContent(title: String, subtitle: String, body: String, badge: Int?, sound: UNNotificationSound?, launchImageName: String, userInfo: [AnyHashable: Any], attachments: [UNNotificationAttachment], categoryIdentifier: String, threadIdentifier: String, targetContentIdentifier: String?, summaryArgument: String, summaryArgumentCount: Int, filterCriteria: String?) -> UNNotificationContent {
        return UNNotificationContent(title: title, subtitle: subtitle, body: body, badge: badge == nil ? nil : NSNumber(value: Int32(badge!)), sound: sound, launchImageName: launchImageName, userInfo: userInfo, attachments: attachments, categoryIdentifier: categoryIdentifier, threadIdentifier: threadIdentifier, targetContentIdentifier: targetContentIdentifier, summaryArgument: summaryArgument, summaryArgumentCount: summaryArgumentCount, filterCriteria: filterCriteria)
    }
}

public final class UNMutableNotificationContent : UNNotificationContent {
    public override var title: String {
        get { super.title }
        set { super.title = newValue }
    }
    public override var subtitle: String {
        get { super.subtitle }
        set { super.subtitle = newValue }
    }
    public override var body: String {
        get { super.body }
        set { super.body = newValue }
    }
    public override var badge: NSNumber? {
        get { super.badge }
        set { super.badge = newValue }
    }
    public override var sound: UNNotificationSound? {
        get { super.sound }
        set { super.sound = newValue }
    }
    public override var launchImageName: String {
        get { super.launchImageName }
        set { super.launchImageName = newValue }
    }
    public override var userInfo: [AnyHashable: Any] {
        get { super.userInfo }
        set { super.userInfo = newValue }
    }
    public override var attachments: [UNNotificationAttachment] {
        get { super.attachments }
        set { super.attachments = newValue }
    }
    public override var categoryIdentifier: String {
        get { super.categoryIdentifier }
        set { super.categoryIdentifier = newValue }
    }
    public override var threadIdentifier: String {
        get { super.threadIdentifier }
        set { super.threadIdentifier = newValue }
    }
    public override var targetContentIdentifier: String? {
        get { super.targetContentIdentifier }
        set { super.targetContentIdentifier = newValue }
    }
    public override var summaryArgument: String {
        get { super.summaryArgument }
        set { super.summaryArgument = newValue }
    }
    public override var summaryArgumentCount: Int {
        get { super.summaryArgumentCount }
        set { super.summaryArgumentCount = newValue }
    }
    public override var filterCriteria: String? {
        get { super.filterCriteria }
        set { super.filterCriteria = newValue }
    }
}

// SKIP @bridge
public final class UNNotificationSound {
    public let name: UNNotificationSoundName
    // SKIP @bridge
    public var bridgedName: String {
        return name.rawValue
    }
    // SKIP @bridge
    public let volume: Float

    // SKIP @bridge
    public static var `default`: UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default"))
    }

    // SKIP @bridge
    public static var defaultCriticalSound: UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_critical"))
    }

    // SKIP @bridge
    public static func defaultCriticalSound(withAudioVolume volume: Float) -> UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_critical"), volume: volume)
    }

    public init(named name: UNNotificationSoundName, volume: Float = Float(0.0)) {
        self.name = name
        self.volume = volume
    }

    // SKIP @bridge
    public convenience init(named name: String, volume: Float) {
        self.init(named: UNNotificationSoundName(rawValue: name), volume: volume)
    }

    public static func soundNamed(_ name: UNNotificationSoundName) -> UNNotificationSound {
        return UNNotificationSound(named: name)
    }
}

public struct UNNotificationSoundName: RawRepresentable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public let UNNotificationAttachmentOptionsTypeHintKey = "UNNotificationAttachmentOptionsTypeHintKey"
public let UNNotificationAttachmentOptionsThumbnailHiddenKey = "UNNotificationAttachmentOptionsThumbnailHiddenKey"
public let UNNotificationAttachmentOptionsThumbnailClippingRectKey = "UNNotificationAttachmentOptionsThumbnailClippingRectKey"
public let UNNotificationAttachmentOptionsThumbnailTimeKey = "UNNotificationAttachmentOptionsThumbnailTimeKey"

// SKIP @bridge
public class UNNotificationAttachment {
    // SKIP @bridge
    public let identifier: String
    // SKIP @bridge
    public let url: URL
    // SKIP @bridge
    public let type: String
    // SKIP @bridge
    public let timeShift: TimeInterval

    // SKIP @bridge
    public init(identifier: String, url: URL, type: String = "public.data", timeShift: TimeInterval = 0) {
        self.identifier = identifier
        self.url = url
        self.type = type
        self.timeShift = timeShift
    }

    public static func attachment(withIdentifier identifier: String, url: URL, options: [AnyHashable: Any]? = nil) throws -> UNNotificationAttachment {
        return UNNotificationAttachment(identifier: identifier, url: url, type: "public.data")
    }
}

// SKIP @bridge
public class UNNotificationTrigger {
    
    // SKIP @bridge
    public let repeats: Bool

    // SKIP @bridge
    public init(repeats: Bool) {
        self.repeats = repeats
    }
}

// SKIP @bridge
public final class UNTimeIntervalNotificationTrigger: UNNotificationTrigger {
    
    // SKIP @bridge
    public let timeInterval: TimeInterval

    // SKIP @bridge
    public init(timeInterval: TimeInterval, repeats: Bool) {
        self.timeInterval = timeInterval
        super.init(repeats: repeats)
    }

    // SKIP @bridge
    public func nextTriggerDate() -> Date? {
        let now = Date()
        return now.addingTimeInterval(self.timeInterval)
    }
}

// SKIP @bridge
public final class UNCalendarNotificationTrigger: UNNotificationTrigger {
    
    // SKIP @bridge
    public let dateComponents: Any /* DateComponents */
    
    // SKIP @bridge
    public init(dateMatching dateComponents: Any /* DateComponents */, repeats: Bool) {
        self.dateComponents = dateComponents
        super.init(repeats: repeats)
    }

    // SKIP @bridge
    public func nextTriggerDate() -> Date? {
        let calendar = Calendar.current
        let now = Date()
        
        guard let nextDate = calendar.nextDate(
            after: now,
            matching: self.dateComponents as! DateComponents,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        ) else {
            return nil
        }
        
        if !self.repeats && nextDate <= now {
            return nil
        }
        
        return nextDate
    }
}

public final class UNLocationNotificationTrigger: UNNotificationTrigger {
    public let region: Any /* CLRegion */

    public init(region: Any /* CLRegion */, repeats: Bool) {
        self.region = region
        super.init(repeats: repeats)
    }
}

public final class UNPushNotificationTrigger: UNNotificationTrigger {
    public override init(repeats: Bool) {
        super.init(repeats: repeats)
    }
}

// SKIP @bridge
public enum UNAuthorizationStatus : Int, @unchecked Sendable {
    case notDetermined = 0
    case denied = 1
    case authorized = 2
    @available(iOS 12.0, *)
    case provisional = 3
    @available(iOS 14.0, *)
    case ephemeral = 4
}

@available(iOS 11.0, *)
public enum UNShowPreviewsSetting : Int, @unchecked Sendable {
    case always = 0
    case whenAuthenticated = 1
    case never = 2
}

public enum UNNotificationSetting : Int, @unchecked Sendable {
    case notSupported = 0
    case disabled = 1
    case enabled = 2
}

public enum UNAlertStyle : Int, @unchecked Sendable {
    case none = 0
    case banner = 1
    case alert = 2
}

// SKIP @bridge
public class UNNotificationSettings : NSObject {
    private let _authorizationStatus: UNAuthorizationStatus
    
    // SKIP @bridge
    public var authorizationStatus: UNAuthorizationStatus {
        return _authorizationStatus
    }
    
    public init(authorizationStatus: UNAuthorizationStatus) {
        self._authorizationStatus = authorizationStatus
        super.init()
    }

    @available(*, unavailable)
    public var soundSetting: UNNotificationSetting {
        fatalError()
    }

    @available(*, unavailable)
    public var badgeSetting: UNNotificationSetting {
        fatalError()
    }

    @available(*, unavailable)
    public var alertSetting: UNNotificationSetting {
        fatalError()
    }

    @available(*, unavailable)
    public var notificationCenterSetting: UNNotificationSetting {
        fatalError()
    }

    @available(*, unavailable)
    public var lockScreenSetting: UNNotificationSetting {
        fatalError()
    }

    @available(*, unavailable)
    public var carPlaySetting: UNNotificationSetting {
        fatalError()
    }

    @available(*, unavailable)
    public var alertStyle: UNAlertStyle {
        fatalError()
    }

    @available(iOS 11.0, *)
    @available(*, unavailable)
    public var showPreviewsSetting: UNShowPreviewsSetting {
        fatalError()
    }

    @available(iOS 12.0, *)
    @available(*, unavailable)
    public var criticalAlertSetting: UNNotificationSetting {
        fatalError()
    }

    @available(iOS 12.0, *)
    @available(*, unavailable)
    public var providesAppNotificationSettings: Bool {
        fatalError()
    }

    @available(iOS 13.0, *)
    @available(*, unavailable)
    public var announcementSetting: UNNotificationSetting {
        fatalError()
    }

    @available(iOS 15.0, *)
    @available(*, unavailable)
    public var timeSensitiveSetting: UNNotificationSetting {
        fatalError()
    }

    @available(iOS 15.0, *)
    @available(*, unavailable)
    public var scheduledDeliverySetting: UNNotificationSetting {
        fatalError()
    }

    @available(iOS 15.0, *)
    @available(*, unavailable)
    public var directMessagesSetting: UNNotificationSetting {
        fatalError()
    }
}

#if SKIP
public class NotificationWorker : Worker {
    /// The extra that carries a notification's request identifier on the intent its tap opens,
    /// which also marks the intent as a tap.
    static let identifierKey = "skip.ui.UNNotificationRequest.identifier"
    /// The extra that carries the time the notification was posted, in milliseconds.
    static let dateKey = "skip.ui.UNNotification.date"
    /// The extra that carries the token proving the intent came from the notification.
    static let tokenKey = "skip.ui.UNNotificationResponse.token"

    public init(context: Context, params: WorkerParameters) {
        super.init(context, params)
    }
    
    public override func doWork() -> ListenableWorker.Result {
        // Get the data which should be displayed in the notification.
        let inputData = getInputData()
        let id = inputData.getInt("id", 0)
        let title = inputData.getString("title") ?? ""
        let body = inputData.getString("body") ?? ""
        let imageAttachmentUrl = inputData.getString("image_url")
        
        let context = getApplicationContext()
        let intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName())
        intent?.addFlags(android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP)
        
        let bundle = android.os.Bundle()
        let allData = inputData.keyValueMap
        for (key, value) in allData where key != "title" && key != "body" && key != "id" && key != "image_url" {
            if let s = value as? String {
                bundle.putString(key, s)
            } else if let b = value as? Bool {
                bundle.putBoolean(key, b)
            } else if let i = value as? Int {
                bundle.putInt(key, i)
            } else if let d = value as? Double {
                bundle.putDouble(key, d)
            } else {
                bundle.putString(key, value.toString())
            }
        }
        bundle.putLong(NotificationWorker.dateKey, System.currentTimeMillis())
        if let identifier = inputData.getString(NotificationWorker.identifierKey) {
            bundle.putString(NotificationWorker.tokenKey, UNUserNotificationCenter.issueResponseToken(identifier: identifier, context: context))
        }
        intent?.putExtras(bundle)
        
        // Create the notification channel.
        let channelID = "tools.skip.firebase.messaging" // Match AndroidManifest.xml
        let notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as! NotificationManager
        if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O {
            let appName = context.getApplicationInfo().loadLabel(context.getPackageManager()).toString()
            notificationManager.createNotificationChannel(NotificationChannel(channelID, appName, NotificationManager.IMPORTANCE_DEFAULT))
        }
        
        // Build the notification.
        let pendingIntent = PendingIntent.getActivity(context, id, intent, PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT)
        let builder = NotificationCompat.Builder(context, channelID)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
        
        // Update the notification icon.
        if let url = imageAttachmentUrl {
            builder.setSmallIcon(IconCompat.createWithContentUri(url))
        } else {
            // Notification icon: must be a resource with transparent background and white logo
            // eg: to be used as a default icon must be added in the AndroidManifest.xml with the following code:
            // <meta-data
            // android:name="com.google.firebase.messaging.default_notification_icon"
            // android:resource="@drawable/ic_notification" />
            var resId = context.getResources().getIdentifier("ic_notification", "drawable", context.getPackageName())
            if resId == 0 {
                resId = context.getResources().getIdentifier("ic_launcher", "mipmap", context.getPackageName())
            }
            // createWithResource throws when the id is 0, which fails the worker and
            // the notification is never posted. A platform status icon always exists.
            // createWithResource records the package of the Context it is given, so a
            // framework id is not found in the app package. Load it from the android package.
            if resId == 0 {
                let androidContext = context.createPackageContext("android", 0)
                builder.setSmallIcon(IconCompat.createWithResource(androidContext, android.R.drawable.stat_notify_chat))
            } else {
                builder.setSmallIcon(IconCompat.createWithResource(context, resId))
            }
        }
        
        // Display the notification.
        notificationManager.notify(id, builder.build())
        return ListenableWorker.Result.success()
    }
}
#endif
#endif
