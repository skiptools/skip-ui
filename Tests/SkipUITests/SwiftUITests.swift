// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
import SkipUI

final class SkipUITests: XCTestCase {
    func testExample() throws {
        if ({ false }()) {
            _ = SkipUI.VStack {
                SkipUI.Text("Hello")
                    .foregroundStyle(.primary)
                    .font(.title)
                SkipUI.Text("Hello")
                    .opacity(0.5)
                    .font(.title2)
            }
        }
    }
}
