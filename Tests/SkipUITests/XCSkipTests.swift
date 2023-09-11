// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if canImport(SkipTest)
import SkipTest

/// This test case will run the transpiled tests for the Skip module.
@available(macOS 13, macCatalyst 16, *)
final class XCSkipTests: XCTestCase, XCGradleHarness {
    public func testSkipModule() async throws {
        // set device ID to run in Android emulator vs. robolectric
        try await runGradleTests(device: .none)
    }
}
#endif
