// Copyright 2024–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
package skip.ui

import androidx.annotation.FloatRange
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.LayoutScopeMarker
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.AlignmentLine
import androidx.compose.ui.layout.FirstBaseline
import androidx.compose.ui.layout.HorizontalAlignmentLine
import androidx.compose.ui.layout.IntrinsicMeasurable
import androidx.compose.ui.layout.IntrinsicMeasureScope
import androidx.compose.ui.layout.Layout
import androidx.compose.ui.layout.Measurable
import androidx.compose.ui.layout.MeasurePolicy
import androidx.compose.ui.layout.MeasureResult
import androidx.compose.ui.layout.MeasureScope
import androidx.compose.ui.layout.Measured
import androidx.compose.ui.layout.Placeable
import androidx.compose.ui.layout.VerticalAlignmentLine
import androidx.compose.ui.node.ModifierNodeElement
import androidx.compose.ui.node.ParentDataModifierNode
import androidx.compose.ui.platform.InspectorInfo
import androidx.compose.ui.unit.Constraints
import androidx.compose.ui.unit.Density
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.util.fastCoerceAtLeast
import androidx.compose.ui.util.fastRoundToInt
import kotlin.collections.List
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

/**
 * This file contains heavily modified versions of Compose's `Row` and `Column` layouts to provide
 * more SwiftUI-like layout behavior.
 *
 * The general structure and supporting code has been intentionally left as close to the original
 * `Row` and `Column` as possible for multiple reasons:
 *
 * - So that we can also maintain our previous `Row` and `Column` implementations for users who
 *   rely on their behavior, and in case we need to revert after finding problems.
 * - To take advantage of `Row` and `Column`'s well-tested implementations.
 * - In case we need to assimilate functionality that gets added to `Row` and `Column` in future
 *   Compose releases.
 *
 * But that means that this code also retains many `Row` and `Column` limitations. It must be combined
 * with additional workarounds in `ComposeContainer`, `HStack` and `VStack` to approximate SwiftUI layout.
 */

/**
 * Expand to fill.
 */
val Float.Companion.flexibleFill: Float
    get() = -1f

/**
 * Expand to fill with space - lower priority than `flexibleFill`.
 */
val Float.Companion.flexibleSpace: Float
    get() = -2f

/**
 * Unknown non-expanding flexible size.
 */
val Float.Companion.flexibleUnknownNonExpanding: Float
    get() = -3f

/**
 * Unknown flexible size that expands due to a `flexibleSpace`.
 */
val Float.Companion.flexibleUnknownWithSpace: Float
    get() = -4f

/**
 * Whether this is some expanding flexible value.
 */
val Float.isFlexibleExpanding: Boolean
    get() = this == Float.flexibleFill || this == Float.flexibleSpace || this == Float.flexibleUnknownWithSpace

/**
 * Whether this is some non-expanding minimum flexible value.
 */
val Float.isFlexibleNonExpandingMin: Boolean
    get() = this > 0f || this == Float.flexibleUnknownNonExpanding

/**
 * Whether this is some non-expanding maximum flexible value.
 */
val Float.isFlexibleNonExpandingMax: Boolean
    get() = this >= 0f || this == Float.flexibleUnknownNonExpanding

/*
 * Modified version of Row.kt
 */

@Composable
internal inline fun HStackRow(
    modifier: Modifier = Modifier,
    horizontalArrangement: Arrangement.Horizontal = Arrangement.Start,
    verticalAlignment: Alignment.Vertical = Alignment.Top,
    content: @Composable HStackRowScope.() -> Unit,
) {
    val measurePolicy = rowMeasurePolicy(horizontalArrangement, verticalAlignment)
    Layout(
        content = { HStackRowScopeInstance.content() },
        measurePolicy = measurePolicy,
        modifier = modifier,
    )
}

@PublishedApi
internal val DefaultRowMeasurePolicy: MeasurePolicy =
    RowMeasurePolicy(horizontalArrangement = Arrangement.Start, verticalAlignment = Alignment.Top)

@PublishedApi
@Composable
internal fun rowMeasurePolicy(
    horizontalArrangement: Arrangement.Horizontal,
    verticalAlignment: Alignment.Vertical,
): MeasurePolicy =
    if (horizontalArrangement == Arrangement.Start && verticalAlignment == Alignment.Top) {
        DefaultRowMeasurePolicy
    } else {
        remember(horizontalArrangement, verticalAlignment) {
            RowMeasurePolicy(
                horizontalArrangement = horizontalArrangement,
                verticalAlignment = verticalAlignment,
            )
        }
    }

internal data class RowMeasurePolicy(
    private val horizontalArrangement: Arrangement.Horizontal,
    private val verticalAlignment: Alignment.Vertical,
) : MeasurePolicy, RowColumnMeasurePolicy {
    override fun Placeable.mainAxisConstrainedSize() = width
    override fun Placeable.mainAxisMeasuredSize() = measuredWidth

    override fun Placeable.crossAxisConstrainedSize() = height
    override fun Placeable.crossAxisMeasuredSize() = measuredHeight

    override fun Measurable.intrinsicMainAxisSize(crossAxisSize: Int) = maxIntrinsicWidth(crossAxisSize)

    override fun MeasureScope.measure(
        measurables: List<Measurable>,
        constraints: Constraints,
    ): MeasureResult {
        return measure(
            constraints.minWidth,
            constraints.minHeight,
            constraints.maxWidth,
            constraints.maxHeight,
            horizontalArrangement.spacing.roundToPx(),
            this,
            measurables,
            arrayOfNulls(measurables.size),
            0,
            measurables.size
        )
    }

    override fun populateMainAxisPositions(
        mainAxisLayoutSize: Int,
        children: List<RowColumnChildInfo>,
        mainAxisPositions: IntArray,
        measureScope: MeasureScope,
    ) {
        with(horizontalArrangement) {
            measureScope.arrange(
                mainAxisLayoutSize,
                children.map { it.mainAxisMeasuredSize }.toIntArray(),
                measureScope.layoutDirection,
                mainAxisPositions,
            )
        }
        // The arrange function will center the difference when any child's measured size is not the
        // same as its constrained size. We want each child to actually align to its assigned position
        for (i in 0..<children.size) {
            val diff = children[i].mainAxisMeasuredSize - children[i].mainAxisConstrainedSize
            mainAxisPositions[i] += diff / 2
        }
    }

    override fun placeHelper(
        placeables: Array<Placeable?>,
        measureScope: MeasureScope,
        beforeCrossAxisAlignmentLine: Int,
        mainAxisPositions: IntArray,
        mainAxisLayoutSize: Int,
        crossAxisLayoutSize: Int,
        crossAxisOffset: IntArray?,
        currentLineIndex: Int,
        startIndex: Int,
        endIndex: Int,
    ): MeasureResult {
        return with(measureScope) {
            layout(mainAxisLayoutSize, crossAxisLayoutSize) {
                placeables.forEachIndexed { i, placeable ->
                    val crossAxisPosition =
                        getCrossAxisPosition(
                            placeable!!,
                            placeable.rowColumnParentData,
                            crossAxisLayoutSize,
                            beforeCrossAxisAlignmentLine,
                        )
                    placeable.place(mainAxisPositions[i], crossAxisPosition)
                }
            }
        }
    }

    override fun createConstraints(
        mainAxisMin: Int,
        crossAxisMin: Int,
        mainAxisMax: Int,
        crossAxisMax: Int,
        isPrioritizing: Boolean,
    ): Constraints {
        return createRowConstraints(
            isPrioritizing,
            mainAxisMin,
            crossAxisMin,
            mainAxisMax,
            crossAxisMax,
        )
    }

    private fun getCrossAxisPosition(
        placeable: Placeable,
        parentData: RowColumnParentData?,
        crossAxisLayoutSize: Int,
        beforeCrossAxisAlignmentLine: Int,
    ): Int {
        val childCrossAlignment = parentData?.crossAxisAlignment
        return childCrossAlignment?.align(
            size = crossAxisLayoutSize - placeable.measuredHeight,
            layoutDirection = LayoutDirection.Ltr,
            placeable = placeable,
            beforeCrossAxisAlignmentLine = beforeCrossAxisAlignmentLine,
        ) ?: verticalAlignment.align(placeable.measuredHeight, crossAxisLayoutSize)
    }

    override fun IntrinsicMeasureScope.minIntrinsicWidth(
        measurables: List<IntrinsicMeasurable>,
        height: Int,
    ) =
        IntrinsicMeasureBlocks.HorizontalMinWidth(
            measurables,
            height,
            horizontalArrangement.spacing.roundToPx(),
        )

    override fun IntrinsicMeasureScope.minIntrinsicHeight(
        measurables: List<IntrinsicMeasurable>,
        width: Int,
    ) =
        IntrinsicMeasureBlocks.HorizontalMinHeight(
            measurables,
            width,
            horizontalArrangement.spacing.roundToPx(),
        )

    override fun IntrinsicMeasureScope.maxIntrinsicWidth(
        measurables: List<IntrinsicMeasurable>,
        height: Int,
    ) =
        IntrinsicMeasureBlocks.HorizontalMaxWidth(
            measurables,
            height,
            horizontalArrangement.spacing.roundToPx(),
        )

    override fun IntrinsicMeasureScope.maxIntrinsicHeight(
        measurables: List<IntrinsicMeasurable>,
        width: Int,
    ) =
        IntrinsicMeasureBlocks.HorizontalMaxHeight(
            measurables,
            width,
            horizontalArrangement.spacing.roundToPx(),
        )
}

internal fun createRowConstraints(
    isPrioritizing: Boolean,
    mainAxisMin: Int,
    crossAxisMin: Int,
    mainAxisMax: Int,
    crossAxisMax: Int,
): Constraints {
    return if (!isPrioritizing) {
        Constraints(
            maxWidth = mainAxisMax,
            maxHeight = crossAxisMax,
            minWidth = mainAxisMin,
            minHeight = crossAxisMin,
        )
    } else {
        Constraints.fitPrioritizingWidth(
            maxWidth = mainAxisMax,
            maxHeight = crossAxisMax,
            minWidth = mainAxisMin,
            minHeight = crossAxisMin,
        )
    }
}

@LayoutScopeMarker
@Immutable
interface HStackRowScope {
    /**
     * SwiftUI-like flexible sizing.
     */
    @Stable
    fun Modifier.flexible(ideal: Float? = null, min: Float? = null, max: Float? = null): Modifier

    @Stable fun Modifier.align(alignment: Alignment.Vertical): Modifier

    @Stable fun Modifier.alignBy(alignmentLine: HorizontalAlignmentLine): Modifier

    @Stable fun Modifier.alignByBaseline(): Modifier

    @Stable fun Modifier.alignBy(alignmentLineBlock: (Measured) -> Int): Modifier
}

internal object HStackRowScopeInstance : HStackRowScope {
    @Stable
    override fun Modifier.flexible(ideal: Float?, min: Float?, max: Float?): Modifier {
        return this.then(
            LayoutFlexibleElement(
                ideal = ideal,
                min = min,
                max = max
            )
        ).applyNonExpandingFlexibleWidth(ideal = ideal, min = min, max = max)
    }

    @Stable
    override fun Modifier.align(alignment: Alignment.Vertical) =
        this.then(VerticalAlignElement(alignment))

    @Stable
    override fun Modifier.alignBy(alignmentLine: HorizontalAlignmentLine) =
        this.then(WithAlignmentLineElement(alignmentLine = alignmentLine))

    @Stable override fun Modifier.alignByBaseline() = alignBy(FirstBaseline)

    override fun Modifier.alignBy(alignmentLineBlock: (Measured) -> Int) =
        this.then(WithAlignmentLineBlockElement(block = alignmentLineBlock))
}

/*
 * Modified version of Column.kt
 */

@Composable
inline fun VStackColumn(
    modifier: Modifier = Modifier,
    verticalArrangement: Arrangement.Vertical = Arrangement.Top,
    horizontalAlignment: Alignment.Horizontal = Alignment.Start,
    content: @Composable VStackColumnScope.() -> Unit,
) {
    val measurePolicy = columnMeasurePolicy(verticalArrangement, horizontalAlignment)
    Layout(
        content = { VStackColumnScopeInstance.content() },
        measurePolicy = measurePolicy,
        modifier = modifier,
    )
}

@PublishedApi
internal val DefaultColumnMeasurePolicy: MeasurePolicy =
    ColumnMeasurePolicy(
        verticalArrangement = Arrangement.Top,
        horizontalAlignment = Alignment.Start,
    )

@PublishedApi
@Composable
internal fun columnMeasurePolicy(
    verticalArrangement: Arrangement.Vertical,
    horizontalAlignment: Alignment.Horizontal,
): MeasurePolicy =
    if (verticalArrangement == Arrangement.Top && horizontalAlignment == Alignment.Start) {
        DefaultColumnMeasurePolicy
    } else {
        remember(verticalArrangement, horizontalAlignment) {
            ColumnMeasurePolicy(
                verticalArrangement = verticalArrangement,
                horizontalAlignment = horizontalAlignment,
            )
        }
    }

internal data class ColumnMeasurePolicy(
    private val verticalArrangement: Arrangement.Vertical,
    private val horizontalAlignment: Alignment.Horizontal,
) : MeasurePolicy, RowColumnMeasurePolicy {

    override fun Measurable.intrinsicMainAxisSize(crossAxisSize: Int) = maxIntrinsicHeight(crossAxisSize)

    override fun Placeable.mainAxisConstrainedSize(): Int = height
    override fun Placeable.mainAxisMeasuredSize(): Int = measuredHeight

    override fun Placeable.crossAxisConstrainedSize(): Int = width
    override fun Placeable.crossAxisMeasuredSize(): Int = measuredWidth

    override fun populateMainAxisPositions(
        mainAxisLayoutSize: Int,
        children: List<RowColumnChildInfo>,
        mainAxisPositions: IntArray,
        measureScope: MeasureScope,
    ) {
        with(verticalArrangement) {
            measureScope.arrange(
                mainAxisLayoutSize,
                children.map { it.mainAxisMeasuredSize }.toIntArray(),
                mainAxisPositions
            )
        }
        // The arrange function will center the difference when any child's measured size is not the
        // same as its constrained size. We want each child to actually align to its assigned position
        for (i in 0..<children.size) {
            val diff = children[i].mainAxisMeasuredSize - children[i].mainAxisConstrainedSize
            mainAxisPositions[i] += diff / 2
        }
    }

    override fun placeHelper(
        placeables: Array<Placeable?>,
        measureScope: MeasureScope,
        beforeCrossAxisAlignmentLine: Int,
        mainAxisPositions: IntArray,
        mainAxisLayoutSize: Int,
        crossAxisLayoutSize: Int,
        crossAxisOffset: IntArray?,
        currentLineIndex: Int,
        startIndex: Int,
        endIndex: Int,
    ): MeasureResult {
        return with(measureScope) {
            layout(crossAxisLayoutSize, mainAxisLayoutSize) {
                placeables.forEachIndexed { i, placeable ->
                    val crossAxisPosition =
                        getCrossAxisPosition(
                            placeable!!,
                            placeable.rowColumnParentData,
                            crossAxisLayoutSize,
                            beforeCrossAxisAlignmentLine,
                            measureScope.layoutDirection,
                        )
                    placeable.place(crossAxisPosition, mainAxisPositions[i])
                }
            }
        }
    }

    private fun getCrossAxisPosition(
        placeable: Placeable,
        parentData: RowColumnParentData?,
        crossAxisLayoutSize: Int,
        beforeCrossAxisAlignmentLine: Int,
        layoutDirection: LayoutDirection,
    ): Int {
        val childCrossAlignment = parentData?.crossAxisAlignment
        return childCrossAlignment?.align(
            size = crossAxisLayoutSize - placeable.measuredWidth,
            layoutDirection = layoutDirection,
            placeable = placeable,
            beforeCrossAxisAlignmentLine = beforeCrossAxisAlignmentLine,
        ) ?: horizontalAlignment.align(placeable.measuredWidth, crossAxisLayoutSize, layoutDirection)
    }

    override fun createConstraints(
        mainAxisMin: Int,
        crossAxisMin: Int,
        mainAxisMax: Int,
        crossAxisMax: Int,
        isPrioritizing: Boolean,
    ): Constraints {
        return createColumnConstraints(
            isPrioritizing,
            mainAxisMin,
            crossAxisMin,
            mainAxisMax,
            crossAxisMax,
        )
    }

    override fun MeasureScope.measure(
        measurables: List<Measurable>,
        constraints: Constraints,
    ): MeasureResult {
        return measure(
            constraints.minHeight,
            constraints.minWidth,
            constraints.maxHeight,
            constraints.maxWidth,
            verticalArrangement.spacing.roundToPx(),
            this,
            measurables,
            arrayOfNulls(measurables.size),
            0,
            measurables.size
        )
    }

    override fun IntrinsicMeasureScope.minIntrinsicWidth(
        measurables: List<IntrinsicMeasurable>,
        height: Int,
    ) =
        IntrinsicMeasureBlocks.VerticalMinWidth(
            measurables,
            height,
            verticalArrangement.spacing.roundToPx(),
        )

    override fun IntrinsicMeasureScope.minIntrinsicHeight(
        measurables: List<IntrinsicMeasurable>,
        width: Int,
    ) =
        IntrinsicMeasureBlocks.VerticalMinHeight(
            measurables,
            width,
            verticalArrangement.spacing.roundToPx(),
        )

    override fun IntrinsicMeasureScope.maxIntrinsicWidth(
        measurables: List<IntrinsicMeasurable>,
        height: Int,
    ) =
        IntrinsicMeasureBlocks.VerticalMaxWidth(
            measurables,
            height,
            verticalArrangement.spacing.roundToPx(),
        )

    override fun IntrinsicMeasureScope.maxIntrinsicHeight(
        measurables: List<IntrinsicMeasurable>,
        width: Int,
    ) =
        IntrinsicMeasureBlocks.VerticalMaxHeight(
            measurables,
            width,
            verticalArrangement.spacing.roundToPx(),
        )
}

internal fun createColumnConstraints(
    isPrioritizing: Boolean,
    mainAxisMin: Int,
    crossAxisMin: Int,
    mainAxisMax: Int,
    crossAxisMax: Int,
): Constraints {
    return if (!isPrioritizing) {
        Constraints(
            minHeight = mainAxisMin,
            minWidth = crossAxisMin,
            maxHeight = mainAxisMax,
            maxWidth = crossAxisMax,
        )
    } else {
        Constraints.fitPrioritizingHeight(
            minHeight = mainAxisMin,
            minWidth = crossAxisMin,
            maxHeight = mainAxisMax,
            maxWidth = crossAxisMax,
        )
    }
}

@LayoutScopeMarker
@Immutable
interface VStackColumnScope {
    /**
     * SwiftUI-like flexible sizing.
     */
    @Stable
    fun Modifier.flexible(ideal: Float? = null, min: Float? = null, max: Float? = null): Modifier

    @Stable fun Modifier.align(alignment: Alignment.Horizontal): Modifier

    @Stable fun Modifier.alignBy(alignmentLine: VerticalAlignmentLine): Modifier

    @Stable fun Modifier.alignBy(alignmentLineBlock: (Measured) -> Int): Modifier
}

internal object VStackColumnScopeInstance : VStackColumnScope {
    @Stable
    override fun Modifier.flexible(ideal: Float?, min: Float?, max: Float?): Modifier {
        return this.then(
            LayoutFlexibleElement(
                ideal = ideal,
                min = min,
                max = max
            )
        ).applyNonExpandingFlexibleHeight(ideal = ideal, min = min, max = max)
    }

    @Stable
    override fun Modifier.align(alignment: Alignment.Horizontal) =
        this.then(HorizontalAlignElement(horizontal = alignment))

    @Stable
    override fun Modifier.alignBy(alignmentLine: VerticalAlignmentLine) =
        this.then(WithAlignmentLineElement(alignmentLine = alignmentLine))

    @Stable
    override fun Modifier.alignBy(alignmentLineBlock: (Measured) -> Int) =
        this.then(WithAlignmentLineBlockElement(block = alignmentLineBlock))
}

/*
 * Modified version of RowColumnMeasurePolicy.kt
 */

internal interface RowColumnMeasurePolicy {
    fun Measurable.intrinsicMainAxisSize(crossAxisSize: Int): Int

    fun Placeable.mainAxisConstrainedSize(): Int
    fun Placeable.mainAxisMeasuredSize(): Int

    fun Placeable.crossAxisConstrainedSize(): Int
    fun Placeable.crossAxisMeasuredSize(): Int

    fun populateMainAxisPositions(
        mainAxisLayoutSize: Int,
        children: List<RowColumnChildInfo>,
        mainAxisPositions: IntArray,
        measureScope: MeasureScope,
    )

    fun placeHelper(
        placeables: Array<Placeable?>,
        measureScope: MeasureScope,
        beforeCrossAxisAlignmentLine: Int,
        mainAxisPositions: IntArray,
        mainAxisLayoutSize: Int,
        crossAxisLayoutSize: Int,
        crossAxisOffset: IntArray?,
        currentLineIndex: Int,
        startIndex: Int,
        endIndex: Int,
    ): MeasureResult

    fun createConstraints(
        mainAxisMin: Int,
        crossAxisMin: Int,
        mainAxisMax: Int,
        crossAxisMax: Int,
        isPrioritizing: Boolean = false,
    ): Constraints
}

internal data class RowColumnChildInfo(val index: Int, var mainAxisConstrainedSize: Int = 0, var mainAxisMeasuredSize: Int = 0, var intrinsic: Int? = null, var measured: Boolean = false)

internal data class RowColumnMeasureInfo(var anyAlignBy: Boolean = false, var crossAxisMeasuredSize: Int = 0, var remainingFlexibleChildrenCount: Int = 0, var flexibleSize: Int = 0)

internal fun RowColumnMeasurePolicy.measure(
    mainAxisMin: Int,
    crossAxisMin: Int,
    mainAxisMax: Int,
    crossAxisMax: Int,
    arrangementSpacing: Int,
    measureScope: MeasureScope,
    measurables: List<Measurable>,
    placeables: Array<Placeable?>,
    startIndex: Int,
    endIndex: Int,
    crossAxisOffset: IntArray? = null,
    currentLineIndex: Int = 0
): MeasureResult {
    val children = (startIndex until endIndex).map { RowColumnChildInfo(it) }
    val measureInfo = RowColumnMeasureInfo()
    val totalSpacing = arrangementSpacing * (children.size - 1)

    // First measure children whose width is fixed
    var fixedSize = 0
    var spaceChildrenMinSize = 0
    var spaceChildrenCount = 0
    for (child in children) {
        val measurable = measurables[child.index]
        val parentData = measurable.rowColumnParentData
        if (parentData?.flexibleMax != null) {
            measureInfo.remainingFlexibleChildrenCount++
            if (parentData.flexibleMax == Float.flexibleSpace) {
                spaceChildrenCount++
                if (parentData.flexibleMin != null && parentData.flexibleMin!! > 0f) {
                    spaceChildrenMinSize += (parentData.flexibleMin!! * measureScope.density).roundToInt()
                }
            }
            continue
        }

        measureInfo.anyAlignBy = measureInfo.anyAlignBy || parentData.isRelative
        val crossAxisDesiredSize = if (crossAxisMax == Constraints.Infinity) null else {
            parentData?.flowLayoutData?.let {
                (it.fillCrossAxisFraction * crossAxisMax).fastRoundToInt()
            }
        }
        val remainingSize = mainAxisMax - totalSpacing - fixedSize
        val placeable = placeables[child.index] ?: measurable.measure(
            createConstraints(
                mainAxisMin = 0,
                crossAxisMin = crossAxisDesiredSize ?: 0,
                mainAxisMax = if (mainAxisMax == Constraints.Infinity) {
                    Constraints.Infinity
                } else {
                    remainingSize.fastCoerceAtLeast(0)
                },
                crossAxisMax = crossAxisDesiredSize ?: crossAxisMax,
            )
        )
        placeables[child.index] = placeable
        child.measured = true
        child.mainAxisConstrainedSize = placeable.mainAxisConstrainedSize()
        child.mainAxisMeasuredSize = placeable.mainAxisMeasuredSize()
        fixedSize += child.mainAxisMeasuredSize
        measureInfo.crossAxisMeasuredSize = max(measureInfo.crossAxisMeasuredSize, placeable.crossAxisMeasuredSize())
    }

    // Measure children with a max that may be under the unit size so that we can allocate the
    // unused space to other children
    while (true) {
        val measuredChildrenCount = measureFlexible(
            children = children,
            measurables = measurables,
            placeables = placeables,
            measureInfo = measureInfo,
            mainAxisMin = mainAxisMin,
            mainAxisMax = mainAxisMax,
            crossAxisMax = crossAxisMax,
            fixedSize = fixedSize,
            includeSpacers = false,
            totalSpacing = totalSpacing,
            spaceChildrenCount = spaceChildrenCount,
            spaceChildrenMinSize = spaceChildrenMinSize
        ) l@{ child, measurable, parentData, flexibleUnitSize ->
            if (flexibleUnitSize <= 0 || parentData?.flexibleMax?.isFlexibleNonExpandingMax != true) {
                return@l false
            }
            var flexibleMaxPx: Int? = null
            if (parentData.flexibleMax!! >= 0f) {
                flexibleMaxPx = (parentData.flexibleMax!! * measureScope.density).roundToInt()
            } else if (parentData.flexibleMax == Float.flexibleUnknownNonExpanding) {
                if (child.intrinsic == null) {
                    val crossAxisDesiredSize = if (crossAxisMax == Constraints.Infinity) null else {
                        parentData.flowLayoutData?.let {
                            (it.fillCrossAxisFraction * crossAxisMax).fastRoundToInt()
                        }
                    }
                    child.intrinsic = measurable.intrinsicMainAxisSize(crossAxisDesiredSize ?: crossAxisMax)
                }
                flexibleMaxPx = child.intrinsic
            }
            return@l flexibleMaxPx != null && flexibleMaxPx <= flexibleUnitSize
        }
        if (measuredChildrenCount == 0) {
            break
        }
    }

    // Measure remaining non-expanding children
    measureFlexible(
        children = children,
        measurables = measurables,
        placeables = placeables,
        measureInfo = measureInfo,
        mainAxisMin = mainAxisMin,
        mainAxisMax = mainAxisMax,
        crossAxisMax = crossAxisMax,
        fixedSize = fixedSize,
        includeSpacers = false,
        totalSpacing = totalSpacing,
        spaceChildrenCount = spaceChildrenCount,
        spaceChildrenMinSize = spaceChildrenMinSize
    ) { _, _, parentData, _ ->
        parentData?.flexibleMax?.isFlexibleExpanding != true
    }

    // Measure non-space children
    measureFlexible(
        children = children,
        measurables = measurables,
        placeables = placeables,
        measureInfo = measureInfo,
        mainAxisMin = mainAxisMin,
        mainAxisMax = mainAxisMax,
        crossAxisMax = crossAxisMax,
        fixedSize = fixedSize,
        includeSpacers = false,
        totalSpacing = totalSpacing,
        spaceChildrenCount = spaceChildrenCount,
        spaceChildrenMinSize = spaceChildrenMinSize
    ) { _, _, parentData, _ ->
        parentData?.flexibleMax != Float.flexibleSpace
    }

    // Measure remaining (space) children
    measureFlexible(
        children = children,
        measurables = measurables,
        placeables = placeables,
        measureInfo = measureInfo,
        mainAxisMin = mainAxisMin,
        mainAxisMax = mainAxisMax,
        crossAxisMax = crossAxisMax,
        fixedSize = fixedSize,
        includeSpacers = true,
        totalSpacing = totalSpacing,
        spaceChildrenCount = spaceChildrenCount,
        spaceChildrenMinSize = spaceChildrenMinSize
    ) { _, _, _, _ ->
        true
    }

    var beforeCrossAxisAlignmentLine = 0
    var afterCrossAxisAlignmentLine = 0
    if (measureInfo.anyAlignBy) {
        for (i in startIndex until endIndex) {
            val placeable = placeables[i]
            val parentData = placeable!!.rowColumnParentData
            val alignmentLinePosition = parentData.crossAxisAlignment?.calculateAlignmentLinePosition(placeable)
            alignmentLinePosition?.let {
                val placeableCrossAxisMeasuredSize = placeable.crossAxisMeasuredSize()
                beforeCrossAxisAlignmentLine = max(
                    beforeCrossAxisAlignmentLine,
                    if (it != AlignmentLine.Unspecified) alignmentLinePosition else 0
                )
                afterCrossAxisAlignmentLine = max(
                    afterCrossAxisAlignmentLine,
                    placeableCrossAxisMeasuredSize - if (it != AlignmentLine.Unspecified) it else placeableCrossAxisMeasuredSize
                )
            }
        }
    }

    // Compute the Row or Column size and position the children.
    val mainAxisLayoutSize = max((fixedSize + measureInfo.flexibleSize + totalSpacing).fastCoerceAtLeast(0), mainAxisMin)
    val crossAxisLayoutSize = maxOf(
        measureInfo.crossAxisMeasuredSize,
        crossAxisMin,
        beforeCrossAxisAlignmentLine + afterCrossAxisAlignmentLine
    )
    val mainAxisPositions = IntArray(endIndex - startIndex)
    populateMainAxisPositions(
        mainAxisLayoutSize,
        children,
        mainAxisPositions,
        measureScope,
    )

    return placeHelper(
        placeables,
        measureScope,
        beforeCrossAxisAlignmentLine,
        mainAxisPositions,
        mainAxisLayoutSize,
        crossAxisLayoutSize,
        crossAxisOffset,
        currentLineIndex,
        startIndex,
        endIndex,
    )
}

private fun RowColumnMeasurePolicy.measureFlexible(
    children: List<RowColumnChildInfo>,
    measurables: List<Measurable>,
    placeables: Array<Placeable?>,
    measureInfo: RowColumnMeasureInfo,
    mainAxisMin: Int,
    mainAxisMax: Int,
    crossAxisMax: Int,
    fixedSize: Int,
    totalSpacing: Int,
    includeSpacers: Boolean,
    spaceChildrenCount: Int,
    spaceChildrenMinSize: Int,
    shouldMeasure: (RowColumnChildInfo, Measurable, RowColumnParentData?, Int) -> Boolean
): Int {
    val childrenCount = if (includeSpacers) measureInfo.remainingFlexibleChildrenCount else measureInfo.remainingFlexibleChildrenCount - spaceChildrenCount
    if (childrenCount <= 0) {
        return 0
    }
    val targetSize = if (mainAxisMax != Constraints.Infinity) mainAxisMax else mainAxisMin
    val remainingSize = (targetSize - totalSpacing - fixedSize - measureInfo.flexibleSize - spaceChildrenMinSize).fastCoerceAtLeast(0)
    val roundedUnitSize = remainingSize / childrenCount
    val roundSlopCount = remainingSize - (roundedUnitSize * childrenCount)
    var measuredChildren = 0
    for (child in children) {
        if (child.measured) {
            continue
        }
        val measurable = measurables[child.index]
        val parentData = measurable.rowColumnParentData
        var flexibleUnitSize = roundedUnitSize
        if (measuredChildren < roundSlopCount) {
            flexibleUnitSize += 1
        }
        if (!shouldMeasure(child, measurables[child.index], parentData, flexibleUnitSize)) {
            continue
        }

        measureInfo.anyAlignBy = measureInfo.anyAlignBy || parentData.isRelative
        val crossAxisDesiredSize = if (crossAxisMax == Constraints.Infinity) null else {
            parentData?.flowLayoutData?.let {
                (it.fillCrossAxisFraction * crossAxisMax).fastRoundToInt()
            }
        }

        val constrainedCrossAxisMin = crossAxisDesiredSize ?: 0
        val constrainedCrossAxisMax = crossAxisDesiredSize ?: crossAxisMax
        var constrainedMainAxisMin = if (parentData?.flexibleMax?.isFlexibleExpanding == true) flexibleUnitSize else 0
        var constrainedMainAxisMax = flexibleUnitSize
        // If we have infinite space (e.g. an element of a scroll view), use our intrinsic size
        if (mainAxisMax == Constraints.Infinity) {
            if (child.intrinsic == null) {
                child.intrinsic = measurable.intrinsicMainAxisSize(constrainedCrossAxisMax)
            }
            constrainedMainAxisMax = child.intrinsic!!
        }

        val placeable = placeables[child.index] ?: measurable.measure(
            createConstraints(
                mainAxisMin = constrainedMainAxisMin,
                crossAxisMin = constrainedCrossAxisMin,
                mainAxisMax = constrainedMainAxisMax,
                crossAxisMax = constrainedCrossAxisMax
            )
        )
        placeables[child.index] = placeable
        child.measured = true
        child.mainAxisConstrainedSize = placeable.mainAxisConstrainedSize()
        child.mainAxisMeasuredSize = placeable.mainAxisMeasuredSize()
        measureInfo.flexibleSize += child.mainAxisMeasuredSize
        measureInfo.crossAxisMeasuredSize = max(measureInfo.crossAxisMeasuredSize, placeable.crossAxisMeasuredSize())

        ++measuredChildren
    }
    measureInfo.remainingFlexibleChildrenCount -= measuredChildren
    return measuredChildren
}

/*
 * Modified ersion of RowColumnImpl.kt
 */

internal enum class LayoutOrientation {
    Horizontal,
    Vertical,
}

//@Immutable
internal sealed class CrossAxisAlignment {
    internal abstract fun align(
        size: Int,
        layoutDirection: LayoutDirection,
        placeable: Placeable,
        beforeCrossAxisAlignmentLine: Int,
    ): Int

    internal open val isRelative: Boolean
        get() = false

    internal open fun calculateAlignmentLinePosition(placeable: Placeable): Int? = null

    companion object {
        @Stable val Center: CrossAxisAlignment = CenterCrossAxisAlignment

        @Stable val Start: CrossAxisAlignment = StartCrossAxisAlignment

        @Stable val End: CrossAxisAlignment = EndCrossAxisAlignment

        fun AlignmentLine(alignmentLine: AlignmentLine): CrossAxisAlignment =
            AlignmentLineCrossAxisAlignment(AlignmentLineProvider.Value(alignmentLine))

        internal fun Relative(alignmentLineProvider: AlignmentLineProvider): CrossAxisAlignment =
            AlignmentLineCrossAxisAlignment(alignmentLineProvider)

        internal fun vertical(vertical: Alignment.Vertical): CrossAxisAlignment =
            VerticalCrossAxisAlignment(vertical)

        internal fun horizontal(horizontal: Alignment.Horizontal): CrossAxisAlignment =
            HorizontalCrossAxisAlignment(horizontal)
    }

    private object CenterCrossAxisAlignment : CrossAxisAlignment() {
        override fun align(
            size: Int,
            layoutDirection: LayoutDirection,
            placeable: Placeable,
            beforeCrossAxisAlignmentLine: Int,
        ): Int {
            return size / 2
        }
    }

    private object StartCrossAxisAlignment : CrossAxisAlignment() {
        override fun align(
            size: Int,
            layoutDirection: LayoutDirection,
            placeable: Placeable,
            beforeCrossAxisAlignmentLine: Int,
        ): Int {
            return if (layoutDirection == LayoutDirection.Ltr) 0 else size
        }
    }

    private object EndCrossAxisAlignment : CrossAxisAlignment() {
        override fun align(
            size: Int,
            layoutDirection: LayoutDirection,
            placeable: Placeable,
            beforeCrossAxisAlignmentLine: Int,
        ): Int {
            return if (layoutDirection == LayoutDirection.Ltr) size else 0
        }
    }

    private class AlignmentLineCrossAxisAlignment(
        val alignmentLineProvider: AlignmentLineProvider
    ) : CrossAxisAlignment() {
        override val isRelative: Boolean
            get() = true

        override fun calculateAlignmentLinePosition(placeable: Placeable): Int {
            return alignmentLineProvider.calculateAlignmentLinePosition(placeable)
        }

        override fun align(
            size: Int,
            layoutDirection: LayoutDirection,
            placeable: Placeable,
            beforeCrossAxisAlignmentLine: Int,
        ): Int {
            val alignmentLinePosition =
                alignmentLineProvider.calculateAlignmentLinePosition(placeable)
            return if (alignmentLinePosition != AlignmentLine.Unspecified) {
                val line = beforeCrossAxisAlignmentLine - alignmentLinePosition
                if (layoutDirection == LayoutDirection.Rtl) {
                    size - line
                } else {
                    line
                }
            } else {
                0
            }
        }
    }

    private data class VerticalCrossAxisAlignment(val vertical: Alignment.Vertical) :
        CrossAxisAlignment() {
        override fun align(
            size: Int,
            layoutDirection: LayoutDirection,
            placeable: Placeable,
            beforeCrossAxisAlignmentLine: Int,
        ): Int {
            return vertical.align(0, size)
        }
    }

    private data class HorizontalCrossAxisAlignment(val horizontal: Alignment.Horizontal) :
        CrossAxisAlignment() {
        override fun align(
            size: Int,
            layoutDirection: LayoutDirection,
            placeable: Placeable,
            beforeCrossAxisAlignmentLine: Int,
        ): Int {
            return horizontal.align(0, size, layoutDirection)
        }
    }
}

@JvmInline
internal value class OrientationIndependentConstraints
private constructor(private val value: Constraints) {
    inline val mainAxisMin: Int
        get() = value.minWidth

    inline val mainAxisMax: Int
        get() = value.maxWidth

    inline val crossAxisMin: Int
        get() = value.minHeight

    inline val crossAxisMax: Int
        get() = value.maxHeight

    constructor(
        mainAxisMin: Int,
        mainAxisMax: Int,
        crossAxisMin: Int,
        crossAxisMax: Int,
    ) : this(
        Constraints(
            minWidth = mainAxisMin,
            maxWidth = mainAxisMax,
            minHeight = crossAxisMin,
            maxHeight = crossAxisMax,
        )
    )

    constructor(
        c: Constraints,
        orientation: LayoutOrientation,
    ) : this(
        if (orientation === LayoutOrientation.Horizontal) c.minWidth else c.minHeight,
        if (orientation === LayoutOrientation.Horizontal) c.maxWidth else c.maxHeight,
        if (orientation === LayoutOrientation.Horizontal) c.minHeight else c.minWidth,
        if (orientation === LayoutOrientation.Horizontal) c.maxHeight else c.maxWidth,
    )

    // Creates a new instance with the same main axis constraints and maximum tight cross axis.
    fun stretchCrossAxis() =
        OrientationIndependentConstraints(
            mainAxisMin,
            mainAxisMax,
            if (crossAxisMax != Constraints.Infinity) crossAxisMax else crossAxisMin,
            crossAxisMax,
        )

    // Given an orientation, resolves the current instance to traditional constraints.
    fun toBoxConstraints(orientation: LayoutOrientation) =
        if (orientation === LayoutOrientation.Horizontal) {
            Constraints(mainAxisMin, mainAxisMax, crossAxisMin, crossAxisMax)
        } else {
            Constraints(crossAxisMin, crossAxisMax, mainAxisMin, mainAxisMax)
        }

    // Given an orientation, resolves the max width constraint this instance represents.
    fun maxWidth(orientation: LayoutOrientation) =
        if (orientation === LayoutOrientation.Horizontal) {
            mainAxisMax
        } else {
            crossAxisMax
        }

    // Given an orientation, resolves the max height constraint this instance represents.
    fun maxHeight(orientation: LayoutOrientation) =
        if (orientation === LayoutOrientation.Horizontal) {
            crossAxisMax
        } else {
            mainAxisMax
        }

    fun copy(
        mainAxisMin: Int = this.mainAxisMin,
        mainAxisMax: Int = this.mainAxisMax,
        crossAxisMin: Int = this.crossAxisMin,
        crossAxisMax: Int = this.crossAxisMax,
    ): OrientationIndependentConstraints =
        OrientationIndependentConstraints(mainAxisMin, mainAxisMax, crossAxisMin, crossAxisMax)
}

internal val IntrinsicMeasurable.rowColumnParentData: RowColumnParentData?
    get() = parentData as? RowColumnParentData

internal val Placeable.rowColumnParentData: RowColumnParentData?
    get() = parentData as? RowColumnParentData

internal val RowColumnParentData?.crossAxisAlignment: CrossAxisAlignment?
    get() = this?.crossAxisAlignment

internal val RowColumnParentData?.isRelative: Boolean
    get() = this.crossAxisAlignment?.isRelative ?: false

internal object IntrinsicMeasureBlocks {
    fun HorizontalMinWidth(
        measurables: List<IntrinsicMeasurable>,
        availableHeight: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicMainAxisSize(
            measurables,
            { h -> minIntrinsicWidth(h) },
            availableHeight,
            mainAxisSpacing,
        )
    }

    fun VerticalMinWidth(
        measurables: List<IntrinsicMeasurable>,
        availableHeight: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicCrossAxisSize(
            measurables,
            { w -> maxIntrinsicHeight(w) },
            { h -> minIntrinsicWidth(h) },
            availableHeight,
            mainAxisSpacing,
        )
    }

    fun HorizontalMinHeight(
        measurables: List<IntrinsicMeasurable>,
        availableWidth: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicCrossAxisSize(
            measurables,
            { h -> maxIntrinsicWidth(h) },
            { w -> minIntrinsicHeight(w) },
            availableWidth,
            mainAxisSpacing,
        )
    }

    fun VerticalMinHeight(
        measurables: List<IntrinsicMeasurable>,
        availableWidth: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicMainAxisSize(
            measurables,
            { w -> minIntrinsicHeight(w) },
            availableWidth,
            mainAxisSpacing,
        )
    }

    fun HorizontalMaxWidth(
        measurables: List<IntrinsicMeasurable>,
        availableHeight: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicMainAxisSize(
            measurables,
            { h -> maxIntrinsicWidth(h) },
            availableHeight,
            mainAxisSpacing,
        )
    }

    fun VerticalMaxWidth(
        measurables: List<IntrinsicMeasurable>,
        availableHeight: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicCrossAxisSize(
            measurables,
            { w -> maxIntrinsicHeight(w) },
            { h -> maxIntrinsicWidth(h) },
            availableHeight,
            mainAxisSpacing,
        )
    }

    fun HorizontalMaxHeight(
        measurables: List<IntrinsicMeasurable>,
        availableWidth: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicCrossAxisSize(
            measurables,
            { h -> maxIntrinsicWidth(h) },
            { w -> maxIntrinsicHeight(w) },
            availableWidth,
            mainAxisSpacing,
        )
    }

    fun VerticalMaxHeight(
        measurables: List<IntrinsicMeasurable>,
        availableWidth: Int,
        mainAxisSpacing: Int,
    ): Int {
        return intrinsicMainAxisSize(
            measurables,
            { w -> maxIntrinsicHeight(w) },
            availableWidth,
            mainAxisSpacing,
        )
    }
}

private inline fun intrinsicMainAxisSize(
    children: List<IntrinsicMeasurable>,
    mainAxisSize: IntrinsicMeasurable.(Int) -> Int,
    crossAxisAvailable: Int,
    mainAxisSpacing: Int,
): Int {
    if (children.isEmpty()) return 0
    val totalSpacing = (children.size - 1) * mainAxisSpacing
    return totalSpacing + children.sumOf { it.mainAxisSize(crossAxisAvailable) }
}

private inline fun intrinsicCrossAxisSize(
    children: List<IntrinsicMeasurable>,
    mainAxisSize: IntrinsicMeasurable.(Int) -> Int,
    crossAxisSize: IntrinsicMeasurable.(Int) -> Int,
    mainAxisAvailable: Int,
    mainAxisSpacing: Int,
): Int {
    if (children.isEmpty()) return 0
    var fixedSpace = min((children.size - 1) * mainAxisSpacing, mainAxisAvailable)
    var crossAxisMax = 0
    children.forEach { child ->
        // Ask the child how much main axis space it wants to occupy. This cannot be more
        // than the remaining available space.
        val remaining = if (mainAxisAvailable == Constraints.Infinity) Constraints.Infinity else mainAxisAvailable - fixedSpace
        val mainAxisSpace = min(child.mainAxisSize(Constraints.Infinity), remaining)
        fixedSpace += mainAxisSpace
        // Now that the assigned main axis space is known, ask about the cross axis space.
        crossAxisMax = max(crossAxisMax, child.crossAxisSize(mainAxisSpace))
    }
    return crossAxisMax
}

internal class LayoutFlexibleElement(val ideal: Float?, val min: Float?, val max: Float?):
    ModifierNodeElement<LayoutFlexibleNode>() {
    override fun create(): LayoutFlexibleNode {
        return LayoutFlexibleNode(ideal, min, max)
    }

    override fun update(node: LayoutFlexibleNode) {
        node.ideal = ideal ?: node.ideal
        node.min = min ?: node.min
        node.max = max ?: node.max
    }

    override fun InspectorInfo.inspectableProperties() {
        name = "flexible"
        value = Triple(ideal, min, max)
        properties["ideal"] = ideal
        properties["min"] = min
        properties["max"] = max
    }

    override fun hashCode(): Int {
        var result = ideal.hashCode()
        result = 31 * result + min.hashCode()
        result = 31 * result + max.hashCode()
        return result
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        val otherModifier = other as? LayoutFlexibleElement ?: return false
        return ideal == otherModifier.ideal && min == otherModifier.min && max == otherModifier.max
    }
}

internal class LayoutFlexibleNode(var ideal: Float?, var min: Float?, var max: Float?) :
    ParentDataModifierNode, Modifier.Node() {
    override fun Density.modifyParentData(parentData: Any?) =
        ((parentData as? RowColumnParentData) ?: RowColumnParentData()).also {
            it.flexibleIdeal = ideal ?: it.flexibleIdeal
            it.flexibleMin = min ?: it.flexibleMin
            it.flexibleMax = max ?: it.flexibleMax
        }
}

internal class WithAlignmentLineBlockElement(val block: (Measured) -> Int) :
    ModifierNodeElement<SiblingsAlignedNode.WithAlignmentLineBlockNode>() {
    override fun create(): SiblingsAlignedNode.WithAlignmentLineBlockNode {
        return SiblingsAlignedNode.WithAlignmentLineBlockNode(block)
    }

    override fun update(node: SiblingsAlignedNode.WithAlignmentLineBlockNode) {
        node.block = block
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        val otherModifier = other as? WithAlignmentLineBlockElement ?: return false
        return block === otherModifier.block
    }

    override fun hashCode(): Int = block.hashCode()

    override fun InspectorInfo.inspectableProperties() {
        name = "alignBy"
        value = block
    }
}

internal class WithAlignmentLineElement(val alignmentLine: AlignmentLine) :
    ModifierNodeElement<SiblingsAlignedNode.WithAlignmentLineNode>() {
    override fun create(): SiblingsAlignedNode.WithAlignmentLineNode {
        return SiblingsAlignedNode.WithAlignmentLineNode(alignmentLine)
    }

    override fun update(node: SiblingsAlignedNode.WithAlignmentLineNode) {
        node.alignmentLine = alignmentLine
    }

    override fun InspectorInfo.inspectableProperties() {
        name = "alignBy"
        value = alignmentLine
    }

    override fun hashCode(): Int = alignmentLine.hashCode()

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        val otherModifier = other as? WithAlignmentLineElement ?: return false
        return alignmentLine == otherModifier.alignmentLine
    }
}

internal sealed class SiblingsAlignedNode : ParentDataModifierNode, Modifier.Node() {
    abstract override fun Density.modifyParentData(parentData: Any?): Any?

    internal class WithAlignmentLineBlockNode(var block: (Measured) -> Int) :
        SiblingsAlignedNode() {
        override fun Density.modifyParentData(parentData: Any?): Any {
            return ((parentData as? RowColumnParentData) ?: RowColumnParentData()).also {
                it.crossAxisAlignment =
                    CrossAxisAlignment.Relative(AlignmentLineProvider.Block(block))
            }
        }
    }

    internal class WithAlignmentLineNode(var alignmentLine: AlignmentLine) : SiblingsAlignedNode() {
        override fun Density.modifyParentData(parentData: Any?): Any {
            return ((parentData as? RowColumnParentData) ?: RowColumnParentData()).also {
                it.crossAxisAlignment =
                    CrossAxisAlignment.Relative(AlignmentLineProvider.Value(alignmentLine))
            }
        }
    }
}

internal class HorizontalAlignElement(val horizontal: Alignment.Horizontal) :
    ModifierNodeElement<HorizontalAlignNode>() {
    override fun create(): HorizontalAlignNode {
        return HorizontalAlignNode(horizontal)
    }

    override fun update(node: HorizontalAlignNode) {
        node.horizontal = horizontal
    }

    override fun InspectorInfo.inspectableProperties() {
        name = "align"
        value = horizontal
    }

    override fun hashCode(): Int = horizontal.hashCode()

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        val otherModifier = other as? HorizontalAlignElement ?: return false
        return horizontal == otherModifier.horizontal
    }
}

internal class HorizontalAlignNode(var horizontal: Alignment.Horizontal) :
    ParentDataModifierNode, Modifier.Node() {
    override fun Density.modifyParentData(parentData: Any?): RowColumnParentData {
        return ((parentData as? RowColumnParentData) ?: RowColumnParentData()).also {
            it.crossAxisAlignment = CrossAxisAlignment.horizontal(horizontal)
        }
    }
}

internal class VerticalAlignElement(val alignment: Alignment.Vertical) :
    ModifierNodeElement<VerticalAlignNode>() {
    override fun create(): VerticalAlignNode {
        return VerticalAlignNode(alignment)
    }

    override fun update(node: VerticalAlignNode) {
        node.vertical = alignment
    }

    override fun InspectorInfo.inspectableProperties() {
        name = "align"
        value = alignment
    }

    override fun hashCode(): Int = alignment.hashCode()

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        val otherModifier = other as? VerticalAlignElement ?: return false
        return alignment == otherModifier.alignment
    }
}

internal class VerticalAlignNode(var vertical: Alignment.Vertical) :
    ParentDataModifierNode, Modifier.Node() {
    override fun Density.modifyParentData(parentData: Any?): RowColumnParentData {
        return ((parentData as? RowColumnParentData) ?: RowColumnParentData()).also {
            it.crossAxisAlignment = CrossAxisAlignment.vertical(vertical)
        }
    }
}

internal data class RowColumnParentData(
    var fill: Boolean = true,
    var flexibleIdeal: Float? = null,
    var flexibleMin: Float? = null,
    var flexibleMax: Float? = null,
    var crossAxisAlignment: CrossAxisAlignment? = null,
    var flowLayoutData: FlowLayoutData? = null,
)

internal sealed class AlignmentLineProvider {
    abstract fun calculateAlignmentLinePosition(placeable: Placeable): Int

    data class Block(val lineProviderBlock: (Measured) -> Int) : AlignmentLineProvider() {
        override fun calculateAlignmentLinePosition(placeable: Placeable): Int {
            return lineProviderBlock(placeable)
        }
    }

    data class Value(val alignmentLine: AlignmentLine) : AlignmentLineProvider() {
        override fun calculateAlignmentLinePosition(placeable: Placeable): Int {
            return placeable[alignmentLine]
        }
    }
}

/*
 * Modified version of FlowLayout.kt
 */

internal data class FlowLayoutData(var fillCrossAxisFraction: Float)
