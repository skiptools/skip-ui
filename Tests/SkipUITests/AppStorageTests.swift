// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest
#if SKIP
import SkipModel
#endif

final class AppStorageTests: XCTestCase {

    /// A value stored under one primitive type and read through an `@AppStorage` of another
    /// must coerce (as `UserDefaults` does on iOS) rather than let the mismatched type through,
    /// which crashed a later consumer with a `ClassCastException` (issue #317).
    func testAppStorageCoercesStringToDouble() throws {
        #if !SKIP
        throw XCTSkip("@AppStorage type coercion is Android-only")
        #else
        let defaults = UserDefaults.standard
        let key = "SkipUITests.appStorageStringToDouble"
        defaults.removeObject(forKey: key)

        defaults.set("1.0", forKey: key) // stored as a String
        let storage = AppStorage(wrappedValue: 0.0, key) // read as a Double
        storage.trackState()
        XCTAssertEqual(storage.wrappedValue, 1.0)

        defaults.removeObject(forKey: key)
        #endif
    }

    /// An integer stored value read through a `Double`-typed `@AppStorage` should coerce as well.
    func testAppStorageCoercesIntToDouble() throws {
        #if !SKIP
        throw XCTSkip("@AppStorage type coercion is Android-only")
        #else
        let defaults = UserDefaults.standard
        let key = "SkipUITests.appStorageIntToDouble"
        defaults.removeObject(forKey: key)

        defaults.set(3, forKey: key) // stored as an Int
        let storage = AppStorage(wrappedValue: 0.0, key) // read as a Double
        storage.trackState()
        XCTAssertEqual(storage.wrappedValue, 3.0)

        defaults.removeObject(forKey: key)
        #endif
    }
}
