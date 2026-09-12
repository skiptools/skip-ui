// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0

import XCTest
@testable import SkipUI

@MainActor
final class WebRuntimeTests: XCTestCase {
    func testHelloWorldProducesTextNode() {
        let node = WebRenderer.render(Text("Hello World"))

        XCTAssertEqual(node.kind, .text)
        XCTAssertEqual(node.value, "Hello World")
    }

    func testStackProducesAdaptiveFlexContainer() {
        let view = VStack(spacing: 12) {
            Text("Hello")
            Text("World")
        }
        let node = WebRenderer.render(view)

        XCTAssertEqual(node.kind, .container)
        XCTAssertEqual(node.styles[.display], "flex")
        XCTAssertEqual(node.styles[.flexDirection], "column")
        XCTAssertEqual(node.styles[.gap], "12.0px")
        XCTAssertEqual(node.children.map(\.value), ["Hello", "World"])
    }

    func testButtonActionAndBindingAreConnectedToWebNodes() {
        var didTap = false
        let state = State(initialValue: "before")
        let view = VStack {
            Button("Tap") { didTap = true }
            TextField("Name", text: state.projectedValue)
        }
        let node = WebRenderer.render(view)

        node.children[0].activate?()
        node.children[1].input?("after")

        XCTAssertTrue(didTap)
        XCTAssertEqual(state.wrappedValue, "after")
        XCTAssertEqual(node.children[1].value, "before")
    }

    func testStateBackedViewKeepsItsStorageWhenActionRuns() {
        struct Counter: View {
            @State private var count = 0

            var currentCount: Int {
                count
            }

            var body: some View {
                Button("Increment") { count += 1 }
            }
        }

        let counter = Counter()
        let node = WebRenderer.render(counter)
        node.activate?()

        XCTAssertEqual(counter.currentCount, 1)
    }
}
