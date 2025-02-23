## 1.26.1

Released 2025-02-23

  - Merge pull request #130 from skiptools/permissions
  - Add showRationale callback to requestPermission
  - Add UIApplication.shared.requestPermission

## 1.20.1

Released 2025-01-24

  - Merge pull request #111 from skiptools/vibrator-manager-os-check
  - Add View.sensoryFeedback functions
  - Check for android.os.Build.VERSION_CODES.S for VibratorManager

## 1.18.1

Released 2025-01-17

  - Localized strings will fall back to the default locale for unhandled locales (#107)
  - Fix HTML formatting

## 1.17.2

Released 2025-01-09

  - Add Text.init(LocalizedStringResource) (#101)

## 1.13.11

Released 2024-11-05

  - Merge pull request #87 from skiptools/svg-images
  - Upgrade to coil3 and add SVG image support

## 1.13.7

Released 2024-10-29

  - Merge pull request #82 from skiptools/uiimage-png-jpeg
  - Add support for UIImage pngData() and jpegData(compressionQuality:)

## 1.13.2

Released 2024-10-15


## 1.0.0

Released 2024-08-15


## 0.10.7

Released 2024-07-15

  - Change how UIApplication.open() launches a URL to fix error about missing FLAG_ACTIVITY_NEW_TASK (fixes https://github.com/orgs/skiptools/discussions/173)

## 0.10.0

Released 2024-07-03


## 0.9.6

Released 2024-05-31

  - Add height and fraction detents
  - Add sheet medium detent & support item argument (thanks, @Louis-PAGNIER)
  - Add Supported UIKit documentation section

## 0.9.5

Released 2024-05-29

  - Fix test case for percent literal in string interpolation
  - Add haptic feedback API; escape percent literals in interpolated strings to prevent them from being interpreted as Java format patterns
  - Add docs for PDF vector images

## 0.9.4

Released 2024-05-29

  - Add support for loading PDF vector icons and template images

## 0.8.11

Released 2024-05-14

  - Allow nil values for List/ForEach id key paths, which in turn allows users to use generic types for their identifier properties without explicitly putting an Any upper bounds on it
  - Add asset image and symbol loading

## 0.5.18

Released 2024-03-21

  - Add custom embedded font support

## 0.5.13

Released 2024-03-13

  - Add simple TextEditor component; move TextField and SecureField to Text folder

## 0.5.13

Released 2024-03-13

  - Add simple TextEditor component; move TextField and SecureField to Text folder

## 0.5.9

Released 2024-02-29

  - Elide compilation of stub code when #if !SKIP
  - Elide compilation of stub code when #if !SKIP
  - Support NavigationStack path binding to an array or NavigationPath
  - Prevent quick back taps from popping past root

## 0.5.6

Released 2024-02-25

  - Default to Bundle.main for Text localization

## 0.5.4

Released 2024-02-18

  - docs: move supported table above topics section
  - Documentation: update support swift table
  - Reference Showcase app in docs
  - Move API list to the end of the README

## 0.5.2

Released 2024-02-10

  - Invoke UserDefaults.obj(forKey:) rather than unescapable object(forKey:)
  - Disable some Android tests due to regressions with latest Compose BOM
  - Update README.md
  - Update README.md
  - Update README.md

## 0.5.0

Released 2024-02-05


## 0.4.1

Released 2024-01-12

  - Rename ShadowModifier.kt -> Shadowed.kt to match function name
  - Simplify and comment shadow implementation
  - Snapshot shadow work
  - Snapshot shadow work
  - Make locale, layoutDirection, timeZone settable in EnvironmentValues
  - Expose locale and timezone in environment

## 0.3.35

Released 2023-12-22

  - Add unit test diagnostics
  - Add Text(String) initialized to infer it as a LocalizedStringKey
  - Add test utilities
  - Add CHANGELOG.md
  - Add parameterized Text localization
  - Basic support for ShareLink

## 0.3.34

Released 2023-12-19

  - Tap nav bar to scroll to top
  - Support Menu
  - Support .zIndex
  - Update README for custom modifier support

## 0.3.33

Released 2023-12-14

  - Better support for View specialization based on placement
  - Support custom modifiers

## 0.3.32

Released 2023-12-13

  - Fix .overlay z-ordering

## 0.3.31

Released 2023-12-13

  - Fix system bar color to match Android's bottom bar
  - Update expected test output
  - Support .background(View) and .overlay

## 0.3.30

Released 2023-12-12

  - Skip tests that use Bundle.module when running against Android emulator to work around NoSuchMethodError
  - Add Localizable.xcstrings for testing
  - Support Link and @Environment(\.openURL)
  - Fix Text string interpolation tests
  - Add Text string interpolation tests
  - Implement localizable Text

## 0.3.29

Released 2023-12-11

  - Dark mode fixes

## 0.3.28

Released 2023-12-11

  - Update skip dependency

## 0.3.27

Released 2023-12-11

  - Update dependencies
  - Improve .searchable: more SwiftUI-like behavior when placed on List, no more infinite recompose cycles
  - Fixes for uses of linvoke in Composables, ForEach with Identifiable elements
  - Support .onChange
  - Remove unnecessary null navigator checks

## 0.3.26

Released 2023-11-29

  - Implement additional gesture handling, including DragGesture
  - Check for null in navigator.value to handle rotation changes without NPE (#20)
  - Implement SecureField
  - Implement onAppear, onDisappear
  - Update README.md

## 0.3.25

Released 2023-11-28

  - Implement onSubmit
  - Remove dynamic library type
  - Fix sheets inheriting searchable modifier from the ownign nav stack
  - Fixes to generic erasure in some SwiftUI views
  - Additional .searchable fixes. Implement keyboard modifiers
  - Implement basic .searchable support

## 0.3.24

Released 2023-11-23

  - Implement .onDelete and .onMove for ForEach in List. Fix List move operations to not commit until the drag ends.

## 0.3.22

Released 2023-11-21


## 0.3.21

Released 2023-11-21

  - Fixes, including handling of empty List views
  - Fix confirmationDialog default title visibility
  - Merge pull request #12 from pnewell/patch-1
  - Simplify topBar logic
  - Display toolbar for toolbar items at root

## 0.3.20

Released 2023-11-21

  - Update README
  - Implement .confirmationDialog

## 0.3.19

Released 2023-11-19

  - Implement .navigationBackButtonHidden
  - Fix AsyncImage jar URL caching
  - Update source headers
  - Support bottom toolbar
  - Add custom image fetcher for jar: URLs

## 0.3.18

Released 2023-11-18

  - Add local file and jar handling for AsyncImage

## 0.3.17

Released 2023-11-17

  - Update README
  - Top toolbar item support

## 0.3.16

Released 2023-11-17

  - Handle non-Parcelizable values as list item identifiers
  - Support Bindable and ObservedObject as actual property wrappers, now that the transpiler treats them as such

## 0.3.15

Released 2023-11-16

  - Much more gradient support
  - Custom shape support
  - Begin custom shape support
  - Update README
  - Update README

## 0.3.14

Released 2023-11-14

  - Update README
  - Additional item binding and reordering fixes
  - Fix use of stale state when reordering list items
  - List edit debugging
  - Drag to reorder in lists
  - Remove conflict marker from README

## 0.3.13

Released 2023-11-12

  - Update README for swipe-to-delete support
  - .deleteDisabled support
  - Implement basic swipe to delete support

## 0.3.12

Released 2023-11-09

  - Improved shape transform support

## 0.3.11

Released 2023-11-09

  - .clipShape support
  - Update README for shape support
  - Implement Capsule
  - Implement UnevenRoundedRectangle
  - Add RoundRectangle support
  - Shape enhancements
  - Implement Shape on top of Path
  - Introduce _layoutAxis env value and use it in Spacer, Divider

## 0.3.10

Released 2023-11-08

  - Additional fixes

## 0.3.9

Released 2023-11-08

  - More frame fixes, support alignment
  - Frame fixes
  - More Shape work
  - Fix test case

## 0.3.8

Released 2023-11-07

  - Support additional .frame specifications
  - More .background, .backgroundStyle support
  - Snapshot lots of Shape work
  - Implement Color.gradient appropriately
  - Vertical divider should expand container
  - Support vertical Divider
  - Remove custom compose componenets section; add color coding to Supported SwiftUI section

## 0.3.7

Released 2023-11-03

  - Fix ForEach within List not using effecient LazyColumn API
  - Snapshot work on ShapeStyle and Gradient
  - Support for foregroundStyle as an actual ShapeStyle (not just Color) and LinearGradient as the first non-Color style
  - Take advantage of new Skip support for static protocol extensions Use block form of .offset modifier
  - Snapshot progress on Shapes
  - Add ForEach.init(range:identifier:content:)

## 0.3.6

Released 2023-10-30

  - Support .offset
  - Fix emulator test failures

## 0.3.5

Released 2023-10-29

  - Fix crash when using an optional @State value

## 0.3.4

Released 2023-10-29

  - Doc updates
  - Support image modifiers like .aspectRatio with systemName images
  - Enhance image support with varying levels of support for: .aspectRatio, .clipped, .scaleToFit, .scaleToFill Also add .lineLimit to Text

## 0.3.3

Released 2023-10-29

  - Make ComposeContainer public
  - Update README for AsyncImage

## 0.3.2

Released 2023-10-27

  - Implement image.resizable() - only the no-args version
  - Get AsyncImage sizing behavior to match iOS. Still to go: image.resizable()

## 0.3.1

Released 2023-10-27

  - Get images appearing in AsyncImage. Scaling, cropping, etc not yet implemented
  - Expanding layout fixes. More stubbing of AsyncImage
  - Support .disabled. Stub out support for AsyncImage with coil
  - Mark the concrete Shape types as unavailable
  - Update README
  - Update README
  - Update README

## 0.3.0

Released 2023-10-23


## 0.2.32

Released 2023-10-24

  - Mark the concrete Shape types as unavailable
  - Update README
  - Update README
  - Update README

## 0.2.31

Released 2023-10-17

  - Add .onTapGesture, .onLongPressGesture support

## 0.2.30

Released 2023-10-17

  - Complete .sheet() support
  - Begin working on .sheet() support
  - Update README
  - Get dismiss() working for NavigationStack

## 0.2.29

Released 2023-10-14

  - List Section styling to more closely match iOS
  - Support for nesting ForEach and Section within each other in Lists

## 0.2.28

Released 2023-10-13

  - Snapshot work on list sections
  - No need to use inout param for Composer view. Update navigation push/pop animations.

## 0.2.27

Released 2023-10-12

  - Update README for ForEach support
  - Support ForEach, use for all List content internally
  - Attempt to always use lazy column for lists
  - Support Form
  - Mark more API as unavailable
  - Mark more API as unavailable
  - Mark window and presentation API as unavailable
  - More unavailable labels on API
  - Finish moving everything from ViewExtensions.swift into the appropriate file and marking unavailable where possible

## 0.2.26

Released 2023-10-10

  - Fix ambiguous function issue with .tint
  - Mark more API unavailable

## 0.2.25

Released 2023-10-10

  - Begin moving ViewExtensions.swift functions into appropriate places and marking them unavailable for better error messages to user
  - Fix unavailable message in README

## 0.2.24

Released 2023-10-07


## 0.2.23

Released 2023-10-06

  - Export dependencies in build.gradle.kts as api

## 0.2.22

Released 2023-10-05

  - Remove UIKit file warning
  - Mark View.body as @MainActor
  - Update ComposeView content and Compose function to return a value. See comments in ComposeView for explanation
  - More robust system for composing in a certain context (e.g. a List). Protect against negative padding runtime exceptions

## 0.2.21

Released 2023-10-03

  - Use material3 components that more closely align with SwiftUI. Fixes in applying foreground and tint color
  - Progress on applying tint and other styling correctly

## 0.2.20

Released 2023-10-02

  - Rename Types.swift to Stub.swift, as that's all it now contains
  - Fixes. Begin supporting .tint
  - Support ProgressView, .progressViewStyle, .hidden

## 0.2.19

Released 2023-10-01

  - Remove VStack adaptive spacing until I can debug it
  - Make nested containers with expanding content layout as in SwiftUI

## 0.2.18

Released 2023-09-29


## 0.2.17

Released 2023-09-28

  - Update macOS star icon test to account for render change in Sonoma

## 0.2.16

Released 2023-09-28

  - Update SF Symbol to Android icon mappings
  - Update SF Symbol to Android icon mappings
  - Update README.md
  - Add to README
  - More README work. Escape '/' in navigation route values

## 0.2.15

Released 2023-09-28

  - Update SF Symbol to Android icon mappings
  - More README content
  - README work. Alphabetize systemImage name mappings and remove duplicates
  - README enhancements and minor comment updates

## 0.2.14

Released 2023-09-27

  - Adjust Android fonts up by 1 since they appear to render smaller

## 0.2.13

Released 2023-09-27

  - Add tests comparing logical SwiftUI and Android text styles

## 0.2.12

Released 2023-09-27

  - Adjust semantic font sizes to more closely match reference platform
  - Fix visible nav top bar layout changes when viewing a navstack for the first time
  - Use initial AppStorage value only when the store does not contain the key

## 0.2.11

Released 2023-09-27

  - Update README
  - Tweaks and work on README
  - Remove unneeded code
  - Remove workarounds for previous transpiler problems

## 0.2.10

Released 2023-09-26

  - Monitor property changes in AppStorage
  - Implement AppStorage; change default nav stack and tab animations to match iOS (none and slide)
  - More TabView support work
  - Work on TabView support
  - Update README

## 0.2.9

Released 2023-09-25

  - Update README.md
  - Navigation fixes
  - Replace .navigationDestination restrictions with Preferences

## 0.2.8

Released 2023-09-24


## 0.2.7

Released 2023-09-24

  - Dependency bump
  - Fix Text constructors. Support .task modifier
  - Put preferences system in place. Implement navigation bar and .navigationTitle
  - Snapshot work on navigation and preferences
  - Use less extensions. Their symbols are less efficient to process

## 0.2.6

Released 2023-09-20

  - Fix layout tests
  - Use a single ComposeModifierView for all modifiers Add ability to peek at unmodified inner view. Support SwiftUI-like variable default spacing in VStack
  - Snapshot progress on adaptive spacing in VStack

## 0.2.5

Released 2023-09-18

  - Break out image pixmap testing
  - Fix pixmap tests for iOS
  - Fix pixmap tests for iOS
  - Add vertical row inset
  - Fix pixmap tests for iOS

## 0.2.4

Released 2023-09-18

  - Add rough pixmap tests for system symbol names
  - Use normal imports instead of SKIP INSERT: import Fix a Sendable warning Mark unsupported Image constructors as unavailable

## 0.2.3

Released 2023-09-17

  - Add more symbol name to Android icon mappings
  - Fix check for macOS
  - Disable pixmap tests for macOS due to shadow differences
  - Update image pixmap tests
  - Disable icon tests on macOS/iOS due to rendering differences
  - Pare out clear pixels for icon pixmap tests
  - Disable anti-alias for symbol image tests

## 0.2.2

Released 2023-09-16


## 0.2.1

Released 2023-09-16


## 0.2.0

Released 2023-09-13

  - Add iOS available checks

## 0.1.22

Released 2023-09-13

  - Set min iOS version to 16

## 0.1.21

Released 2023-09-11

  - Move SymbolVariants and SymbolRenderingMode into Symbol.swift
  - Add Android check for skipping opacity test on emulator

## 0.1.20

Released 2023-09-11

  - Check for canImport(Symbols) before using Symbols

## 0.1.19

Released 2023-09-11

  - Trim out unnecessary Robolectric annotations

## 0.1.18

Released 2023-09-09

  - Add androidTestImplementation for in-device testing

## 0.1.17

Released 2023-09-08


## 0.1.16

Released 2023-09-08


## 0.1.15

Released 2023-09-08

  - Add Image stubs; removed redundant comments for Biew.body
  - Refactor snapshot tests into individual cases

## 0.1.14

Released 2023-09-07

  - Move CoreGraphics to SkipLib
  - Add improved fillWidth() and fillHeight() modifiers for internal use
  - SwiftUI-like button styling
  - Adapt Button for use in List items
  - List styling
  - Snapshot consolidating SKIP INSERT import blocks
  - Snapshot stop fully qualifying all Kotlin types

## 0.1.13

Released 2023-09-06


## 0.1.12

Released 2023-09-06


## 0.1.11

Released 2023-09-06


## 0.1.10

Released 2023-09-05


## 0.1.9

Released 2023-09-05


## 0.1.8

Released 2023-09-05


## 0.1.7

Released 2023-09-05

  - TextField support
  - Toggle and .labelsHidden() support
  - Work on Toggle
  - Navigation state fixes. Alias StateObject to State
  - Add check for canImport(Observation) for macOS 13 CI

## 0.1.6

Released 2023-09-03


## 0.1.5

Released 2023-09-03

  - Fixes for deep navigation

## 0.1.4

Released 2023-09-03


## 0.1.3

Released 2023-09-03


## 0.1.2

Released 2023-09-03

  - Minor fixes
  - Get rid of warnings when using Binding directly

## 0.1.1

Released 2023-09-02

  - Add stub implementation to remove warnings around Never
  - Reduce warnings

## 0.1.0

Released 2023-09-02


## 0.0.15

Released 2023-09-01

  - Allow more types to be passed to as navigation targets. Type fixes for Lists
  - Wire navigation to begin supporting passing value objects to destination views
  - Redo some of the view handling. Navigation
  - Snapshot navigation work
  - Snapshot navigation work
  - Snapshot navigation work

## 0.0.14

Released 2023-08-31


## 0.0.13

Released 2023-08-31

  - Add LocalizedStringResource stub initializer
  - Add HStack alignment test
  - Improve compact behavior for snapshot testing
  - Update snapshot tests
  - Add custom font and anti-aliasing test
  - Fix stack layout test on Android; add rotation and font render tests
  - Fix stack layout test on Android

## 0.0.12

Released 2023-08-30

  - Add GraphicsMode.Mode.NATIVE to Robolectric tests for rendering corectness
  - Fixes and tests
  - Environment work and tests
  - Update platform colors and snapshot tests
  - Refactor and improve SnapshotTests
  - Refactor and improve SnapshotTests
  - Add color pixmap tests
  - Add color pixmap tests
  - More work on Environment. Replace previous Style
  - More progress on Environment
  - Snapshot progress on implementing an Environment property
  - Refine and comment Environment implementation
  - Begin to implement Environment
  - Add pixmap rendering tests

## 0.0.11

Released 2023-08-25

  - Implement border. Tweaks.
  - Move CoreGraphics imports to needed files (because I was trying to debug something involving typealiases). Implement padding modifier
  - Figure out how to pass scope-dependent modifiers down
  - Renaming
  - Allow parent views to influence rendering of child views

## 0.0.10

Released 2023-08-24

  - Basic List support
  - ScrollView support and some fixes
  - Support HStack, VStack, ZStack default alignments
  - Integrate Font
  - Integrate accessibilityIdentifier and accessibilityLabel
  - Integrate frame, opacity, etc
  - Integrate Color

## 0.0.9

Released 2023-08-22

  - Update README and bump version
  - Integrate Text
  - Integrate Slider

## 0.0.8

Released 2023-08-22

  - More integration of old SkipUI code with stubs

## 0.0.7

Released 2023-08-21

  - Temporarily comment out breaking code until I find solutions
  - Integrate State
  - Integrate Binding
  - Add TODOs to files that need processing
  - Remove PlatformView
  - Begin integrating old SkipUI types into SwiftUI stubs
  - Update dependencies

## 0.0.6

Released 2023-08-21

  - Visibility updates

## 0.0.5

Released 2023-08-20


## 0.0.4

Released 2023-08-20


## 0.0.3

Released 2023-08-20


## 0.0.2

Released 2023-08-20


