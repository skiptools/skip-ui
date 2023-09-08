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
// SKIP INSERT: @org.robolectric.annotation.Config(manifest=org.robolectric.annotation.Config.NONE, sdk = [33])
// SKIP INSERT: @org.robolectric.annotation.GraphicsMode(org.robolectric.annotation.GraphicsMode.Mode.NATIVE)
final class ColorTests: XCSnapshotTestCase {
    func testColorBlackCompact() throws {
        XCTAssertEqual("0", try render(compact: 1, view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteCompact() throws {
        XCTAssertEqual("F", try render(compact: 1, view: Color.white.frame(width: 1.0, height: 1.0)))
    }

    func testColorClearDark() throws {
        XCTAssertEqual(plaf("00FF00", macos: "000000", android: "000000"), try render(darkMode: true, view: Color.clear.frame(width: 1.0, height: 1.0)))
    }

    func testColorClearLight() throws {
        XCTAssertEqual(plaf("FFFF00", macos: "FFFFFF", android: "000000"), try render(view: Color.clear.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlackDark() throws {
        XCTAssertEqual(plaf("000000"), try render(darkMode: true, view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlackLight() throws {
        XCTAssertEqual(plaf("000000"), try render(view: Color.black.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteDark() throws {
        XCTAssertEqual(plaf("FFFFFF"), try render(darkMode: true, view: Color.white.frame(width: 1.0, height: 1.0)))
    }

    func testColorWhiteLight() throws {
        XCTAssertEqual(plaf("FFFFFF"), try render(view: Color.white.frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayDark() throws {
        XCTAssertEqual(plaf("8E8E93", macos: "98989D"), try render(darkMode: true, view: Color.gray.frame(width: 1.0, height: 1.0)))
    }

    func testColorGrayLight() throws {
        XCTAssertEqual(plaf("8E8E93"), try render(view: Color.gray.frame(width: 1.0, height: 1.0)))
    }

    func testColorRedDark() throws {
        XCTAssertEqual(plaf("FF453A", android: "FF3B30"), try render(darkMode: true, view: Color.red.frame(width: 1.0, height: 1.0)))
    }

    func testColorRedLight() throws {
        XCTAssertEqual(plaf("FF3B30"), try render(view: Color.red.frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeDark() throws {
        XCTAssertEqual(plaf("FF9F0A", android: "FF9500"), try render(darkMode: true, view: Color.orange.frame(width: 1.0, height: 1.0)))
    }

    func testColorOrangeLight() throws {
        XCTAssertEqual(plaf("FF9500"), try render(view: Color.orange.frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowDark() throws {
        XCTAssertEqual(plaf("FFD60A", android: "FFCC00"), try render(darkMode: true, view: Color.yellow.frame(width: 1.0, height: 1.0)))
    }

    func testColorYellowLight() throws {
        XCTAssertEqual(plaf("FFCC00"), try render(view: Color.yellow.frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenDark() throws {
        XCTAssertEqual(plaf("30D158", macos: "32D74B", android: "34C759"), try render(darkMode: true, view: Color.green.frame(width: 1.0, height: 1.0)))
    }

    func testColorGreenLight() throws {
        XCTAssertEqual(plaf("34C759", macos: "28CD41"), try render(view: Color.green.frame(width: 1.0, height: 1.0)))
    }

    func testColorMintDark() throws {
        XCTAssertEqual(plaf("63E6E2", android: "00C7BE"), try render(darkMode: true, view: Color.mint.frame(width: 1.0, height: 1.0)))
    }

    func testColorMintLight() throws {
        XCTAssertEqual(plaf("00C7BE"), try render(view: Color.mint.frame(width: 1.0, height: 1.0)))
    }

    func testColortTealDark() throws {
        XCTAssertEqual(plaf("40C8E0", macos: "6AC4DC", android: "30B0C7"), try render(darkMode: true, view: Color.teal.frame(width: 1.0, height: 1.0)))
    }

    func testColorTealLight() throws {
        XCTAssertEqual(plaf("30B0C7", macos: "59ADC4"), try render(view: Color.teal.frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanDark() throws {
        XCTAssertEqual(plaf("64D2FF", macos: "5AC8F5", android: "32ADE6"), try render(darkMode: true, view: Color.cyan.frame(width: 1.0, height: 1.0)))
    }

    func testColorCyanLight() throws {
        XCTAssertEqual(plaf("32ADE6", macos: "55BEF0"), try render(view: Color.cyan.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueDark() throws {
        XCTAssertEqual(plaf("0A84FF", android: "007AFF"), try render(darkMode: true, view: Color.blue.frame(width: 1.0, height: 1.0)))
    }

    func testColorBlueLight() throws {
        XCTAssertEqual(plaf("007AFF"), try render(view: Color.blue.frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoDark() throws {
        XCTAssertEqual(plaf("5E5CE6", android: "5856D6"), try render(darkMode: true, view: Color.indigo.frame(width: 1.0, height: 1.0)))
    }

    func testColorIndigoLight() throws {
        XCTAssertEqual(plaf("5856D6"), try render(view: Color.indigo.frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleDark() throws {
        XCTAssertEqual(plaf("BF5AF2", android: "AF52DE"), try render(darkMode: true, view: Color.purple.frame(width: 1.0, height: 1.0)))
    }

    func testColorPurpleLight() throws {
        XCTAssertEqual(plaf("AF52DE"), try render(view: Color.purple.frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkDark() throws {
        XCTAssertEqual(plaf("FF375F", android: "FF2D55"), try render(darkMode: true, view: Color.pink.frame(width: 1.0, height: 1.0)))
    }

    func testColorPinkLight() throws {
        XCTAssertEqual(plaf("FF2D55"), try render(view: Color.pink.frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownDark() throws {
        XCTAssertEqual(plaf("AC8E68", android: "A2845E"), try render(darkMode: true, view: Color.brown.frame(width: 1.0, height: 1.0)))
    }

    func testColorBrownLight() throws {
        XCTAssertEqual(plaf("A2845E"), try render(view: Color.brown.frame(width: 1.0, height: 1.0)))
    }
}
