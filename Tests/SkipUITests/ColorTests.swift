// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import SwiftUI
import XCTest
import OSLog
import Foundation

final class ColorTests: XCSnapshotTestCase {
    func testColorBlackCompact() throws {
        XCTAssertEqual("0", try render(compact: 1, view: Color.black.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func testColorWhiteCompact() throws {
        XCTAssertEqual("F", try render(compact: 1, view: Color.white.frame(width: 1.0, height: 1.0)).pixmap)
    }

    // Disabled tests (due to slow performance when running against emulator)

    func DISABLEDtestColorClearDark() throws {
        XCTAssertEqual(plaf("00FF00", macos: "000000", android: "000000"), try render(darkMode: true, view: Color.clear.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorClearLight() throws {
        XCTAssertEqual(plaf("FFFF00", macos: "FFFFFF", android: "000000"), try render(view: Color.clear.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorBlackDark() throws {
        XCTAssertEqual(plaf("000000"), try render(darkMode: true, view: Color.black.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorBlackLight() throws {
        XCTAssertEqual(plaf("000000"), try render(view: Color.black.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorWhiteDark() throws {
        XCTAssertEqual(plaf("FFFFFF"), try render(darkMode: true, view: Color.white.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorWhiteLight() throws {
        XCTAssertEqual(plaf("FFFFFF"), try render(view: Color.white.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorGrayDark() throws {
        XCTAssertEqual(plaf("8E8E93", macos: "98989D"), try render(darkMode: true, view: Color.gray.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorGrayLight() throws {
        XCTAssertEqual(plaf("8E8E93"), try render(view: Color.gray.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorRedDark() throws {
        XCTAssertEqual(plaf("FF453A", android: "FF3B30"), try render(darkMode: true, view: Color.red.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorRedLight() throws {
        XCTAssertEqual(plaf("FF3B30"), try render(view: Color.red.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorOrangeDark() throws {
        XCTAssertEqual(plaf("FF9F0A", android: "FF9500"), try render(darkMode: true, view: Color.orange.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorOrangeLight() throws {
        XCTAssertEqual(plaf("FF9500"), try render(view: Color.orange.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorYellowDark() throws {
        XCTAssertEqual(plaf("FFD60A", android: "FFCC00"), try render(darkMode: true, view: Color.yellow.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorYellowLight() throws {
        XCTAssertEqual(plaf("FFCC00"), try render(view: Color.yellow.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorGreenDark() throws {
        XCTAssertEqual(plaf("30D158", macos: "32D74B", android: "34C759"), try render(darkMode: true, view: Color.green.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorGreenLight() throws {
        XCTAssertEqual(plaf("34C759", macos: "28CD41"), try render(view: Color.green.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorMintDark() throws {
        XCTAssertEqual(plaf("63E6E2", android: "00C7BE"), try render(darkMode: true, view: Color.mint.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorMintLight() throws {
        XCTAssertEqual(plaf("00C7BE"), try render(view: Color.mint.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColortTealDark() throws {
        XCTAssertEqual(plaf("40C8E0", macos: "6AC4DC", android: "30B0C7"), try render(darkMode: true, view: Color.teal.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorTealLight() throws {
        XCTAssertEqual(plaf("30B0C7", macos: "59ADC4"), try render(view: Color.teal.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorCyanDark() throws {
        XCTAssertEqual(plaf("64D2FF", macos: "5AC8F5", android: "32ADE6"), try render(darkMode: true, view: Color.cyan.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorCyanLight() throws {
        XCTAssertEqual(plaf("32ADE6", macos: "55BEF0"), try render(view: Color.cyan.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorBlueDark() throws {
        XCTAssertEqual(plaf("0A84FF", android: "007AFF"), try render(darkMode: true, view: Color.blue.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorBlueLight() throws {
        XCTAssertEqual(plaf("007AFF"), try render(view: Color.blue.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorIndigoDark() throws {
        XCTAssertEqual(plaf("5E5CE6", android: "5856D6"), try render(darkMode: true, view: Color.indigo.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorIndigoLight() throws {
        XCTAssertEqual(plaf("5856D6"), try render(view: Color.indigo.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorPurpleDark() throws {
        XCTAssertEqual(plaf("BF5AF2", android: "AF52DE"), try render(darkMode: true, view: Color.purple.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorPurpleLight() throws {
        XCTAssertEqual(plaf("AF52DE"), try render(view: Color.purple.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorPinkDark() throws {
        XCTAssertEqual(plaf("FF375F", android: "FF2D55"), try render(darkMode: true, view: Color.pink.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorPinkLight() throws {
        XCTAssertEqual(plaf("FF2D55"), try render(view: Color.pink.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorBrownDark() throws {
        XCTAssertEqual(plaf("AC8E68", android: "A2845E"), try render(darkMode: true, view: Color.brown.frame(width: 1.0, height: 1.0)).pixmap)
    }

    func DISABLEDtestColorBrownLight() throws {
        XCTAssertEqual(plaf("A2845E"), try render(view: Color.brown.frame(width: 1.0, height: 1.0)).pixmap)
    }
}
