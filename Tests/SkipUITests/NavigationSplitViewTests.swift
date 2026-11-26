// Copyright 2026 Skip
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.compose.ui.platform.WindowInfo
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp

final class NavigationSplitViewTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createComposeRule()

    func testCompactShowsSidebarThenPushesLinkedDetail() throws {
        install(widthDp: 400, heightDp: 800, LinkedSplitView(preferredCompactColumn: nil))
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithText("Placeholder").assertDoesNotExist()

        click("Sidebar Row")
        composeRule.onNodeWithText("Detail 7").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertDoesNotExist()

        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
    }

    func testExpandedShowsColumnsSideBySide() throws {
        install(widthDp: 1000, heightDp: 800, LinkedSplitView(preferredCompactColumn: nil))
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithText("Placeholder").assertIsDisplayed()

        click("Sidebar Row")
        composeRule.onNodeWithText("Detail 7").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithContentDescription("Back").assertDoesNotExist()
    }

    func testPreferredCompactColumnFollowsNavigation() throws {
        let column = mutableStateOf(NavigationSplitViewColumn.detail)
        let binding = Binding(get: { column.value }, set: { column.value = $0 })
        install(widthDp: 400, heightDp: 800, LinkedSplitView(preferredCompactColumn: binding))
        composeRule.onNodeWithText("Placeholder").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertDoesNotExist()

        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        XCTAssertEqual(column.value, NavigationSplitViewColumn.sidebar)

        composeRule.runOnIdle { column.value = NavigationSplitViewColumn.detail }
        composeRule.onNodeWithText("Placeholder").assertIsDisplayed()
        composeRule.onNodeWithText("Sidebar Row").assertDoesNotExist()
    }

    func testColumnWithOwnStackPushesWithinTheColumn() throws {
        install(widthDp: 400, heightDp: 800, StackedSplitView())
        click("Sidebar Row")
        composeRule.onNodeWithText("Pushed 7").assertIsDisplayed()
        composeRule.onNodeWithText("Placeholder").assertDoesNotExist()
    }

    func testThreeColumnsDrillDownWhenCompact() throws {
        install(widthDp: 400, heightDp: 800, ThreeColumnSplitView())
        click("Sidebar Row")
        composeRule.onNodeWithText("Content 7").assertIsDisplayed()
        click("Content 7")
        composeRule.onNodeWithText("Detail 70").assertIsDisplayed()

        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Content 7").assertIsDisplayed()
        composeRule.onNodeWithContentDescription("Back").performClick()
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
    }

    func testExpandedShowsTwoOfThreeColumns() throws {
        install(widthDp: 1000, heightDp: 800, ThreeColumnSplitView())
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithText("No Content").assertIsDisplayed()
        composeRule.onNodeWithText("No Detail").assertDoesNotExist()
    }

    func testLargeShowsAllThreeColumns() throws {
        install(widthDp: 1300, heightDp: 900, ThreeColumnSplitView())
        composeRule.onNodeWithText("Sidebar Row").assertIsDisplayed()
        composeRule.onNodeWithText("No Content").assertIsDisplayed()
        composeRule.onNodeWithText("No Detail").assertIsDisplayed()
    }

    /// Render in a window of the given size; the split view sizes its columns from the window info.
    private func install(widthDp: Int, heightDp: Int, _ view: any View) {
        composeRule.setContent {
            let windowInfo = FixedWindowInfo(containerSize: IntSize(widthDp * 2, heightDp * 2))
            CompositionLocalProvider(LocalDensity.provides(Density(Float(2.0))), LocalWindowInfo.provides(windowInfo)) {
                Box(modifier: Modifier.size(widthDp.dp, heightDp.dp)) {
                    view.Compose()
                }
            }
        }
    }

    /// Click after NavigationLink's double-tap throttle has passed.
    private func click(_ text: String) {
        Thread.sleep(forTimeInterval: 0.4)
        composeRule.onNodeWithText(text).performClick()
    }
}

// SKIP INSERT: private class FixedWindowInfo(override val containerSize: IntSize) : WindowInfo { override val isWindowFocused: Boolean = true }

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
