// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
@testable import SkipUI

/// Issue #331: a localized string that contains both a literal percent and Markdown
/// must keep a single percent. The format pattern still doubles it for String.format.
final class LocalizedStringKeyPercentTests: XCTestCase {
    func testLiteralPercentStaysSingleInTheLocalizedPattern() {
        let key = LocalizedStringKey(stringLiteral: "Perfect! 100% **bold**")
        XCTAssertEqual(key.patternFormat, "Perfect! 100%% **bold**")
        XCTAssertEqual(key.localizedPattern, "Perfect! 100% **bold**")
    }

    func testLiteralPercentBesideAnInterpolationKeepsTheSpecifier() {
        var interpolation = LocalizedStringKey.StringInterpolation(literalCapacity: 0, interpolationCount: 1)
        interpolation.appendLiteral("Perfect! 100% ")
        interpolation.appendInterpolation("Ada")
        let key = LocalizedStringKey(stringInterpolation: interpolation)
        XCTAssertEqual(key.patternFormat, "Perfect! 100%% %@")
        XCTAssertEqual(key.localizedPattern, "Perfect! 100% %@")
    }

    func testPatternWithoutAPercentIsUnchanged() {
        let key = LocalizedStringKey(stringLiteral: "Hello")
        XCTAssertEqual(key.localizedPattern, "Hello")
        XCTAssertEqual(key.localizedPattern, key.patternFormat)
    }

    func testNoInterpolationDisplayKeepsOnePercent() {
        let key = LocalizedStringKey(stringLiteral: "Perfect! 100% **bold**")
        let literal = key.localizedPattern
        XCTAssertEqual(literal, "Perfect! 100% **bold**")
        XCTAssertEqual(key.noInterpolationDisplay(literal: literal, kotlinFormat: literal), "Perfect! 100% **bold**")
        XCTAssertEqual(key.noInterpolationMarkdownSource(literal: literal, kotlinFormat: literal), "Perfect! 100% **bold**")
    }

    func testNoInterpolationDisplayKeepsTwoPercents() {
        let key = LocalizedStringKey(stringLiteral: "100%% **bold**")
        XCTAssertEqual(key.patternFormat, "100%%%% **bold**")
        let literal = key.localizedPattern
        XCTAssertEqual(literal, "100%% **bold**")
        XCTAssertEqual(key.noInterpolationDisplay(literal: literal, kotlinFormat: literal), "100%% **bold**")
        XCTAssertEqual(key.noInterpolationMarkdownSource(literal: literal, kotlinFormat: literal), "100%% **bold**")
    }

    func testNoInterpolationDisplayKeepsObjCSpecifier() {
        let key = LocalizedStringKey(stringLiteral: "Use %@")
        let literal = key.localizedPattern
        XCTAssertEqual(key.patternFormat, "Use %%@")
        XCTAssertEqual(literal, "Use %@")
        let kotlinFormat = "Use %s"
        XCTAssertNotEqual(literal, kotlinFormat)
        let display = key.noInterpolationDisplay(literal: literal, kotlinFormat: kotlinFormat)
        XCTAssertEqual(display, "Use %@")
        XCTAssertNotEqual(display, kotlinFormat)
        XCTAssertNil(key.noInterpolationMarkdownSource(literal: literal, kotlinFormat: kotlinFormat))
    }
}
