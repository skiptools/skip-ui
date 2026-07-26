// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import android.content.Context
import android.content.ContextWrapper
import androidx.activity.ComponentActivity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.systemBars
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection

/// The root of a presentation, such as the root presentation or a sheet.
@Composable public func PresentationRoot(defaultColorScheme: ColorScheme? = nil, absoluteSystemBarEdges systemBarEdges: Edge.Set = .all, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
    launchUIApplicationActivity()

    let preferredColorScheme = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<PreferredColorScheme>, Any>) { mutableStateOf(Preference<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self)) }
    let preferredColorSchemeCollector = PreferenceCollector<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self, state: preferredColorScheme)
    PreferenceValues.shared.collectPreferences([preferredColorSchemeCollector]) {
        let materialColorScheme = preferredColorScheme.value.reduced.colorScheme?.asMaterialTheme() ?? defaultColorScheme?.asMaterialTheme() ?? MaterialTheme.colorScheme
        MaterialTheme(colorScheme: materialColorScheme) {
            let density = LocalDensity.current
            let layoutDirection = LocalLayoutDirection.current
            let safeDrawing = WindowInsets.safeDrawing
            let systemBars = WindowInsets.systemBars
            let isRTL = layoutDirection == androidx.compose.ui.unit.LayoutDirection.Rtl
            let safeLeftPx = systemBarEdges.contains(isRTL ? .trailing : .leading) ? safeDrawing.getLeft(density, layoutDirection) : 0
            let safeRightPx = systemBarEdges.contains(isRTL ? .leading : .trailing) ? safeDrawing.getRight(density, layoutDirection) : 0
            let safeTopPx = systemBarEdges.contains(.top) ? safeDrawing.getTop(density) : 0
            // The keyboard is handled by `imePadding` below, so don't reserve the navigation bar it covers
            let safeBottomPx = systemBarEdges.contains(.bottom) ? max(0, systemBars.getBottom(density) - WindowInsets.ime.getBottom(density)) : 0
            let contentInsets = with(density) {
                contentWindowInsets(
                    top: safeTopPx.toDp(),
                    leading: (isRTL ? safeRightPx : safeLeftPx).toDp(),
                    bottom: safeBottomPx.toDp(),
                    trailing: (isRTL ? safeLeftPx : safeRightPx).toDp()
                )
            }
            var rootModifier = Modifier
                .background(androidx.compose.ui.graphics.Color.Black)
                .fillMaxSize()
            // We pad horizontally like standard Android apps do, so we can consume those insets
            if systemBarEdges.contains(.leading) {
                rootModifier = rootModifier.windowInsetsPadding(WindowInsets.safeDrawing.only(WindowInsetsSides.Start))
            }
            if systemBarEdges.contains(.trailing) {
                rootModifier = rootModifier.windowInsetsPadding(WindowInsets.safeDrawing.only(WindowInsetsSides.End))
            }
            if systemBarEdges.contains(.bottom) {
                rootModifier = rootModifier.imePadding()
            }
            rootModifier = rootModifier.background(Color.background.colorImpl())
            // Reserve the vertical system bars, but with plain padding rather than `windowInsetsPadding`:
            // containers like NavigationStack and TabView expand back into these edges, and their bars
            // apply the system insets themselves. Consuming here would zero out that bar padding
            let verticalPadding = with(density) { PaddingValues(top: safeTopPx.toDp(), bottom: safeBottomPx.toDp()) }
            Box(modifier: rootModifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
                EnvironmentValues.shared.setValues {
                    if $0._isEdgeToEdge == nil {
                        $0.set_isEdgeToEdge(safeLeftPx > 0 || safeTopPx > 0 || safeRightPx > 0 || safeBottomPx > 0)
                    }
                    $0.set_contentWindowInsets(contentInsets)
                    $0.set_presentationSystemBarEdges(systemBarEdges)
                    // A presentation is a new layout root: scroll axes inherited from the presenting
                    // context (e.g. a sheet presented from a button inside a ScrollView) must not
                    // leak in. Otherwise expanding content in the presentation is sized with
                    // IntrinsicSize as if it were in the presenter's scroll direction, which crashes
                    // when that content contains a lazy container: intrinsic measurement of
                    // SubcomposeLayout-based components is unsupported in Compose
                    $0.set_layoutScrollAxes(Axis.Set(rawValue: 0))
                    $0.set_scrollAxes(Axis.Set(rawValue: 0))
                    return ComposeResult.ok
                } in: {
                    Box(modifier: Modifier.fillMaxSize().padding(verticalPadding), contentAlignment: androidx.compose.ui.Alignment.Center) {
                        content(context)
                    }
                }
            }
        }
    }
}

@Composable func launchUIApplicationActivity() {
    // Modern Skip projects will set the launch activity in Main.kt. This function exists for older projects
    var context: Context? = LocalContext.current
    var activity: ComponentActivity? = nil
    while context != nil {
        if let a = context as? ComponentActivity {
            activity = a
            break
        } else if let w = context as? ContextWrapper {
            context = w.baseContext
        } else {
            break
        }
    }
    if let activity {
        UIApplication.launch(activity)
    }
}

#endif
