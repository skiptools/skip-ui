// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
#if SKIP
@testable import SkipUI
#else
import SwiftUI
#endif
import XCTest

/// Exercise the public SwiftUI spelling on Apple and through Skip Lite.
final class EditableAttributedTextTests: XCTestCase {
    func testRangeStylingAndCopyIndependence() {
        let original = AttributedString("Hello world")
        var text = original
        let range = text.range(of: "world")!
        text[range].foregroundColor = .orange
        text[range].font = .headline
        text[range].underlineStyle = .single
        text[range].strikethroughStyle = .single
        text[range].baselineOffset = 6
        XCTAssertEqual(text[range].foregroundColor, .orange)
        XCTAssertEqual(text[range].font, .headline)
        XCTAssertEqual(text[range].underlineStyle, .single)
        XCTAssertEqual(text[range].strikethroughStyle, .single)
        XCTAssertEqual(text[range].baselineOffset, 6)
        XCTAssertNil(original[range].foregroundColor)
        XCTAssertNil(text.foregroundColor)
        text[range].foregroundColor = nil
        XCTAssertNil(text[range].foregroundColor)
        XCTAssertEqual(text[range].font, .headline)
    }

    func testAttributeContainerAndRunAccess() {
        var attributes = AttributeContainer()
        attributes.font = .caption
        attributes.foregroundColor = .purple
        attributes.baselineOffset = -4
        let text = AttributedString("H2O", attributes: attributes)
        XCTAssertEqual(text.runs.first!.font, .caption)
        XCTAssertEqual(text.runs.first!.foregroundColor, .purple)
        XCTAssertEqual(text.runs.first!.baselineOffset, -4)
    }

    #if SKIP
    func testEditedMarkdownProducesCurrentRenderRuns() throws {
        var text = try AttributedString(markdown: "**bold** [*link*](https://example.com)")
        let range = text.range(of: "link")!
        text[range].foregroundColor = .orange
        text[range].baselineOffset = 4
        text[range].link = URL(string: "https://swift.org")
        let runs: [AttributedTextRun] = AttributedTextRun.runs(from: text)
        let link = runs.first { $0.text == "link" }!
        XCTAssertEqual(link.color, Color.orange)
        XCTAssertEqual(link.baselineOffset, 4.0)
        XCTAssertEqual(link.link, "https://swift.org")
        XCTAssertTrue(link.italic)
        XCTAssertTrue(runs.first!.bold)
    }
    #endif
}

/// Transpiled fixture consumed by the Compose regression test, so range writes
/// are tested from Swift source all the way to Material's rendered text.
func editableAttributedTextFixture() -> Text {
    var value = AttributedString("A 👩🏽‍💻 cafe\u{0301} Z")
    let range = value.range(of: "👩🏽‍💻 cafe\u{0301}")!
    value[range].foregroundColor = .red
    value[range].font = .system(size: 24)
    value[range].underlineStyle = .single
    value[range].baselineOffset = 4
    value[range].link = URL(string: "https://example.com")
    return Text(value)
}
