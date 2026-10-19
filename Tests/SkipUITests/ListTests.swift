// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import SwiftUI

#if SKIP
// MARK: - List Tests
final class ListTests: XCTestCase {

    func testFooterPlacementBatchesInitialSections() {
        // Arrange
        let placement = List.SectionChromeAnimationState()

        // Act
        let first = placement.prepare(sectionKey: "first", previousCount: nil, currentCount: 3)
        let second = placement.prepare(sectionKey: "second", previousCount: nil, currentCount: 5)
        let initiallyReady = first.value || second.value
        let scheduledFirstFrame = placement.beginFrame()
        let scheduledDuplicateFrame = placement.beginFrame()
        placement.completeFrame()
        let scheduledEmptyFrame = placement.beginFrame()

        // Assert
        XCTAssertFalse(initiallyReady)
        XCTAssertTrue(scheduledFirstFrame)
        XCTAssertFalse(scheduledDuplicateFrame)
        XCTAssertTrue(first.value)
        XCTAssertTrue(second.value)
        XCTAssertFalse(scheduledEmptyFrame)
    }

    func testFooterPlacementPreservesSmallChanges() {
        // Arrange
        let placement = List.SectionChromeAnimationState()
        let initial = placement.prepare(sectionKey: "section", previousCount: nil, currentCount: 3)
        _ = placement.beginFrame()
        placement.completeFrame()

        // Act
        let updated = placement.prepare(sectionKey: "section", previousCount: 3, currentCount: 4)
        let scheduledFrame = placement.beginFrame()

        // Assert
        XCTAssertTrue(updated === initial)
        XCTAssertTrue(updated.value)
        XCTAssertFalse(scheduledFrame)
    }

    func testFooterPlacementResetsOnlyBulkUpdatedSection() {
        // Arrange
        let placement = List.SectionChromeAnimationState()
        let first = placement.prepare(sectionKey: "first", previousCount: nil, currentCount: 3)
        let second = placement.prepare(sectionKey: "second", previousCount: nil, currentCount: 5)
        _ = placement.beginFrame()
        placement.completeFrame()

        // Act
        _ = placement.prepare(sectionKey: "second", previousCount: 5, currentCount: 20)
        let firstRemainedReady = first.value
        let secondWasReset = !second.value
        let scheduledFrame = placement.beginFrame()
        placement.completeFrame()

        // Assert
        XCTAssertTrue(firstRemainedReady)
        XCTAssertTrue(secondWasReset)
        XCTAssertTrue(scheduledFrame)
        XCTAssertTrue(second.value)
    }

    func testFooterPlacementReleasesRemovedSections() {
        // Arrange
        let placement = List.SectionChromeAnimationState()
        let removed = placement.prepare(sectionKey: "removed", previousCount: nil, currentCount: 3)
        let retained = placement.prepare(sectionKey: "retained", previousCount: nil, currentCount: 5)
        _ = placement.beginFrame()

        // Act
        placement.retainSections(kotlin.collections.setOf("retained"))
        placement.completeFrame()
        let existing = placement.prepare(sectionKey: "retained", previousCount: 5, currentCount: 5)
        let recreated = placement.prepare(sectionKey: "removed", previousCount: nil, currentCount: 3)

        // Assert
        XCTAssertFalse(removed.value)
        XCTAssertTrue(retained.value)
        XCTAssertTrue(existing === retained)
        XCTAssertFalse(recreated === removed)
    }
}
#endif
