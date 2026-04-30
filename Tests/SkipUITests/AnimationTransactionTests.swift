// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest

#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.performClick
import org.junit.Rule
#endif

final class AnimationTransactionTests: SkipUITestCase {
    // SKIP INSERT: @get:Rule val composeRule = createComposeRule()

    func testOutsideThenInsideWithAnimationScopesOnlyInsideWrite() throws {
        #if !SKIP
        throw XCTSkip("Animation transaction decisions are Android-only")
        #else
        let decisions = try runScenario(.outsideThenInside)
        XCTAssertDecision(decisions, at: 0, usesAnimation: false)
        XCTAssertDecision(decisions, at: 1, usesAnimation: true)
        #endif
    }

    func testBothInsideWithAnimationBothAnimate() throws {
        #if !SKIP
        throw XCTSkip("Animation transaction decisions are Android-only")
        #else
        let decisions = try runScenario(.bothInside)
        XCTAssertDecision(decisions, at: 0, usesAnimation: true)
        XCTAssertDecision(decisions, at: 1, usesAnimation: true)
        #endif
    }

    func testWithoutWithAnimationBothSnap() throws {
        #if !SKIP
        throw XCTSkip("Animation transaction decisions are Android-only")
        #else
        let decisions = try runScenario(.neitherInside)
        XCTAssertDecision(decisions, at: 0, usesAnimation: false)
        XCTAssertDecision(decisions, at: 1, usesAnimation: false)
        #endif
    }

    func testValueAnimationEnvironmentTakesPrecedence() throws {
        #if !SKIP
        throw XCTSkip("Animation transaction decisions are Android-only")
        #else
        let decisions = try runScenario(.environmentOverridesTransaction)
        XCTAssertDecision(decisions, at: 0, usesAnimation: true)
        XCTAssertDecision(decisions, at: 1, usesAnimation: true)
        XCTAssertTrue(decisions.contains { $0.contains("environmentAnimation=true") && $0.contains("usesAnimation=true") }, decisions.joined(separator: "\n"))
        #endif
    }

    #if SKIP
    private func runScenario(_ scenario: AnimationTransactionScenario) throws -> [String] {
        var decisions: [String] = []
        AnimationDebug.decisionSink = { decisions.append($0) }
        defer { AnimationDebug.decisionSink = nil }

        composeRule.setContent {
            AnimationTransactionTestView(scenario: scenario).Compose()
        }
        composeRule.waitForIdle()

        decisions.removeAll()
        composeRule.onNodeWithTag("run").performClick()
        composeRule.waitForIdle()

        return decisions
    }

    private func XCTAssertDecision(_ decisions: [String], at index: Int, usesAnimation: Bool) {
        let expected = "usesAnimation=\(usesAnimation)"
        let changes = decisions.filter { $0.contains("animatable change value=") }
        XCTAssertTrue(changes.count > index, decisions.joined(separator: "\n"))
        XCTAssertTrue(changes[index].contains(expected), decisions.joined(separator: "\n"))
    }
    #endif
}

#if SKIP
private enum AnimationTransactionScenario {
    case outsideThenInside
    case bothInside
    case neitherInside
    case environmentOverridesTransaction
}

private struct AnimationTransactionTestView: View {
    let scenario: AnimationTransactionScenario

    @State private var redOpacity = 1.0
    @State private var greenOpacity = 1.0

    var body: some View {
        VStack {
            Color.red
                .opacity(redOpacity)
                .frame(width: 8.0, height: 8.0)
            Color.green
                .opacity(greenOpacity)
                .frame(width: 8.0, height: 8.0)
            Button("Run") {
                switch scenario {
                case .outsideThenInside:
                    redOpacity = 0.25
                    withAnimation(.linear(duration: 1.5)) {
                        greenOpacity = 0.5
                    }
                case .bothInside:
                    withAnimation(.linear(duration: 1.5)) {
                        redOpacity = 0.25
                        greenOpacity = 0.5
                    }
                case .neitherInside:
                    redOpacity = 0.25
                    greenOpacity = 0.5
                case .environmentOverridesTransaction:
                    withAnimation(.linear(duration: 1.5)) {
                        redOpacity = 0.25
                        greenOpacity = 0.5
                    }
                }
            }
            .accessibilityIdentifier("run")
            .buttonStyle(.bordered)
        }
        .animation(scenario == .environmentOverridesTransaction ? .easeInOut(duration: 0.25) : nil, value: redOpacity)
        .animation(scenario == .environmentOverridesTransaction ? .easeInOut(duration: 0.25) : nil, value: greenOpacity)
    }
}
#endif
