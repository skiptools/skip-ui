import Foundation
import Combine
import XCTest

final class ObservationTests: XCTestCase {
    // Disabled for CI
    func XXXtestObservation() throws {
        let ob = ObOb(intProp: 1, stringProp: "two")

        #if !SKIP
        var changeCount = 0
        let cancellable = ob.objectWillChange.sink { _ in
            changeCount += 1
        }
        XCTAssertEqual(0, changeCount)
        #endif

        XCTAssertEqual(1, ob.intProp)
        XCTAssertEqual("two", ob.stringProp)

        ob.intProp += 1
        ob.stringProp = "three"

        XCTAssertEqual(2, ob.intProp)
        XCTAssertEqual("three", ob.stringProp)

        #if !SKIP
        XCTAssertEqual(2, changeCount)
        _ = cancellable
        #endif
    }


    class ObOb : ObservableObject {
        @Published var intProp: Int
        @Published var stringProp: String
        @Published var optionalProp: String?

        init(intProp: Int, stringProp: String, optionalProp: String? = nil) {
            self.intProp = intProp
            self.stringProp = stringProp
            self.optionalProp = optionalProp
        }
    }
}

