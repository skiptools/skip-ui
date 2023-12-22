// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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


class SkipUITestCase : XCTestCase {

    #if SKIP
    @org.junit.Rule private let _testName: org.junit.rules.TestName = org.junit.rules.TestName()
    #endif

    private var testName: String? {
        #if SKIP
        _testName.methodName
        #else
        testRun?.test.name
        #endif
    }

    override func setUp() {
        // this is where we could try to identify whether we are just running a single test case, and if so, we can run the `gradle test` command with flags to filter the test cases to just run the single transpiled equivalent test case – see https://github.com/skiptools/skip-unit/issues/1
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
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
