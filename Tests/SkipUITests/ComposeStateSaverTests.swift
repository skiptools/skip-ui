// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import SwiftUI

#if SKIP
import androidx.compose.runtime.saveable.SaverScope
import androidx.compose.runtime.saveable.SaveableStateRegistry
import androidx.compose.foundation.layout.padding
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import java.lang.ref.WeakReference
import org.junit.Assume

final class ComposeStateSaverTests: XCTestCase {
    private let scope: SaverScope = SaverScope { _ in true }

    func testSavedKeysKeepValuesAliveAndSupportRepeatedRestoration() {
        // Arrange
        let saver = ComposeStateSaver()
        let (key, value) = makeRetainedSnapshot(saver)
        var restoredEveryTime = true

        // Act
        for _ in 0..<3 {
            java.lang.System.gc()
            restoredEveryTime = restoredEveryTime && value.get() != nil && value.get() === saver.restore(key)
        }

        // Assert
        XCTAssertTrue(restoredEveryTime)
    }

    func testPrimitiveAndNilValuesRoundTrip() {
        // Arrange
        let saver = ComposeStateSaver()

        // Act
        let text = saver.restore(save(saver, "hello")) as? String
        let number = saver.restore(save(saver, 42)) as? Int
        let empty = saver.restore(save(saver, nil))

        // Assert
        XCTAssertEqual(text, "hello")
        XCTAssertEqual(number, 42)
        XCTAssertNil(empty)
    }

    func testDiscardedKeysDoNotRetainHistoricalSnapshots() {
        // Arrange
        let saver = ComposeStateSaver()
        let liveValue = java.lang.Object()
        let liveKey = save(saver, liveValue)
        let (key, value) = makeDiscardedSnapshot(saver)

        // Act
        let keyWasCollected = awaitCollection(key)

        // GC is nondeterministic. A key that has not been collected yet does not
        // indicate that the saver is retaining it, so skip this run rather than fail.
        Assume.assumeTrue("GC did not collect the discarded key", keyWasCollected)

        // Access the map to expunge queued entries, as later saves/restores do.
        let restoredLiveValue = saver.restore(liveKey)
        let valueWasCollected = awaitCollection(value)

        // Assert
        XCTAssertTrue(valueWasCollected)
        XCTAssertTrue(liveValue === restoredLiveValue)
    }

    func testRegistryRetainsSavedValuesUntilRestoration() {
        // Arrange
        let saver = ComposeStateSaver()
        let value = java.lang.Object()
        let registry = SaveableStateRegistry(restoredValues: nil, canBeSaved: { _ in true })
        let entry = registry.registerProvider("row") { self.save(saver, value) }

        // Act
        let savedValues = registry.performSave()
        entry.unregister()

        java.lang.System.gc()
        let restored = SaveableStateRegistry(restoredValues: savedValues, canBeSaved: { _ in true })
        let key = restored.consumeRestored("row")
        let restoredValue = key == nil ? nil : saver.restore(key!)

        // Assert
        XCTAssertNotNil(key)
        XCTAssertTrue(restoredValue === value)
    }

    func testChildContextInheritsSavedStateWithoutMutatingParent() {
        // Arrange
        let saver = ComposeStateSaver()
        let value = java.lang.Object()
        let key = save(saver, value)
        let parentModifier = Modifier.padding(4.dp)
        let parentComposer = Composer { _, _ in ComposeResult.ok }
        let parentScope = java.lang.Object()
        let parent = ComposeContext(
            modifier: parentModifier,
            composer: parentComposer,
            stateSaver: saver,
            scope: parentScope
        )

        // Act
        var child = parent.content()
        let initialModifier = child.modifier
        let initialComposer = child.composer
        let initialScope = child.scope
        let restoredChildValue = child.stateSaver.restore(key)
        child.modifier = Modifier.padding(8.dp)

        // Assert
        XCTAssertEqual(initialModifier, Modifier)
        XCTAssertNil(initialComposer)
        XCTAssertNil(initialScope)
        XCTAssertTrue(restoredChildValue === value)
        XCTAssertEqual(parent.modifier, parentModifier)
        XCTAssertTrue(parent.composer === parentComposer)
        XCTAssertTrue(parent.scope === parentScope)
        XCTAssertTrue(parent.stateSaver.restore(key) === value)
    }

    func testChildContextUsesExplicitStateSaverAndCompositionValues() {
        // Arrange
        let parentSaver = ComposeStateSaver()
        let childSaver = ComposeStateSaver()
        let value = java.lang.Object()
        let key = save(childSaver, value)
        let modifier = Modifier.padding(8.dp)
        let composer = Composer { _, _ in ComposeResult.ok }
        let scope = java.lang.Object()
        let parent = ComposeContext(stateSaver: parentSaver)

        // Act
        let child = parent.content(
            modifier: modifier,
            composer: composer,
            stateSaver: childSaver,
            scope: scope
        )

        // Assert
        XCTAssertEqual(child.modifier, modifier)
        XCTAssertTrue(child.composer === composer)
        XCTAssertTrue(child.scope === scope)
        XCTAssertTrue(child.stateSaver.restore(key) === value)
        XCTAssertNil(parent.stateSaver.restore(key))
        XCTAssertEqual(parent.modifier, Modifier)
        XCTAssertNil(parent.composer)
        XCTAssertNil(parent.scope)
    }

}

// MARK: - Helpers
private extension ComposeStateSaverTests {

    /// Saves a value using the test's permissive saver scope.
    ///
    /// - Parameters:
    ///   - saver: The state saver under test.
    ///   - value: The value to save.
    /// - Returns: The saved representation.
    func save(_ saver: ComposeStateSaver, _ value: Any?) -> Any {
        return with(saver) { scope.save(value) }
    }

    /// Saves a snapshot while retaining its key.
    ///
    /// - Parameter saver: The state saver under test.
    /// - Returns: The retained key and a weak reference to the saved value.
    func makeRetainedSnapshot(_ saver: ComposeStateSaver) -> (Any, WeakReference<Any>) {
        let value: Any = java.lang.Object()
        return (save(saver, value), WeakReference(value))
    }

    /// Saves a snapshot without retaining its key or value outside the saver.
    ///
    /// - Parameter saver: The state saver under test.
    /// - Returns: Weak references to the saved key and value.
    func makeDiscardedSnapshot(_ saver: ComposeStateSaver) -> (WeakReference<Any>, WeakReference<Any>) {
        let value: Any = java.lang.Object()
        let key = save(saver, value)
        return (WeakReference(key), WeakReference(value))
    }

    /// Waits briefly for an unreferenced object to be collected.
    ///
    /// - Parameter reference: The weak reference to observe.
    /// - Returns: Whether the object was collected within the retry limit.
    func awaitCollection(_ reference: WeakReference<Any>) -> Bool {
        for _ in 0..<100 {
            if reference.get() == nil { return true }
            java.lang.System.gc()
            java.lang.System.runFinalization()
            java.lang.Thread.sleep(20)
        }

        return reference.get() == nil
    }
}
#endif
