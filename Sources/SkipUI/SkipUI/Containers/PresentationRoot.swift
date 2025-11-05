// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if SKIP
import android.content.Context
import android.content.ContextWrapper
import androidx.activity.ComponentActivity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection

/// The root of a presentation, such as the root presentation or a sheet.
// SKIP INSERT: @OptIn(ExperimentalLayoutApi::class)
@Composable public func PresentationRoot(defaultColorScheme: ColorScheme? = nil, absoluteSystemBarEdges systemBarEdges: Edge.Set = .all, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
    launchUIApplicationActivity()

    let preferredColorScheme = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<PreferredColorScheme>, Any>) { mutableStateOf(Preference<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self)) }
    let preferredColorSchemeCollector = PreferenceCollector<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self, state: preferredColorScheme)
    PreferenceValues.shared.collectPreferences([preferredColorSchemeCollector]) {
        let materialColorScheme = preferredColorScheme.value.reduced.colorScheme?.asMaterialTheme() ?? defaultColorScheme?.asMaterialTheme() ?? MaterialTheme.colorScheme
        MaterialTheme(colorScheme: materialColorScheme) {
            let presentationBounds = remember { mutableStateOf(Rect.Zero) }
            let density = LocalDensity.current
            let layoutDirection = LocalLayoutDirection.current
            var rootModifier = Modifier
                .background(androidx.compose.ui.graphics.Color.Black)
                .fillMaxSize()
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
                .onGloballyPositionedInWindow {
                    presentationBounds.value = $0
                }
            Box(modifier: rootModifier) {
                guard presentationBounds.value != Rect.Zero else {
                    return
                }
                // Cannot get accurate WindowInsets until we're in the content box. We only check top and bottom
                // because we've padded the content to within horizontal safe insets already, mirroring standard
                // Android app behavior like e.g. Settings
                var (safeLeft, safeTop, safeRight, safeBottom) = presentationBounds.value
                if systemBarEdges.contains(.top) {
                    safeTop += WindowInsets.safeDrawing.getTop(density)
                }
                if systemBarEdges.contains(.bottom) {
                    safeBottom -= max(0, WindowInsets.safeDrawing.getBottom(density) - WindowInsets.ime.getBottom(density))
                }
                let safeBounds = Rect(left: safeLeft, top: safeTop, right: safeRight, bottom: safeBottom)
                let safeArea = SafeArea(presentation: presentationBounds.value, safe: safeBounds, absoluteSystemBars: systemBarEdges)
                EnvironmentValues.shared.setValues {
                    // Detect whether the app is edge to edge mode based on whether we're padding horizontally (landscape)
                    // or we have a top/bttom safe area (portrait)
                    if $0._isEdgeToEdge == nil {
                        $0.set_isEdgeToEdge(safeBounds != presentationBounds.value)
                    }
                    $0.set_safeArea(safeArea)
                    return ComposeResult.ok
                } in: {
                    Box(modifier: Modifier.fillMaxSize().padding(safeArea), contentAlignment = androidx.compose.ui.Alignment.Center) {
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
