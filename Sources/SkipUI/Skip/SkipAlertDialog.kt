// Copyright 2021 The Android Open Source Project
// Copyright 2025 Skip - adapted for skip-ui with package and import fixes
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package skip.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.sizeIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialogDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.layout.Layout
import androidx.compose.ui.layout.Placeable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.semantics.paneTitle
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.util.fastForEach
import androidx.compose.ui.util.fastForEachIndexed
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import kotlin.collections.List
import kotlin.math.max

/**
 * Material3-style AlertDialog implementation for skip-ui.
 * Copy of androidx.compose.material3.AlertDialog logic with internal/token dependencies
 * replaced by public MaterialTheme/AlertDialogDefaults APIs.
 *
 * Use this for basic cases (title, optional text, confirm + optional dismiss buttons).
 */
@Composable
fun SkipAlertDialog(
    onDismissRequest: () -> Unit,
    confirmButton: @Composable () -> Unit,
    modifier: Modifier = Modifier,
    dismissButton: @Composable (() -> Unit)? = null,
    neutralButtons: List<@Composable () -> Unit> = emptyList(),
    icon: @Composable (() -> Unit)? = null,
    title: @Composable (() -> Unit)? = null,
    text: @Composable (() -> Unit)? = null,
    textFields: @Composable (() -> Unit)? = null,
    shape: Shape = AlertDialogDefaults.shape,
    containerColor: Color = AlertDialogDefaults.containerColor,
    iconContentColor: Color = AlertDialogDefaults.iconContentColor,
    titleContentColor: Color = AlertDialogDefaults.titleContentColor,
    textContentColor: Color = AlertDialogDefaults.textContentColor,
    tonalElevation: Dp = AlertDialogDefaults.TonalElevation,
    properties: DialogProperties = DialogProperties(),
) {
    Dialog(onDismissRequest = onDismissRequest, properties = properties) {
        Box(
            modifier = modifier
                .sizeIn(minWidth = DialogMinWidth, maxWidth = DialogMaxWidth)
                .then(Modifier.semantics { paneTitle = "Dialog" })
                .then(Modifier.logLayoutModifier(tag = "SkipAlertDialog")),
            propagateMinConstraints = true,
        ) {
            SkipAlertDialogContent(
                buttons = {
                    SkipAlertDialogFlowRow(
                        mainAxisSpacing = ButtonsMainAxisSpacing,
                        crossAxisSpacing = ButtonsCrossAxisSpacing,
                    ) {
                        for (btn in neutralButtons) { btn() }
                        dismissButton?.let { it() }
                        confirmButton()
                    }
                },
                icon = icon,
                title = title,
                text = text,
                textFields = textFields,
                shape = shape,
                containerColor = containerColor,
                tonalElevation = tonalElevation,
                buttonContentColor = MaterialTheme.colorScheme.primary,
                iconContentColor = iconContentColor,
                titleContentColor = titleContentColor,
                textContentColor = textContentColor,
            )
        }
    }
}

@Composable
private fun SkipAlertDialogContent(
    buttons: @Composable () -> Unit,
    modifier: Modifier = Modifier,
    icon: (@Composable () -> Unit)?,
    title: (@Composable () -> Unit)?,
    text: @Composable (() -> Unit)?,
    textFields: @Composable (() -> Unit)? = null,
    shape: Shape,
    containerColor: Color,
    tonalElevation: Dp,
    buttonContentColor: Color,
    iconContentColor: Color,
    titleContentColor: Color,
    textContentColor: Color,
) {
    SideEffect { Log.d("SkipAlertDialog", "containerColor=$containerColor") }
    Surface(
        modifier = modifier,
        shape = shape,
        color = containerColor,
        tonalElevation = tonalElevation,
    ) {
        Column(modifier = Modifier.padding(DialogPadding)) {
            icon?.let {
                CompositionLocalProvider(androidx.compose.material3.LocalContentColor provides iconContentColor) {
                    Box(Modifier.padding(IconPadding).align(Alignment.CenterHorizontally)) {
                        icon()
                    }
                }
            }
            title?.let {
                ProvideContentColorTextStyle(
                    contentColor = titleContentColor,
                    textStyle = MaterialTheme.typography.headlineSmall,
                ) {
                    Box(
                        Modifier.padding(TitlePadding)
                            .align(
                                if (icon == null) Alignment.Start
                                else Alignment.CenterHorizontally,
                            ),
                    ) {
                        title()
                    }
                }
            }
            text?.let {
                SideEffect { Log.d("SkipAlertMessageColor", "textContentColor=$textContentColor") }
                val scrollState = rememberScrollState()
                ProvideContentColorTextStyle(
                    contentColor = textContentColor,
                    textStyle = MaterialTheme.typography.bodyMedium,
                ) {
                    Box(
                        Modifier
                            .weight(weight = 1f, fill = false)
                            .padding(TextPadding)
                            .fillMaxWidth()
                            .verticalScroll(scrollState)
                            .align(Alignment.Start),
                    ) {
                        text()
                    }
                }
            }
            textFields?.let {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .align(Alignment.Start),
                ) {
                    textFields()
                }
            }
            Box(
                modifier = Modifier
                    .align(Alignment.End)
                    .then(Modifier.logLayoutModifier(tag = "SkipAlertDialogButtonBox")),
                contentAlignment = Alignment.CenterEnd,
            ) {
                ProvideContentColorTextStyle(
                    contentColor = buttonContentColor,
                    textStyle = MaterialTheme.typography.labelLarge,
                    content = buttons,
                )
            }
        }
    }
}

/** Replaces material3 internal ProvideContentColorTextStyle using public CompositionLocals. */
@Composable
private fun ProvideContentColorTextStyle(
    contentColor: Color,
    textStyle: TextStyle,
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(
        androidx.compose.material3.LocalContentColor provides contentColor,
        androidx.compose.material3.LocalTextStyle provides androidx.compose.material3.LocalTextStyle.current.merge(textStyle),
    ) {
        content()
    }
}

@Composable
private fun SkipAlertDialogFlowRow(
    mainAxisSpacing: Dp,
    crossAxisSpacing: Dp,
    content: @Composable () -> Unit,
) {
    val density = LocalDensity.current
    val layoutDirection = LocalLayoutDirection.current
    Layout(
        modifier = Modifier.logLayoutModifier(tag = "SkipAlertDialogFlowRow"),
        content = content,
    ) { measurables, constraints ->
        val sequences = mutableListOf<kotlin.collections.List<Placeable>>()
        val crossAxisSizes = mutableListOf<Int>()
        val crossAxisPositions = mutableListOf<Int>()

        var mainAxisSpace = 0
        var crossAxisSpace = 0

        val currentSequence = mutableListOf<Placeable>()
        var currentMainAxisSize = 0
        var currentCrossAxisSize = 0

        fun canAddToCurrentSequence(placeable: Placeable) =
            currentSequence.isEmpty() ||
                currentMainAxisSize + with(density) { mainAxisSpacing.roundToPx() } + placeable.width <=
                    constraints.maxWidth

        fun startNewSequence() {
            if (sequences.isNotEmpty()) {
                crossAxisSpace += with(density) { crossAxisSpacing.roundToPx() }
            }
            // Append sequences (not prepend) so neutral buttons appear above dismiss/confirm buttons
            sequences.add(currentSequence.toList())
            crossAxisSizes += currentCrossAxisSize
            crossAxisPositions += crossAxisSpace

            crossAxisSpace += currentCrossAxisSize
            mainAxisSpace = max(mainAxisSpace, currentMainAxisSize)

            currentSequence.clear()
            currentMainAxisSize = 0
            currentCrossAxisSize = 0
        }

        measurables.fastForEach { measurable ->
            val placeable = measurable.measure(constraints)
            if (!canAddToCurrentSequence(placeable)) startNewSequence()

            if (currentSequence.isNotEmpty()) {
                currentMainAxisSize += with(density) { mainAxisSpacing.roundToPx() }
            }
            currentSequence.add(placeable)
            currentMainAxisSize += placeable.width
            currentCrossAxisSize = max(currentCrossAxisSize, placeable.height)
        }

        if (currentSequence.isNotEmpty()) startNewSequence()

        val mainAxisLayoutSize = max(mainAxisSpace, constraints.minWidth)
        val crossAxisLayoutSize = max(crossAxisSpace, constraints.minHeight)

        layout(mainAxisLayoutSize, crossAxisLayoutSize) {
            sequences.fastForEachIndexed { i, placeables ->
                val childrenMainAxisSizes =
                    IntArray(placeables.size) { j: Int ->
                        placeables[j].width +
                            if (j < placeables.lastIndex) with(density) { mainAxisSpacing.roundToPx() } else 0
                    }
                val arrangement = Arrangement.End
                val mainAxisPositions = IntArray(childrenMainAxisSizes.size)
                with(arrangement) {
                    arrange(
                        mainAxisLayoutSize,
                        childrenMainAxisSizes,
                        layoutDirection,
                        mainAxisPositions,
                    )
                }
                placeables.fastForEachIndexed { j, placeable ->
                    placeable.place(x = mainAxisPositions[j], y = crossAxisPositions[i])
                }
            }
        }
    }
}

private val DialogMinWidth = 280.dp
private val DialogMaxWidth = 560.dp

private val ButtonsMainAxisSpacing = 8.dp
private val ButtonsCrossAxisSpacing = 12.dp
// Paddings for each of the dialog's parts (match Material3 AlertDialog.kt).
private val DialogPadding = PaddingValues(all = 24.dp)
private val IconPadding = PaddingValues(bottom = 16.dp)
private val TitlePadding = PaddingValues(bottom = 16.dp)
private val TextPadding = PaddingValues(bottom = 24.dp)
