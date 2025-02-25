// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import Foundation
import XCTest

#if os(macOS)
import SkipTest

/// This test case will run the transpiled tests for the Skip module.
@available(macOS 13, macCatalyst 16, *)
final class XCSkipTests: XCTestCase, XCGradleHarness {
    public func testSkipModule() async throws {
        // set device ID to run in Android emulator vs. robolectric
        try await runGradleTests()
    }
}
#endif


open class SkipUITestCase : XCTestCase {

    #if SKIP
    // must be public and be prefixed wit "@get:" or else org.junit.runners.model.InvalidTestClassError: "The @Rule '_testName' must be public"
    // SKIP INSERT: @get:org.junit.Rule
    public let _testName: org.junit.rules.TestName = org.junit.rules.TestName()
    #endif

    public var testName: String? {
        #if SKIP
        let tname = _testName.methodName // "testLocalizedText$SkipUI_debugUnitTest"
        return tname.split(separator: Char("$")).first
        #else
        let tname = testRun?.test.name // "-[SkipUITests testLocalizedText]"
        return tname?
            .trimmingCharacters(in: CharacterSet(charactersIn: "-[]"))
            .split(separator: " ")
            .last?
            .description
        #endif
    }

    open override func setUp() {
        super.setUp()

        // this is where we could try to identify whether we are just running a single test case, and if so, we can run the `gradle test` command with flags to filter the test cases to just run the single transpiled equivalent test case – see https://github.com/skiptools/skip-unit/issues/1
        let filteredTestCase: String? = nil

        if let filteredTestCase = filteredTestCase {
            if self.testName != filteredTestCase {
                #if SKIP
                throw XCTSkip("skipping filtered test \(self.testName)")
                #endif
            } else {
                // we are running a restricted
                #if !SKIP
                // TODO: launch gradle with the correct arguments to run the tests with the filtered test case
                #endif
            }
        }
    }

    open override func tearDown() {
        super.tearDown()
    }
}

public class TestIntrospectionTests : SkipUITestCase {
    func testTestIntrospection() {
        XCTAssertEqual("testTestIntrospection", self.testName)
    }
}

/// True when running in a transpiled Java runtime environment
let isJava = ProcessInfo.processInfo.environment["java.io.tmpdir"] != nil
/// True when running within an Android environment (either an emulator or device)
let isAndroid = isJava && ProcessInfo.processInfo.environment["ANDROID_ROOT"] != nil
/// True is the transpiled code is currently running in the local Robolectric test environment
let isRobolectric = isJava && !isAndroid
#if os(macOS)
let isMacOS = true
#else
let isMacOS = false
#endif
#if os(iOS)
let isIOS = true
#else
let isIOS = false
#endif
#if os(Linux)
let isLinux = true
#else
let isLinux = false
#endif
