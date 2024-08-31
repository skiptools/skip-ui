// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.registerForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.IconCompat
import kotlin.coroutines.Continuation
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine
import kotlin.random.Random
#endif

public final class UNUserNotificationCenter {
    private static let shared = UNUserNotificationCenter()
    #if SKIP
    private var requestPermissionLauncher: ActivityResultLauncher<String>?
    private let waitingContinuations: MutableList<Continuation<Bool>> = mutableListOf<Continuation<Bool>>()
    #endif

    private init() {
    }

    public static func current() -> UNUserNotificationCenter {
        return shared
    }

    #if SKIP
    /// Called by `UIApplication` when it receives its activity reference.
    static func launch(_ activity: AppCompatActivity) {
        let shared = self.shared
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
        } catch {
            android.util.Log.w("SkipUI", "error initializing permission launcher", error as? Throwable)
        }
    }
    #endif

    @available(*, unavailable)
    public func getNotificationSettings() async -> Any /* UNNotificationSettings */ {
        fatalError()
    }

    @available(*, unavailable)
    public func setBadgeCount(_ count: Int) async throws {
    }

    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        #if SKIP
        guard Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU else {
            return false
        }
        guard let activity = UIApplication.shared.androidActivity, ContextCompat.checkSelfPermission(activity, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED else {
            return true
        }
        suspendCoroutine { continuation in
            var count = 0
            synchronized(waitingContinuations) {
                waitingContinuations.add(continuation)
                count = waitingContinuations.count()
            }
            if count == 1 {
                requestPermissionLauncher?.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        }
        #else
        fatalError()
        #endif
    }

    public var delegate: (any UNUserNotificationCenterDelegate)?

    @available(*, unavailable)
    public var supportsContentExtensions: Bool {
        fatalError()
    }

    @MainActor
    public func add(_ request: UNNotificationRequest) async throws {
        guard let delegate else {
            return
        }
        let notification = UNNotification(request: request, date: Date.now)
        let options = await delegate.userNotificationCenter(self, willPresent: notification)
        guard options.contains(.banner) || options.contains(.alert) else {
            return
        }

        #if SKIP
        guard let activity = UIApplication.shared.androidActivity else {
            return
        }
        let intent = Intent(activity, type(of: activity).java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        let extras = android.os.Bundle()
        for (key, value) in request.content.userInfo {
            if let s = value as? String {
                extras.putString(key.toString(), s)
            } else if let b = value as? Bool {
                extras.putBoolean(key.toString(), b)
            } else if let i = value as? Int {
                extras.putInt(key.toString(), i)
            } else if let d = value as? Double {
                extras.putDouble(key.toString(), d)
            } else {
                extras.putString(key.toString(), value.toString())
            }
        }
        intent.putExtras(extras)

        // SKIP INSERT: val pendingFlags = PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        let pendingIntent = PendingIntent.getActivity(activity, 0, intent, pendingFlags)

        let channelID = "tools.skip.firebase.messaging" // Match AndroidManifest.xml
        let notificationBuilder = NotificationCompat.Builder(activity, channelID)
            .setContentTitle(request.content.title)
            .setContentText(request.content.body)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
        let application = activity.application
        if let imageAttachment = request.content.attachments.first(where: { $0.type == "public.image" }) {
            notificationBuilder.setSmallIcon(IconCompat.createWithContentUri(imageAttachment.url.absoluteString))
        } else {
            let packageName = application.getPackageName()
            let resId = application.resources.getIdentifier("ic_launcher", "mipmap", packageName)
            notificationBuilder.setSmallIcon(IconCompat.createWithResource(application, resId))
        }

        let manager = activity.getSystemService(Context.NOTIFICATION_SERVICE) as! NotificationManager
        let appName = application.packageManager.getApplicationLabel(application.applicationInfo)
        let channel = NotificationChannel(channelID, appName, NotificationManager.IMPORTANCE_DEFAULT)
        manager.createNotificationChannel(channel)
        manager.notify(Random.nextInt(), notificationBuilder.build())
        #endif
    }

    @available(*, unavailable)
    public func getPendingNotificationRequests() async -> [Any /* UNNotificationRequest */] {
        fatalError()
    }

    @available(*, unavailable)
    public func removePendingNotificationRequests(withIdentifiers: [String]) {
    }

    @available(*, unavailable)
    public func removeAllPendingNotificationRequests() {
    }

    @available(*, unavailable)
    public func getDeliveredNotifications() async -> [Any /* UNNotification */] {
        fatalError()
    }

    @available(*, unavailable)
    public func removeDeliveredNotifications(withIdentifiers: [String]) {
    }

    @available(*, unavailable)
    public func removeAllDeliveredNotifications() {
    }

    @available(*, unavailable)
    public func setNotificationCategories(_ categories: Set<AnyHashable /* UNNotificationCategory */>) {
    }

    @available(*, unavailable)
    public func getNotificationCategories() async -> Set<AnyHashable /* UNNotificationCategory */> {
        fatalError()
    }
}

@MainActor
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

    public static let badge = UNAuthorizationOptions(rawValue: 1 << 0)
    public static let sound = UNAuthorizationOptions(rawValue: 1 << 1)
    public static let alert = UNAuthorizationOptions(rawValue: 1 << 2)
    public static let carPlay = UNAuthorizationOptions(rawValue: 1 << 3)
    public static let criticalAlert = UNAuthorizationOptions(rawValue: 1 << 4)
    public static let providesAppNotificationSettings = UNAuthorizationOptions(rawValue: 1 << 5)
    public static var provisional = UNAuthorizationOptions(rawValue: 1 << 6)
}

public final class UNNotification {
    public let request: UNNotificationRequest
    public let date: Date

    public init(request: UNNotificationRequest, date: Date) {
        self.request = request
        self.date = date
    }
}

public final class UNNotificationRequest {
    public let identifier: String
    public let content: UNNotificationContent
    public let trigger: UNNotificationTrigger?

    public init(identifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger?) {
        self.identifier = identifier
        self.content = content
        self.trigger = trigger
    }
}

public let UNNotificationDefaultActionIdentifier = "UNNotificationDefaultActionIdentifier"
public let UNNotificationDismissActionIdentifier = "UNNotificationDismissActionIdentifier"

public final class UNNotificationResponse {
    public let actionIdentifier: String
    public let notification: UNNotification

    @available(*, unavailable)
    public var targetScene: Any? /* UIScene? */ {
        fatalError()
    }

    public init(actionIdentifier: String = UNNotificationDefaultActionIdentifier, notification: UNNotification) {
        self.actionIdentifier = actionIdentifier
        self.notification = notification
    }
}

public struct UNNotificationPresentationOptions : OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let badge = UNNotificationPresentationOptions(rawValue: 1 << 0)
    public static let banner = UNNotificationPresentationOptions(rawValue: 1 << 1)
    public static let list = UNNotificationPresentationOptions(rawValue: 1 << 2)
    public static let sound = UNNotificationPresentationOptions(rawValue: 1 << 3)
    public static let alert = UNNotificationPresentationOptions(rawValue: 1 << 4)
}

public class UNNotificationContent {
    public internal(set) var title: String
    public internal(set) var subtitle: String
    public internal(set) var body: String
    public internal(set) var badge: NSNumber?
    public internal(set) var sound: UNNotificationSound?
    public internal(set) var launchImageName: String
    public internal(set) var userInfo: [AnyHashable: Any]
    public internal(set) var attachments: [UNNotificationAttachment]
    public internal(set) var categoryIdentifier: String
    public internal(set) var threadIdentifier: String
    public internal(set) var targetContentIdentifier: String?
    public internal(set) var summaryArgument: String
    public internal(set) var summaryArgumentCount: Int
    public internal(set) var filterCriteria: String?

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

public final class UNNotificationSound {
    public let name: UNNotificationSoundName
    public let volume: Float

    public static var `default`: UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default"))
    }

    public static var defaultCriticalSound: UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_critical"))
    }

    public static func defaultCriticalSound(withAudioVolume volume: Float) -> UNNotificationSound {
        return UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_critical"), volume: volume)
    }

    public init(named name: UNNotificationSoundName, volume: Float = Float(0.0)) {
        self.name = name
        self.volume = volume
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

public class UNNotificationAttachment {
    public let identifier: String
    public let url: URL
    public let type: String
    public let timeShift: TimeInterval

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

public class UNNotificationTrigger {
    public let repeats: Bool

    public init(repeats: Bool) {
        self.repeats = repeats
    }
}

public final class UNTimeIntervalNotificationTrigger: UNNotificationTrigger {
    public let timeInterval: TimeInterval

    public init(timeInterval: TimeInterval, repeats: Bool) {
        self.timeInterval = timeInterval
        super.init(repeats: repeats)
    }
}

public final class UNCalendarNotificationTrigger: UNNotificationTrigger {
    public let dateComponents: DateComponents

    public init(dateComponents: DateComponents, repeats: Bool) {
        self.dateComponents = dateComponents
        super.init(repeats: repeats)
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
