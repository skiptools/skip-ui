// Copyright 2026 Skip
package skip.ui

import androidx.activity.ComponentActivity
import androidx.compose.material3.MaterialTheme
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.sp
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import org.junit.Assert.*
import org.junit.Test

/** Checks the actual AnnotatedString passed to Material, after Swift range edits. */
@org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
class EditableAttributedTextRenderingTests {
    @get:org.junit.Rule val rule = createAndroidComposeRule<ComponentActivity>()

    @OptIn(ExperimentalTextApi::class)
    @Test fun editedSwiftRangesReachMaterialText() {
        var rendered: AnnotatedString? = null
        rule.setContent {
            MaterialTheme {
                EnvironmentValues.shared.setValues({ environment ->
                    environment.set_material3Text { options ->
                        rendered = options.annotatedText
                        options
                    }
                    ComposeResult.ok
                }, {
                    editableAttributedTextFixture().Compose(ComposeContext())
                })
            }
        }
        rule.runOnIdle {
            val text = requireNotNull(rendered)
            val styledText = "👩🏽‍💻 cafe\u0301"
            assertEquals("A $styledText Z", text.text)
            val span = text.spanStyles.single { it.start == 2 && it.end == 2 + styledText.length }
            assertEquals(24.sp, span.item.fontSize)
            assertEquals(TextDecoration.Underline, span.item.textDecoration)
            assertTrue(span.item.color.red > span.item.color.green)
            assertTrue(requireNotNull(span.item.baselineShift).multiplier > 0f)
            val link = text.getUrlAnnotations(span.start, span.end).single()
            assertEquals("https://example.com", link.item.url)
            assertEquals(span.start, link.start)
            assertEquals(span.end, link.end)
        }
    }
}
