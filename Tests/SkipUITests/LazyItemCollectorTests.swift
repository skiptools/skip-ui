// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import SwiftUI

#if SKIP
// MARK: - Lazy Item Collector Tests
final class LazyItemCollectorTests: XCTestCase {

    func testGroupedOffsetsAndIdentitiesIncludeSectionChrome() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()

        // Act
        for section in 0..<500 {
            _ = fixture.collector.sectionHeader(listOf(), section)
            fixture.collector.indexedItems(
                0..<3,
                { index in section * 10 + (index as! Int) },
                nil,
                nil,
                0,
                { _, _ in EmptyView() }
            )
            _ = fixture.collector.sectionFooter(listOf(), section)
        }

        // Assert
        XCTAssertEqual(fixture.collector.count, 3_500)
        XCTAssertEqual(fixture.offsets.count, 500)
        XCTAssertEqual(fixture.offsets.first, 2)
        XCTAssertEqual(fixture.offsets.last, 3_495)
        XCTAssertEqual(fixture.collector.index(for: 4_992), 3_498)
        XCTAssertEqual(fixture.collector.id(for: 3_498) as? Int, 4_992)
        XCTAssertNil(fixture.collector.id(for: 3_499))
    }

    func testSectionCornersFollowFirstAndLastRowsInEachSection() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()

        // Act
        _ = fixture.collector.sectionHeader(listOf(), "first")
        fixture.collector.indexedItems(0..<3, nil, nil, nil, 0, { _, _ in EmptyView() })
        _ = fixture.collector.sectionFooter(listOf(), "first")
        _ = fixture.collector.sectionHeader(listOf(), "second")
        fixture.collector.indexedItems(0..<1, nil, nil, nil, 0, { _, _ in EmptyView() })
        _ = fixture.collector.sectionFooter(listOf(), "second")

        // Assert
        XCTAssertTrue(fixture.collector.isFirstInSection(3))
        XCTAssertFalse(fixture.collector.isLastInSection(3))
        XCTAssertFalse(fixture.collector.isFirstInSection(4))
        XCTAssertFalse(fixture.collector.isLastInSection(4))
        XCTAssertFalse(fixture.collector.isFirstInSection(5))
        XCTAssertTrue(fixture.collector.isLastInSection(5))
        XCTAssertTrue(fixture.collector.isFirstInSection(10))
        XCTAssertTrue(fixture.collector.isLastInSection(10))
        XCTAssertFalse(fixture.collector.isFirstInSection(8))
        XCTAssertFalse(fixture.collector.isLastInSection(9))
    }

    func testConditionalEmptyRowsTransferCornersToRemainingVisibleRow() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()
        _ = fixture.collector.sectionHeader(listOf(), "section")
        fixture.collector.indexedItems(0..<5, nil, nil, nil, 0, { _, _ in EmptyView() })
        _ = fixture.collector.sectionFooter(listOf(), "section")

        // Act
        for index in [3, 4, 6, 7] {
            fixture.collector.recordEmptyItem(index, isEmpty: true)
        }

        // Assert
        XCTAssertTrue(fixture.collector.isFirstInSection(5))
        XCTAssertTrue(fixture.collector.isLastInSection(5))

        // Act
        fixture.collector.recordEmptyItem(4, isEmpty: false)
        fixture.collector.recordEmptyItem(6, isEmpty: false)

        // Assert
        XCTAssertTrue(fixture.collector.isFirstInSection(4))
        XCTAssertFalse(fixture.collector.isFirstInSection(5))
        XCTAssertFalse(fixture.collector.isLastInSection(5))
        XCTAssertTrue(fixture.collector.isLastInSection(6))
    }

    func testLayoutChangeDiscardsPreviousEmptyRowPositions() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()
        _ = fixture.collector.sectionHeader(listOf(), "section")
        fixture.collector.indexedItems(0..<3, nil, nil, nil, 0, { _, _ in EmptyView() })
        _ = fixture.collector.sectionFooter(listOf(), "section")
        fixture.collector.recordEmptyItem(3, isEmpty: true)
        fixture.collector.recordEmptyItem(5, isEmpty: true)
        XCTAssertTrue(fixture.collector.isFirstInSection(4))
        XCTAssertTrue(fixture.collector.isLastInSection(4))

        // Act
        fixture.collector.resetEmptyItems()

        // Assert
        XCTAssertTrue(fixture.collector.isFirstInSection(3))
        XCTAssertFalse(fixture.collector.isFirstInSection(4))
        XCTAssertFalse(fixture.collector.isLastInSection(4))
        XCTAssertTrue(fixture.collector.isLastInSection(5))
    }

    func testDeletingRowsRecomputesSectionBoundaries() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()
        _ = fixture.collector.sectionHeader(listOf(), "section")
        fixture.collector.indexedItems(0..<3, nil, nil, nil, 0, { _, _ in EmptyView() })
        _ = fixture.collector.sectionFooter(listOf(), "section")
        XCTAssertTrue(fixture.collector.isLastInSection(5))

        // Act
        fixture.initialize()
        _ = fixture.collector.sectionHeader(listOf(), "section")
        fixture.collector.indexedItems(0..<1, nil, nil, nil, 0, { _, _ in EmptyView() })
        _ = fixture.collector.sectionFooter(listOf(), "section")

        // Assert
        XCTAssertTrue(fixture.collector.isFirstInSection(3))
        XCTAssertTrue(fixture.collector.isLastInSection(3))
        XCTAssertFalse(fixture.collector.isLastInSection(5))
    }

    func testReinitializingResetsCollectedCount() {
        // Arrange
        let fixture = CollectorFixture()

        // Act
        fixture.initialize()
        fixture.collector.item(EmptyView(), 0)

        let initialCount = fixture.collector.count
        fixture.initialize()
        let resetCount = fixture.collector.count

        fixture.collector.indexedItems(0..<4, nil, nil, nil, 0, { _, _ in EmptyView() })

        // Assert
        XCTAssertEqual(initialCount, 1)
        XCTAssertEqual(resetCount, 0)
        XCTAssertEqual(fixture.collector.count, 4)
        XCTAssertEqual(fixture.offsets.last, 0)
    }

    func testBindingRangesRetainLiveOffsets() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()
        var values: any RandomAccessCollection<Any> = [1, 2]
        let binding = Binding<any RandomAccessCollection<Any>>(
            get: { values },
            set: { values = $0 }
        )

        // Act
        fixture.collector.objectBindingItems(
            binding,
            { $0 as? Int },
            EditActions(rawValue: 0),
            nil,
            nil,
            0,
            { _, _, _ in EmptyView() }
        )

        let initialCount = fixture.collector.count
        values = [1, 2, 3, 4]
        fixture.collector.indexedItems(0..<1, nil, nil, nil, 0, { _, _ in EmptyView() })

        // Assert
        XCTAssertEqual(initialCount, 2)
        XCTAssertEqual(fixture.offsets.last, 4)
        XCTAssertEqual(fixture.collector.count, 5)
    }

    func testMixedRangesPreserveMoveBoundariesAndOffsets() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()
        var movedFrom: Int? = nil
        var movedTo: Int? = nil

        // Act
        _ = fixture.collector.sectionHeader(listOf(), "first")
        fixture.collector.indexedItems(
            10..<13,
            { $0 as? Int },
            nil,
            { indexes, destination in
                movedFrom = indexes.first
                movedTo = destination
            },
            0,
            { _, _ in EmptyView() }
        )
        _ = fixture.collector.sectionFooter(listOf(), "first")
        fixture.collector.objectItems(["a", "b"], { $0 as? String }, nil, nil, 0, { _, _ in EmptyView() })

        let count = fixture.collector.count
        let objectIndex = fixture.collector.index(for: "a")
        let objectIdentity = fixture.collector.id(for: 11) as? String
        let canMoveWithinSection = fixture.collector.canMove(from: 3, to: 5)
        let canMoveAcrossSections = fixture.collector.canMove(from: 3, to: 10)
        let canMoveToHeader = fixture.collector.canMove(from: 3, to: 2)
        fixture.collector.move(from: 3, to: 5, trigger: { _ in })
        let remappedFirst = fixture.collector.remapIndex(0, from: 2)
        let remappedLast = fixture.collector.remapIndex(2, from: 2)
        fixture.collector.commitMove()

        // Assert
        XCTAssertEqual(count, 11)
        XCTAssertEqual(objectIndex, 10)
        XCTAssertEqual(objectIdentity, "b")
        XCTAssertTrue(canMoveWithinSection)
        XCTAssertFalse(canMoveAcrossSections)
        XCTAssertFalse(canMoveToHeader)
        XCTAssertEqual(remappedFirst, 1)
        XCTAssertEqual(remappedLast, 0)
        XCTAssertEqual(movedFrom, 0)
        XCTAssertEqual(movedTo, 3)
        XCTAssertFalse(fixture.collector.hasActiveMove)
    }

    func testBindingShrinkAndReinitializePreserveLiveIdentityLookup() {
        // Arrange
        let fixture = CollectorFixture()
        fixture.initialize()
        var values: any RandomAccessCollection<Any> = [1, 2, 3]
        let binding = Binding<any RandomAccessCollection<Any>>(get: { values }, set: { values = $0 })
        fixture.collector.objectBindingItems(
            binding, { $0 as? Int }, EditActions(rawValue: 0), nil, nil, 0,
            { _, _, _ in EmptyView() }
        )

        // Act
        values = [3]

        let shrunkCount = fixture.collector.count
        let remainingIndex = fixture.collector.index(for: 3)
        let remainingIdentity = fixture.collector.id(for: 1) as? Int
        let removedIndex = fixture.collector.index(for: 2)

        fixture.initialize()
        fixture.collector.indexedItems(0..<2, nil, nil, nil, 0, { _, _ in EmptyView() })
        values = []

        // Assert
        XCTAssertEqual(shrunkCount, 1)
        XCTAssertEqual(remainingIndex, 1)
        XCTAssertEqual(remainingIdentity, 3)
        XCTAssertNil(removedIndex)
        XCTAssertEqual(fixture.collector.count, 2)
    }
}

// MARK: - Helpers
private extension LazyItemCollectorTests {

    final class CollectorFixture {
        let collector = LazyItemCollector()
        var offsets: [Int] = []

        /// Initializes callbacks with two lazy slots for each section header and footer.
        func initialize() {
            offsets = []
            collector.initialize(
                startItemIndex: 1,
                item: { _, _ in },
                indexedItems: { _, _, offset, _, _, _, _ in self.offsets.append(offset) },
                objectItems: { _, _, offset, _, _, _, _ in self.offsets.append(offset) },
                objectBindingItems: { _, _, offset, _, _, _, _, _ in self.offsets.append(offset) },
                sectionHeader: { _, _ in 2 },
                sectionFooter: { _, _, _ in 2 }
            )
        }
    }
}
#endif
