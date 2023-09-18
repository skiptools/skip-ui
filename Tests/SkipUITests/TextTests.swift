// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import XCTest
import OSLog
import Foundation

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class TextTests: XCSnapshotTestCase {


    func testDrawTextMonospacedFont() throws {
        XCTAssertEqual(try pixmap(brightness: 0.75, content: ZStack {
            Text("T").font(Font.custom("courier", size: CGFloat(14.0))).foregroundColor(Color.black).frame(height: 14.0)
        }.background(Color.white)),
        plaf("""



          . . . . . . .
          .   . .   . .
          .   . .   . .
          .   . .
              . .
              . .
              . .
            . . . . .



        """, macos: """


        . . . . . . . .
        . . . . . . . .
        . .   . .   . .
        . .   . .   . .
              . .
              . .
              . .
              . .
            . . . . .



        """, android: """



          . . . . . . .
          .     .     .
          .     .     .
                .
                .
                .
                .
                .
            . . . . .


        """))
    }


    func testDrawMessage() throws {
        XCTAssertEqual(try pixmap(brightness: 0.75, content: ZStack {
            Text("HELLO").font(Font.custom("courier", size: CGFloat(14.0))).foregroundColor(Color.black).frame(height: 14.0)
        }.background(Color.white)),
        plaf("""



          . . .   . . .   . . . . . . .   . . . . .       . . . . .           . . . . .
          . .       . .     . .     . .     . .               .             . .     . .
            .       .       . .   .   .     . .               .             .         . .
            . . . . .       . . . .         . .               .           . .         . .
            . . . . .       . .   .         . .       .       .         . . .         . .
            .       .       . .       .     . .       . .     .       . .   .         . .
          . .       . .     . .     . .     . .       . .   . . .     . .   . .     . .
          . . .   . . .   . . . . . . .   . . . . . . .   . . . . . . . .     . . . . .



        """, macos: """


        . . . . . . . .   . . . . . . .   . . . . .       . . . . .           . . . . .
          . .     . .     . . . . . . .     . . .           . . . .         . . .   . . .
          . .       .       .       . .     . .               .             . .       . .
          . .     . .       . . . .         . .               .             . .       . .
          . . . . . .       . . . .         . .               .             .           . .
          . .       .       .     .         . .       . .     .         .   . .       . .
          . .       .       .       . .     . .       . .     .       . .   . .       . .
          . .     . .       . .     . .     . .       . .     . .     . .   . . .   . . .
        . . . . . . . .   . . . . . . .   . . . . . . . . . . . . . . . .     . . . . .



        """, android: """



          . . .   . . .   . . . . . . .   . . . .         . . . .           . . . .
            .       .       .         .       .               .           . .     . .
            .       .       .         .       .               .           .         . .
            .       .       .     .           .               .           .           .
            . . . . .       . . . .           .               .           .           .
            .       .       .     .           .               .           .           .
            .       .       .         .       .       .       .       .   .         . .
            .       .       .         .       .       .       .       .   . .     . .
          . . .   . . .   . . . . . . . . . . . . . . . . . . . . . . .     . . . .


        """))
    }
}
