// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import XCTest

final class ModifierTests: SkipUITestCase {
    func testModifierViewDoesNotCopy() {
        #if SKIP
        let text = Text("test")
        let modified = text.font(.title).padding(.all, 10.0)
        modified.strippingModifiers { XCTAssertEqual($0, text) }
        #endif
    }
}
