// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import android.os.Looper
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.nestedscroll.NestedScrollSource
import androidx.compose.ui.unit.Velocity
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Test

/** Exercise the generated suspend override that delivers pull-down completion to native clients. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class AndroidVerticalOverscrollPullDownTests {
    @Test fun flingCompletesPullOnMainThreadOnce() = runBlocking {
        withContext(Dispatchers.Main.immediate) {
            var completionCount = 0
            var completionLooper: Looper? = null
            val connection = AndroidVerticalOverscrollPullDownConnection(
                isEnabled = { true },
                onPullPx = {},
                onEnd = {
                    completionCount += 1
                    completionLooper = Looper.myLooper()
                }
            )

            // A fling without an outstanding pull must not notify the client.
            val velocity = Velocity(25f, 120f)
            assertEquals(Velocity.Zero, connection.onPostFling(Velocity.Zero, velocity))
            assertEquals(0, completionCount)

            connection.onPostScroll(Offset.Zero, Offset(0f, 40f), NestedScrollSource.UserInput)
            assertEquals(Velocity(0f, 120f), connection.onPostFling(Velocity.Zero, velocity))
            assertEquals(1, completionCount)
            assertSame("Pull completion must stay on the Android main thread", Looper.getMainLooper(), completionLooper)

            // Completion consumes the pull, so a second fling must not deliver it again.
            assertEquals(Velocity.Zero, connection.onPostFling(Velocity.Zero, velocity))
            assertEquals(1, completionCount)
        }
    }
}
