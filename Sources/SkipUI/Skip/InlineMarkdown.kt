// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
package skip.ui

import org.commonmark.ext.gfm.strikethrough.Strikethrough
import org.commonmark.ext.gfm.strikethrough.StrikethroughExtension
import org.commonmark.node.*
import org.commonmark.node.Text as MarkdownText
import org.commonmark.node.Link as MarkdownLink
import org.commonmark.parser.*
import org.commonmark.parser.block.*

/**
 * Uses the same CommonMark engine and strikethrough extension as SkipFoundation.
 * An inline-only input must bypass paragraph splitting and whitespace trimming.
 * The public block extension supplies normalized input to CommonMark's inline
 * parser as one source line, including its embedded newlines and source positions.
 */
internal object InlineMarkdown {
    fun runs(source: String): skip.lib.Array<AttributedTextRun> {
        // Direct inline parsing bypasses CommonMark's input normalization. Keep
        // parsing and source-span lookups on the same normalized string.
        val normalizedSource = source.replace('\u0000', '\uFFFD')
            .replace("\r\n", "\n")
            .replace('\r', '\n')
        val parser = Parser.builder()
            .enabledBlockTypes(emptySet())
            .extensions(listOf(StrikethroughExtension.create()))
            .customBlockParserFactory { _, _ ->
                BlockStart.of(InputBlock(normalizedSource)).atIndex(0)
            }
            .build()
        // A punctuation character invokes the custom block factory. The block's
        // parseInlines method replaces this trigger with the actual source.
        val document = parser.parse("#")
        val result = mutableListOf<AttributedTextRun>()
        append(document, normalizedSource, result)
        return skip.lib.Array(result)
    }

    private class InputBlock(private val source: String) : AbstractBlockParser() {
        private val paragraph = Paragraph()
        override fun getBlock(): Block = paragraph
        override fun tryContinue(state: ParserState): BlockContinue = BlockContinue.none()
        override fun parseInlines(parser: InlineParser) {
            parser.parse(SourceLines.of(SourceLine.of(source, SourceSpan.of(0, 0, 0, source.length))), paragraph)
        }
    }

    private fun append(
        node: Node, source: String, result: MutableList<AttributedTextRun>,
        bold: Boolean = false, italic: Boolean = false, code: Boolean = false,
        strike: Boolean = false, link: String? = null
    ) {
        val nextBold = bold || node is StrongEmphasis
        val nextItalic = italic || node is Emphasis
        val nextCode = code || node is Code
        val nextStrike = strike || node is Strikethrough
        val nextLink = (node as? MarkdownLink)?.destination ?: link
        val text = when (node) {
            is MarkdownText -> {
                // CommonMark trims spaces before a newline and at end of input.
                // Its source span retains them, even for decoded entities/escapes.
                val lastSpan = node.sourceSpans.lastOrNull()
                val raw = lastSpan?.let { source.substring(it.inputIndex, it.inputIndex + it.length) }.orEmpty()
                val sourceSpaces = raw.takeLastWhile { it == ' ' || it == '\t' }
                val keptSpaces = node.literal.takeLastWhile { it == ' ' || it == '\t' }
                node.literal + sourceSpaces.drop(keptSpaces.length)
            }
            is Code -> node.literal
            is HtmlInline -> node.literal
            is SoftLineBreak, is HardLineBreak -> "\n"
            else -> null
        }
        if (text != null) {
            if (text.isNotEmpty()) {
                result.add(AttributedTextRun(text, nextBold, nextItalic, nextCode, nextStrike, false, nextLink))
            }
        } else {
            var child = node.firstChild
            while (child != null) {
                append(child, source, result, nextBold, nextItalic, nextCode, nextStrike, nextLink)
                child = child.next
            }
        }
    }
}
