// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import Observation
import OSLog
import SwiftUI
import XCTest

#if SKIP
import android.os.Build
import android.graphics.Bitmap
import android.graphics.Canvas

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.interaction.FocusInteraction
import androidx.compose.foundation.interaction.Interaction
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredHeight
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentSize

import androidx.compose.material3.Text
import androidx.compose.material3.Button

import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue

import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.asAndroidBitmap
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.toPixelMap
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.input.key.KeyEvent
import androidx.compose.ui.input.key.NativeKeyEvent
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalFontFamilyResolver
import androidx.compose.ui.platform.LocalTextInputService
import androidx.compose.ui.platform.LocalTextToolbar
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.platform.TextToolbar
import androidx.compose.ui.platform.TextToolbarStatus
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.SemanticsActions
import androidx.compose.ui.semantics.SemanticsNode
import androidx.compose.ui.semantics.SemanticsConfiguration
import androidx.compose.ui.semantics.SemanticsProperties
import androidx.compose.ui.semantics.getOrNull
import androidx.compose.ui.test.ExperimentalTestApi
import androidx.compose.ui.test.SemanticsMatcher
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assert
import androidx.compose.ui.test.assertHasClickAction
import androidx.compose.ui.test.assertIsFocused
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertTextEquals
import androidx.compose.ui.test.captureToImage
import androidx.compose.ui.test.click
import androidx.compose.ui.test.down
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.hasTextExactly
import androidx.compose.ui.test.hasImeAction
import androidx.compose.ui.test.hasSetTextAction
import androidx.compose.ui.test.isFocused
import androidx.compose.ui.test.isNotFocused
import androidx.compose.ui.test.junit4.StateRestorationTester
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.junit4.ComposeContentTestRule
import androidx.compose.ui.test.longClick
import androidx.compose.ui.test.moveTo
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.printToLog
import androidx.compose.ui.test.performImeAction
import androidx.compose.ui.test.performKeyPress
import androidx.compose.ui.test.performSemanticsAction
import androidx.compose.ui.test.performTextClearance
import androidx.compose.ui.test.performTextInput
import androidx.compose.ui.test.performTextInputSelection
import androidx.compose.ui.test.performTouchInput
import androidx.compose.ui.test.performGesture
import androidx.compose.ui.test.up
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.ParagraphStyle
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextLayoutResult
import androidx.compose.ui.text.TextRange
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.UrlAnnotation
import androidx.compose.ui.text.VerbatimTtsAnnotation
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontSynthesis
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.input.CommitTextCommand
import androidx.compose.ui.text.input.EditCommand
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.OffsetMapping
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.PlatformTextInputService
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.text.input.TextFieldValue.Companion.Saver
import androidx.compose.ui.text.input.TextInputService
import androidx.compose.ui.text.input.TransformedText
import androidx.compose.ui.text.intl.Locale
import androidx.compose.ui.text.intl.LocaleList
import androidx.compose.ui.text.style.BaselineShift
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextDirection
import androidx.compose.ui.text.style.TextGeometricTransform
import androidx.compose.ui.text.style.TextIndent
import androidx.compose.ui.text.toUpperCase
import androidx.compose.ui.text.withAnnotation
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.toSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.em
import androidx.compose.ui.unit.sp

import androidx.test.ext.junit.runners.AndroidJUnit4

import kotlin.test.assertFailsWith
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

import org.junit.Ignore
import org.junit.Rule
import org.junit.Test

// needed to override M3.Text
import skip.ui.Text
#endif


fileprivate let logger: Logger = Logger(subsystem: "test", category: "SkipUITests")

final class SkipUITests: SkipUITestCase {
    // SKIP INSERT: @get:Rule val composeRule = createComposeRule()

    func testSkipUI() throws {
        XCTAssertEqual(3, 1 + 2)
    }

    func check(_ rule: any SkipUIEvaluator, id: String, hasText text: String, exactly: Bool = true) throws {
        #if !SKIP
        #if os(macOS)
        // TODO: we would like to use the accessibility API to find the NSView/UIView with the accessibility identifier, but it the view hierarchy does not seem to set the accessibility identifier of the views
        guard let hostView = rule.hostView,
              let view = traverse(hostView, \.subviews).first(where: { view in
            //view.identifier?.rawValue == id
            //printAccessibilityInformation(for: view)
            return view.accessibilityIdentifier() == id
        }) else {
            //XCTFail("Cannot locate subview with accessibilityIdentifier=\"\(id)\"")
            return
        }
        
        let title = view.accessibilityTitle()
        if exactly {
            XCTAssertEqual(text, title)
        } else {
            XCTAssertTrue(title?.contains(text) == true, "view accessibilityTitle '\(title ?? "NONE")' does not match '\(text)'")
        }
        #endif

        throw XCTSkip("UI testing not yet supported on Darwin platforms")
        #else
        rule.onNodeWithTag(id).assert(hasTextExactly(text))
        #endif
    }

    func testUI<V: View>(@ViewBuilder view: () throws -> V, eval: (any SkipUIEvaluator) throws -> ()) throws {
        #if !SKIP
        try eval(HostingController(rootView: try view()))
        #else
        composeRule.setContent {
            view().Compose()
        }
        eval(composeRule)
        #endif
    }

    // MARK: -

    func testButton() throws {
        try testUI(view: {
            ButtonTestView().accessibilityIdentifier("test-view")
        }, eval: { rule in
            try check(rule, id: "label", hasText: "Counter: 1")
            #if SKIP
            rule.onNodeWithTag("button").performClick()
            try check(rule, id: "label", hasText: "Counter: 2")
            #endif
        })
    }
    struct ButtonTestView: View {
        @State var counter = 1
        var body: some View {
            VStack {
                Text("Counter: \(counter)")
                    .accessibilityIdentifier("label")
                Button("Increment") {
                    counter += 1
                }
                .accessibilityIdentifier("button")
                .buttonStyle(.bordered) // Required to use Compose Button
            }
        }
    }

    func testSlider() throws {
        if isAndroid {
            throw XCTSkip("Test not working on Android emulator")
        }
        // TODO: https://github.com/tikurahul/androidx/blob/ccac66729a5e461b3a05944014f42e2dc55337d6/compose/material/material/src/androidAndroidTest/kotlin/androidx/compose/material/ButtonTest.kt#L48
        // https://github.com/tikurahul/androidx/blob/ccac66729a5e461b3a05944014f42e2dc55337d6/compose/material/material/src/androidAndroidTest/kotlin/androidx/compose/material/SliderTest.kt

        try testUI(view: {
            SliderTestView().accessibilityIdentifier("test-view")
        }, eval: { rule in
            try check(rule, id: "label", hasText: "0%")
            #if SKIP
            // https://developer.android.com/jetpack/compose/testing-cheatsheet
            rule.onNodeWithTag("label").assertIsDisplayed()
            rule.onNodeWithTag("label").assert(hasTextExactly("0%"))
            rule.onNodeWithTag("slider").performGesture {
                down(Offset(Float(10.0), Float(20.0)))
                moveTo(Offset(Float(1000.0), Float(20.0)))
                up()
            }
            //DISABLE rule.onNodeWithTag("label").assert(hasTextExactly("100%"))
            #endif
            try check(rule, id: "label", hasText: "100%")
        })
    }
    struct SliderTestView: View {
        @State var sliderValue = 0.0
        var body: some View {
            VStack {
                Text("\(Int(sliderValue * 100.0))%")
                    .accessibilityIdentifier("label")
                Slider(value: $sliderValue, in: 0.0...1.0)
                    .accessibilityIdentifier("slider")
            }
        }
    }

    // look up a localized string in the current bundle using the given language
    func localizedBundle(_ lang: String) throws -> Bundle {
        try XCTUnwrap(Bundle(url: XCTUnwrap(Bundle.module.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: lang)).deletingLastPathComponent()))
    }

    func testLocalizedString() throws {
        #if !SKIP
        // SwiftPM does not handle Localizable.xcstrings (like Xcode does), so no Localizable.strings files are created at runtime
        if Bundle.module.localizations == [] {
            throw XCTSkip("test does not work in SwiftPM due to lack of .process resource for Localizable.xcstrings")
        }
        #endif

        XCTAssertEqual("تم", NSLocalizedString("Done", bundle: try localizedBundle("ar"), comment: ""))
        XCTAssertEqual("Terminé", NSLocalizedString("Done", bundle: try localizedBundle("fr"), comment: ""))
        XCTAssertEqual("סיום", NSLocalizedString("Done", bundle: try localizedBundle("he"), comment: ""))
        XCTAssertEqual("完了", NSLocalizedString("Done", bundle: try localizedBundle("ja"), comment: ""))
        XCTAssertEqual("OK", NSLocalizedString("Done", bundle: try localizedBundle("pt-BR"), comment: ""))
        XCTAssertEqual("Готово", NSLocalizedString("Done", bundle: try localizedBundle("ru"), comment: ""))
        XCTAssertEqual("Klar", NSLocalizedString("Done", bundle: try localizedBundle("sv"), comment: ""))
        XCTAssertEqual("Готово", NSLocalizedString("Done", bundle: try localizedBundle("uk"), comment: ""))
        XCTAssertEqual("完成", NSLocalizedString("Done", bundle: try localizedBundle("zh-Hans"), comment: ""))
    }

    func testLocalizableStringsIndex() throws {
        #if SKIP
        // verify that the resources index contains the localized strings files derived from the `Localizable.xcstrings` file
        let resourcesIndex = try String(contentsOf: XCTUnwrap(Bundle.module.url(forResource: "resources", withExtension: "lst")))
        XCTAssertEqual(resourcesIndex, """
        Assets.xcassets/Contents.json
        Assets.xcassets/dumbbell.fill.symbolset/Contents.json
        Assets.xcassets/dumbbell.fill.symbolset/dumbbell.fill.svg
        ar.lproj/Localizable.strings
        fr.lproj/Localizable.strings
        he.lproj/Localizable.strings
        ja.lproj/Localizable.strings
        pt-BR.lproj/Localizable.strings
        ru.lproj/Localizable.strings
        sv.lproj/Localizable.strings
        uk.lproj/Localizable.strings
        zh-Hans.lproj/Localizable.strings
        zh-Hant.lproj/Localizable.strings
        """)
        #else
        throw XCTSkip("non-Android platforms do not create a resources.lst index file")
        #endif
    }

    func testLocalizedText() throws {
        #if !SKIP
        if ({ true }()) {
            throw XCTSkip("not running checks on non-Skip platform")
        }
        #endif

        try testUI(view: {
            Text("String: \("ABC") integer: \(123)", bundle: .module, comment: "test localization comment")
                .accessibilityIdentifier("loc-text1")
            Text("String: \("XYZ") integer: \(987)", bundle: .module, comment: "test localization comment")
                .accessibilityIdentifier("loc-text2")

            Text("Done", bundle: .module)
                .accessibilityIdentifier("loc-text3")
                .environment(\.locale, Locale(identifier: "fr"))

            //Group {
            //    Label {
            //        Text("Done: \("XYZ")", bundle: .module)
            //    } icon: {
            //        Image(systemName: "house.fill")
            //    }
            //}
            Text("Done: \("XYZ")", bundle: .module)
                .environment(\.locale, Locale(identifier: "fr"))
                .accessibilityIdentifier("loc-text4")

            Text("Welcome", bundle: .module)
                .accessibilityIdentifier("loc-text5")
                .environment(\.locale, Locale(identifier: "zh-Hans"))

            Text("Welcome", bundle: .module)
                .environment(\.locale, Locale(identifier: "zh-Hant"))
                .accessibilityIdentifier("loc-text6")

        }, eval: { rule in
            try check(rule, id: "loc-text1", hasText: "String: ABC integer: 123")
            try check(rule, id: "loc-text2", hasText: "String: XYZ integer: 987")
            try check(rule, id: "loc-text3", hasText: "Terminé")
            try check(rule, id: "loc-text4", hasText: "Terminé: XYZ")
            try check(rule, id: "loc-text5", hasText: "欢迎") // simplified Chinese "Welcome"
            try check(rule, id: "loc-text6", hasText: "歡迎") // traditional Chinese "Welcome"
        })
    }

    func testEnvironmentObject() throws {
        try testUI(view: {
            EnvironmentObjectOuterView()
                .environmentObject(TestEnvironmentObject(text: "outer"))
                .accessibilityIdentifier("test-view")
        }, eval: { rule in
            try check(rule, id: "outer-label", hasText: "outer")
            try check(rule, id: "inner-label", hasText: "inner")
        })
    }
    class TestEnvironmentObject: ObservableObject {
        @Published var text: String
        init(text: String) {
            self.text = text
        }
    }
    struct EnvironmentObjectOuterView: View {
        @EnvironmentObject var object: TestEnvironmentObject
        var body: some View {
            VStack {
                Text(object.text)
                    .accessibilityIdentifier("outer-label")
                EnvironmentObjectInnerView()
                    .environmentObject(TestEnvironmentObject(text: "inner"))
            }
        }
    }
    struct EnvironmentObjectInnerView: View {
        @EnvironmentObject var object: TestEnvironmentObject
        var body: some View {
            Text(object.text)
                .accessibilityIdentifier("inner-label")
        }
    }

    #if os(iOS) // TODO: enable on macOS once 14 is released
    func testEnvironmentObservable() throws {
        if #available(iOS 17.0, macOS 14.0, *) {
            try testUI(view: {
                EnvironmentObservableOuterView()
                    .environment(TestObservable(text: "outer"))
                    .accessibilityIdentifier("test-view")
            }, eval: { rule in
                #if SKIP
                rule.onNodeWithTag("outer-label").assert(hasTextExactly("outer"))
                rule.onNodeWithTag("inner-label").assert(hasTextExactly("inner"))
                rule.onNodeWithTag("null-label").assert(hasTextExactly("null"))
                #endif
            })
        }
    }
    @available(iOS 17.0, macOS 14.0, *)
    @Observable class TestObservable {
        var text = ""
        init(text: String) {
            self.text = text
        }
    }
    @available(iOS 17.0, macOS 14.0, *)
    struct EnvironmentObservableOuterView: View {
        @Environment(TestObservable.self) var object
        var body: some View {
            VStack {
                Text(object.text)
                    .accessibilityIdentifier("outer-label")
                EnvironmentObservableInnerView(identifier: "inner-label")
                    .environment(TestObservable(text: "inner"))
                EnvironmentObservableInnerView(identifier: "null-label")
                    .environment(nil as TestObservable?)
            }
        }
    }
    @available(iOS 17.0, macOS 14.0, *)
    struct EnvironmentObservableInnerView: View {
        let identifier: String
        @Environment(TestObservable.self) var object: TestObservable?
        var body: some View {
            Text(object?.text ?? "null")
                .accessibilityIdentifier(identifier)
        }
    }
    #endif

    func testCustomEnvironmentValue() throws {
        try testUI(view: {
            EnvironmentValueDefaultView()
                .accessibilityIdentifier("test-view")
        }, eval: { rule in
            try check(rule, id: "default-label", hasText: "default")
            try check(rule, id: "outer-label", hasText: "outer")
            try check(rule, id: "inner-label", hasText: "inner")
        })
    }
    struct EnvironmentValueDefaultView: View {
        @Environment(\.testValue) var environmentValue: String
        var body: some View {
            VStack {
                Text(environmentValue)
                    .accessibilityIdentifier("default-label")
                EnvironmentValueOuterView()
                    .environment(\.testValue, "outer")
            }
        }
    }
    struct EnvironmentValueOuterView: View {
        @Environment(\.testValue) var environmentValue: String
        var body: some View {
            VStack {
                Text(environmentValue)
                    .accessibilityIdentifier("outer-label")
                EnvironmentValueInnerView()
                    .environment(\.testValue, "inner")
            }
        }
    }
    struct EnvironmentValueInnerView: View {
        @Environment(\.testValue) var environmentValue: String
        var body: some View {
            Text(environmentValue)
                .accessibilityIdentifier("inner-label")
        }
    }

//    func testObservability() throws {
//        try testUI(view: {
//            ObservablesOuterView()
//                .environmentObject(TestEnvironmentObject(text: "initialEnvironment"))
//                .accessibilityIdentifier("test-view")
//        }, eval: { rule in
//            #if SKIP
//            rule.onNodeWithTag("state-label").assert(hasTextExactly("initialState"))
//            rule.onNodeWithTag("environment-label").assert(hasTextExactly("initialEnvironment"))
//            rule.onNodeWithTag("observable-state-label").assert(hasTextExactly("initialState"))
//            rule.onNodeWithTag("observable-environment-label").assert(hasTextExactly("initialEnvironment"))
//
//            rule.onNodeWithTag("observable-button").performClick()
//            rule.onNodeWithTag("state-label").assert(hasTextExactly("observableState"))
//            rule.onNodeWithTag("environment-label").assert(hasTextExactly("observableEnvironment"))
//            rule.onNodeWithTag("observable-state-label").assert(hasTextExactly("observableState"))
//            rule.onNodeWithTag("observable-environment-label").assert(hasTextExactly("observableEnvironment"))
//
//            rule.onNodeWithTag("binding-button").performClick()
//            rule.onNodeWithTag("state-label").assert(hasTextExactly("bindingState"))
//            rule.onNodeWithTag("environment-label").assert(hasTextExactly("observableEnvironment"))
//            rule.onNodeWithTag("observable-state-label").assert(hasTextExactly("bindingState"))
//            rule.onNodeWithTag("observable-environment-label").assert(hasTextExactly("observableEnvironment"))
//            #endif
//        })
//    }
//    struct ObservablesOuterView: View {
//        @State var stateObject = TestObservable(text: "initialState")
//        @EnvironmentObject var environmentObject: TestEnvironmentObject
//        var body: some View {
//            VStack {
//                Text(stateObject.text)
//                    .accessibilityIdentifier("state-label")
//                Text(environmentObject.text)
//                    .accessibilityIdentifier("environment-label")
//                ObservablesObservableView(observable: stateObject)
//                    .accessibilityIdentifier("observable-view")
//                ObservablesBindingView(text: $stateObject.text)
//                    .accessibilityIdentifier("binding-view")
//            }
//        }
//    }
//    struct ObservablesObservableView: View {
//        let observable: TestObservable
//        @EnvironmentObject var environmentObject: TestEnvironmentObject
//        var body: some View {
//            Text(observable.text)
//                .accessibilityIdentifier("observable-state-label")
//            Text(environmentObject.text)
//                .accessibilityIdentifier("observable-environment-label")
//            Button("Button") {
//                observable.text = "observableState"
//                environmentObject.text = "observableEnvironment"
//            }
//            .accessibilityIdentifier("observable-button")
//        }
//    }
//    struct ObservablesBindingView: View {
//        @Binding var text: String
//        var body: some View {
//            Button("Button") {
//                text = "bindingState"
//            }
//            .accessibilityIdentifier("binding-button")
//        }
//    }

    // MARK: -

    func testCompose() {
        #if SKIP
        composeRule.setContent {
            androidx.compose.material3.Text(text: "ABC")
        }
        composeRule.onNodeWithText("ABC").assertIsDisplayed()
        #endif
    }

    func testPressButton() {
        #if SKIP
        composeRule.setContent {
            let counter = remember { mutableStateOf(0) }

            androidx.compose.material3.Text(
                text: counter.value.toString(),
                modifier: Modifier.testTag("Counter")
            )
            androidx.compose.material3.Button(onClick = { counter.value++ }) {
                androidx.compose.material3.Text("Increment")
            }
        }

        //XCTAssertEqual(composeRule.onRoot().fetchSemanticsNode().treeString(), """
        //Node:
        //  Node:Text=[0] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean) TestTag=Counter
        //  Node:OnClick=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Focused=false RequestFocus=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Role=Button Text=[Increment] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        //""")

        composeRule
            .onNodeWithTag("Counter")
            .assertTextEquals("0")
        composeRule
            .onNodeWithText("Increment")
            .performClick()
        composeRule
            .onNodeWithTag("Counter")
            .assertTextEquals("1")

        //XCTAssertEqual(composeRule.onRoot().fetchSemanticsNode().treeString(), """
        //Node:
        //  Node:Text=[1] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean) TestTag=Counter
        //  Node:OnClick=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Focused=false RequestFocus=AccessibilityAction(label=null, action=() -> kotlin.Boolean) Role=Button Text=[Increment] GetTextLayoutResult=AccessibilityAction(label=null, action=(kotlin.collections.MutableList<androidx.compose.ui.text.TextLayoutResult>) -> kotlin.Boolean)
        //""")

        #endif
    }

}


#if SKIP

extension SemanticsNode {
    /// Returns a description of this node's hierarchy and attributes
    func treeString(indent: String = "") -> String {
        let nodeDescription = "\(indent)Node:\(attrList())"
        let cdesc = self.children.joinToString(separator = "\n") { child in
            child.treeString(indent + "  ")
        }
        return cdesc.isBlank() ? nodeDescription : (nodeDescription + "\n" + cdesc)
    }

    private func attrList() -> String {
        var desc = ""

        config.forEach { configValue in
            let key = configValue.key.name
            let values = configValue.value
            if !desc.isEmpty {
                desc += " "
            }
            desc += "\(key)=\(values)"
        }

        return desc
    }
}

#endif

// Used in `testCustomEnvironmentValue`
private struct EnvironmentValueTestKey: EnvironmentKey {
  static let defaultValue = "default"
}
extension EnvironmentValues {
    fileprivate var testValue: String {
        get { self[EnvironmentValueTestKey.self] }
        set { self[EnvironmentValueTestKey.self] = newValue }
    }
}
