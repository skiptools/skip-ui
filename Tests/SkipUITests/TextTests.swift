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

    func testTextSizeLargeTitle() throws {
        let size = try render(view: Text("X").font(.largeTitle)).size
        #if SKIP
        XCTAssertEqual(size.height, 42.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 41.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 31.0)
        #endif
    }

    func testTextSizeTitle() throws {
        let size = try render(view: Text("X").font(.title)).size
        #if SKIP
        XCTAssertEqual(size.height, 35.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 34.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 26.0)
        #endif
    }

    func testTextSizeTitle2() throws {
        let size = try render(view: Text("X").font(.title2)).size
        #if SKIP
        XCTAssertEqual(size.height, 27.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 27.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 21.0)
        #endif
    }

    func testTextSizeTitle3() throws {
        let size = try render(view: Text("X").font(.title3)).size
        #if SKIP
        XCTAssertEqual(size.height, 24.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 24.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 19.0)
        #endif
    }

    func testTextSizeHeadline() throws {
        let size = try render(view: Text("X").font(.headline)).size
        #if SKIP
        XCTAssertEqual(size.height, 21.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 21.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 16.0)
        #endif
    }

    func testTextSizeSubheadline() throws {
        let size = try render(view: Text("X").font(.subheadline)).size
        #if SKIP
        XCTAssertEqual(size.height, 18.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 18.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 14.0)
        #endif
    }

    func testTextSizeBody() throws {
        let size = try render(view: Text("X").font(.body)).size
        #if SKIP
        XCTAssertEqual(size.height, 21.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 21.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 16.0)
        #endif
    }

    func testTextSizeCallout() throws {
        let size = try render(view: Text("X").font(.callout)).size
        #if SKIP
        XCTAssertEqual(size.height, 20.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 20.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 15.0)
        #endif
    }

    func testTextSizeFootnote() throws {
        let size = try render(view: Text("X").font(.footnote)).size
        #if SKIP
        XCTAssertEqual(size.height, 16.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 16.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 13.0)
        #endif
    }

    func testTextSizeCaption() throws {
        let size = try render(view: Text("X").font(.caption)).size
        #if SKIP
        XCTAssertEqual(size.height, 15.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 15.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 13.0)
        #endif
    }

    func testTextSizeCaption2() throws {
        let size = try render(view: Text("X").font(.caption2)).size
        #if SKIP
        XCTAssertEqual(size.height, 14.0 + (isAndroid ? 0.0 : 1.0))
        #elseif os(iOS)
        XCTAssertEqual(size.height, 14.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 13.0)
        #endif
    }

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



          . . . . . .
          .
          .




            . . . .



        """, robolectric: """



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
        if isAndroid {
            throw XCTSkip("Disabled on Android due to inconsistent font rendering on different emulators")
        }

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



          . .     . . .   . . . . . . .   . . . .         . . . .             . . . .
            .       .       .         .       .               .             .         .
            .       .       .         .       .               .             .         .
            .       .       .     .           .               .           .
            . . . . .       . . . .           .               .           .             .
            .       .       .     .           .       .       .       .               .
            .       .       .         .       .       .       .       .     .         .
          . .       .       . . . . . .   . . . . . . .     . . . . . .       . . . .


        """, robolectric: """



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
