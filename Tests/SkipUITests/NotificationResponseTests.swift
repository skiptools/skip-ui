// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest

#if SKIP
import android.content.Context
import android.content.Intent
#endif

final class NotificationResponseTests: SkipUITestCase {
    override func setUp() {
        super.setUp()
        #if SKIP
        context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE).edit().clear().commit()
        #endif
    }

    #if SKIP
    private var context: Context {
        return ProcessInfo.processInfo.androidContext
    }

    private func tapIntent(identifier: String, token: String?, postedAt millis: Int64 = Int64(1_700_000_000_000), userInfo: [String: String] = [:]) -> Intent {
        let intent = Intent(Intent.ACTION_MAIN)
        intent.putExtra("skip.ui.UNNotificationRequest.identifier", identifier)
        if let token {
            intent.putExtra("skip.ui.UNNotificationResponse.token", token)
        }
        intent.putExtra("skip.ui.UNNotification.date", millis)
        for (key, value) in userInfo {
            intent.putExtra(key, value)
        }
        return intent
    }
    #endif

    func testTapIntentIsTheDefaultActionResponse() throws {
        #if !SKIP
        throw XCTSkip("Notification taps arrive as Android intents")
        #else
        let token = UNUserNotificationCenter.issueResponseToken(identifier: "reminder.1", context: context)
        let intent = tapIntent(identifier: "reminder.1", token: token, userInfo: ["link": "app://open"])
        intent.putExtra("count", 3)
        let response = try XCTUnwrap(UNUserNotificationCenter.response(from: intent, context: context))
        XCTAssertEqual(response.actionIdentifier, UNNotificationDefaultActionIdentifier)
        XCTAssertEqual(response.notification.request.identifier, "reminder.1")
        XCTAssertEqual(response.notification.date, Date(timeIntervalSince1970: 1_700_000_000))
        let userInfo = response.notification.request.content.userInfo
        XCTAssertEqual(userInfo.count, 2)
        XCTAssertEqual(userInfo["link"] as? String, "app://open")
        XCTAssertEqual(userInfo["count"] as? Int, 3)
        #endif
    }

    func testTapWithoutTheNotificationsTokenIsNotAResponse() throws {
        #if !SKIP
        throw XCTSkip("Notification taps arrive as Android intents")
        #else
        let token = UNUserNotificationCenter.issueResponseToken(identifier: "reminder.1", context: context)
        XCTAssertNil(UNUserNotificationCenter.response(from: tapIntent(identifier: "reminder.1", token: nil), context: context))
        XCTAssertNil(UNUserNotificationCenter.response(from: tapIntent(identifier: "reminder.1", token: "forged"), context: context))
        XCTAssertNil(UNUserNotificationCenter.response(from: tapIntent(identifier: "reminder.2", token: token), context: context))
        // None of those spent the real token.
        XCTAssertNotNil(UNUserNotificationCenter.response(from: tapIntent(identifier: "reminder.1", token: token), context: context))
        #endif
    }

    func testTokenIsSpentByItsTap() throws {
        #if !SKIP
        throw XCTSkip("Notification taps arrive as Android intents")
        #else
        let first = UNUserNotificationCenter.issueResponseToken(identifier: "reminder.1", context: context)
        let tap = tapIntent(identifier: "reminder.1", token: first)
        XCTAssertNotNil(UNUserNotificationCenter.response(from: tap, context: context))
        // The system hands a recreated activity the same intent again.
        XCTAssertNil(UNUserNotificationCenter.response(from: tap, context: context))

        // Posting the identifier again issues a new token, and the old one no longer counts.
        let earlier = UNUserNotificationCenter.issueResponseToken(identifier: "reminder.1", context: context)
        let latest = UNUserNotificationCenter.issueResponseToken(identifier: "reminder.1", context: context)
        XCTAssertNil(UNUserNotificationCenter.response(from: tapIntent(identifier: "reminder.1", token: earlier), context: context))
        XCTAssertNotNil(UNUserNotificationCenter.response(from: tapIntent(identifier: "reminder.1", token: latest), context: context))
        #endif
    }

    func testOtherIntentsAreNotResponses() throws {
        #if !SKIP
        throw XCTSkip("Notification taps arrive as Android intents")
        #else
        let launcher = Intent(Intent.ACTION_MAIN)
        launcher.addCategory(Intent.CATEGORY_LAUNCHER)
        XCTAssertNil(UNUserNotificationCenter.response(from: launcher, context: context))
        XCTAssertFalse(UNUserNotificationCenter.current().receiveResponse(from: launcher))

        let link = Intent(Intent.ACTION_VIEW, android.net.Uri.parse("app://open"))
        link.putExtra("link", "app://open")
        XCTAssertNil(UNUserNotificationCenter.response(from: link, context: context))
        #endif
    }
}
