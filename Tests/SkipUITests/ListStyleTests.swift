// Copyright 2026 Skip
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.dp

/// Verifies row geometry for each list style and for `listRowInsets` and `listRowBackground`.
///
/// Rows render in a 240pt wide viewport at a density of 1, so pixels equal points.
final class ListStyleTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    private static let viewportWidth = 240

    // MARK: List styles

    func testPlainRowsSpanTheList() throws {
        install(ListStyleFixture(style: .plain))
        assertContent(left: 16, top: 8, right: 224)
    }

    func testAutomaticMatchesInsetGrouped() throws {
        install(ListStyleFixture(style: .automatic))
        assertContent(left: 32, top: 24, right: 208)
    }

    func testInsetGroupedRowsAreInset() throws {
        install(ListStyleFixture(style: .insetGrouped))
        assertContent(left: 32, top: 24, right: 208)
    }

    func testGroupedRowsSpanTheList() throws {
        install(ListStyleFixture(style: .grouped))
        assertContent(left: 16, top: 24, right: 224)
    }

    func testInsetRowsAreInset() throws {
        install(ListStyleFixture(style: .inset))
        assertContent(left: 32, top: 24, right: 208)
    }

    func testSidebarMatchesInsetGrouped() throws {
        install(ListStyleFixture(style: .sidebar))
        assertContent(left: 32, top: 24, right: 208)
    }

    // MARK: listRowInsets

    func testRowInsetsReplaceDefaultInsets() throws {
        install(ListStyleFixture(style: .plain, insets: EdgeInsets(top: 4.0, leading: 30.0, bottom: 6.0, trailing: 10.0)))
        assertContent(left: 30, top: 4, right: 230)
    }

    func testRowInsetsAddToStyleInsets() throws {
        install(ListStyleFixture(style: .insetGrouped, insets: EdgeInsets(top: 4.0, leading: 30.0, bottom: 6.0, trailing: 10.0)))
        assertContent(left: 46, top: 20, right: 214)
    }

    func testNilRowInsetsUseDefaultInsets() throws {
        install(ListStyleFixture(style: .plain, insets: nil, appliesInsets: true))
        assertContent(left: 16, top: 8, right: 224)
    }

    func testOutermostRowInsetsWin() throws {
        // Matches how listRowBackground and listRowSeparator combine
        install(ListStyleFixture(style: .plain, insets: EdgeInsets(top: 4.0, leading: 30.0, bottom: 6.0, trailing: 10.0), outerInsets: EdgeInsets(top: 20.0, leading: 50.0, bottom: 20.0, trailing: 50.0)))
        assertContent(left: 50, top: 20, right: 190)
    }

    // MARK: listRowBackground

    func testRowBackgroundFillsInsetsAndSeparator() throws {
        // 4 top inset + 40 content + 6 bottom inset + 1 separator
        install(ListStyleFixture(style: .plain, insets: EdgeInsets(top: 4.0, leading: 30.0, bottom: 6.0, trailing: 10.0), hasBackground: true))
        assertBounds(of: "row-background", left: 0, top: 0, right: Self.viewportWidth, height: 51)
    }

    func testRowBackgroundFollowsInsetStyle() throws {
        // A section's only row hides its separator: 8 + 40 + 8
        install(ListStyleFixture(style: .insetGrouped, hasBackground: true))
        assertBounds(of: "row-background", left: 16, top: 16, right: 224, height: 56)
    }

    func testZeroInsetsKeepMinimumRowHeight() throws {
        // 48 minimum row height + 1 separator
        install(ListStyleFixture(style: .plain, insets: EdgeInsets(), contentHeight: 10.0, hasBackground: true))
        assertBounds(of: "row-background", left: 0, top: 0, right: Self.viewportWidth, height: 49)
    }
}

private extension ListStyleTests {
    func install(_ fixture: ListStyleFixture) {
        composeRule.setContent {
            CompositionLocalProvider(LocalDensity.provides(Density(Float(1.0)))) {
                Box(modifier: Modifier.size(Self.viewportWidth.dp, 200.dp).testTag("viewport")) {
                    fixture.Compose()
                }
            }
        }
    }

    func assertContent(left: Int, top: Int, right: Int) {
        assertBounds(of: "row-content", left: left, top: top, right: right, height: 40)
    }

    func assertBounds(of tag: String, left: Int, top: Int, right: Int, height: Int) {
        let viewport = composeRule.onNodeWithTag("viewport").fetchSemanticsNode().boundsInRoot
        let bounds = composeRule.onNodeWithTag(tag).fetchSemanticsNode().boundsInRoot
        XCTAssertEqual(Int(bounds.left - viewport.left), left, "left of \(tag)")
        XCTAssertEqual(Int(bounds.top - viewport.top), top, "top of \(tag)")
        XCTAssertEqual(Int(bounds.right - viewport.left), right, "right of \(tag)")
        XCTAssertEqual(Int(bounds.height), height, "height of \(tag)")
    }
}

struct ListStyleFixture: View {
    let style: ListStyle
    var insets: EdgeInsets? = nil
    var appliesInsets = false
    var outerInsets: EdgeInsets? = nil
    var contentHeight = 40.0
    var hasBackground = false

    var body: some View {
        List {
            row
        }
        .listStyle(style)
    }

    private var row: some View {
        var content: any View = Color.white.frame(height: contentHeight).accessibilityIdentifier("row-content")
        if insets != nil || appliesInsets {
            content = content.listRowInsets(insets)
        }
        if let outerInsets {
            content = content.listRowInsets(outerInsets)
        }
        if hasBackground {
            content = content.listRowBackground(Color.red.accessibilityIdentifier("row-background"))
        }
        return content
    }
}
#endif
