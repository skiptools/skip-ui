// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
import SkipUI
//import SwiftUI

final class SkipUITests: XCTestCase {
    @MainActor func testConstants() throws {
        XCTAssertEqual("Weight(value: -0.8)", "\(Font.Weight.ultraLight)")
        XCTAssertEqual("Weight(value: -0.6)", "\(Font.Weight.thin)")
        XCTAssertEqual("Weight(value: -0.4)", "\(Font.Weight.light)")
        XCTAssertEqual("Weight(value: 0.0)", "\(Font.Weight.regular)")
        XCTAssertEqual("Weight(value: 0.23)", "\(Font.Weight.medium)")
        XCTAssertEqual("Weight(value: 0.3)", "\(Font.Weight.semibold)")
        XCTAssertEqual("Weight(value: 0.4)", "\(Font.Weight.bold)")
        XCTAssertEqual("Weight(value: 0.56)", "\(Font.Weight.heavy)")
        XCTAssertEqual("Weight(value: 0.62)", "\(Font.Weight.black)")
    }

    @MainActor func testExample() throws {
        if ({ false }()) {
            _ = VStack {
                Text("Hello")
                    .foregroundStyle(.primary)
                    .font(.title)
                Text("Hello")
                    .opacity(0.5)
                    .font(.title2)
            }

            _ = TabView {
                List {
                    ForEach(1..<100) { i in
                        HStack(spacing: 6.0) {
                            Text("Hello")
                                .foregroundStyle(.primary)
                                .font(.body)
                        }
                    }
                    .listItemTint(.red)
                }
            }
        }
    }
}


struct DemoViw : View {
    @ViewBuilder var body: some View {
        VStack {
            Text("Hello")
            Text("Hello")
        }
    }
}
