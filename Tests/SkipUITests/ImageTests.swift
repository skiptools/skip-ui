// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class ImageTests: XCSnapshotTestCase {

    func img(systemName: String) throws -> some View {
        Image(systemName: systemName)
            .background(Color.black)
            .foregroundStyle(Color.white)
            .frame(width: 16.0, height: 16.0)
    }

    func testSystemImageStar() throws {
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
