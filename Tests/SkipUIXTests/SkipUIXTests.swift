// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import XCTest
// the CI workflow at .github/workflows/ci.yml will run with both Debug "import SkipUI" and Release "import SwiftUI"
#if DEBUG
import SkipUIX
#else
import SwiftUI
#endif

final class SkipUITests: XCTestCase {
    func testExampleAssert() throws {
        XCTAssertEqual(1, 1)
    }

    #if !SKIP
    @MainActor func testConstants() throws {
        XCTAssertEqual("Weight(value: -0.8)", "\(Font.Weight.ultraLight)")
        XCTAssertEqual("Weight(value: -0.6)", "\(Font.Weight.thin)")
        XCTAssertEqual("Weight(value: -0.4)", "\(Font.Weight.light)")
        XCTAssertEqual("Weight(value: 0.0)", "\(Font.Weight.regular)")
        XCTAssertEqual("Weight(value: 0.23)", "\(Font.Weight.medium)")
        XCTAssertEqual("Weight(value: 0.3)", "\(Font.Weight.semibold)")
        XCTAssertEqual("Weight(value: 0.4)", "\(Font.Weight.bold)")
        XCTAssertEqual("Weight(value: 0.56)", "\(Font.Weight.heavy)")
        XCTAssertEqual("Weight(value: 0.62)", "\(Font.Weight.black)")

        XCTAssertEqual("Spacer(minLength: nil)", "\(Spacer())")
        XCTAssertEqual("Spacer(minLength: Optional(12.345))", "\(Spacer(minLength: 12.345))")

        XCTAssertEqual("largeTitle", "\(Font.TextStyle.largeTitle)")
        XCTAssertEqual("title", "\(Font.TextStyle.title)")
        XCTAssertEqual("title2", "\(Font.TextStyle.title2)")
        XCTAssertEqual("title3", "\(Font.TextStyle.title3)")
        XCTAssertEqual("headline", "\(Font.TextStyle.headline)")
        XCTAssertEqual("subheadline", "\(Font.TextStyle.subheadline)")
        XCTAssertEqual("body", "\(Font.TextStyle.body)")
        XCTAssertEqual("callout", "\(Font.TextStyle.callout)")
        XCTAssertEqual("footnote", "\(Font.TextStyle.footnote)")
        XCTAssertEqual("caption", "\(Font.TextStyle.caption)")
        XCTAssertEqual("caption2", "\(Font.TextStyle.caption2)")


        #if !DEBUG
        XCTAssertEqual("AccentColorProvider()", "\(Color.accentColor)")
        XCTAssertEqual("red", "\(Color.red)")
        XCTAssertEqual("orange", "\(Color.orange)")
        XCTAssertEqual("yellow", "\(Color.yellow)")
        XCTAssertEqual("green", "\(Color.green)")
        XCTAssertEqual("mint", "\(Color.mint)")
        XCTAssertEqual("teal", "\(Color.teal)")
        XCTAssertEqual("cyan", "\(Color.cyan)")
        XCTAssertEqual("blue", "\(Color.blue)")
        XCTAssertEqual("indigo", "\(Color.indigo)")
        XCTAssertEqual("purple", "\(Color.purple)")
        XCTAssertEqual("pink", "\(Color.pink)")
        XCTAssertEqual("brown", "\(Color.brown)")
        XCTAssertEqual("white", "\(Color.white)")
        XCTAssertEqual("gray", "\(Color.gray)")
        XCTAssertEqual("black", "\(Color.black)")
        XCTAssertEqual("clear", "\(Color.clear)")
        XCTAssertEqual("primary", "\(Color.primary)")
        XCTAssertEqual("secondary", "\(Color.secondary)")


        XCTAssertEqual(#"Text(storage: SwiftUI.Text.Storage.verbatim("XYZ"), modifiers: [])"#, "\(Text(verbatim: "XYZ"))")
        #endif
    }
    #endif

    #if !SKIP
    @MainActor func testExample() throws {
        if ({ false }()) {
            _ = VStack {
                Text("Hello")
                    .foregroundStyle(.primary)
                    .font(.title)
                Text("Hello")
                    .opacity(0.5)
                    .font(.title2)
            }

            _ = TabView {
                List {
                    ForEach(1..<100) { i in
                        HStack(spacing: 6.0) {
                            Text("Hello")
                                .foregroundStyle(.primary)
                                .font(.body)
                        }
                    }
                    .listItemTint(.red)
                }
            }
        }
    }
    #endif
}

#if !SKIP
struct DemoViw : View {
    @ViewBuilder var body: some View {
        VStack {
            Text("Hello")
            Text("Hello")
        }
    }
}
#endif

