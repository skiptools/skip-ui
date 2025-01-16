// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import Foundation

/// A simple local cache that returns the cached value if it exists, or else instantiates it using the block and stores the result.
func rememberCachedAsset<T: Hashable, U>(_ cache: [T: U], _ key: T, block: (T) -> U) -> U {
    synchronized(cache) {
        if let value = cache[key] { return value }
        let value = block(key)
        cache[key] = value
        return value
    }
}

/// Find all the `.xcassets` resource for the given bundle.
func assetContentsURLs(name: String, bundle: Bundle) -> [URL] {
    let resourceNames = bundle.resourcesIndex
    var resourceURLs: [URL] = []
    for resourceName in resourceNames {
        let components = resourceName.split(separator: "/").map({ String($0) })
        // return every *.xcassets/NAME/Contents.json
        if components.first?.hasSuffix(".xcassets") == true
            && components.dropFirst().first == name
            && components.last == "Contents.json",
           let contentsURL = bundle.url(forResource: resourceName, withExtension: nil) {
            resourceURLs.append(contentsURL)
        }
    }
    return resourceURLs
}

/// A cache key for remembering the `Content.json` URL location in the bundled assets for the given
/// name, bundle, and `ColorScheme` combination.
struct AssetKey: Hashable {
    let name: String
    let bundle: Bundle?
    let colorScheme: ColorScheme?

    init(name: String, bundle: Bundle? = nil, colorScheme: ColorScheme? = nil) {
        self.name = name
        self.bundle = bundle
        self.colorScheme = colorScheme
    }
}

/// Protocol used to sort candidate assets.
protocol AssetSortable {
    var idiom: String? { get }
    var appearances: [AssetAppearance]? { get }
}

extension Array {
    /// Sort assets by relevance for the given color scheme - the most relevant will be **last**.
    func sortedByAssetFit(colorScheme: ColorScheme) -> Self {
        return sorted {
            let asset0 = $0 as? AssetSortable
            let asset1 = $1 as? AssetSortable

            // We use universal assets for Android
            let isCandidate0 = asset0?.idiom == nil || asset0?.idiom == "universal"
            let isCandidate1 = asset1?.idiom == nil || asset1?.idiom == "universal"
            if isCandidate0 && !isCandidate1 {
                return false
            } else if isCandidate1 && !isCandidate0 {
                return true
            }

            // If one of the assets is explicitly of the target color scheme, use it
            let isColorScheme0 = asset0?.appearances?.contains { $0.isColorScheme(colorScheme) } == true
            let isColorScheme1 = asset1?.appearances?.contains { $0.isColorScheme(colorScheme) } == true
            if isColorScheme0 && !isColorScheme1 {
                return false
            } else if isColorScheme1 && !isColorScheme0 {
                return true
            }

            // If one of the assets is of the wrong color scheme, use the other
            let otherColorScheme: ColorScheme = colorScheme == .light ? .dark : .light
            let isWrongColorScheme0 = asset0?.appearances?.contains { $0.isColorScheme(otherColorScheme) } == true
            let isWrongColorScheme1 = asset1?.appearances?.contains { $0.isColorScheme(otherColorScheme) } == true
            if isWrongColorScheme0 && !isWrongColorScheme1 {
                return true
            } else if isWrongColorScheme1 && !isWrongColorScheme0 {
                return false
            }

            // Equal
            return false
        }
    }
}

/// Appearance as encoded in the asset catalog.
struct AssetAppearance : Decodable {
    let appearance: String? // e.g., "luminosity"
    let value: String? // e.g., "light", "dark"

    func isColorScheme(_ colorScheme: ColorScheme) -> Bool {
        switch colorScheme {
        case .light:
            return appearance == "luminosity" && value == "light"
        case .dark:
            return appearance == "luminosity" && value == "dark"
        default:
            return false
        }
    }
}

/// Additional asset content information as encoded in the asset catalog.
struct AssetContentsInfo : Decodable {
    let author: String? // e.g. "xcode"
    let version: Int? // e.g. 1
}

#endif
