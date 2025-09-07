// Copyright 2024–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
package skip.ui

import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.forEachGesture
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.input.pointer.PointerEvent
import androidx.compose.ui.input.pointer.PointerInputChange
import androidx.compose.ui.input.pointer.PointerInputScope
import androidx.compose.ui.input.pointer.positionChangeConsumed
import androidx.compose.ui.input.pointer.consumeAllChanges
import androidx.compose.ui.input.pointer.positionChanged
import androidx.compose.ui.util.fastAny
import androidx.compose.ui.util.fastForEach
import androidx.compose.ui.util.fastSumBy
import kotlin.contracts.ExperimentalContracts
import kotlin.math.PI
import kotlin.math.abs
import kotlin.math.atan2

/**
 * This file contains a modified version of Compose's `detectTransformGestures` that adds a
 * gensture end callback.
 */

suspend fun PointerInputScope.detectTransformGesturesWithGestureEnd(
    panZoomLock: Boolean = false,
    onGesture: (centroid: Offset, pan: Offset, zoom: Float, rotation: Float) -> Unit,
    onGestureEnd: () -> Unit
) {
    forEachGesture {
        awaitPointerEventScope {
            var rotation = 0f
            var zoom = 1f
            var pan = Offset.Zero
            var pastTouchSlop = false
            val touchSlop = viewConfiguration.touchSlop
            var lockedToPanZoom = false
            var hasSentGesture = false

            awaitFirstDown(requireUnconsumed = false)
            do {
                val event = awaitPointerEvent()
                val canceled = event.changes.fastAny { it.positionChangeConsumed() }
                val pointerCount = event.changes.fastSumBy { if (it.previousPressed && it.pressed) 1 else 0 }
                if (!canceled && pointerCount == 2) {
                    val zoomChange = event.calculateZoom()
                    val rotationChange = event.calculateRotation()
                    val panChange = event.calculatePan()

                    if (!pastTouchSlop) {
                        zoom *= zoomChange
                        rotation += rotationChange
                        pan += panChange

                        val centroidSize = event.calculateCentroidSize(useCurrent = false)
                        val zoomMotion = abs(1 - zoom) * centroidSize
                        val rotationMotion = abs(rotation * PI.toFloat() * centroidSize / 180f)
                        val panMotion = pan.getDistance()

                        if (zoomMotion > touchSlop ||
                            rotationMotion > touchSlop ||
                            panMotion > touchSlop
                        ) {
                            pastTouchSlop = true
                            lockedToPanZoom = panZoomLock && rotationMotion < touchSlop
                        }
                    }

                    if (pastTouchSlop) {
                        val centroid = event.calculateCentroid(useCurrent = false)
                        val effectiveRotation = if (lockedToPanZoom) 0f else rotationChange
                        if (effectiveRotation != 0f ||
                            zoomChange != 1f ||
                            panChange != Offset.Zero
                        ) {
                            onGesture(centroid, panChange, zoomChange, effectiveRotation)
                            hasSentGesture = true
                        }
                        event.changes.fastForEach {
                            if (it.positionChanged()) {
                                it.consumeAllChanges()
                            }
                        }
                    }
                }
            } while (!canceled && event.changes.fastAny { it.pressed })

            if (hasSentGesture) {
                onGestureEnd()
            }
        }
    }
}

fun PointerEvent.calculateRotation(): Float {
    val pointerCount = changes.fastSumBy { if (it.previousPressed && it.pressed) 1 else 0 }
    if (pointerCount < 2) {
        return 0f
    }
    val currentCentroid = calculateCentroid(useCurrent = true)
    val previousCentroid = calculateCentroid(useCurrent = false)
    var rotation = 0f
    var rotationWeight = 0f

    // We want to weigh each pointer differently so that motions farther from the
    // centroid have more weight than pointers close to the centroid. Essentially,
    // a small distance change near the centroid could equate to a large angle
    // change and we don't want it to affect the rotation as much as pointers farther
    // from the centroid, which should be more stable.

    changes.fastForEach { change ->
        if (change.pressed && change.previousPressed) {
            val currentPosition = change.position
            val previousPosition = change.previousPosition
            val previousOffset = previousPosition - previousCentroid
            val currentOffset = currentPosition - currentCentroid

            val previousAngle = previousOffset.angle()
            val currentAngle = currentOffset.angle()
            val angleDiff = currentAngle - previousAngle
            val weight = (currentOffset + previousOffset).getDistance() / 2f

            // We weigh the rotation with the distance to the centroid. This gives
            // more weight to angle changes from pointers farther from the centroid than
            // those that are closer.
            rotation += when {
                angleDiff > 180f -> angleDiff - 360f
                angleDiff < -180f -> angleDiff + 360f
                else -> angleDiff
            } * weight

            // weight its contribution by the distance to the centroid
            rotationWeight += weight
        }
    }
    return if (rotationWeight == 0f) 0f else rotation / rotationWeight
}

private fun Offset.angle(): Float =
    if (x == 0f && y == 0f) 0f else -atan2(x, y) * 180f / PI.toFloat()

fun PointerEvent.calculateZoom(): Float {
    val currentCentroidSize = calculateCentroidSize(useCurrent = true)
    val previousCentroidSize = calculateCentroidSize(useCurrent = false)
    if (currentCentroidSize == 0f || previousCentroidSize == 0f) {
        return 1f
    }
    return currentCentroidSize / previousCentroidSize
}

fun PointerEvent.calculatePan(): Offset {
    val currentCentroid = calculateCentroid(useCurrent = true)
    if (currentCentroid == Offset.Unspecified) {
        return Offset.Zero
    }
    val previousCentroid = calculateCentroid(useCurrent = false)
    return currentCentroid - previousCentroid
}

fun PointerEvent.calculateCentroidSize(useCurrent: Boolean = true): Float {
    val centroid = calculateCentroid(useCurrent)
    if (centroid == Offset.Unspecified) {
        return 0f
    }

    var distanceToCentroid = 0f
    var distanceWeight = 0
    changes.fastForEach { change ->
        if (change.pressed && change.previousPressed) {
            val position = if (useCurrent) change.position else change.previousPosition
            distanceToCentroid += (position - centroid).getDistance()
            distanceWeight++
        }
    }
    return distanceToCentroid / distanceWeight.toFloat()
}

@OptIn(ExperimentalContracts::class)
fun PointerEvent.calculateCentroid(
    useCurrent: Boolean = true
): Offset {
    var centroid = Offset.Zero
    var centroidWeight = 0

    changes.fastForEach { change ->
        if (change.pressed && change.previousPressed) {
            val position = if (useCurrent) change.position else change.previousPosition
            centroid += position
            centroidWeight++
        }
    }
    return if (centroidWeight == 0) {
        Offset.Unspecified
    } else {
        centroid / centroidWeight.toFloat()
    }
}
