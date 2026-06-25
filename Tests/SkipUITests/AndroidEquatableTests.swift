// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

#if SKIP
import androidx.activity.ComponentActivity
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.performClick
#endif

final class AndroidEquatableTests: SkipUITestCase {
    // SKIP INSERT: @get:org.junit.Rule val composeRule = createAndroidComposeRule<ComponentActivity>()

    func testUnchangedOverrideSkipsChildBodyWhenParentRecomposes() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let parentTick = State(initialValue: 0)
        let childText = State(initialValue: "A")
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableOverrideHost(
                parentTick: parentTick,
                childText: childText,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-child").assertTextEquals("A")
        XCTAssertEqual(counter.value("android-equatable-child"), 1)

        parentTick.wrappedValue = 1
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-parent").assertTextEquals("tick 1")
        composeRule.onNodeWithTag("android-equatable-child").assertTextEquals("A")
        XCTAssertEqual(counter.value("android-equatable-child"), 1)
        #endif
    }

    func testChangedOverrideRecomposesChildBodyAndUpdatesOutput() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let parentTick = State(initialValue: 0)
        let childText = State(initialValue: "A")
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableOverrideHost(
                parentTick: parentTick,
                childText: childText,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        XCTAssertEqual(counter.value("android-equatable-child"), 1)

        childText.wrappedValue = "B"
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-child").assertTextEquals("B")
        XCTAssertEqual(counter.value("android-equatable-child"), 2)
        #endif
    }

    func testEquatableConvenienceSkipsUnchangedValueAndUpdatesChangedValue() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let parentTick = State(initialValue: 0)
        let childText = State(initialValue: "A")
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableConvenienceHost(
                parentTick: parentTick,
                childText: childText,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-convenience-child").assertTextEquals("A")
        XCTAssertEqual(counter.value("android-equatable-convenience-child"), 1)

        parentTick.wrappedValue = 1
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-convenience-parent").assertTextEquals("tick 1")
        XCTAssertEqual(counter.value("android-equatable-convenience-child"), 1)

        childText.wrappedValue = "B"
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-convenience-child").assertTextEquals("B")
        XCTAssertEqual(counter.value("android-equatable-convenience-child"), 2)
        #endif
    }

    func testForEachRowsKeepStableBodiesAcrossParentAndCollectionChanges() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let parentTick = State(initialValue: 0)
        let items = State(initialValue: [
            AndroidEquatableItem(id: 1, title: "One"),
            AndroidEquatableItem(id: 2, title: "Two"),
            AndroidEquatableItem(id: 3, title: "Three"),
        ])
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableForEachHost(
                parentTick: parentTick,
                items: items,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-row-1").assertTextEquals("One")
        composeRule.onNodeWithTag("android-equatable-row-2").assertTextEquals("Two")
        composeRule.onNodeWithTag("android-equatable-row-3").assertTextEquals("Three")
        let row1InitialCount = counter.value("android-equatable-row-1")
        let row2InitialCount = counter.value("android-equatable-row-2")
        let row3InitialCount = counter.value("android-equatable-row-3")
        XCTAssertGreaterThan(row1InitialCount, 0)
        XCTAssertGreaterThan(row2InitialCount, 0)
        XCTAssertGreaterThan(row3InitialCount, 0)

        parentTick.wrappedValue = 1
        composeRule.waitForIdle()

        XCTAssertEqual(counter.value("android-equatable-row-1"), row1InitialCount)
        XCTAssertEqual(counter.value("android-equatable-row-2"), row2InitialCount)
        XCTAssertEqual(counter.value("android-equatable-row-3"), row3InitialCount)

        items.wrappedValue = [
            AndroidEquatableItem(id: 0, title: "Zero"),
            AndroidEquatableItem(id: 1, title: "One"),
            AndroidEquatableItem(id: 3, title: "Three"),
        ]
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-row-0").assertTextEquals("Zero")
        composeRule.onNodeWithTag("android-equatable-row-1").assertTextEquals("One")
        composeRule.onNodeWithTag("android-equatable-row-3").assertTextEquals("Three")
        XCTAssertGreaterThan(counter.value("android-equatable-row-0"), 0)
        XCTAssertGreaterThan(counter.value("android-equatable-row-1"), 0)
        XCTAssertGreaterThan(counter.value("android-equatable-row-3"), 0)

        items.wrappedValue = [
            AndroidEquatableItem(id: 3, title: "Three"),
            AndroidEquatableItem(id: 0, title: "Zero"),
            AndroidEquatableItem(id: 1, title: "One"),
        ]
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-row-3").assertTextEquals("Three")
        composeRule.onNodeWithTag("android-equatable-row-0").assertTextEquals("Zero")
        composeRule.onNodeWithTag("android-equatable-row-1").assertTextEquals("One")
        XCTAssertGreaterThan(counter.value("android-equatable-row-0"), 0)
        XCTAssertGreaterThan(counter.value("android-equatable-row-1"), 0)
        XCTAssertGreaterThan(counter.value("android-equatable-row-3"), 0)
        #endif
    }

    func testLazyStackRowsRemainVisibleAndSkipParentOnlyChanges() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let parentTick = State(initialValue: 0)
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableLazyHost(parentTick: parentTick, counter: counter)
                .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-lazy-row-0").assertIsDisplayed()
        composeRule.onNodeWithTag("android-equatable-lazy-row-1").assertIsDisplayed()
        let row0InitialCount = counter.value("android-equatable-lazy-row-0")
        let row1InitialCount = counter.value("android-equatable-lazy-row-1")
        XCTAssertGreaterThan(row0InitialCount, 0)
        XCTAssertGreaterThan(row1InitialCount, 0)

        parentTick.wrappedValue = 1
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-lazy-row-0").assertIsDisplayed()
        composeRule.onNodeWithTag("android-equatable-lazy-row-1").assertIsDisplayed()
        XCTAssertEqual(counter.value("android-equatable-lazy-row-0"), row0InitialCount)
        XCTAssertEqual(counter.value("android-equatable-lazy-row-1"), row1InitialCount)
        #endif
    }

    func testEnvironmentChangeUpdatesChildInsideBoundary() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let environmentValue = State(initialValue: "outer")
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableEnvironmentHost(
                environmentValue: environmentValue,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-environment-child").assertTextEquals("outer")

        environmentValue.wrappedValue = "inner"
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-environment-child").assertTextEquals("inner")
        XCTAssertEqual(counter.value("android-equatable-environment-child"), 2)
        #endif
    }

    func testBodyDrivenChildStateIsNotImplicitInvalidationInput() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let parentTick = State(initialValue: 0)
        let stateOverride = State(initialValue: 0)
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableStatefulHost(
                parentTick: parentTick,
                stateOverride: stateOverride,
                counter: counter
            )
                .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-stateful-child").assertTextEquals("count 0")
        XCTAssertEqual(counter.value("android-equatable-stateful-child"), 1)

        composeRule.onNodeWithTag("android-equatable-stateful-child").performClick()
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-stateful-child").assertTextEquals("count 0")
        XCTAssertEqual(counter.value("android-equatable-stateful-child"), 1)

        stateOverride.wrappedValue = 1
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-stateful-child").assertTextEquals("count 0")
        XCTAssertEqual(counter.value("android-equatable-stateful-child"), 2)

        parentTick.wrappedValue = 1
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-stateful-child").assertTextEquals("count 0")
        XCTAssertEqual(counter.value("android-equatable-stateful-child"), 2)
        #endif
    }

    func testHoistedStateUpdatesWhenIncludedInOverride() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let childCount = State(initialValue: 0)
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableHoistedStateHost(childCount: childCount, counter: counter)
                .Compose()
        }
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-hoisted-state-child").assertTextEquals("count 0")
        XCTAssertEqual(counter.value("android-equatable-hoisted-state-child"), 1)

        composeRule.onNodeWithTag("android-equatable-hoisted-state-child").performClick()
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-hoisted-state-child").assertTextEquals("count 1")
        XCTAssertEqual(counter.value("android-equatable-hoisted-state-child"), 2)
        #endif
    }

    func testActionOutsideBoundaryUsesLatestParentClosure() throws {
        #if !SKIP
        throw XCTSkip("androidEquatable is an Android-only optimization")
        #else
        let selectedValue = State(initialValue: 0)
        let parentValue = State(initialValue: 1)
        let counter = AndroidEquatableBodyCounter()

        composeRule.setContent {
            AndroidEquatableActionHost(
                parentValue: parentValue,
                selectedValue: selectedValue,
                counter: counter
            )
            .Compose()
        }
        composeRule.waitForIdle()

        XCTAssertEqual(counter.value("android-equatable-action-child"), 1)

        parentValue.wrappedValue = 2
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-action-child").performClick()
        composeRule.waitForIdle()

        composeRule.onNodeWithTag("android-equatable-selected-value").assertTextEquals("selected 2")
        XCTAssertEqual(selectedValue.wrappedValue, 2)
        XCTAssertEqual(counter.value("android-equatable-action-child"), 1)
        #endif
    }
}

#if SKIP
private final class AndroidEquatableBodyCounter {
    private var counts: [String: Int] = [:]

    @discardableResult
    func increment(_ key: String) -> Int {
        let value = (counts[key] ?? 0) + 1
        counts[key] = value
        return value
    }

    func value(_ key: String) -> Int {
        return counts[key] ?? 0
    }
}

private struct AndroidEquatableItem: Equatable {
    let id: Int
    let title: String
}

private struct AndroidEquatableCountingRow: View, Equatable {
    let id: String
    let text: String
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let _ = counter.increment(id)
        Text(text)
            .accessibilityIdentifier(id)
    }

    static func == (lhs: AndroidEquatableCountingRow, rhs: AndroidEquatableCountingRow) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text
    }
}

private struct AndroidEquatableOverrideHost: View {
    let parentTick: State<Int>
    let childText: State<String>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let text = childText.wrappedValue
        VStack {
            Text("tick \(parentTick.wrappedValue)")
                .accessibilityIdentifier("android-equatable-parent")
            AndroidEquatableCountingRow(id: "android-equatable-child", text: text, counter: counter)
                .androidEquatable(recomposeOverride: text)
        }
    }
}

private struct AndroidEquatableConvenienceHost: View {
    let parentTick: State<Int>
    let childText: State<String>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        VStack {
            Text("tick \(parentTick.wrappedValue)")
                .accessibilityIdentifier("android-equatable-convenience-parent")
            AndroidEquatableCountingRow(id: "android-equatable-convenience-child", text: childText.wrappedValue, counter: counter)
                .androidEquatable()
        }
    }
}

private struct AndroidEquatableForEachHost: View {
    let parentTick: State<Int>
    let items: State<[AndroidEquatableItem]>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        VStack {
            Text("tick \(parentTick.wrappedValue)")
                .accessibilityIdentifier("android-equatable-list-parent")
            ForEach(items.wrappedValue, id: { $0.id }) { item in
                AndroidEquatableCountingRow(
                    id: "android-equatable-row-\(item.id)",
                    text: item.title,
                    counter: counter
                )
                .androidEquatable(recomposeOverride: item)
            }
        }
    }
}

private struct AndroidEquatableLazyHost: View {
    let parentTick: State<Int>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        LazyVStack {
            Text("tick \(parentTick.wrappedValue)")
                .accessibilityIdentifier("android-equatable-lazy-parent")
            ForEach(0..<4) { index in
                AndroidEquatableCountingRow(
                    id: "android-equatable-lazy-row-\(index)",
                    text: "Lazy \(index)",
                    counter: counter
                )
                .androidEquatable(recomposeOverride: index)
            }
        }
    }
}

private struct AndroidEquatableEnvironmentHost: View {
    let environmentValue: State<String>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let value = environmentValue.wrappedValue
        AndroidEquatableEnvironmentRow(counter: counter)
            .androidEquatable(recomposeOverride: value)
            .environment(\.testValue, value)
    }
}

private struct AndroidEquatableEnvironmentRow: View {
    @Environment(\.testValue) var environmentValue: String
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let _ = counter.increment("android-equatable-environment-child")
        Text(environmentValue)
            .accessibilityIdentifier("android-equatable-environment-child")
    }
}

private struct AndroidEquatableStatefulHost: View {
    let parentTick: State<Int>
    let stateOverride: State<Int>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        VStack {
            Text("tick \(parentTick.wrappedValue)")
                .accessibilityIdentifier("android-equatable-stateful-parent")
            AndroidEquatableStatefulRow(counter: counter)
                .androidEquatable(recomposeOverride: stateOverride.wrappedValue)
        }
    }
}

private struct AndroidEquatableStatefulRow: View, Equatable {
    @State var count = 0
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let _ = counter.increment("android-equatable-stateful-child")
        Button("count \(count)") {
            count += 1
        }
        .accessibilityIdentifier("android-equatable-stateful-child")
        .buttonStyle(.bordered)
    }

    static func == (lhs: AndroidEquatableStatefulRow, rhs: AndroidEquatableStatefulRow) -> Bool {
        return true
    }
}

private struct AndroidEquatableHoistedStateHost: View {
    let childCount: State<Int>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let count = childCount.wrappedValue
        AndroidEquatableHoistedStateRow(
            count: count,
            counter: counter,
            increment: { childCount.wrappedValue += 1 }
        )
        .androidEquatable(recomposeOverride: count)
    }
}

private struct AndroidEquatableHoistedStateRow: View, Equatable {
    let count: Int
    let counter: AndroidEquatableBodyCounter
    let increment: () -> Void

    var body: some View {
        let _ = counter.increment("android-equatable-hoisted-state-child")
        Button("count \(count)", action: increment)
            .accessibilityIdentifier("android-equatable-hoisted-state-child")
            .buttonStyle(.bordered)
    }

    static func == (lhs: AndroidEquatableHoistedStateRow, rhs: AndroidEquatableHoistedStateRow) -> Bool {
        return lhs.count == rhs.count
    }
}

private struct AndroidEquatableActionHost: View {
    let parentValue: State<Int>
    let selectedValue: State<Int>
    let counter: AndroidEquatableBodyCounter

    var body: some View {
        let capturedValue = parentValue.wrappedValue
        VStack {
            Text("parent \(capturedValue)")
                .accessibilityIdentifier("android-equatable-action-parent")
            Text("selected \(selectedValue.wrappedValue)")
                .accessibilityIdentifier("android-equatable-selected-value")
            AndroidEquatableCountingRow(
                id: "android-equatable-action-child",
                text: "Select",
                counter: counter
            )
            .androidEquatable(recomposeOverride: "action")
            .onTapGesture { _ in selectedValue.wrappedValue = capturedValue }
        }
    }
}
#endif
