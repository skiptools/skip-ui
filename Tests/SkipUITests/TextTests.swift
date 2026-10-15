// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest
import OSLog
import Foundation

final class TextTests: XCSnapshotTestCase {

    func testTextSizeLargeTitle() throws {
        let size = try render(view: Text("X").font(.largeTitle)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 37.0)
        } else {
            XCTAssertEqual(size.height, 38.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 41.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 31.0)
        #endif
    }

    func testTextSizeTitle() throws {
        let size = try render(view: Text("X").font(.title)).size
        #if SKIP
        XCTAssertEqual(size.height, 30.0)
        #elseif os(iOS)
        XCTAssertEqual(size.height, 34.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 26.0)
        #endif
    }

    func testTextSizeTitle2() throws {
        let size = try render(view: Text("X").font(.title2)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 23.0)
        } else {
            XCTAssertEqual(size.height, 24.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 27.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 21.0)
        #endif
    }

    func testTextSizeTitle3() throws {
        let size = try render(view: Text("X").font(.title3)).size
        #if SKIP
        XCTAssertEqual(size.height, 21.0)
        #elseif os(iOS)
        XCTAssertEqual(size.height, 24.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 19.0)
        #endif
    }

    func testTextSizeHeadline() throws {
        let size = try render(view: Text("X").font(.headline)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 19.0)
        } else {
            XCTAssertEqual(size.height, 19.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 21.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 16.0)
        #endif
    }

    func testTextSizeSubheadline() throws {
        let size = try render(view: Text("X").font(.subheadline)).size
        #if SKIP
        XCTAssertEqual(size.height, 16.0)
        #elseif os(iOS)
        XCTAssertEqual(size.height, 18.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 14.0)
        #endif
    }

    func testTextSizeBody() throws {
        let size = try render(view: Text("X").font(.body)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 19.0)
        } else {
            XCTAssertEqual(size.height, 19.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 21.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 16.0)
        #endif
    }

    func testTextSizeCallout() throws {
        let size = try render(view: Text("X").font(.callout)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 17.0)
        } else {
            XCTAssertEqual(size.height, 18.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 20.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 15.0)
        #endif
    }

    func testTextSizeFootnote() throws {
        let size = try render(view: Text("X").font(.footnote)).size
        #if SKIP
        XCTAssertEqual(size.height, 14.0)
        #elseif os(iOS)
        XCTAssertEqual(size.height, 16.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 13.0)
        #endif
    }

    func testTextSizeCaption() throws {
        let size = try render(view: Text("X").font(.caption)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 13.0)
        } else {
            XCTAssertEqual(size.height, 13.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 15.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 13.0)
        #endif
    }

    func testTextSizeCaption2() throws {
        let size = try render(view: Text("X").font(.caption2)).size
        #if SKIP
        if isAndroid {
            XCTAssertEqual(size.height, 12.0)
        } else {
            XCTAssertEqual(size.height, 13.0)
        }
        #elseif os(iOS)
        XCTAssertEqual(size.height, 14.0)
        #elseif os(macOS)
        XCTAssertEqual(size.height, 13.0)
        #endif
    }

    func testDrawTextMonospacedFont() throws {
        // disabled until we can update to compose-bom 2024 or later, since this rendering changed
        if isAndroid {
            throw XCTSkip("Disabled on Android until BOM 2024")
        }

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

    /// Splits a pixmap of two equal rows into its top and bottom halves, so a concatenation can
    /// be compared against an equivalent plain text rendered directly beneath it. The compose
    /// test rule permits a single `setContent` per test, so both subjects share one render.
    private func stackedHalves(_ map: String) -> (top: String, bottom: String) {
        let rows = map.split(separator: "\n", omittingEmptySubsequences: false).map({ String($0) })
        let mid = rows.count / 2
        return (Array(rows.prefix(mid)).joined(separator: "\n"), Array(rows.suffix(mid)).joined(separator: "\n"))
    }

    /// `Text + Text` must lay out as a single string rather than as two adjacent views: the
    /// concatenation renders identically to the equivalent joined literal below it.
    func testTextConcatenationLaysOutAsSingleString() throws {
        if isAndroid {
            throw XCTSkip("Disabled on Android due to inconsistent font rendering on different emulators")
        }

        let halves = stackedHalves(try pixmap(content: VStack(spacing: 0.0) {
            Text("Hello") + Text("World")
            Text("HelloWorld")
        }.background(Color.white)))
        XCTAssertEqual(halves.top, halves.bottom)
    }

    /// Each operand's own styling survives the concatenation. Were the captured per-run style
    /// dropped, the runs would fall back to the environment font and render at body size rather
    /// than matching the equivalently styled plain text below them. Compared by inked height
    /// rather than the whole pixmap because the two paths differ slightly in advance width.
    func testTextConcatenationAppliesPerSegmentFont() throws {
        if isAndroid {
            throw XCTSkip("Disabled on Android due to inconsistent font rendering on different emulators")
        }

        let halves = stackedHalves(try pixmap(content: VStack(spacing: 0.0) {
            Text("A").font(.largeTitle) + Text("B").font(.largeTitle)
            Text("AB").font(.largeTitle)
        }.background(Color.white)))
        XCTAssertEqual(inkedRows(halves.top), inkedRows(halves.bottom))
        XCTAssertGreaterThan(inkedRows(halves.top), 0)
    }

    /// The number of rows containing rendered pixels, i.e. the drawn height of a pixmap.
    private func inkedRows(_ map: String) -> Int {
        return map.split(separator: "\n", omittingEmptySubsequences: false).filter({ $0.contains(".") }).count
    }
}
