// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import Foundation
import androidx.compose.runtime.Composable
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.UrlAnnotation
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration

enum AttributedStringCompose {
    // SKIP INSERT: @OptIn(ExperimentalTextApi::class)
    @Composable static func toAnnotatedString(
        _ attrStr: AttributedString,
        baseStyle: androidx.compose.ui.text.TextStyle,
        baseColor: androidx.compose.ui.graphics.Color?,
        linkColor: androidx.compose.ui.graphics.Color,
        textDecoration: TextDecoration?,
        isUppercased: Bool,
        isLowercased: Bool,
        isRedacted: Bool
    ) -> AnnotatedString {
        if attrStr.characters.isEmpty {
            return AnnotatedString("")
        }
        return buildAnnotatedString {
            for run in attrStr.runs {
                var text = attrStr.substring(in: run.utf16Range)
                if isUppercased {
                    text = text.uppercased()
                } else if isLowercased {
                    text = text.lowercased()
                }
                let spanStyle = composeSpanStyle(
                    run: run,
                    baseStyle: baseStyle,
                    baseColor: baseColor,
                    linkColor: linkColor,
                    textDecoration: textDecoration,
                    isRedacted: isRedacted
                )
                let link = run.attributes.link
                if let url = link {
                    if isRedacted {
                        pushStyle(spanStyle.copy(background: linkColor))
                    } else {
                        pushStyle(spanStyle)
                    }
                    pushUrlAnnotation(UrlAnnotation(url.absoluteString))
                    append(text)
                    pop()
                    pop()
                } else {
                    pushStyle(spanStyle)
                    append(text)
                    pop()
                }
            }
        }
    }

    @Composable private static func composeSpanStyle(
        run: AttributedString.Run,
        baseStyle: androidx.compose.ui.text.TextStyle,
        baseColor: androidx.compose.ui.graphics.Color?,
        linkColor: androidx.compose.ui.graphics.Color,
        textDecoration: TextDecoration?,
        isRedacted: Bool
    ) -> SpanStyle {
        var style = baseStyle
        if let font = run.attributes.font {
            style = style.merge(font.asComposeTextStyle())
        }
        var spanStyle = style.toSpanStyle()
        if let color = run.attributes.foregroundColor?.colorImpl() {
            spanStyle = spanStyle.copy(color: color)
        } else if let baseColor, baseColor != androidx.compose.ui.graphics.Color.Unspecified {
            spanStyle = spanStyle.copy(color: baseColor)
        }
        if let background = run.attributes.backgroundColor?.colorImpl() {
            spanStyle = spanStyle.copy(background: background)
        }
        var decorations: TextDecoration? = textDecoration
        if run.attributes.markdownBold {
            spanStyle = spanStyle.copy(fontWeight: FontWeight.Bold)
        }
        if run.attributes.markdownItalic {
            spanStyle = spanStyle.copy(fontStyle: FontStyle.Italic)
        }
        if run.attributes.markdownCode {
            spanStyle = spanStyle.copy(fontFamily: FontFamily.Monospace)
        }
        if run.attributes.markdownStrikethrough {
            decorations = combineDecoration(decorations, TextDecoration.LineThrough)
        }
        if run.attributes.underlineStyle != nil {
            decorations = combineDecoration(decorations, TextDecoration.Underline)
        }
        if run.attributes.strikethroughStyle != nil {
            decorations = combineDecoration(decorations, TextDecoration.LineThrough)
        }
        if let decorations {
            spanStyle = spanStyle.copy(textDecoration: decorations)
        }
        if run.attributes.link != nil && !isRedacted {
            spanStyle = spanStyle.copy(color: linkColor)
        }
        return spanStyle
    }

    private static func combineDecoration(_ existing: TextDecoration?, _ addition: TextDecoration) -> TextDecoration {
        if let existing {
            return existing + addition
        }
        return addition
    }
}

#endif
