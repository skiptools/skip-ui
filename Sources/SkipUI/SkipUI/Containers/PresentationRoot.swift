// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.systemBars
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection

/// The root of a presentation, such as the root presentation or a sheet.
// SKIP INSERT: @OptIn(ExperimentalLayoutApi::class)
@Composable public func PresentationRoot(defaultColorScheme: ColorScheme? = nil, absoluteSystemBarEdges systemBarEdges: Edge.Set = .all, context: ComposeContext, content: @Composable (ComposeContext) -> Void) {
    let preferredColorScheme = rememberSaveable(stateSaver: context.stateSaver as! Saver<Preference<PreferredColorScheme>, Any>) { mutableStateOf(Preference<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self)) }
    let preferredColorSchemeCollector = PreferenceCollector<PreferredColorScheme>(key: PreferredColorSchemePreferenceKey.self, state: preferredColorScheme)
    PreferenceValues.shared.collectPreferences([preferredColorSchemeCollector]) {
        let materialColorScheme = preferredColorScheme.value.reduced.colorScheme?.asMaterialTheme() ?? defaultColorScheme?.asMaterialTheme() ?? MaterialTheme.colorScheme
        MaterialTheme(colorScheme: materialColorScheme) {
            let presentationBounds = remember { mutableStateOf(Rect.Zero) }
            let density = LocalDensity.current
            let layoutDirection = LocalLayoutDirection.current
            let rootModifier = Modifier
                .background(Color.background.colorImpl())
                .fillMaxSize()
                .imePadding()
                .onGloballyPositioned {
                    presentationBounds.value = $0.boundsInWindow()
                }
            Box(modifier: rootModifier) {
                guard presentationBounds.value != Rect.Zero else {
                    return
                }
                // Cannot get accurate WindowInsets until we're in the content box
                var (safeLeft, safeTop, safeRight, safeBottom) = presentationBounds.value
                if systemBarEdges.contains(.leading) {
                    safeLeft += WindowInsets.systemBars.getLeft(density, layoutDirection)
                }
                if systemBarEdges.contains(.top) {
                    safeTop += WindowInsets.systemBars.getTop(density)
                }
                if systemBarEdges.contains(.trailing) {
                    safeRight -= WindowInsets.systemBars.getRight(density, layoutDirection)
                }
                if systemBarEdges.contains(.bottom) {
                    safeBottom -= max(0, WindowInsets.systemBars.getBottom(density) - WindowInsets.ime.getBottom(density))
                }
                let safeBounds = Rect(left: safeLeft, top: safeTop, right: safeRight, bottom: safeBottom)
                let safeArea = SafeArea(presentation: presentationBounds.value, safe: safeBounds, absoluteSystemBars: systemBarEdges)
                EnvironmentValues.shared.setValues {
                    // Detect whether the app is edge to edge mode based on whether the bounds extend past the safe areas
                    if $0._isEdgeToEdge == nil {
                        $0.set_isEdgeToEdge(safeBounds != presentationBounds.value)
                    }
                    $0.set_safeArea(safeArea)
                } in: {
                    Box(modifier: Modifier.fillMaxSize().padding(safeArea), contentAlignment = androidx.compose.ui.Alignment.Center) {
                        content(context)
                    }
                }
            }
        }
    }
}
#endif
