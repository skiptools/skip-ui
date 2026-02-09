// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
import Foundation
#if SKIP
import android.Manifest
import android.app.AlarmManager
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
        
        let intent = Intent("skip.notification.receiver")
        intent.setPackage(activity.getPackageName())
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        
        intent.putExtra("title", request.content.title)
        intent.putExtra("body", request.content.body)
        
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
        
        let pendingFlags = PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT
        let pendingIntent = PendingIntent.getBroadcast(activity, request.identifier.hashValue, intent, pendingFlags)
        
        if let nextDate =
            (request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ??
            (request.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate() {
            
            let triggerMillis = nextDate.currentTimeMillis
            let alarmManager = activity.getSystemService(Context.ALARM_SERVICE) as! AlarmManager
            let canScheduleExactAlarm = Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarmManager.canScheduleExactAlarms()
            if canScheduleExactAlarm {
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
            }
            
            let preferences = activity.getSharedPreferences("alarms", Context.MODE_PRIVATE)
            let editor = preferences.edit()
            let ids = java.util.HashSet<String>(preferences.getStringSet("ids", java.util.HashSet<String>()) ?? java.util.HashSet<String>())
            ids.add(request.identifier)
            editor.putStringSet("ids", ids)
            editor.putLong("date_" + request.identifier, triggerMillis)
            editor.apply()
        } else {
            let channelID = "tools.skip.firebase.messaging"
            let notificationBuilder = NotificationCompat.Builder(activity, channelID)
                .setContentTitle(request.content.title)
                .setContentText(request.content.body)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)

            // Notification icon: must be a resource with transparent background and white logo
            // eg: to be used as a default icon must be added in the AndroidManifest.xml with the following code:
            // <meta-data
            // android:name="com.google.firebase.messaging.default_notification_icon"
            // android:resource="@drawable/ic_notification" />
            let application = activity.application
            let packageName = application.getPackageName()
            let iconNotificationIdentifier = "ic_notification"

            // Check if the resource is found, otherwise fallback to use the default app icon (eg. ic_launcher)
            var resId = application.resources.getIdentifier(iconNotificationIdentifier, "drawable", packageName)
            if resId == 0 {
                resId = application.resources.getIdentifier("ic_launcher", "mipmap", packageName)
            }

            notificationBuilder.setSmallIcon(IconCompat.createWithResource(application, resId))

            let manager = activity.getSystemService(Context.NOTIFICATION_SERVICE) as! NotificationManager
            let appName = application.packageManager.getApplicationLabel(application.applicationInfo)

            if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O {
                let channel = NotificationChannel(channelID, appName, NotificationManager.IMPORTANCE_DEFAULT)
                manager.createNotificationChannel(channel)
            }

            manager.notify(request.identifier.hashValue, notificationBuilder.build())
        }
        #endif
    }
    
    public func pendingNotificationRequests() async -> [UNNotificationRequest] {
        #if SKIP
        return getPendingNotificationRequests()
        #else
        fatalError()
        #endif
    }
    
    public func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        #if SKIP
        guard let activity = UIApplication.shared.androidActivity else { return }
        let alarmManager = activity.getSystemService(Context.ALARM_SERVICE) as! AlarmManager
        let preferences = activity.getSharedPreferences("alarms", Context.MODE_PRIVATE)
        let editor = preferences.edit()
        
        let ids = java.util.HashSet<String>(preferences.getStringSet("ids", java.util.HashSet<String>()) ?? java.util.HashSet<String>())
        
        for identifier in identifiers {
            let intent = Intent("skip.notification.receiver")
            intent.setPackage(activity.getPackageName())
            
            let pendingFlags = PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT
            let pendingIntent = PendingIntent.getBroadcast(activity, identifier.hashValue, intent, pendingFlags)
            
            if pendingIntent != nil {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
            }
            
            ids.remove(identifier)
            editor.remove("date_" + identifier)
        }
        
        editor.putStringSet("ids", ids)
        editor.apply()
        #endif
    }
    
    public func removeAllPendingNotificationRequests() {
        #if SKIP
        let pendingNotifications = getPendingNotificationRequests()
        let identifiers = pendingNotifications.map { $0.identifier }
        removePendingNotificationRequests(withIdentifiers: identifiers)
        #else
        fatalError()
        #endif
    }
    
    public func deliveredNotifications() async -> [UNNotification] {
        #if SKIP
        return getDeliveredNotifications()
        #else
        fatalError()
        #endif
    }
    
    public func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        #if SKIP
        guard let activity = UIApplication.shared.androidActivity else { return }
        
        let notificationManager = activity.getSystemService(android.content.Context.NOTIFICATION_SERVICE) as! android.app.NotificationManager
        
        let preferences = activity.getSharedPreferences("alarms", android.content.Context.MODE_PRIVATE)
        let editor = preferences.edit()
        let ids = java.util.HashSet<String>(preferences.getStringSet("ids", java.util.HashSet<String>()) ?? java.util.HashSet<String>())
        
        for identifier in identifiers {
            notificationManager.cancel(identifier.hashValue)
            ids.remove(identifier)
            editor.remove("date_" + identifier)
        }
        
        editor.putStringSet("ids", ids)
        editor.apply()
        #else
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        #endif
    }
    
    public func removeAllDeliveredNotifications() {
        #if SKIP
        let deliveredNotifications = getDeliveredNotifications()
        let identifiers = deliveredNotifications.map { $0.request.identifier }
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
    private func getAllNotificationRequests() -> [(id: String, timestamp: Long)] {
        guard let activity = UIApplication.shared.androidActivity else { return [] }
        let preferences = activity.getSharedPreferences("alarms", Context.MODE_PRIVATE)
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
    
    private func getPendingNotificationRequests() -> [UNNotificationRequest] {
        let now = Date().currentTimeMillis
        return getAllNotificationRequests()
            .filter { $0.timestamp > now }
            .map {
                UNNotificationRequest(identifier: $0.id, content: UNMutableNotificationContent(), trigger: nil)
            }
    }
    
    private func getDeliveredNotifications() -> [UNNotification] {
        let now = Date().currentTimeMillis
        return getAllNotificationRequests()
            .filter { $0.timestamp <= now }
            .map {
                let request = UNNotificationRequest(identifier: $0.id, content: UNMutableNotificationContent(), trigger: nil)
                return UNNotification(request: request, date: Date(timeIntervalSince1970: Double($0.timestamp) / 1000.0))
            }
    }
    #endif
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

    public func nextTriggerDate() -> Date? {
        let now = Date()
        return now.addingTimeInterval(self.timeInterval)
    }
}

public final class UNCalendarNotificationTrigger: UNNotificationTrigger {
    public let dateComponents: DateComponents

    public init(dateMatching dateComponents: DateComponents, repeats: Bool) {
        self.dateComponents = dateComponents
        super.init(repeats: repeats)
    }

    public func nextTriggerDate() -> Date? {
        let calendar = Calendar.current
        let now = Date()
        return calendar.nextDate(
            after: now,
            matching: self.dateComponents,
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        )
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

#endif
