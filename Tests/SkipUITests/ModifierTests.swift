// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
