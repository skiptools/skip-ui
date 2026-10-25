// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.dp

final class ListSeparatorAlignmentTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    func testDefaultInsetsAreUnchanged() throws {
        try install()
        assertSeparator(start: 16, endInset: 0)
    }

    func testLeadingAndTrailingGuidesUseMeasuredDimensions() throws {
        try install(leading: { $0[.leading] + 24.0 }, trailing: { $0[.trailing] - 20.0 })
        assertSeparator(start: 40, endInset: 36)
    }

    func testNestedLabelGuideIncludesIconAndSpacing() throws {
        try install(nested: true, leading: { $0[.leading] })
        assertSeparator(start: 60, endInset: 0)
    }

    func testPaddingOutsideGuideMovesSeparator() throws {
        try install(leading: { $0[.leading] }, innerPadding: 10.0)
        assertSeparator(start: 26, endInset: 0)
    }

    func testRtlMirrorsBothGuides() throws {
        try install(rtl: true, leading: { $0[.leading] + 24.0 }, trailing: { $0[.trailing] - 20.0 })
        assertSeparator(start: 40, endInset: 36, rtl: true)
    }

    func testGuideChangesUpdateWithoutChangingRowSize() throws {
        let offset = mutableStateOf(24.0)
        try install(leading: { $0[.leading] + offset.value })
        assertSeparator(start: 40, endInset: 0)

        composeRule.runOnIdle { offset.value = 48.0 }

        assertSeparator(start: 64, endInset: 0)
    }
}

private extension ListSeparatorAlignmentTests {
    /// Renders real list rows at a fixed density for pixel assertions.
    func install(rtl: Bool = false, nested: Bool = false, leading: ((ViewDimensions) -> CGFloat)? = nil, trailing: ((ViewDimensions) -> CGFloat)? = nil, innerPadding: CGFloat = 0.0) throws {
        if android.os.Build.FINGERPRINT.contains("robolectric") {
            throw XCTSkip("Separator pixel assertions require a device compositor")
        }
        let fixture = SeparatorRows(nested: nested, leading: leading, trailing: trailing, innerPadding: innerPadding)
        composeRule.setContent {
            CompositionLocalProvider(LocalDensity.provides(Density(Float(2.0))), LocalLayoutDirection.provides(rtl ? androidx.compose.ui.unit.LayoutDirection.Rtl : androidx.compose.ui.unit.LayoutDirection.Ltr)) {
                Box(modifier: Modifier.size(240.dp, 180.dp).testTag("viewport")) {
                    fixture.environment(\.layoutDirection, rtl ? LayoutDirection.rightToLeft : LayoutDirection.leftToRight).Compose()
                }
            }
        }
    }

    /// Checks the actual separator pixels rather than duplicating its inset calculation.
    func assertSeparator(start: Int, endInset: Int, rtl: Bool = false) {
        let bounds = composeRule.onNodeWithTag("row-content").fetchSemanticsNode().boundsInRoot
        let viewport = composeRule.onNodeWithTag("viewport").fetchSemanticsNode().boundsInRoot
        let bitmap = composeRule.onNodeWithTag("viewport").captureToImage().asAndroidBitmap()
        let yStart = Int(bounds.bottom - viewport.top)
        let left = rtl ? endInset * 2 : start * 2
        let right = rtl ? bitmap.width - start * 2 : bitmap.width - endInset * 2
        var separatorY: Int? = nil
        for y in yStart..<min(bitmap.height, yStart + 24) {
            if bitmap.getPixel((left + right) / 2, y) != android.graphics.Color.WHITE {
                separatorY = y
                break
            }
        }
        XCTAssertNotNil(separatorY, "Divider should be drawn below the row content")
        if let y = separatorY {
            XCTAssertNotEqual(bitmap.getPixel(left + 1, y), android.graphics.Color.WHITE)
            XCTAssertNotEqual(bitmap.getPixel(right - 2, y), android.graphics.Color.WHITE)
            if left > 1 {
                XCTAssertEqual(bitmap.getPixel(left - 2, y), android.graphics.Color.WHITE)
            }
            if right < bitmap.width - 1 {
                XCTAssertEqual(bitmap.getPixel(right + 1, y), android.graphics.Color.WHITE)
            }
        }
        bitmap.recycle()
    }
}

private struct SeparatorRows: View {
    let nested: Bool
    let leading: ((ViewDimensions) -> CGFloat)?
    let trailing: ((ViewDimensions) -> CGFloat)?
    let innerPadding: CGFloat

    var body: some View {
        List {
            row.listRowBackground(Color.white)
            Color.white.frame(height: 40.0).listRowBackground(Color.white)
        }
        .listStyle(.plain)
    }

    @ViewBuilder private var row: some View {
        if nested {
            HStack(spacing: 12.0) {
                Color.white.frame(width: 32.0, height: 32.0)
                label
            }
        } else {
            label
        }
    }

    private var label: some View {
        var content: any View = Color.white.frame(height: 40.0).accessibilityIdentifier("row-content")
        if let leading {
            content = content.alignmentGuide(.listRowSeparatorLeading, computeValue: leading)
        }
        if let trailing {
            content = content.alignmentGuide(.listRowSeparatorTrailing, computeValue: trailing)
        }
        return content.padding(.leading, innerPadding)
    }
}
#endif
