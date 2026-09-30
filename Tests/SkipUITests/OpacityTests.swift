// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest
import OSLog
import Foundation

final class OpacityTests: XCSnapshotTestCase {
    /// Black content that draws 5 wide inside a 1 wide layout frame, on a white 5x1 background.
    private func overflowingContent(opacity: Double?) -> AnyView {
        let base = Color.black.frame(width: 5.0, height: 1.0).frame(width: 1.0, height: 1.0)
        let content = opacity == nil ? AnyView(base) : AnyView(base.opacity(opacity!))
        return AnyView(ZStack {
            Color.white
            content
        }
        .frame(width: 5.0, height: 1.0))
    }

    /// The rendered pixels. Emulators scale by display density, so tests compare the ends of the
    /// row rather than an exact pixel count.
    private func pixels(_ view: AnyView) throws -> [String] {
        return try render(view: view).pixmap.split(separator: " ").map { String($0) }
    }

    /// `opacity` must not clip what its content draws outside the layout bounds: the layer it
    /// composites into is bounded by the clip, not by the 1 wide frame. An unbounded `blur()`
    /// underneath an `opacity()` depends on this.
    func testOpacityDoesNotClipOverflowingContent() throws {
        let pixels = try pixels(overflowingContent(opacity: 0.5))
        XCTAssertEqual(false, pixels.isEmpty)
        for pixel in [pixels.first!, pixels.last!] {
            XCTAssertNotEqual("FFFFFF", pixel) // the overflow reaches the edge
            XCTAssertNotEqual("000000", pixel) // and it is dimmed
        }
    }

    /// Control: without `opacity` the same content covers the full width.
    func testOverflowingContentWithoutOpacity() throws {
        let pixels = try pixels(overflowingContent(opacity: nil))
        XCTAssertEqual(false, pixels.isEmpty)
        XCTAssertEqual("000000", pixels.first!)
        XCTAssertEqual("000000", pixels.last!)
    }

    /// Control: `opacity` still dims uniformly.
    func testOpacityDims() throws {
        let view = AnyView(ZStack {
            Color.white
            Color.black.frame(width: 5.0, height: 1.0).opacity(0.5)
        }
        .frame(width: 5.0, height: 1.0))
        let pixels = try pixels(view)
        XCTAssertEqual(false, pixels.isEmpty)
        for pixel in pixels {
            XCTAssertNotEqual("FFFFFF", pixel)
            XCTAssertNotEqual("000000", pixel)
            XCTAssertEqual(pixels.first!, pixel)
        }
    }
}
