// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import XCTest
@testable import SkipUI

/// Issue #545: the navigation back button cannot announce a hard-coded English "Back".
final class NavigationBackLabelTests: XCTestCase {
    func testFrenchBackButtonMatchesTheSystemWord() {
        XCTAssertEqual(NavigationAccessibilityLabel.backButton(locale: Locale(identifier: "fr_FR")), "Retour")
    }

    func testEnglishBackButton() {
        XCTAssertEqual(NavigationAccessibilityLabel.backButton(locale: Locale(identifier: "en_US")), "Back")
    }

    func testGermanAndJapaneseBackButtons() {
        XCTAssertEqual(NavigationAccessibilityLabel.backButton(locale: Locale(identifier: "de_DE")), "Zurück")
        XCTAssertEqual(NavigationAccessibilityLabel.backButton(locale: Locale(identifier: "ja_JP")), "戻る")
        XCTAssertEqual(NavigationAccessibilityLabel.backButton(locale: Locale(identifier: "zh_CN")), "返回")
    }

    func testUnknownLocaleFallsBackToEnglish() {
        XCTAssertEqual(NavigationAccessibilityLabel.backButton(locale: Locale(identifier: "zz")), "Back")
    }
}
