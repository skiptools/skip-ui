// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest

#if SKIP
import android.content.Context
import androidx.work.Configuration
import androidx.work.Data
import androidx.work.ListenableWorker
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkInfo
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.concurrent.TimeUnit
#endif

final class NotificationRequestTests: SkipUITestCase {
    #if SKIP
    private var context: Context {
        return ProcessInfo.processInfo.androidContext
    }

    private func workManager() -> WorkManager {
        if !WorkManager.isInitialized() {
            let configuration = Configuration.Builder()
                .setExecutor(DirectExecutor())
                .build()
            WorkManager.initialize(context, configuration)
        }
        let workManager = WorkManager.getInstance(context)
        workManager.cancelAllWork().result.get()
        workManager.pruneWork().result.get()
        context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE).edit().clear().commit()
        return workManager
    }

    private func states(tag: String, _ workManager: WorkManager) -> [String] {
        var states: [String] = []
        let iterator = workManager.getWorkInfosByTag(tag).get().iterator()
        while iterator.hasNext() {
            states.append((iterator.next() as! WorkInfo).state.name)
        }
        return states.sorted()
    }

    private func enqueue(_ identifier: String, inDays days: Double?) {
        let date: Date? = days == nil ? nil : Date().addingTimeInterval(days! * 86400)
        UNUserNotificationCenter.enqueueRequest(identifier: identifier, data: Data.Builder().putString("title", identifier).build(), date: date, context: context)
    }

    private func savedDate(_ identifier: String) -> Int64 {
        return context.getSharedPreferences("__skip_usernotifications", Context.MODE_PRIVATE).getLong("date_" + identifier, 0)
    }
    #endif

    func testRequestReplacesOnlyItsOwnWork() throws {
        #if !SKIP
        throw XCTSkip("Notification requests are WorkManager work on Android")
        #else
        let workManager = workManager()
        let unrelated = OneTimeWorkRequestBuilder<UnrelatedWorker>().setInitialDelay(1, TimeUnit.DAYS).addTag("daily").build()
        workManager.enqueue(unrelated).result.get()

        enqueue("daily", inDays: 1)
        enqueue("daily", inDays: 2)

        XCTAssertEqual(workManager.getWorkInfoById(unrelated.id).get()?.state, WorkInfo.State.ENQUEUED)
        // Unique work with REPLACE deletes the work it replaces.
        XCTAssertEqual(states(tag: UNUserNotificationCenter.workName("daily"), workManager), ["ENQUEUED"])
        XCTAssertEqual(UNUserNotificationCenter.queuedNotificationIdentifiers(workManager), ["daily"])

        UNUserNotificationCenter.removePendingRequests(identifiers: ["daily"], context: context)
        XCTAssertEqual(workManager.getWorkInfoById(unrelated.id).get()?.state, WorkInfo.State.ENQUEUED)
        XCTAssertTrue(UNUserNotificationCenter.queuedNotificationIdentifiers(workManager).isEmpty)
        XCTAssertEqual(savedDate("daily"), Int64(0))
        #endif
    }

    func testRequestReplacesDuplicatesOfEarlierVersions() throws {
        #if !SKIP
        throw XCTSkip("Notification requests are WorkManager work on Android")
        #else
        let workManager = workManager()
        // Earlier versions enqueued one request per call, tagged with the bare identifier.
        for _ in 0..<2 {
            workManager.enqueue(OneTimeWorkRequestBuilder<NotificationWorker>().setInitialDelay(1, TimeUnit.DAYS).addTag("reminder").build()).result.get()
        }
        XCTAssertEqual(UNUserNotificationCenter.queuedNotificationIdentifiers(workManager), ["reminder"])

        enqueue("reminder", inDays: 1)

        XCTAssertEqual(states(tag: "reminder", workManager), ["CANCELLED", "CANCELLED"])
        XCTAssertEqual(states(tag: UNUserNotificationCenter.workName("reminder"), workManager), ["ENQUEUED"])
        #endif
    }

    func testImmediateRequestReplacesTheScheduledDate() throws {
        #if !SKIP
        throw XCTSkip("Notification requests are WorkManager work on Android")
        #else
        let workManager = workManager()
        enqueue("reminder", inDays: 1)
        XCTAssertGreaterThan(savedDate("reminder"), Int64(System.currentTimeMillis()))

        enqueue("reminder", inDays: nil)

        XCTAssertLessThanOrEqual(savedDate("reminder"), Int64(System.currentTimeMillis()))
        // The request a day out is gone; only the immediate one remains.
        let workInfos = workManager.getWorkInfosByTag(UNUserNotificationCenter.workName("reminder")).get()
        XCTAssertEqual(workInfos.size, 1)
        XCTAssertEqual((workInfos.get(0) as! WorkInfo).initialDelayMillis, Int64(0))
        #endif
    }
}

#if SKIP
final class DirectExecutor: java.util.concurrent.Executor {
    override func execute(command: java.lang.Runnable) {
        command.run()
    }
}

public final class UnrelatedWorker: Worker {
    public init(context: Context, params: WorkerParameters) {
        super.init(context, params)
    }

    public override func doWork() -> ListenableWorker.Result {
        return ListenableWorker.Result.success()
    }
}
#endif
