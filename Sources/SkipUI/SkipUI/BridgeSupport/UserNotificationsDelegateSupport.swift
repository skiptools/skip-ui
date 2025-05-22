// Copyright 2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

// SKIP @bridge
public final class UserNotificationCenterDelegateSupport : UNUserNotificationCenterDelegate {
    let didReceive: (UNNotificationResponse, CompletionHandler) -> Void
    let willPresent: (UNNotification, ValueCompletionHandler) -> Void
    let openSettings: (UNNotification?) -> Void

    // SKIP @bridge
    public init(didReceive: @escaping (UNNotificationResponse, CompletionHandler) -> Void, willPresent: @escaping (UNNotification, ValueCompletionHandler) -> Void, openSettings: @escaping (UNNotification?) -> Void) {
        self.didReceive = didReceive
        self.willPresent = willPresent
        self.openSettings = openSettings
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotificationResponse) async {
        #if SKIP
        kotlin.coroutines.suspendCoroutine { continuation in
            let completionHandler = CompletionHandler { continuation.resumeWith(kotlin.Result.success(Unit)) }
            self.didReceive(notification, completionHandler)
        }
        #endif
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        #if SKIP
        kotlin.coroutines.suspendCoroutine { continuation in
            let completionHandler = ValueCompletionHandler {
                let options = UNNotificationPresentationOptions(rawValue: $0 as! Int)
                continuation.resumeWith(kotlin.Result.success(options))
            }
            self.willPresent(notification, completionHandler)
        }
        #else
        return []
        #endif
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        openSettings(notification)
    }
}


#endif
