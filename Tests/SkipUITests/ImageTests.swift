// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SwiftUI
import XCTest
import OSLog
import Foundation
#if SKIP
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Icon
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.ColorFilter
#endif

final class ImageTests: XCSnapshotTestCase {

    func img(systemName: String) throws -> some View {
        Image(systemName: systemName)
            .background(Color.black)
            .foregroundStyle(Color.white)
            .frame(width: 16.0, height: 16.0)
    }

    // This renders different in macOS 15 and macOS 14
    func XXXtestSystemImageStar() throws {
        let macOSStar: String
        if #available(macOS 14, *) {
            macOSStar = """
            . . . . . . . . . . . . . . . .
            . . . . . . .     . . . . . . .
            . . . . . . .       . . . . . .
            . . . . . .         . . . . . .
            . . . . . .         . . . . . .
            .
            .
            .                             .
            . .                         . .
            . . . .                 . . . .
            . . . .                 . . . .
            . . . .                   . . .
            . . .                     . . .
            . . .         . .         . . .
            . . .       . . . . .     . . .
            . . . . . . . . . . . . . . . .
            """
        } else {
            macOSStar = """
            . . . . . . . . . . . . . . . .
            . . . . . . . . . . . . . . . .
            . . . . . . . .   . . . . . . .
            . . . . . . .     . . . . . . .
            . . . . . . .     . . . . . . .
            . . . . . . .     . . . . . . .
            . .     . .         . .     . .
            . .                         . .
            . . . .                   . . .
            . . . . .             . . . . .
            . . . . .             . . . . .
            . . . . .             . . . . .
            . . . .       . .       . . . .
            . . . .     . . . . .   . . . .
            . . . . . . . . . . . . . . . .
            . . . . . . . . . . . . . . . .
            """
        }
        XCTAssertEqual(try pixmap(brightness: 0.9, content: img(systemName: "star.fill")), plaf("""
        . . . . . . .       . . . . . .
        . . . . . .         . . . . . .
        . . . . . .           . . . . .
        . . . . . .           . . . . .
        . . . . .             . . . . .



        .
        . .                         . .
        . . .                     . . .
        . . .                       . .
        . . .                       . .
        . .                         . .
        . .           . .             .
        . .         . . . .           .
        """, macos: macOSStar, android: """
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . .     . . . . . . .
        . . . . . . .     . . . . . . .
        . . . . . . .     . . . . . . .
        . .                         . .
        . . .                     . . .
        . . . .                 . . . .
        . . . . .             . . . . .
        . . . . .             . . . . .
        . . . . .             . . . . .
        . . . .     . . . .     . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        """, robolectric: """
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . .     . . . . . . .
        . . . . . . .     . . . . . . .
        . .                         . .
        . . .                     . . .
        . . . . .             . . . . .
        . . . . .             . . . . .
        . . . . .             . . . . .
        . . . . .     . .     . . . . .
        . . . . .   . . . .   . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        """))
    }

    // Not yet working, probably because Coil's SubcomposeAsyncImage does not have the image loaded by the time the view is rendered
    func XXXtestCustomSystemSymbol() throws {
        // the dumbbell.fill.svg symbol template is included in Tests/Resources/Assets.xcassets
        let imageName = "dumbbell.fill"

        // when running in Skip, Image(systemName:) only loads from the Main bundle, which isn't the case for the test case bundle; so we need to load the image from the local bundle
        let sysImg = isJava ? Image(imageName, bundle: .module).resizable() : Image(systemName: imageName)

        let systemImage = sysImg
            .aspectRatio(contentMode: .fit)
            .background(Color.black)
            .foregroundStyle(Color.white)
            .frame(width: 16.0, height: 16.0)

        XCTAssertEqual(try pixmap(content: systemImage), """


        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . .     . . . . . .       . .
                  . . . . . .
                  . . . . . .
                  .         .
                  .         .
                  . .       .
                  . . . . . .
        . . .     . . . . . .       . .
        . . .     . . . . . .     . . .
        . . . . . . . . . . . . . . . .


        """)
    }

    // Symbol templates with Baseline/Capline guides keep their designed size relative to the font, like on Darwin,
    // instead of stretching the ink to the font size.
    func testSymbolTemplateSizedByCapHeight() throws {
        #if !SKIP
        throw XCTSkip("Symbol templates are only parsed on Android")
        #else
        let svg = """
        <svg xmlns="http://www.w3.org/2000/svg"><g id="Guides">
        <line id="Baseline-S" x1="263" x2="3036" y1="696" y2="696"/><line id="Capline-S" x1="263" x2="3036" y1="625.541" y2="625.541"/>
        <line id="Baseline-M" x1="263" x2="3036" y1="1126" y2="1126"/><line id="Capline-M" x1="263" x2="3036" y1="1055.54" y2="1055.54"/>
        </g></svg>
        """
        let document = javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(java.io.ByteArrayInputStream(svg.toByteArray()))
        let capHeights = symbolCapHeights(document)
        XCTAssertEqual(Double(capHeights["S"] ?? Float(0.0)), 70.459, accuracy: 0.01)
        XCTAssertEqual(Double(capHeights["M"] ?? Float(0.0)), 70.46, accuracy: 0.01)
        XCTAssertNil(capHeights["L"])

        // xmark at the medium scale has 77.4 units of ink in a 100-unit em, so it renders at 0.774 em as on Darwin
        let medium = symbolViewport(width: Float(77.43), height: Float(77.42), capHeight: capHeights["M"], scale: "M")
        XCTAssertEqual(Double(Float(77.43) / medium.span * medium.sizeRatio), 0.774, accuracy: 0.002)
        // a small variant is shown at the medium scale, 1.276 times larger
        let small = symbolViewport(width: Float(50.0), height: Float(50.0), capHeight: capHeights["S"], scale: "S")
        XCTAssertEqual(Double(Float(50.0) / small.span * small.sizeRatio), 0.638, accuracy: 0.002)
        // ink wider than an em widens the viewport and the rendered size instead of being clipped
        let wide = symbolViewport(width: Float(124.0), height: Float(114.0), capHeight: capHeights["M"], scale: "M")
        XCTAssertEqual(Double(wide.span), 124.0, accuracy: 0.01)
        XCTAssertEqual(Double(wide.sizeRatio), 1.24, accuracy: 0.002)
        // without guides the ink fills the font size, as before
        let unguided = symbolViewport(width: Float(124.0), height: Float(62.0), capHeight: nil, scale: "S")
        XCTAssertEqual(Double(unguided.span), 124.0, accuracy: 0.01)
        XCTAssertEqual(Double(unguided.sizeRatio), 1.0, accuracy: 0.0001)
        #endif
    }

    func testRenderPNGImageData() throws {
        func save(_ base64EncodedImage: String) throws -> URL {
            let uri = URL(fileURLWithPath: NSTemporaryDirectory() + "/testRenderImageData-\(UUID().uuidString).png")
            try Data(base64Encoded: base64EncodedImage)?.write(to: uri)
            return uri
        }

        #if canImport(AppKit)
        func image(_ base64EncodedImage: String) throws -> Image {
            let uri = try save(base64EncodedImage)
            defer { try? FileManager.default.removeItem(at: uri) }
            #if canImport(UIKit)
            typealias Img = UIImage
            #else
            typealias Img = NSImage
            #endif

            guard let img = Img(contentsOf: uri) else {
                throw CocoaError(.fileReadCorruptFile)
            }
            return Image(nsImage: img)
        }

        // a 5x5 red "dot" from https://en.wikipedia.org/wiki/Data_URI_scheme
        XCTAssertEqual(try render(view: image("iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==")).pixmap,
        plaf("""
        FFFFFF FF0000 FF0000 FF0000 FFFFFF
        FF0000 FF0000 FF0000 FF0000 FF0000
        FF0000 FF0000 FF0000 FF0000 FF0000
        FF0000 FF0000 FF0000 FF0000 FF0000
        FFFFFF FF0000 FF0000 FF0000 FFFFFF
        """))
        #endif
    }


    func testRenderVectorDrawableResource() {
        #if SKIP
        throw XCTSkip("Resources in res/ are no longer copied to the project, so SkipUITests/Skip/res/values/strings.xml and SkipUITests/Skip/res/drawable/battery_charging.xml are no longer being found")
        let ctx = ProcessInfo.processInfo.androidContext
        let resources = ctx.getResources()
        let pkg = ctx.getPackageName()
        let stringID = resources.getIdentifier("hello_message", "string", pkg)
        XCTAssertNotEqual(0, stringID, "bad resources ID for hello_message")
        let value = resources.getText(stringID)
        XCTAssertEqual("Hello, World", value, "unexpected resources value")

        let drawableID = resources.getIdentifier("battery_charging", "drawable", pkg)
        XCTAssertNotEqual(0, drawableID, "bad resources ID for battery_charging")

        XCTAssertEqual(try pixmap(content: ZStack {
            ComposeView { context in
                let tintColor = EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0, animationContext: context) ?? Color.primary.colorImpl()
                let imageVector = ImageVector.vectorResource(id: drawableID)
                let painter = rememberVectorPainter(imageVector)
                //Icon(imageVector: imageVector, contentDescription: "demo icon", modifier: Modifier.fillSize(expandContainer: false))
                androidx.compose.foundation.Image(painter: painter, contentDescription: "demo icon", modifier: Modifier.fillSize(), contentScale: ContentScale.Fit, colorFilter: ColorFilter.tint(tintColor))
            }
            .background(Color.black)
            .foregroundStyle(Color.white)
            .frame(width: 16.0, height: 16.0)
        }), """
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . . . . . . . . . . . . .
        . . . . .       . . . . . . . .
        . . . .       .       . . . . .
        . . . .     . .       . . . . .
        . . . .     . . .     . . . . .
        . . . .     . .     . . . . . .
        . . .       .       . . . . . .
        . . .               . . . . . .
        . . .               . . . . . .
        . . . . .         . . . . . . .
        . . . . . . . . . . . . . . . .
        """)

        #endif
    }

}
