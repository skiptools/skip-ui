// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SwiftUI
import XCTest
import OSLog
import Foundation

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class ImageTests: XCSnapshotTestCase {

    func img(systemName: String) throws -> some View {
        Image(systemName: systemName)
            .background(Color.black)
            .foregroundStyle(Color.white)
            .frame(width: 12.0, height: 12.0)
    }

    func testSystemImageHouse() throws {
        XCTAssertEqual(try pixmap(img(systemName: "house.fill")), plaf("""








                 . . . .
                 . . . .
                 . . . .
                 . . . .
         """, macos: """
         . . . . . . . . . . . .
         . . . . . . . . . . . .
         . . . . . . . . . .   .
         . . . . .     . . .   .
         . . .           . . . .
         . .               . . .
         .                   . .
               . . . . .       .
               . . . . .       .
               . . . . .       .
               . . . . .       .
         .     . . . . .       .
         """, android: """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . .     . . . . .
        . . .             . . .
        . .                 . .
        . . .             . . .
        . . .     . .     . . .
        . . .     . .     . . .
        . . .     . .     . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """))
    }

    func testSystemImageStar() throws {
        XCTAssertEqual(try pixmap(img(systemName: "star.fill")), plaf("""
        . . . .           . . .
        . . . .           . . .
        . . .             . . .





        .                     .
        .
        .

        """, macos: """
        . . . . . . . . . . . .
        . . . . . .   . . . . .
        . . . . .     . . . . .
        . . . . .     . . . . .
        . . . . .       . . . .
        .                     .
        . .                 . .
        . . .             . . .
        . . .             . . .
        . . .             . . .
        . . .     . . .     . .
        . .   . . . . . .   . .
        """, android: """
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . .     . . . . .
        . . . . .     . . . . .
        . . .             . . .
        . . . .         . . . .
        . . . .         . . . .
        . . . .   . .   . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        . . . . . . . . . . . .
        """))
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
        XCTAssertEqual(try render(view: image("iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==")),
        plaf("""
        FFFFFF FF0000 FF0000 FF0000 FFFFFF
        FF0000 FF0000 FF0000 FF0000 FF0000
        FF0000 FF0000 FF0000 FF0000 FF0000
        FF0000 FF0000 FF0000 FF0000 FF0000
        FFFFFF FF0000 FF0000 FF0000 FFFFFF
        """))
        #endif
    }
}
