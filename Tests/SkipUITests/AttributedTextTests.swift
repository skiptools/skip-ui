// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if SKIP
@testable import SkipUI
#endif

final class AttributedTextTests: XCTestCase {
    #if SKIP
    func testNestedMarkdownLinks() {
        let runs = AttributedTextRun.markdownRuns("Read [**important** *instructions*](https://example.com)")
        XCTAssertEqual(runs.map { $0.text }.joined(), "Read important instructions")
        let bold = runs.first { $0.text == "important" }!
        XCTAssertTrue(bold.bold)
        XCTAssertEqual(bold.link, "https://example.com")
        let italic = runs.first { $0.text == "instructions" }!
        XCTAssertTrue(italic.italic)
        XCTAssertEqual(italic.link, "https://example.com")
        XCTAssertFalse(bold.underline)
    }

    func testCombinedInlineStyles() {
        let runs = AttributedTextRun.markdownRuns("***both*** `code` ~~gone~~")
        XCTAssertTrue(runs.first!.bold)
        XCTAssertTrue(runs.first!.italic)
        XCTAssertTrue(runs.first { $0.text == "code" }!.code)
        XCTAssertTrue(runs.first { $0.text == "gone" }!.strikethrough)
    }

    func testWhitespaceAndUnicode() {
        let runs = AttributedTextRun.markdownRuns("  **👩🏽‍💻 café**  \n\n\nnext  ")
        XCTAssertEqual(runs.map { $0.text }.joined(), "  👩🏽‍💻 café  \n\n\nnext  ")
    }

    func testInlineParsingPreservesWhitespaceWithinEmphasis() {
        let runs = AttributedTextRun.markdownRuns("**one\n\n  two**")
        XCTAssertEqual(runs.map { $0.text }.joined(), "one\n\n  two")
        XCTAssertTrue(runs.allSatisfy { $0.bold })
        XCTAssertEqual(AttributedTextRun.markdownRuns("`one\n two`").map { $0.text }.joined(), "one  two")
    }

    func testEscapesAndEntities() {
        XCTAssertEqual(AttributedTextRun.markdownRuns("\\*plain\\* &amp; **bold**").map { $0.text }.joined(), "*plain* & bold")
        XCTAssertEqual(AttributedTextRun.markdownRuns("a  \nb").map { $0.text }.joined(), "a  \nb")
    }

    func testLiteralPercentAndPlainText() {
        XCTAssertEqual(AttributedTextRun.markdownRuns("100% and **50%**").map { $0.text }.joined(), "100% and 50%")
        XCTAssertEqual(AttributedTextRun.markdownRuns("plain \n  text").map { $0.text }.joined(), "plain \n  text")
        XCTAssertEqual(AttributedTextRun.markdownRuns("").map { $0.text }.joined(), "")
    }

    func testInlineHTMLIsPreservedAsLiteralText() {
        XCTAssertEqual(AttributedTextRun.markdownRuns("a <b>bold</b> z").map { $0.text }.joined(), "a <b>bold</b> z")
        let runs = AttributedTextRun.markdownRuns("**<kbd>Enter</kbd>**")
        XCTAssertEqual(runs.map { $0.text }.joined(), "<kbd>Enter</kbd>")
        XCTAssertTrue(runs.allSatisfy { $0.bold })
    }

    func testNullCharactersDoNotTruncateText() {
        let runs = AttributedTextRun.markdownRuns("a\u{0000}**b**\u{0000}c")
        XCTAssertEqual(runs.map { $0.text }.joined(), "a\u{FFFD}b\u{FFFD}c")
        XCTAssertTrue(runs.first { $0.text == "b" }!.bold)
    }

    func testLineEndingsAreNormalizedWithoutLosingWhitespace() {
        let runs = AttributedTextRun.markdownRuns("👩🏽‍💻  \r\n**one\r\n  two**  \rnext  ")
        XCTAssertEqual(runs.map { $0.text }.joined(), "👩🏽‍💻  \none\n  two  \nnext  ")
        XCTAssertTrue(runs.first { $0.text == "one" }!.bold)
        XCTAssertEqual(AttributedTextRun.markdownRuns("`one\r\n two`").map { $0.text }.joined(), "one  two")
    }
    #endif
}
