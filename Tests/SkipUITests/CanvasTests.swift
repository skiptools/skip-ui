// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import XCTest
import OSLog
import Foundation

#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.size
import androidx.compose.ui.unit.dp
#endif

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class CanvasTests: XCSnapshotTestCase {
    func testRenderCustomShape() throws {
        #if !SKIP
        throw XCTSkip("Android-only function")
        #else
        XCTAssertEqual(try render(compact: 1, view: ComposeView(content: { ctx in
            androidx.compose.foundation.layout.Box(modifier: androidx.compose.ui.Modifier.background(androidx.compose.ui.graphics.Color.White).size(12.dp), contentAlignment: androidx.compose.ui.Alignment.Center) {
                androidx.compose.foundation.layout.Box(modifier: androidx.compose.ui.Modifier.background(androidx.compose.ui.graphics.Color.Black).size(6.dp, 6.dp))
            }
        })),
        plaf("""
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        """))
        #endif
    }

    func testRenderCustomCanvas() throws {
        #if !SKIP
        throw XCTSkip("Android-only function")
        #else
        XCTAssertEqual(try render(compact: 1, view: ComposeView(content: { ctx in
            androidx.compose.foundation.layout.Box(modifier: androidx.compose.ui.Modifier.size(12.dp).background(androidx.compose.ui.graphics.Color.White), contentAlignment: androidx.compose.ui.Alignment.Center) {
                androidx.compose.foundation.layout.Box(modifier: androidx.compose.ui.Modifier.size(6.dp, 6.dp).background(androidx.compose.ui.graphics.Color.Black))
            }
        })),
        plaf("""
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F 0 0 0 0 0 0 F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        """))
        #endif
    }
}
