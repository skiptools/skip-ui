// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import Foundation
import SwiftUI
import XCTest
#if SKIP
import SkipModel
#endif

/// Direct-mode tests of the layered animation-transaction runtime:
/// `withAnimation` pushes a `Transaction` onto the `StateTracking` stack so writes inside
/// the body get the per-slot tx stamp, AND publishes the animation as a marker on exit for
/// render-time-resolved values. `Transaction` conforms to `StateMutationTransaction` so the
/// modifier-entry `animTx:` capture path can carry it.
final class TransactionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        #if SKIP
        // The marker is a static global — reset it so a prior test can't bleed in through
        // the post-exit window.
        Animation.resetRecentWithAnimationForTesting()
        #endif
    }

    // MARK: - withAnimation stack semantics

    func testWithAnimationPushesAndPopsTransaction() throws {
        #if !SKIP
        throw XCTSkip("transaction stack is Android-only")
        #else
        XCTAssertNil(StateTracking.currentTransaction)
        let snap = withAnimation(.linear(duration: 1)) {
            return StateTracking.currentTransaction
        }
        let tx = snap as? Transaction
        XCTAssertNotNil(tx, "withAnimation should push a Transaction onto the stack")
        XCTAssertNotNil(tx?.animation)
        XCTAssertNil(StateTracking.currentTransaction, "stack should be empty after withAnimation exits")
        #endif
    }

    func testWithAnimationPopsOnThrow() throws {
        #if !SKIP
        throw XCTSkip("transaction stack is Android-only")
        #else
        XCTAssertNil(StateTracking.currentTransaction)
        do {
            _ = try withAnimation(.linear(duration: 1)) { () throws -> Int in
                throw TransactionTestsBoom()
            }
            XCTFail("expected throw")
        } catch is TransactionTestsBoom {
            XCTAssertNil(StateTracking.currentTransaction, "transaction must be popped even on throw")
        }
        #endif
    }

    func testNestedWithAnimationRestoresOuter() throws {
        #if !SKIP
        throw XCTSkip("transaction stack is Android-only")
        #else
        let outer = withAnimation(.linear(duration: 1)) { () -> StateMutationTransaction? in
            let outerTx = StateTracking.currentTransaction
            withAnimation(.easeIn(duration: 0.25)) {
                let innerTx = StateTracking.currentTransaction
                XCTAssertNotNil(innerTx)
                XCTAssertFalse(innerTx === outerTx, "inner should be a distinct transaction")
            }
            XCTAssertTrue(StateTracking.currentTransaction === outerTx, "outer should be restored on inner pop")
            return outerTx
        }
        XCTAssertNotNil(outer)
        XCTAssertNil(StateTracking.currentTransaction)
        #endif
    }

    func testWithAnimationNilDoesNotPushTransaction() throws {
        #if !SKIP
        throw XCTSkip("transaction stack is Android-only")
        #else
        XCTAssertNil(StateTracking.currentTransaction)
        withAnimation(nil) {
            XCTAssertNil(StateTracking.currentTransaction, "nil animation must not push a transaction")
        }
        XCTAssertNil(StateTracking.currentTransaction)
        #endif
    }

    // MARK: - Marker fallback semantics

    /// After `withAnimation` exits, the recent-withAnimation marker is set for one Compose
    /// frame so render-time-resolved animatable values (e.g. `Shape.fill`) can pick it up.
    func testMarkerSetAfterWithAnimationExits() throws {
        #if !SKIP
        throw XCTSkip("isInWithAnimation marker is Android-only")
        #else
        XCTAssertFalse(Animation.isInWithAnimation)
        withAnimation(.linear(duration: 1)) {}
        XCTAssertTrue(Animation.isInWithAnimation, "marker should be set in the post-exit window")
        #endif
    }

    func testMarkerNotSetForNilWithAnimation() throws {
        #if !SKIP
        throw XCTSkip("isInWithAnimation marker is Android-only")
        #else
        XCTAssertFalse(Animation.isInWithAnimation)
        withAnimation(nil) {}
        XCTAssertFalse(Animation.isInWithAnimation, "nil animation should not publish marker")
        #endif
    }

    // MARK: - withTransaction

    func testWithTransactionPushesAndPopsTransaction() throws {
        #if !SKIP
        throw XCTSkip("transaction stack is Android-only")
        #else
        XCTAssertNil(StateTracking.currentTransaction)
        let custom = Transaction(animation: .easeOut(duration: 0.3))
        let captured = withTransaction(custom) {
            return StateTracking.currentTransaction
        }
        XCTAssertTrue(captured === custom, "the exact passed transaction should be on the stack")
        XCTAssertNil(StateTracking.currentTransaction)
        #endif
    }

    func testWithTransactionDisablesAnimationsSuppressesMarker() throws {
        #if !SKIP
        throw XCTSkip("withTransaction marker publishing is Android-only")
        #else
        let tx = Transaction(animation: .easeOut(duration: 0.3))
        tx.disablesAnimations = true
        withTransaction(tx) {}
        XCTAssertFalse(Animation.isInWithAnimation, "disablesAnimations=true should suppress the marker")
        #endif
    }

    /// Custom transaction key values: set/get by type-name string (Skip Lite workaround for
    /// generic-typed static members).
    func testTransactionCustomValues() throws {
        #if !SKIP
        throw XCTSkip("transaction custom-value storage is Android-only")
        #else
        let tx = Transaction()
        XCTAssertNil(tx.getCustomValue(forKeyTypeName: "MyKey"))
        tx.setCustomValue(forKeyTypeName: "MyKey", value: "hello")
        XCTAssertEqual("hello", tx.getCustomValue(forKeyTypeName: "MyKey") as? String)
        tx.setCustomValue(forKeyTypeName: "MyKey", value: 42)
        XCTAssertEqual(42, tx.getCustomValue(forKeyTypeName: "MyKey") as? Int)
        tx.setCustomValue(forKeyTypeName: "MyKey", value: nil)
        XCTAssertNil(tx.getCustomValue(forKeyTypeName: "MyKey"))
        #endif
    }

    // MARK: - SkipFuseUI bridge entry points

    func testBridgePreAndPostBalanced() throws {
        #if !SKIP
        throw XCTSkip("preBodyWithAnimation is Android-only")
        #else
        XCTAssertNil(StateTracking.currentTransaction)
        let wasInside = Animation.preBodyWithAnimation(.linear(duration: 1))
        XCTAssertFalse(wasInside)
        XCTAssertNotNil(StateTracking.currentTransaction, "bridge pre should push a transaction")
        Animation.postBodyWithAnimation()
        XCTAssertNil(StateTracking.currentTransaction, "bridge post should pop the transaction")
        XCTAssertTrue(Animation.isInWithAnimation, "marker should be published on post")
        #endif
    }

    func testBridgeNested() throws {
        #if !SKIP
        throw XCTSkip("preBodyWithAnimation is Android-only")
        #else
        let outerWasInside = Animation.preBodyWithAnimation(.linear(duration: 1))
        XCTAssertFalse(outerWasInside)
        let innerWasInside = Animation.preBodyWithAnimation(.easeOut(duration: 0.25))
        XCTAssertTrue(innerWasInside, "inner pre should observe outer is active")
        Animation.postBodyWithAnimation()
        XCTAssertNotNil(StateTracking.currentTransaction, "outer transaction should still be active after inner pop")
        Animation.postBodyWithAnimation()
        XCTAssertNil(StateTracking.currentTransaction)
        #endif
    }

    func testBridgePostWithoutPreIsHarmless() throws {
        #if !SKIP
        throw XCTSkip("preBodyWithAnimation is Android-only")
        #else
        Animation.postBodyWithAnimation()
        XCTAssertNil(StateTracking.currentTransaction)
        #endif
    }

    func testBridgeNilAnimationDoesNotPushOrMark() throws {
        #if !SKIP
        throw XCTSkip("preBodyWithAnimation is Android-only")
        #else
        _ = Animation.preBodyWithAnimation(nil)
        XCTAssertNil(StateTracking.currentTransaction, "nil bridge animation should not push")
        Animation.postBodyWithAnimation()
        XCTAssertFalse(Animation.isInWithAnimation, "nil bridge animation should not mark")
        #endif
    }

    // MARK: - Bridged provenance priming (SkipFuseUI native provenance)

    /// `primeBridgedProvenance(animation)` seeds the read cursor with a transaction carrying
    /// the animation, so the next animatable modifier impl's entry capture consumes it.
    func testPrimeBridgedProvenanceSeedsCursor() throws {
        #if !SKIP
        throw XCTSkip("primeBridgedProvenance is Android-only")
        #else
        Animation.primeBridgedProvenance(.linear(duration: 1))
        let captured = StateTracking.captureLastReadAndClear()
        let tx = captured as? Transaction
        XCTAssertNotNil(tx, "prime should seed a Transaction into the cursor")
        XCTAssertNotNil(tx?.animation)
        XCTAssertNil(StateTracking.captureLastReadAndClear(), "capture should have cleared the cursor")
        #endif
    }

    /// Priming nil explicitly clears the cursor — even when a stale read was recorded — so
    /// the modifier snaps deterministically.
    func testPrimeBridgedProvenanceNilClearsStaleCursor() throws {
        #if !SKIP
        throw XCTSkip("primeBridgedProvenance is Android-only")
        #else
        withAnimation(.linear(duration: 1)) {}
        StateTracking.recordRead(Transaction(animation: .easeOut(duration: 1)))
        Animation.primeBridgedProvenance(nil)
        XCTAssertNil(StateTracking.captureLastReadAndClear(), "prime(nil) must clear any stale cursor")
        #endif
    }

    /// Priming overwrites a stale cursor value rather than being dropped by first-read-wins.
    func testPrimeBridgedProvenanceOverwritesStaleCursor() throws {
        #if !SKIP
        throw XCTSkip("primeBridgedProvenance is Android-only")
        #else
        StateTracking.recordRead(Transaction(animation: .easeOut(duration: 9)))
        Animation.primeBridgedProvenance(.linear(duration: 1))
        let tx = StateTracking.captureLastReadAndClear() as? Transaction
        XCTAssertNotNil(tx?.animation)
        // The primed animation wins; the stale easeOut must not survive.
        // (Animation equality is structural via Hashable on the Compose spec.)
        XCTAssertEqual(tx?.animation, Animation.linear(duration: 1))
        #endif
    }

    // MARK: - Two-slot semantic (the core "two squares" case)

    /// The salvage-plan invariant: a write to slot A inside `withAnimation` stamps A's
    /// transaction; a concurrent write to slot B outside `withAnimation` leaves B unstamped.
    /// Reading A returns the tx; reading B returns nil. This is what makes the red square
    /// animate and the green square snap in Showcase's AnimationPlayground.
    func testTwoSlotIndependentAnimationProvenance() throws {
        #if !SKIP
        throw XCTSkip("MutableStateBacking is Android-only")
        #else
        let backing = MutableStateBacking()
        backing.trackState()

        withAnimation(.linear(duration: 1)) {
            backing.update(stateAt: 0)
        }
        backing.update(stateAt: 1)

        let red = StateTracking.captureRead { () -> Int in
            backing.access(stateAt: 0)
            return 0
        }
        let green = StateTracking.captureRead { () -> Int in
            backing.access(stateAt: 1)
            return 0
        }
        XCTAssertNotNil(red.transaction, "slot 0 (inside withAnimation) must carry a transaction")
        XCTAssertNil(green.transaction, "slot 1 (outside withAnimation) must NOT carry a transaction")
        #endif
    }
}

private struct TransactionTestsBoom: Error {}
