// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

final class PathContainmentTests: XCTestCase {
    func testTriangleUsesContour() {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 100))
        path.closeSubpath()

        XCTAssertTrue(path.contains(CGPoint(x: 20, y: 20)))
        XCTAssertFalse(path.contains(CGPoint(x: 80, y: 80)))
    }

    func testEllipseExcludesBoundingBoxCorners() {
        let path = Path(ellipseIn: CGRect(x: 20, y: 30, width: 100, height: 60))

        XCTAssertTrue(path.contains(CGPoint(x: 70, y: 60)))
        XCTAssertFalse(path.contains(CGPoint(x: 21, y: 31)))
    }

    func testClosingEdgeContributesToContainment() {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 100))
        path.closeSubpath()

        XCTAssertTrue(path.contains(CGPoint(x: 20, y: 80)))
        XCTAssertFalse(path.contains(CGPoint(x: 80, y: 20)))
    }

    func testOpenContoursAreImplicitlyClosed() {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 100))
        path.move(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: 300, y: 100))

        XCTAssertTrue(path.contains(CGPoint(x: 20, y: 80)))
        XCTAssertFalse(path.contains(CGPoint(x: 80, y: 20)))
        XCTAssertTrue(path.contains(CGPoint(x: 220, y: 80)))
        XCTAssertFalse(path.contains(CGPoint(x: 280, y: 20)))
    }

    func testFillRuleAppliesIndependentlyToEachQuery() {
        var path = Path()
        path.addRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        path.addRect(CGRect(x: 25, y: 25, width: 50, height: 50))
        let center = CGPoint(x: 50, y: 50)

        XCTAssertTrue(path.contains(center))
        XCTAssertFalse(path.contains(center, eoFill: true))
        XCTAssertTrue(path.contains(center))
        XCTAssertTrue(path.contains(CGPoint(x: 10, y: 10), eoFill: true))
    }
}
