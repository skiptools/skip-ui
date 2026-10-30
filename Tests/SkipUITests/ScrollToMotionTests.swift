// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
@testable import SkipUI

/// Issue #469: `scrollTo` animates only for a transaction that is active on that call.
/// A withAnimation that has already exited leaves a marker and must not animate the scroll.
final class ScrollToMotionTests: XCTestCase {
    func testScrollToDoesNotInheritAFinishedWithAnimation() {
        XCTAssertFalse(ScrollToMotion.shouldAnimate(activeAnimatedTransaction: false, recentWithAnimationMarker: true))
    }

    func testScrollToAnimatesInsideWithAnimation() {
        XCTAssertTrue(ScrollToMotion.shouldAnimate(activeAnimatedTransaction: true, recentWithAnimationMarker: false))
    }

    func testScrollToStaysInstantWithNoTransaction() {
        XCTAssertFalse(ScrollToMotion.shouldAnimate(activeAnimatedTransaction: false, recentWithAnimationMarker: false))
    }
}
