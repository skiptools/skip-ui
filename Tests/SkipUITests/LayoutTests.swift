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
final class LayoutTests: XCSnapshotTestCase {
    func testRenderWhiteSquareTiny() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 2.0, height: 2.0)),
        plaf("""
        F F
        F F
        """))
    }

    func testRenderWhiteSquare() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 4.0, height: 4.0)),
        plaf("""
        F F F F
        F F F F
        F F F F
        F F F F
        """))
    }

    func testRenderWhiteSquareBig() throws {
        XCTAssertEqual(try render(compact: 1, view: Color.white.frame(width: 12.0, height: 12.0)),
        plaf("""
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
        """))
    }

    func testZStackSquareCenter() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testRotatedSquareAliased() throws {
        // shadow effect of a rotated shape is slightly different on Android and iOS
        XCTAssertEqual(try render(compact: 2, antiAlias: true, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
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
        // aliasing effect of a rotated shape is slightly different on Android and iOS so disable
        // TODO: anti-aliasing on Android doesn't yet work
        XCTAssertEqual(try render(compact: 2, antiAlias: false, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0).rotationEffect(Angle.degrees(45.0))
        }),
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

    func testDrawCourierBar() throws {
        XCTAssertEqual(try render(compact: 2, view: ZStack {
            Text("|").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 7.0, height: 8.0).background(Color.white)),
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
        XCTAssertEqual(try render(compact: 2, view: ZStack {
            Text("T").foregroundColor(Color.white)
        }.background(Color.black)),
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
        00 00 00 00 00 00 00 00
        """))
    }

    func testDrawTextMonospacedFont() throws {
        XCTAssertEqual(try render(compact: 2, antiAlias: false, view: ZStack {
            Text("T").font(Font.custom("courier", size: CGFloat(8.0))).foregroundColor(Color.black)
        }.frame(width: 8.0, height: 8.0).background(Color.white)),
        plaf("""
        FF FF FF FF FF FF FF FF
        FF FF E2 9C 9B A1 F0 FF
        FF FF A9 8D 73 87 C8 FF
        FF FF E0 E0 8E E5 E9 FF
        FF FF FF F4 82 FF FF FF
        FF FF FF A8 5A BF FF FF
        FF FF FF FA FB FA FF FF
        FF FF FF FF FF FF FF FF
        """, macos: """
        FF FF FF FF FF FF FF FF
        FF FF 5F 50 18 40 92 FF
        FF FF 56 FF 4D CF 87 FF
        FF FF DF FF 4D F9 E5 FF
        FF FF FF FF 4D FF FF FF
        FF FF FF 5E 19 7F FF FF
        FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF
        """, android: """
        FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF
        FF FF 97 00 00 00 B9 FF
        FF FF B6 FF B6 FE B7 FF
        FF FF F8 FF B6 FF F8 FF
        FF FF FF 40 00 70 FF FF
        FF FF FF FF FF FF FF FF
        """))
    }


    func testZStackSquareCenterInset() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 4.0, height: 4.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 F F F F 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackOpacityOverlay() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.opacity(0.6).frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 9 9 9 9 9 9 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackMultiOpacityOverlay() throws {
        if isAndroid {
            throw XCTSkip("opacity overlay not passing on Android emulator")
        }

        XCTAssertEqual(try render(compact: 1, view: ZStack {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.opacity(0.8).frame(width: 8.0, height: 8.0)
            Color.black.opacity(0.5).frame(width: 4.0, height: 4.0)
            Color.white.opacity(0.22).frame(width: 2.0, height: 2.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 C C C C C C C C 0 0
        0 0 C C C C C C C C 0 0
        0 0 C C 6 6 6 6 C C 0 0
        0 0 C C 6 8 8 6 C C 0 0
        0 0 C C 6 8 8 6 C C 0 0
        0 0 C C 6 6 6 6 C C 0 0
        0 0 C C C C C C C C 0 0
        0 0 C C C C C C C C 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackSquareBottomTrailing() throws {
        XCTAssertEqual(try render(outputFile: "\(NSTemporaryDirectory())/SkipUITests-testZStackSquareBottomTrailing", compact: 1, view: ZStack(alignment: .bottomTrailing) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        """))
    }

    func testZStackSquareTopLeading() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack(alignment: .topLeading) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        F F F F F F 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackSquareTop() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack(alignment: .top) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 F F F F F F 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testZStackSquareTrailing() throws {
        XCTAssertEqual(try render(compact: 1, view: ZStack(alignment: .trailing) {
            Color.black.frame(width: 12.0, height: 12.0)
            Color.white.frame(width: 6.0, height: 6.0)
        }),
        plaf("""
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 F F F F F F
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0 0 0
        """))
    }

    func testRenderStacks() throws {
        XCTAssertEqual(try render(outputFile: "\(NSTemporaryDirectory())/SkipUITests-testRenderStacks", compact: 1, view: VStack(spacing: 0.0) {
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
        0 F F F F F F 0 0 0 0 0
        0 F F F F F F 0 0 0 0 0
        F F F F F F F 0 0 0 0 0
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        0 0 0 F F F F F F F F F
        """))
    }

    func testHStackAlignment() throws {
        // TODO: Android HStack Color elements do not seem to expand to fill the space
        XCTAssertEqual(try render(compact: 2, view: HStack(alignment: .bottom, spacing: 0.0) {
            Color.black.frame(height: 10.0)
            Color.white.opacity(0.8).frame(height: 12.0)
            Color.black.frame(height: 10.0)
        }.background(Color.white).frame(width: 12.0, height: 12.0)),
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
        """, android: """
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        FF FF FF FF FF FF FF FF FF FF FF FF
        """))
    }

}
