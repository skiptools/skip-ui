// Copyright 2026 Skip
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick

final class NavigationSplitViewTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    // SKIP INSERT: @org.robolectric.annotation.Config(qualifiers = "w400dp-h800dp")
    func testCompactShowsSidebarThenPushesLinkedDetail() throws {
        try requireRobolectric()
        composeRule.setContent { LinkedSplitView(preferredCompactColumn: nil).Compose() }
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithText("Placeholder").assertDoesNotExist()

        click("Sidebar Row")
        composeRule.onNodeWithText("Detail 7").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertDoesNotExist()

        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
    }

    // SKIP INSERT: @org.robolectric.annotation.Config(qualifiers = "w1000dp-h800dp")
    func testExpandedShowsColumnsSideBySide() throws {
        try requireRobolectric()
        composeRule.setContent { LinkedSplitView(preferredCompactColumn: nil).Compose() }
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithText("Placeholder").assertIsDisplayed()

        click("Sidebar Row")
        composeRule.onNodeWithText("Detail 7").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithContentDescription("Back").assertDoesNotExist()
    }

    // SKIP INSERT: @org.robolectric.annotation.Config(qualifiers = "w400dp-h800dp")
    func testPreferredCompactColumnFollowsNavigation() throws {
        try requireRobolectric()
        let column = mutableStateOf(NavigationSplitViewColumn.detail)
        let binding = Binding(get: { column.value }, set: { column.value = $0 })
        composeRule.setContent { LinkedSplitView(preferredCompactColumn: binding).Compose() }
        composeRule.onNodeWithText("Placeholder").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertDoesNotExist()

        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        XCTAssertEqual(column.value, NavigationSplitViewColumn.sidebar)

        composeRule.runOnIdle { column.value = NavigationSplitViewColumn.detail }
        composeRule.onNodeWithText("Placeholder").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertDoesNotExist()
    }

    // SKIP INSERT: @org.robolectric.annotation.Config(qualifiers = "w400dp-h800dp")
    func testColumnWithOwnStackPushesWithinTheColumn() throws {
        try requireRobolectric()
        composeRule.setContent { StackedSplitView().Compose() }
        click("Sidebar Row")
        composeRule.onNodeWithText("Pushed 7").assertIsDisplayed()
        composeRule.onNodeWithText("Placeholder").assertDoesNotExist()
    }

    // SKIP INSERT: @org.robolectric.annotation.Config(qualifiers = "w400dp-h800dp")
    func testThreeColumnsDrillDownWhenCompact() throws {
        try requireRobolectric()
        composeRule.setContent { ThreeColumnSplitView().Compose() }
        click("Sidebar Row")
        composeRule.onNodeWithText("Content 7").assertIsDisplayed()
        click("Content 7")
        composeRule.onNodeWithText("Detail 70").assertIsDisplayed()

        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Content 7").assertIsDisplayed()
        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
    }

    /// Window size classes come from Robolectric qualifiers.
    private func requireRobolectric() throws {
        if !android.os.Build.FINGERPRINT.contains("robolectric") {
            throw XCTSkip("Window size qualifiers require Robolectric")
        }
    }

    /// Click after NavigationLink's double-tap throttle has passed.
    private func click(_ text: String) {
        Thread.sleep(forTimeInterval: 0.4)
        composeRule.onNodeWithText(text).performClick()
    }
}

private struct LinkedSplitView: View {
    let preferredCompactColumn: Binding<NavigationSplitViewColumn>?

    var body: some View {
        NavigationSplitView(preferredCompactColumn: preferredCompactColumn) {
            List {
                NavigationLink("Sidebar Row", value: 7)
            }
            .navigationDestination(for: Int.self) { Text("Detail \($0)") }
        } detail: {
            Text("Placeholder")
        }
    }
}

private struct StackedSplitView: View {
    var body: some View {
        NavigationSplitView {
            NavigationStack {
                List {
                    NavigationLink("Sidebar Row", value: 7)
                }
                .navigationDestination(for: Int.self) { Text("Pushed \($0)") }
            }
        } detail: {
            NavigationStack {
                Text("Placeholder")
            }
        }
    }
}

private struct ThreeColumnSplitView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Sidebar Row", value: 7)
            }
            .navigationDestination(for: Int.self) { value in
                List {
                    NavigationLink("Content \(value)", value: "\(value * 10)")
                }
                .navigationDestination(for: String.self) { Text("Detail \($0)") }
            }
        } content: {
            Text("No Content")
        } detail: {
            Text("No Detail")
        }
    }
}
#endif
