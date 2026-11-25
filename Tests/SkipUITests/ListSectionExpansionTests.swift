// Copyright 2026 Skip
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick

/// Verifies collapsible `.sidebar` sections and `Section(isExpanded:)`.
final class ListSectionExpansionTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    func testSidebarHeaderCollapsesAndExpandsSection() throws {
        composeRule.setContent { SectionExpansionFixture(style: .sidebar).Compose() }
        assertSectionExpanded(true)

        tapHeader()
        assertSectionExpanded(false)
        // A section without a header has nothing to tap, so it never collapses
        composeRule.onNodeWithTag("row-b").assertIsDisplayed()

        tapHeader()
        assertSectionExpanded(true)
    }

    func testInsetGroupedHeaderDoesNotCollapseSection() throws {
        composeRule.setContent { SectionExpansionFixture(style: .insetGrouped).Compose() }
        tapHeader()
        assertSectionExpanded(true)
    }

    func testIsExpandedBindingCollapsesSection() throws {
        composeRule.setContent { SectionExpansionFixture(style: .insetGrouped, usesBinding: true).Compose() }
        assertSectionExpanded(true, hasFooter: false)

        composeRule.onNodeWithText("Toggle").performClick()
        assertSectionExpanded(false, hasFooter: false)

        composeRule.onNodeWithText("Toggle").performClick()
        assertSectionExpanded(true, hasFooter: false)
    }

    func testSidebarHeaderTogglesIsExpandedBinding() throws {
        composeRule.setContent { SectionExpansionFixture(style: .sidebar, usesBinding: true).Compose() }
        tapHeader()
        composeRule.onNodeWithText("Collapsed").assertExists()
        assertSectionExpanded(false, hasFooter: false)

        tapHeader()
        composeRule.onNodeWithText("Expanded").assertExists()
        assertSectionExpanded(true, hasFooter: false)
    }

    // As on iOS, only sidebar headers show a chevron and toggle their section
    func testPlainHeaderDoesNotToggleIsExpandedBinding() throws {
        assertHeaderDoesNotToggleBinding(style: .plain)
    }

    func testInsetGroupedHeaderDoesNotToggleIsExpandedBinding() throws {
        assertHeaderDoesNotToggleBinding(style: .insetGrouped)
    }

    func testIsExpandedOutsideListHidesContent() throws {
        composeRule.setContent { SectionExpansionFixture(style: .automatic, usesBinding: true, isInList: false).Compose() }
        composeRule.onNodeWithTag("row-a1").assertExists()

        composeRule.onNodeWithText("Toggle").performClick()
        composeRule.onNodeWithTag("row-a1").assertDoesNotExist()
    }
}

private extension ListSectionExpansionTests {
    func assertHeaderDoesNotToggleBinding(style: ListStyle) {
        composeRule.setContent { SectionExpansionFixture(style: style, usesBinding: true).Compose() }
        tapHeader()
        composeRule.onNodeWithText("Expanded").assertExists()
        assertSectionExpanded(true, hasFooter: false)
    }

    func tapHeader() {
        composeRule.onNodeWithText("Header A", ignoreCase: true).performClick()
        composeRule.waitForIdle()
    }

    /// `Section(isExpanded:)` has no footer, so only the sidebar fixture checks one.
    func assertSectionExpanded(_ isExpanded: Bool, hasFooter: Bool = true) {
        composeRule.waitForIdle()
        for tag in ["row-a1", "row-a2"] {
            if isExpanded {
                composeRule.onNodeWithTag(tag).assertIsDisplayed()
            } else {
                composeRule.onNodeWithTag(tag).assertDoesNotExist()
            }
        }
        guard hasFooter else {
            return
        }
        if isExpanded {
            composeRule.onNodeWithText("Footer A", ignoreCase: true).assertExists()
        } else {
            composeRule.onNodeWithText("Footer A", ignoreCase: true).assertDoesNotExist()
        }
    }
}

/// A collapsible section followed by a section without a header.
///
/// With `usesBinding`, the first section uses `Section(isExpanded:)`, and the "Toggle" button changes the binding without animation.
struct SectionExpansionFixture: View {
    let style: ListStyle
    var usesBinding = false
    var isInList = true
    @State var isExpanded = true

    var body: some View {
        VStack {
            Text(isExpanded ? "Expanded" : "Collapsed")
            Button("Toggle") { isExpanded = !isExpanded }
            if isInList {
                List {
                    sectionA
                    Section {
                        Text("Row B").accessibilityIdentifier("row-b")
                    }
                }
                .listStyle(style)
            } else {
                sectionA
            }
        }
    }

    @ViewBuilder private var sectionA: some View {
        if usesBinding {
            Section(isExpanded: $isExpanded) {
                rowsA
            } header: {
                Text("Header A")
            }
        } else {
            Section {
                rowsA
            } header: {
                Text("Header A")
            } footer: {
                Text("Footer A")
            }
        }
    }

    @ViewBuilder private var rowsA: some View {
        Text("Row A1").accessibilityIdentifier("row-a1")
        Text("Row A2").accessibilityIdentifier("row-a2")
    }
}
#endif
