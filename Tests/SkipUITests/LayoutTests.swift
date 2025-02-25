// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SwiftUI
import XCTest
import OSLog
import Foundation

final class LayoutTests: XCSnapshotTestCase {

    func testRenderWhiteDot() throws {
        XCTAssertEqual("FFFFFF", try render(view: Color.white.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func testRenderWhiteSquareTiny() throws {
        if isAndroid {
            throw XCTSkip("fails on Android")
        }
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 2.0, height: 2.0)).pixmap, """
        F F
        F F
        """)
    }

    func testZStackSquareCenterInset() throws {
        XCTAssertEqual(try pixmap(content: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 4.0, height: 4.0)
        }), """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . .         . . . .
        . . . .         . . . .
        . . . .         . . . .
        . . . .         . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """)
    }

    func testRenderWhiteSquare() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 4.0, height: 4.0)).pixmap, """
        F F F F
        F F F F
        F F F F
        F F F F
        """)
    }

    func testRenderWhiteSquareBig() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 12.0, height: 12.0)).pixmap, """
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        F F F F F F F F F F F F
        """)
    }

    func testZStackSquareCenter() throws {
        XCTAssertEqual(try pixmap(brightness: 0.5, content: ZStack {
            Color.black.opacity(0.5).frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """)
    }

    func testZStackSquareCenterTransparent() throws {
        // The 49% opacity is below the brightness threshold, so the pixmap doesn't show any dots
        XCTAssertEqual(try pixmap(brightness: 0.5, content: ZStack {
            Color.gray.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """












        """)
    }

    func testZStackSquareCenterBrightnessThresholdHigh() throws {
        XCTAssertEqual(try pixmap(brightness: 0.9, content: ZStack {
            Color.gray.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """)
    }


    func testZStackSquareCenterBrightnessThresholdLow() throws {
        XCTAssertEqual(try pixmap(brightness: 0.1, content: ZStack {
            Color.gray.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """












        """)
    }


    func testRotatedSquareAliased() throws {
        if isAndroid {
            throw XCTSkip("fails on Android")
        }

        // shadow effect of a rotated shape is slightly different on Android and iOS
        XCTAssertEqual(try render(compact: 2, antiAlias: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }).pixmap,
        plaf("""
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 07 07 00 00 00 00 00
        00 00 00 00 07 B6 B6 07 00 00 00 00
        00 00 00 07 B6 FF FF B6 07 00 00 00
        00 00 07 B6 FF FF FF FF B6 07 00 00
        00 07 B6 FF FF FF FF FF FF B6 07 00
        00 07 B6 FF FF FF FF FF FF B6 07 00
        00 00 07 B6 FF FF FF FF B6 07 00 00
        00 00 00 07 B6 FF FF B6 07 00 00 00
        00 00 00 00 07 B6 B6 07 00 00 00 00
        00 00 00 00 00 07 07 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """, android: """
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 01 01 00 00 00 00 00
        00 00 00 00 01 DA DC 01 00 00 00 00
        00 00 00 00 D0 FF FF D0 00 00 00 00
        00 00 01 D0 FF FF FF FF D8 01 00 00
        00 01 DA FF FF FF FF FF FF DC 01 00
        00 01 DD FF FF FF FF FF FF DF 01 00
        00 00 01 D1 FF FF FF FF D8 01 00 00
        00 00 00 00 D8 FF FF D8 00 00 00 00
        00 00 00 00 01 DD DF 01 00 00 00 00
        00 00 00 00 00 01 01 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """, robolectric: """
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 A0 9F 00 00 00 00 00
        00 00 00 00 A0 FF FF 9F 00 00 00 00
        00 00 00 A0 FF FF FF FF 9F 00 00 00
        00 00 A0 FF FF FF FF FF FF 9F 00 00
        00 00 A0 FF FF FF FF FF FF A0 00 00
        00 00 00 A0 FF FF FF FF A0 00 00 00
        00 00 00 00 A0 FF FF A0 00 00 00 00
        00 00 00 00 00 A0 A0 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """))
    }

    func testRotatedSquare() throws {
        if isAndroid {
            throw XCTSkip("fails on Android")
        }

        // aliasing effect of a rotated shape is slightly different on Android and iOS so disable
        // TODO: anti-aliasing on Android doesn't yet work
        XCTAssertEqual(try render(compact: 2, antiAlias: false, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }).pixmap,
        plaf("""
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 FF FF 00 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 FF FF FF FF FF FF 00 00 00
        00 00 FF FF FF FF FF FF FF FF 00 00
        00 FF FF FF FF FF FF FF FF FF FF 00
        00 FF FF FF FF FF FF FF FF FF FF 00
        00 00 FF FF FF FF FF FF FF FF 00 00
        00 00 00 FF FF FF FF FF FF 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 00 FF FF 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """, android: """
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 01 01 00 00 00 00 00
        00 00 00 00 01 DA DC 01 00 00 00 00
        00 00 00 00 D0 FF FF D0 00 00 00 00
        00 00 01 D0 FF FF FF FF D8 01 00 00
        00 01 DA FF FF FF FF FF FF DC 01 00
        00 01 DD FF FF FF FF FF FF DF 01 00
        00 00 01 D1 FF FF FF FF D8 01 00 00
        00 00 00 00 D8 FF FF D8 00 00 00 00
        00 00 00 00 01 DD DF 01 00 00 00 00
        00 00 00 00 00 01 01 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """, robolectric: """
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 A0 9F 00 00 00 00 00
        00 00 00 00 A0 FF FF 9F 00 00 00 00
        00 00 00 A0 FF FF FF FF 9F 00 00 00
        00 00 A0 FF FF FF FF FF FF 9F 00 00
        00 00 A0 FF FF FF FF FF FF A0 00 00
        00 00 00 A0 FF FF FF FF A0 00 00 00
        00 00 00 00 A0 FF FF A0 00 00 00 00
        00 00 00 00 00 A0 A0 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00 00
        """))
    }

    func testRotatedSquareThreshold() throws {
        XCTAssertEqual(try pixmap(brightness: 0.1, content: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
        plaf("""
        . . . . . . . . . . . .
        . . . . .     . . . . .
        . . . .         . . . .
        . . .             . . .
        . .                 . .
        .                     .
        .                     .
        . .                 . .
        . . .             . . .
        . . . .         . . . .
        . . . . .     . . . . .
        . . . . . . . . . . . .
        """, android: """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . .     . . . . .
        . . . .         . . . .
        . . .             . . .
        . .                 . .
        . .                 . .
        . . .             . . .
        . . . .         . . . .
        . . . . .     . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """))
    }

    func testDrawCourierBar() throws {
        // disabled until we can update to compose-bom 2024 or later, since this rendering changed
        if isAndroid {
            throw XCTSkip("Disabled on Android until BOM 2024")
        }

        XCTAssertEqual(try render(compact: 2, view: ZStack {
            Text("|").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 7.0, height: 8.0).background(Color.white)).pixmap,
        plaf("""
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F5 9F FF FF FF
        FF FF F6 A5 FF FF FF
        """, macos: """
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 6F FF FF FF
        FF FF FF 74 FF FF FF
        """, android: """
        FF FF FF FF FF FF
        FF FF FF FF FF FF
        FF FF FF 55 FF FF
        FF FF FF 55 FF FF
        FF FF FF 55 FF FF
        FF FF FF 55 FF FF
        FF FF FF 61 FF FF
        FF FF FF FF FF FF
        """, robolectric: """
        FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF
        FF FF FF A9 FF FF FF
        FF FF FF A1 FF FF FF
        FF FF FF A1 FF FF FF
        FF FF FF A1 FF FF FF
        FF FF FF AA FF FF FF
        FF FF FF FF FF FF FF
        """))
    }

    func testDrawTextDefaultFont() throws {
        if isAndroid {
            throw XCTSkip("fails on Android")
        }

        XCTAssertEqual(try render(compact: 2, view: ZStack {
            Text("T").foregroundColor(Color.white)
        }.background(Color.black)).pixmap,
        plaf("""
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        0A B1 CE CD C9 C2 CB CD CF 91 00
        07 79 8C 8A B3 FF 9F 8B 8D 64 00
        00 00 00 00 4A FC 1D 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 51 FC 26 00 00 00 00
        00 00 00 00 53 FF 27 00 00 00 00
        00 00 00 00 41 CB 1F 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00 00 00
        """, macos: """
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        53 92 92 92 92 92 92 76 00
        8F F6 F6 FF FF F6 F6 C9 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A8 E5 00 00 00 00
        00 00 00 A2 E0 00 00 00 00
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00 00
        """, android: """
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        40 4C 4C 4C 4C 4C 4C 4C
        B6 D8 D8 EA FC D8 D8 D8
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 81 F1 00 00 00
        00 00 00 08 0F 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        """, robolectric: """
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        B6 F7 F7 F7 F7 F7 F7 F7
        2A 39 39 A3 E3 39 39 39
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 94 DF 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        00 00 00 00 00 00 00 00
        """))
    }

    func testZStackSquareBottomTrailing() throws {
        XCTAssertEqual(try pixmap(content: ZStack(alignment: .bottomTrailing) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        """)
    }

    func testZStackSquareTopLeading() throws {
        XCTAssertEqual(try pixmap(content: ZStack(alignment: .topLeading) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """
                    . . . . . .
                    . . . . . .
                    . . . . . .
                    . . . . . .
                    . . . . . .
                    . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """)
    }

    func testZStackSquareTop() throws {
        XCTAssertEqual(try pixmap(content: ZStack(alignment: .top) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """)
    }

    func testZStackSquareTrailing() throws {
        XCTAssertEqual(try pixmap(content: ZStack(alignment: .trailing) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }), """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """)
    }

    func testRenderStacks() throws {
        XCTAssertEqual(try pixmap(content: VStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    (Color.black).frame(width: 1.0, height: 2.0)
                    (Color.white).frame(width: 1.0, height: 1.0)
                }
                (Color.white).frame(width: 6.0, height: 3.0)
                (Color.black).frame(width: 5.0, height: 3.0)
            }
            HStack(spacing: 0.0) {
                (Color.black).frame(width: 3.0, height: 9.0)
                (Color.white).frame(width: 9.0, height: 9.0)
            }
        }
        .frame(width: 12.0, height: 12.0)), plaf("""
        .             . . . . .
        .             . . . . .
                      . . . . .
        . . .
        . . .
        . . .
        . . .
        . . .
        . . .
        . . .
        . . .
        . . .
        """))
    }

    func testHStackAlignmentExpand() throws {
        // TODO: Android HStack Color elements do not seem to expand to fill the space
        XCTAssertEqual(try render(compact: 2, view: HStack(alignment: .bottom, spacing: 0.0) {
            Color.black.frame(height: 10.0)
            Color.white.opacity(0.8).frame(height: 12.0)
            Color.black.frame(height: 10.0)
        }.background(Color.white).frame(width: 12.0, height: 12.0)).pixmap,
        plaf("""
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        00 00 00 00 FF FF FF FF 00 00 00 00
        """))
    }

    func testVStackAlignment() throws {
        XCTAssertEqual(try pixmap(content: VStack {
            Spacer()
            Color.black.frame(height: 2.0)
            Spacer()
            Color.black.frame(height: 2.0)
            Spacer()
        }.background(Color.white).frame(width: 12.0, height: 12.0)), plaf("""
        . . . . . . . . . . . .
        . . . . . . . . . . . .








        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """, android: """








        . . . . . . . . . . . .
        . . . . . . . . . . . .

        . . . . . . . . . . . .
        """))
    }


    func testHStackAlignment() throws {
        XCTAssertEqual(try pixmap(content: HStack {
            Spacer()
            Color.black.frame(width: 2.0)
            Spacer()
            Color.black.frame(width: 2.0)
            Spacer()
        }.background(Color.white).frame(width: 12.0, height: 12.0)), plaf("""
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        . .                 . .
        """, android: """
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
                        . . . .
        """))
    }

}
