// Copyright 2026 Skip
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.imeAnimationTarget
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import org.junit.Assert.assertSame
import org.junit.Test

/** Keyboard insets follow the animation by default and its target when animation is disabled. */
@OptIn(ExperimentalLayoutApi::class)
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class KeyboardInsetsAnimationTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @Test fun animatedInsetsByDefault() {
        var source: WindowInsets? = null
        var expected: WindowInsets? = null
        rule.setContent {
            source = (windowKeyboardInsets() as WindowKeyboardInsets).source
            expected = WindowInsets.ime
        }
        rule.runOnIdle { assertSame(expected, source) }
    }

    @Test fun targetInsetsWhenAnimationDisabled() {
        var source: WindowInsets? = null
        var expected: WindowInsets? = null
        rule.setContent {
            CompositionLocalProvider(LocalAnimatesKeyboardInsets provides false) {
                source = (windowKeyboardInsets() as WindowKeyboardInsets).source
                expected = WindowInsets.imeAnimationTarget
            }
        }
        rule.runOnIdle { assertSame(expected, source) }
    }
}
