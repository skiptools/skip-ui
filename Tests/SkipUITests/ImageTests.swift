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

    func testSystemImageStar() throws {
        if isMacOS || isIOS {
            throw XCTSkip("Shadow grayscale is slightly different for different macOS/iOS versions")
        }

        XCTAssertEqual(try render(compact: 2, clear: "FF", antiAlias: false, view: Image(systemName: "star").background(Color.white).frame(width: 20.0, height: 20.0)), plaf("""



                                   DB BE
                                   69 36 FC
                                F5 3C 64 C6
                                B7 72 A9 81
                                72 B4 E9 3E FE
                 67 3A 3B 3D 3F 32 F1    56 3D 3D 3C 3A 47 F1
                 B4 41 B7 F7 F4 F7       FA F2 F7 D5 4F 88 FE
                    DF 52 78 F3             FD 9E 40 C1
                       FA 88 49             7F 61 EC
                          C5 61             97 8F
                          7D AC FB 86 64 EB E2 47
                       FC 3E D8 56 76 9B 40 CA 55 D6
                       C5 3B 41 AF       D2 47 49 8E
                       BA 5C DF             F3 78 89



        """, android: """


                                   9F 9F
                                   3F 40
                                CF 00 00 CF
                                5F 00 00 5F
                             EF 00 00 00 00 EF
           EF A0 80 80 60 40 30 00 00 00 00 30 40 60 80 80 A0 EF
              9F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9F
                 AF 0F 00 00 00 00 00 00 00 00 00 00 0F AF
                    CF 0F 00 00 00 00 00 00 00 00 0F CF
                       DF 1F 00 00 00 00 00 00 1F DF
                          00 00 00 00 00 00 00 00
                       BF 00 00 00 00 00 00 00 00 CF
                       8F 00 00 00 4F 4F 00 00 00 8F
                       4F 00 1F BF       BF 1F 00 4F
                       0F 7F                EF 7F 0F
                       DF                         DF


        """))
    }

    func testSystemImageLock() throws {
        if isMacOS || isIOS {
            throw XCTSkip("Shadow grayscale is slightly different for different macOS/iOS versions")
        }
        XCTAssertEqual(try render(compact: 2, clear: "FF", antiAlias: false, view: Image(systemName: "lock").background(Color.white).frame(width: 20.0, height: 20.0)), plaf("""




                                 F9 B9 A4 D0
                              ED 4A 63 85 46 82
                              82 86       F7 46 CB
                              4B D5          8D 93
                              3F E6          9E 88
                           E4 36 9B AB AB AB 70 6B F8
                           43 76 84 84 84 84 84 56 8C
                           27 F9                B0 70
                           27 F9                B0 6F
                           27 F9                B0 6F
                           27 F9                B0 6F
                           2A F1                A9 73
                           78 2F 2F 2F 2F 2F 2F 34 BA



         """, android: """
                                   EF EF
                             BF 20 00 00 20 BF
                          BF 00 1F 7F 7F 1F 00 BF
                          1F 1F EF       EF 0F 20
                       EF 00 7F             7F 00 EF
                       BF 00 7F             7F 00 BF
                    CF 90 00 60 C0 C0 C0 C0 60 00 90 CF
                 9F 00 00 00 00 00 00 00 00 00 00 00 00 9F
                 3F 00 00 00 00 00 00 00 00 00 00 00 00 4F
                 3F 00 00 00 00 00 00 00 00 00 00 00 00 3F
                 3F 00 00 00 00 00 0F 0F 00 00 00 00 00 3F
                 3F 00 00 00 00 4F       4F 00 00 00 00 3F
                 3F 00 00 00 00 9F       9F 00 00 00 00 3F
                 3F 00 00 00 00 50    EF 40 00 00 00 00 3F
                 3F 00 00 00 00 00 10 10 00 00 00 00 00 3F
                 3F 00 00 00 00 00 00 00 00 00 00 00 00 3F
                 3F 00 00 00 00 00 00 00 00 00 00 00 00 4F
                 9F 00 00 00 00 00 00 00 00 00 00 00 00 AF
                    CF BF BF BF BF BF BF BF BF BF BF CF

        """))
    }

    func testSystemImageInfo() throws {
        if isMacOS || isIOS {
            throw XCTSkip("Shadow grayscale is slightly different for different macOS/iOS versions")
        }
        XCTAssertEqual(try render(compact: 2, clear: "FF", antiAlias: false, view: Image(systemName: "info").background(Color.white).frame(width: 20.0, height: 20.0)), plaf("""





                                D6 58 DB
                                C7 33 CC

                             C0 9E A1 F1
                             A9 81 32 BF
                                   42 BE
                                   42 BE
                                   42 BE
                             FC F8 41 B9 FB
                             45 27 27 27 32 F6





        """, android: """

                                CF C0 C0 CF
                       EF 80 10 00 00 00 00 20 80 EF
                    CF 10 00 00 00 00 00 00 00 00 10 CF
                 CF 00 00 00 00 00 00 00 00 00 00 00 00 CF
              EF 10 00 00 00 00 00 2F 2F 00 00 00 00 00 10 EF
              7F 00 00 00 00 00 00 BF BF 00 00 00 00 00 00 7F
              0F 00 00 00 00 00 00 60 60 00 00 00 00 00 00 20
           CF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CF
           BF 00 00 00 00 00 00 00 8F 8F 00 00 00 00 00 00 00 BF
           BF 00 00 00 00 00 00 00 BF BF 00 00 00 00 00 00 00 BF
           CF 00 00 00 00 00 00 00 BF BF 00 00 00 00 00 00 00 CF
              0F 00 00 00 00 00 00 BF BF 00 00 00 00 00 00 1F
              7F 00 00 00 00 00 00 BF BF 00 00 00 00 00 00 7F
              EF 0F 00 00 00 00 00 30 30 00 00 00 00 00 0F EF
                 CF 00 00 00 00 00 00 00 00 00 00 00 00 CF
                    CF 0F 00 00 00 00 00 00 00 00 0F CF
                       EF 7F 1F 00 00 00 00 1F 7F EF
                                CF BF BF CF

        """))
    }

    func testSystemImagePhone() throws {
        if isMacOS || isIOS {
            throw XCTSkip("Shadow grayscale is slightly different for different macOS/iOS versions")
        }
        XCTAssertEqual(try render(compact: 2, clear: "FF", antiAlias: false, view: Image(systemName: "phone").background(Color.white).frame(width: 20.0, height: 20.0)), plaf("""




                       E6 B1 F6
                    D1 37 59 5F FD
                    55 AA    62 9D
                    2D F7    E6 37 E7
                    37 F2    E1 36 DA
                    6B B2    61 92
                    C4 4B FB A2 5C FA
                       6C 93    80 6B FA    DA E7
                       EA 41 BB FD 7F 5B 91 36 38 9D FD
                          D9 3B BC    A1 61 E1 E7 64 5F F5
                             D8 41 95 FC             59 B1
                                EA 6C 4B AF F2 F7 A9 37 E6
                                      C4 6B 37 2D 56 D1



        """, android: """


              EF 80 80 80 A0
              7F 00 00 00 00
              9F 00 00 00 00 BF
              BF 00 00 00 00 9F
              DF 00 00 00 00 7F
                 2F 00 00 0F DF
                 8F 00 0F CF
                 EF 0F 30
                    7F 00 8F
                    EF 2F 00 BF
                       DF 0F 10 BF          CF 80 A0 C0
                          CF 0F 00 90    CF 10 00 00 00 00 9F
                             DF 2F 00 30 10 00 00 00 00 00 7F
                                EF 7F 0F 00 00 00 00 00 00 7F
                                      EF 8F 2F 00 00 00 00 7F
                                               DF BF 9F 7F EF


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
