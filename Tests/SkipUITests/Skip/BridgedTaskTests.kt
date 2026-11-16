// Copyright 2026 Skip
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.atomic.AtomicInteger
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

/** Exercise the real task modifier's ownership of a pending native operation. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class BridgedTaskTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @Test fun replacingTaskIDCancelsEveryPreviousOperation() {
        val id = mutableStateOf(0)
        val present = mutableStateOf(true)
        val pending = ConcurrentHashMap<Int, CompletionHandler>()
        val cancelled = CopyOnWriteArrayList<Int>()
        rule.setContent {
            if (present.value) {
                val current = id.value
                Color.clear.task(id = current, bridgedAction = { completion ->
                    pending[current] = completion
                    completion.onCancel = {
                        cancelled.add(current)
                        pending.remove(current)
                        completion.run()
                    }
                }).Compose(ComposeContext())
            }
        }
        rule.waitUntil(5_000) { pending.containsKey(0) }
        for (next in 1..12) {
            rule.runOnIdle { id.value = next }
            rule.runOnIdle {
                assertEquals("Only the current native operation may remain", setOf(next), pending.keys.toSet())
                assertEquals((0 until next).toList(), cancelled.toList())
            }
        }
        rule.runOnIdle { present.value = false }
        rule.runOnIdle {
            assertEquals(emptySet<Int>(), pending.keys.toSet())
            assertEquals((0..12).toList(), cancelled.toList())
        }
    }

    @Test fun removingTaskForwardsCancellationAndReleasesCallback() {
        val present = mutableStateOf(true)
        val cancellations = AtomicInteger()
        val handlers = CopyOnWriteArrayList<CompletionHandler>()
        rule.setContent {
            if (present.value) {
                Color.clear.task(id = 0, bridgedAction = { completion ->
                    completion.onCancel = { cancellations.incrementAndGet(); completion.run() }
                    handlers.add(completion)
                }).Compose(ComposeContext())
            }
        }
        rule.waitUntil(5_000) { handlers.size == 1 }
        rule.runOnIdle { present.value = false }
        rule.runOnIdle {
            assertEquals(1, cancellations.get())
            assertNull("Disposal must release the closure holding the native Task", handlers.single().onCancel)
        }
    }

    @Test fun unchangedIDKeepsOperationAndReplacementUsesLatestAction() {
        val id = mutableStateOf(0)
        val actionVersion = mutableStateOf(0)
        val started = CopyOnWriteArrayList<Pair<Int, Int>>()
        val cancelled = CopyOnWriteArrayList<Int>()
        rule.setContent {
            val currentID = id.value
            val version = actionVersion.value
            Color.clear.task(id = currentID, bridgedAction = { completion ->
                completion.onCancel = { cancelled.add(currentID); completion.run() }
                started.add(currentID to version)
            }).Compose(ComposeContext())
        }
        rule.waitUntil(5_000) { started.size == 1 }
        rule.runOnIdle { actionVersion.value = 1 }
        rule.runOnIdle {
            assertEquals(listOf(0 to 0), started.toList())
            assertEquals(emptyList<Int>(), cancelled.toList())
            id.value = 1
        }
        rule.runOnIdle {
            assertEquals(listOf(0 to 0, 1 to 1), started.toList())
            assertEquals(listOf(0), cancelled.toList())
        }
    }

    @Test fun removalRequestedDuringSetupWaitsForCancellationCallback() {
        val present = mutableStateOf(true)
        val cancellations = AtomicInteger()
        rule.setContent {
            if (present.value) {
                Color.clear.task(id = 0, bridgedAction = { completion ->
                    present.value = false
                    completion.onCancel = { cancellations.incrementAndGet(); completion.run() }
                }).Compose(ComposeContext())
            }
        }
        rule.waitUntil(5_000) { !present.value }
        rule.runOnIdle { assertEquals(1, cancellations.get()) }
    }

    @Test fun completionBeforeCallbackInstallationDoesNotRestartTask() {
        val present = mutableStateOf(true)
        val revision = mutableStateOf(0)
        val starts = AtomicInteger()
        val handlers = CopyOnWriteArrayList<CompletionHandler>()
        rule.setContent {
            val currentRevision = revision.value
            if (present.value) {
                Color.clear.task(id = 0, bridgedAction = { completion ->
                    starts.incrementAndGet()
                    // Native work can finish before its Task handle is assigned to onCancel.
                    completion.run()
                    completion.onCancel = { check(currentRevision >= 0) }
                    handlers.add(completion)
                }).Compose(ComposeContext())
            }
        }
        rule.waitUntil(5_000) { handlers.size == 1 }
        rule.runOnIdle { revision.value++ }
        rule.runOnIdle { assertEquals(1, starts.get()); present.value = false }
        rule.runOnIdle { assertNull(handlers.single().onCancel) }
    }
}
