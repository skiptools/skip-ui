# Sheet clipping regression

`SkipUITests/Skip/SheetPresentationTests.kt` exercises the production Android
`SheetPresentation` with a minimal Compose body. It needs no application,
network service, account, or measured-content sizing code.

The regression changes a fixed detent from 260 to 520 points. The header's
layout moves immediately. Before the fix, the clipping outline can still use
the previous top inset for one frame, hiding the header. The fix reads the inset
while constructing the outline instead of capturing it earlier in composition.

## Why the original code could hide content

The sheet uses the same top inset for two jobs: positioning the content below
its reserved top space, and clipping away that space. Those values must agree
in the frame being drawn.

Previously, `SheetPresentation` read `topInset.value` in its outer composition
and captured the resulting pixel value in the `GenericShape` closure. The
`ModalBottomSheet` content then resolved the current detent and window insets
and wrote a new value to `topInset` later in composition.

For example, when a sheet expands from 260 to 520 points:

1. The shape closure initially captures the larger top inset of the short sheet.
2. The modal content computes a smaller inset and lays out the header higher up.
3. Until the outer composition catches up, the old clipping boundary can cut
   away the newly positioned header. The content exists but is not drawn.

The change keeps the inset calculation and content layout intact. It moves only
its state read into outline construction:

```swift
// Before: the shape captures a pixel value from an earlier composition.
let topInsetPx = with(LocalDensity.current) { topInset.value.toPx() }
let shape = GenericShape { size, _ in
    let y = topInsetPx - handleHeightPx - handlePaddingPx
    // ...
}

// After: the outline uses the current inset when it is constructed.
let density = LocalDensity.current
let shape = GenericShape { size, _ in
    let topInsetPx = with(density) { topInset.value.toPx() }
    let y = topInsetPx - handleHeightPx - handlePaddingPx
    // ...
}
```

This addresses inconsistent clipping during a layout transition. It does not
suppress general recomposition or change detent selection, measurement, or
animation. The modified presenter serves Android sheets and full-screen covers;
it does not change the shared geometry observer, alerts, or iOS presentation.

The regression fails on the original code and passes with the change on a
Samsung SM-S721U and Pixel 9 Pro emulator, both running Android 16. Eleven
behavioral checks pass on each target. The recording helper is opt-in and is
skipped during the regular suite. Frame inspection supports the narrow clipping
finding; the brief artifact is not a persuasive normal-speed video demonstration
of a broader flicker improvement.

## Running

Generate the package's Skip test project with `swift test list`, then build its
`SkipUI:assembleDebugAndroidTest` Gradle task using the configured toolchain.
Install the resulting test APK on an Android device or emulator. Run:

```sh
adb -s DEVICE shell am instrument -w \
  -e class skip.ui.SheetPresentationTests \
  skip.ui.module.test/androidx.test.runner.AndroidJUnitRunner
```

The tests sample actual window pixels, so they skip under Robolectric. Run the
height regression in portrait: landscape may clamp both heights to the same
available area and therefore does not demonstrate this particular failure.

The Compose clock advances one frame at a time. An 80 ms wall-clock pause lets
Android drawing and the compositor present that frame without advancing the
Compose clock to the next frame. Assertions check the green header at its
current layout bounds. Failures save a PNG under the test application's external
files directory. This avoids treating a previous display frame as current.

`SheetTestActivity` exists only in the test manifest. Its configuration handling
allows real orientation changes while retaining the same Compose tree.

## Coverage

- Fixed, medium, large, and fractional detents; expanding and shrinking.
- Full-screen presentation and dismissal callback.
- Taps near the top edge, Back, drag dismissal, and reopening.
- Scrolling after content growth.
- Expanded text-input sheet: keyboard visibility, keyboard Back, then sheet Back.
- Nested-sheet dismissal without dismissing the parent.
- Android WebView identity retained across detent changes.
- Repeated updates, followed by no continuing body recomposition or redraw.
- Rotation with the sheet open and input retained.

The WebView case covers integration and retained identity, not every native-view
surface type. Video surfaces, popup windows, and every possible nested gesture
combination are not covered. Visual recordings give a provisional motion pass;
live motion quality still benefits from human review.

## Recording the minimal reproduction

Start an Android screen recording before running:

```sh
adb -s DEVICE shell am instrument -w \
  -e class skip.ui.SheetPresentationTests#recordDetentTransitions \
  -e sheetVideo true \
  skip.ui.module.test/androidx.test.runner.AndroidJUnitRunner
```

Use identical test code and device settings for the original and fixed library.
The recording steps the Compose clock at roughly real-time cadence and changes
only the requested detent. Keep original recordings for frame analysis. Label
any slowed copies explicitly, and preserve variable frame timestamps when
encoding: an average-frame-rate conversion can drop or lengthen the bad frame.

## Separate compact-sheet keyboard limitation

On both the original and fixed library, a 260-point sheet can lose its content
when the keyboard opens. The expanded sheet works. This is not fixed by the
outline change. To reproduce that separate issue, run the keyboard test with
`-e compactKeyboard true`; its visible-header assertion is expected to fail.
Keep this investigation separate from the clipping fix.
