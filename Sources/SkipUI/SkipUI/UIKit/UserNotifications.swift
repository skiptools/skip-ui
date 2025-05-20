// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
import androidx.core.app.NotificationCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import kotlin.random.Random
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
            return true
        }
        UIApplication.shared.requestPermission(Manifest.permission.POST_NOTIFICATIONS)
        #else
        fatalError()
        #endif
    }

    // SKIP @bridge
    public func requestAuthorization(bridgedOptions: Int) async throws -> Bool {
        return try await requestAuthorization(options: UNAuthorizationOptions(rawValue: bridgedOptions))
    }

    // SKIP @bridge
    public var delegate: (any UNUserNotificationCenterDelegate)?

    @available(*, unavailable)
    public var supportsContentExtensions: Bool {
        fatalError()
    }

    // SKIP @bridge
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
            
            // Notification icon: must be a resource with transparent background and white logo
            // eg: to be used as a default icon must be added in the AndroidManifest.xml with the following code:
            // <meta-data
            // android:name="com.google.firebase.messaging.default_notification_icon"
            // android:resource="@drawable/ic_notification" />
            
            let iconNotificationIdentifier = "ic_notification"
            let resourceFolder = "drawable"
            
            var resId = application.resources.getIdentifier(iconNotificationIdentifier, resourceFolder, packageName)
            
            // Check if the resource is found, otherwise fallback to use the default app icon (eg. ic_launcher)
            if resId == 0 {
                resId = application.resources.getIdentifier("ic_launcher", "mipmap", packageName)
            }
            
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
    public internal(set) var title: String
    // SKIP @bridge
    public internal(set) var subtitle: String
    // SKIP @bridge
    public internal(set) var body: String
    public internal(set) var badge: NSNumber?
    // SKIP @bridge
    public var bridgedBadge: Int? {
        return badge?.intValue
    }
    // SKIP @bridge
    public internal(set) var sound: UNNotificationSound?
    // SKIP @bridge
    public internal(set) var launchImageName: String
    // SKIP @bridge
    public internal(set) var userInfo: [AnyHashable: Any]
    // SKIP @bridge
    public internal(set) var attachments: [UNNotificationAttachment]
    // SKIP @bridge
    public internal(set) var categoryIdentifier: String
    // SKIP @bridge
    public internal(set) var threadIdentifier: String
    // SKIP @bridge
    public internal(set) var targetContentIdentifier: String?
    // SKIP @bridge
    public internal(set) var summaryArgument: String
    // SKIP @bridge
    public internal(set) var summaryArgumentCount: Int
    // SKIP @bridge
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

#endif
