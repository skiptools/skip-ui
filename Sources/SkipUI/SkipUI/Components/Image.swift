// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material.icons.__
import androidx.compose.material.icons.filled.__
import androidx.compose.material.icons.outlined.__
import androidx.compose.material.icons.rounded.__
import androidx.compose.material.icons.sharp.__
import androidx.compose.material.icons.twotone.__
import androidx.compose.material3.Icon
import androidx.compose.material3.LocalTextStyle
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.graphics.vector.rememberVectorPainter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.ScaleFactor
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
#else
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
#endif

public struct Image : View, Equatable, Sendable {
    let image: ImageType
    var capInsets = EdgeInsets()
    var resizingMode: ResizingMode?

    enum ImageType : Equatable, Sendable {
        case named(name: String, bundle: Bundle?, label: Text?)
        case decorative(name: String, bundle: Bundle?)
        case system(systemName: String)
        #if SKIP
        case painter(painter: Painter, scale: CGFloat)
        #endif
    }

    @available(*, unavailable)
    public init(_ name: String, bundle: Bundle? = nil) {
        self.image = .named(name: name, bundle: bundle, label: nil)
    }

    @available(*, unavailable)
    public init(_ name: String, bundle: Bundle? = nil, label: Text) {
        self.image = .named(name: name, bundle: bundle, label: label)
    }

    @available(*, unavailable)
    public init(decorative name: String, bundle: Bundle? = nil) {
        self.image = .decorative(name: name, bundle: bundle)
    }

    public init(systemName: String) {
        self.image = .system(systemName: systemName)
    }

    #if SKIP
    public init(painter: Painter, scale: CGFloat) {
        self.image = .painter(painter: painter, scale: scale)
    }

    @Composable public override func ComposeContent(context: ComposeContext) {
        let aspect = EnvironmentValues.shared._aspectRatio

        // Put given modifiers on the containing Box so that the image can scale itself without affecting them
        Box(modifier: context.modifier, contentAlignment: androidx.compose.ui.Alignment.Center) {
            switch image {
            case .painter(let painter, let scale):
                ComposePainter(painter: painter, scale: scale, aspectRatio: aspect?.0, contentMode: aspect?.1)
            case .system(let systemName):
                ComposeSystem(systemName: systemName, aspectRatio: aspect?.0, contentMode: aspect?.1)
            default:
                Icon(imageVector: Icons.Default.Warning, contentDescription: "unsupported image type")
            }
        }
    }

    @Composable private func ComposePainter(painter: Painter, scale: CGFloat = 1.0, colorFilter: ColorFilter? = nil, aspectRatio: Double?, contentMode: ContentMode?) {
        switch resizingMode {
        case .stretch:
            let scale = contentScale(aspectRatio: aspectRatio, contentMode: contentMode)
            let modifier = Modifier.fillSize(expandContainer: false)
            androidx.compose.foundation.Image(painter: painter, contentDescription: nil, modifier: modifier, contentScale: scale, colorFilter: colorFilter)
        default: // TODO: .tile
            let modifier = Modifier.wrapContentSize(unbounded: true).size((painter.intrinsicSize.width / scale).dp, (painter.intrinsicSize.height / scale).dp)
            androidx.compose.foundation.Image(painter: painter, contentDescription: nil, modifier: modifier, colorFilter: colorFilter)
        }
    }

    @Composable private func ComposeSystem(systemName: String, aspectRatio: Double?, contentMode: ContentMode?) {
        guard let image = Self.composeImageVector(named: systemName) else {
            print("Unable to find system image named: \(systemName)")
            Icon(imageVector: Icons.Default.Warning, contentDescription: "missing icon")
            return
        }

        let tintColor = EnvironmentValues.shared._foregroundStyle?.asColor(opacity: 1.0) ?? Color.primary.colorImpl()
        switch resizingMode {
        case .stretch:
            let painter = rememberVectorPainter(image)
            let colorFilter: ColorFilter?
            if let tintColor {
                colorFilter = ColorFilter.tint(tintColor)
            } else {
                colorFilter = nil
            }
            ComposePainter(painter: painter, colorFilter: colorFilter, aspectRatio: aspectRatio, contentMode: contentMode)
        default: // TODO: .tile
            let textStyle = EnvironmentValues.shared.font?.fontImpl() ?? LocalTextStyle.current
            let modifier: Modifier
            if textStyle.fontSize.isSp {
                let textSizeDp = with(LocalDensity.current) {
                    textStyle.fontSize.toDp()
                }
                // Apply a multiplier to more closely match SwiftUI's relative text and system image sizes
                modifier = Modifier.size(textSizeDp * Float(1.5))
            } else {
                modifier = Modifier
            }
            Icon(imageVector: image, contentDescription: systemName, modifier: modifier, tint: tintColor ?? androidx.compose.ui.graphics.Color.Unspecified)
        }
    }

    private func contentScale(aspectRatio: Double?, contentMode: ContentMode?) -> ContentScale {
        guard let contentMode else {
            return ContentScale.FillBounds
        }
        guard let aspectRatio else {
            switch contentMode {
            case .fit:
                return ContentScale.Fit
            case .fill:
                return ContentScale.Crop
            }
        }
        return AspectRatioContentScale(aspectRatio: aspectRatio, contentMode: contentMode)
    }

    /// Custom scale to handle fitting or filling a user-specified aspect ratio.
    private struct AspectRatioContentScale: ContentScale {
        let aspectRatio: Double
        let contentMode: ContentMode

        override func computeScaleFactor(srcSize: Size, dstSize: Size) -> ScaleFactor {
            let dstAspectRatio = dstSize.width / dstSize.height
            switch contentMode {
            case .fit:
                return aspectRatio > dstAspectRatio ? fitToWidth(srcSize, dstSize) : fitToHeight(srcSize, dstSize)
            case .fill:
                return aspectRatio < dstAspectRatio ? fitToWidth(srcSize, dstSize) : fitToHeight(srcSize, dstSize)
            }
        }

        private func fitToWidth(srcSize: Size, dstSize: Size) -> ScaleFactor {
            return ScaleFactor(scaleX: dstSize.width / srcSize.width, scaleY: dstSize.width / Float(aspectRatio) / srcSize.height)
        }

        private func fitToHeight(srcSize: Size, dstSize: Size) -> ScaleFactor {
            return ScaleFactor(scaleX: dstSize.height * Float(aspectRatio) / srcSize.width, scaleY: dstSize.height / srcSize.height)
        }
    }

    private static func composeSymbolName(for symbolName: String) -> String? {
        switch symbolName {
        case "person.crop.square": return "Icons.Outlined.AccountBox" //􀉹
        case "person.crop.circle": return "Icons.Outlined.AccountCircle" //􀉭
        case "plus.circle.fill": return "Icons.Outlined.AddCircle" //􀁍
        case "plus": return "Icons.Outlined.Add" //􀅼
        case "arrow.left": return "Icons.Outlined.ArrowBack" //􀄪
        case "arrowtriangle.down.fill": return "Icons.Outlined.ArrowDropDown" //􀄥
        case "arrow.forward": return "Icons.Outlined.ArrowForward" //􀰑
        case "wrench": return "Icons.Outlined.Build" //􀎕
        case "phone": return "Icons.Outlined.Call" //􀌾
        case "checkmark.circle": return "Icons.Outlined.CheckCircle" //􀁢
        case "checkmark": return "Icons.Outlined.Check" //􀆅
        case "xmark": return "Icons.Outlined.Clear" //􀆄
        //case "xmark": return "Icons.Outlined.Close" //􀆄
        case "pencil": return "Icons.Outlined.Create" //􀈊
        case "calendar": return "Icons.Outlined.DateRange" //􀉉
        case "trash": return "Icons.Outlined.Delete" //􀈑
        //case "checkmark": return "Icons.Outlined.Done" //􀆅
        //case "pencil": return "Icons.Outlined.Edit" //􀈊
        case "envelope": return "Icons.Outlined.Email" //􀍕
        case "arrow.forward.square": return "Icons.Outlined.ExitToApp" //􀰔
        case "face.smiling": return "Icons.Outlined.Face" //􀎸
        case "heart": return "Icons.Outlined.FavoriteBorder" //􀊴
        case "heart.fill": return "Icons.Outlined.Favorite" //􀊵
        case "house": return "Icons.Outlined.Home" //􀎞
        case "info.circle": return "Icons.Outlined.Info" //􀅴
        case "chevron.down": return "Icons.Outlined.KeyboardArrowDown" //􀆈
        case "chevron.left": return "Icons.Outlined.KeyboardArrowLeft" //􀆉
        case "chevron.right": return "Icons.Outlined.KeyboardArrowRight" //􀆊
        case "chevron.up": return "Icons.Outlined.KeyboardArrowUp" //􀆇
        case "list.bullet": return "Icons.Outlined.List" //􀋲
        case "location": return "Icons.Outlined.LocationOn" //􀋑
        case "lock": return "Icons.Outlined.Lock" //􀎠
        //case "envelope": return "Icons.Outlined.MailOutline" //􀍕
        case "line.3.horizontal": return "Icons.Outlined.Menu" //􀌇
        case "ellipsis": return "Icons.Outlined.MoreVert" //􀍠
        case "bell": return "Icons.Outlined.Notifications" //􀋙
        case "person": return "Icons.Outlined.Person" //􀉩
        //case "phone": return "Icons.Outlined.Phone" //􀌾
        case "mappin.circle": return "Icons.Outlined.Place" //􀎪
        case "play": return "Icons.Outlined.PlayArrow" //􀊃
        case "arrow.clockwise.circle": return "Icons.Outlined.Refresh" //􀚁
        case "magnifyingglass": return "Icons.Outlined.Search" //􀊫
        case "paperplane": return "Icons.Outlined.Send" //􀈟
        case "gearshape": return "Icons.Outlined.Settings" //􀣋
        case "square.and.arrow.up": return "Icons.Outlined.Share" //􀈂
        case "cart": return "Icons.Outlined.ShoppingCart" //􀍩
        case "star": return "Icons.Outlined.Star" //􀋃
        case "hand.thumbsup": return "Icons.Outlined.ThumbUp" //􀉿
        case "exclamationmark.triangle": return "Icons.Outlined.Warning" //􀇿

        case "person.crop.square.fill": return "Icons.Filled.AccountBox" //􀉺
        case "person.crop.circle.fill": return "Icons.Filled.AccountCircle" //􀉮
        //case "plus.circle.fill": return "Icons.Filled.AddCircle" //􀁍
        //case "plus": return "Icons.Filled.Add" //􀅼
        //case "arrow.left": return "Icons.Filled.ArrowBack" //
        //case "arrowtriangle.down.fill": return "Icons.Filled.ArrowDropDown" //
        //case "arrow.forward": return "Icons.Filled.ArrowForward" //
        case "wrench.fill": return "Icons.Filled.Build" //􀎖
        case "phone.fill": return "Icons.Filled.Call" //􀌿
        case "checkmark.circle.fill": return "Icons.Filled.CheckCircle" //􀁣
        //case "XXX": return "Icons.Filled.Check" //
        //case "XXX": return "Icons.Filled.Clear" //
        //case "XXX": return "Icons.Filled.Close" //
        //case "XXX": return "Icons.Filled.Create" //
        //case "XXX": return "Icons.Filled.DateRange" //
        case "trash.fill": return "Icons.Filled.Delete" //􀈒
        //case "XXX": return "Icons.Filled.Done" //
        //case "XXX": return "Icons.Filled.Edit" //
        case "envelope.fill": return "Icons.Filled.Email" //􀍖
        //case "XXX": return "Icons.Filled.ExitToApp" //
        //case "XXX": return "Icons.Filled.Face" //
        //case "XXX": return "Icons.Filled.FavoriteBorder" //
        //case "XXX": return "Icons.Filled.Favorite" //
        case "house.fill": return "Icons.Filled.Home" //􀎟
        case "info.circle.fill": return "Icons.Filled.Info" //􀅵
        //case "XXX": return "Icons.Filled.KeyboardArrowDown" //
        //case "XXX": return "Icons.Filled.KeyboardArrowLeft" //
        //case "XXX": return "Icons.Filled.KeyboardArrowRight" //
        //case "XXX": return "Icons.Filled.KeyboardArrowUp" //
        //case "XXX": return "Icons.Filled.List" //
        case "location.fill": return "Icons.Filled.LocationOn" //􀋒
        case "lock.fill": return "Icons.Filled.Lock" //􀎡
        //case "XXX": return "Icons.Filled.MailOutline" //
        //case "XXX": return "Icons.Filled.Menu" //
        //case "XXX": return "Icons.Filled.MoreVert" //
        case "bell.fill": return "Icons.Filled.Notifications" //􀋚
        case "person.fill": return "Icons.Filled.Person" //􀉪
        //case "phone.fill": return "Icons.Filled.Phone" //􀌿
        case "mappin.circle.fill": return "Icons.Filled.Place" //􀜈
        case "play.fill": return "Icons.Filled.PlayArrow" //􀊄
        //case "XXX": return "Icons.Filled.Refresh" //
        //case "XXX": return "Icons.Filled.Search" //
        case "paperplane.fill": return "Icons.Filled.Send" //􀈠
        case "gearshape.fill": return "Icons.Filled.Settings" //􀣌
        case "square.and.arrow.up.fill": return "Icons.Filled.Share" //􀈃
        case "cart.fill": return "Icons.Filled.ShoppingCart" //􀍪
        case "star.fill": return "Icons.Filled.Star" //􀋃
        case "hand.thumbsup.fill": return "Icons.Filled.ThumbUp" //􀊀
        case "exclamationmark.triangle.fill": return "Icons.Filled.Warning" //􀇿

        default: return nil
        }
    }

    /// Returns the `androidx.compose.ui.graphics.vector.ImageVector` for the given constant name.
    ///
    /// See: https://developer.android.com/reference/kotlin/androidx/compose/material/icons/Icons.Outlined
    static func composeImageVector(named name: String) -> ImageVector? {
        switch composeSymbolName(for: name) ?? name {
        case "Icons.Outlined.AccountBox": return Icons.Outlined.AccountBox
        case "Icons.Outlined.AccountCircle": return Icons.Outlined.AccountCircle
        case "Icons.Outlined.AddCircle": return Icons.Outlined.AddCircle
        case "Icons.Outlined.Add": return Icons.Outlined.Add
        case "Icons.Outlined.ArrowBack": return Icons.Outlined.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.ArrowBack
        case "Icons.Outlined.ArrowDropDown": return Icons.Outlined.ArrowDropDown
        case "Icons.Outlined.ArrowForward": return Icons.Outlined.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.ArrowForward
        case "Icons.Outlined.Build": return Icons.Outlined.Build
        case "Icons.Outlined.Call": return Icons.Outlined.Call
        case "Icons.Outlined.CheckCircle": return Icons.Outlined.CheckCircle
        case "Icons.Outlined.Check": return Icons.Outlined.Check
        case "Icons.Outlined.Clear": return Icons.Outlined.Clear
        case "Icons.Outlined.Close": return Icons.Outlined.Close
        case "Icons.Outlined.Create": return Icons.Outlined.Create
        case "Icons.Outlined.DateRange": return Icons.Outlined.DateRange
        case "Icons.Outlined.Delete": return Icons.Outlined.Delete
        case "Icons.Outlined.Done": return Icons.Outlined.Done
        case "Icons.Outlined.Edit": return Icons.Outlined.Edit
        case "Icons.Outlined.Email": return Icons.Outlined.Email
        case "Icons.Outlined.ExitToApp": return Icons.Outlined.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.ExitToApp
        case "Icons.Outlined.Face": return Icons.Outlined.Face
        case "Icons.Outlined.FavoriteBorder": return Icons.Outlined.FavoriteBorder
        case "Icons.Outlined.Favorite": return Icons.Outlined.Favorite
        case "Icons.Outlined.Home": return Icons.Outlined.Home
        case "Icons.Outlined.Info": return Icons.Outlined.Info
        case "Icons.Outlined.KeyboardArrowDown": return Icons.Outlined.KeyboardArrowDown
        case "Icons.Outlined.KeyboardArrowLeft": return Icons.Outlined.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.KeyboardArrowLeft
        case "Icons.Outlined.KeyboardArrowRight": return Icons.Outlined.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.KeyboardArrowRight
        case "Icons.Outlined.KeyboardArrowUp": return Icons.Outlined.KeyboardArrowUp
        case "Icons.Outlined.List": return Icons.Outlined.List // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.List
        case "Icons.Outlined.LocationOn": return Icons.Outlined.LocationOn
        case "Icons.Outlined.Lock": return Icons.Outlined.Lock
        case "Icons.Outlined.MailOutline": return Icons.Outlined.MailOutline
        case "Icons.Outlined.Menu": return Icons.Outlined.Menu
        case "Icons.Outlined.MoreVert": return Icons.Outlined.MoreVert
        case "Icons.Outlined.Notifications": return Icons.Outlined.Notifications
        case "Icons.Outlined.Person": return Icons.Outlined.Person
        case "Icons.Outlined.Phone": return Icons.Outlined.Phone
        case "Icons.Outlined.Place": return Icons.Outlined.Place
        case "Icons.Outlined.PlayArrow": return Icons.Outlined.PlayArrow
        case "Icons.Outlined.Refresh": return Icons.Outlined.Refresh
        case "Icons.Outlined.Search": return Icons.Outlined.Search
        case "Icons.Outlined.Send": return Icons.Outlined.Send // Compose 1.6 TODO: Icons.AutoMirrored.Outlined.Send
        case "Icons.Outlined.Settings": return Icons.Outlined.Settings
        case "Icons.Outlined.Share": return Icons.Outlined.Share
        case "Icons.Outlined.ShoppingCart": return Icons.Outlined.ShoppingCart
        case "Icons.Outlined.Star": return Icons.Outlined.Star
        case "Icons.Outlined.ThumbUp": return Icons.Outlined.ThumbUp
        case "Icons.Outlined.Warning": return Icons.Outlined.Warning

        case "Icons.Filled.AccountBox": return Icons.Filled.AccountBox
        case "Icons.Filled.AccountCircle": return Icons.Filled.AccountCircle
        case "Icons.Filled.AddCircle": return Icons.Filled.AddCircle
        case "Icons.Filled.Add": return Icons.Filled.Add
        case "Icons.Filled.ArrowBack": return Icons.Filled.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Filled.ArrowBack
        case "Icons.Filled.ArrowDropDown": return Icons.Filled.ArrowDropDown
        case "Icons.Filled.ArrowForward": return Icons.Filled.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Filled.ArrowForward
        case "Icons.Filled.Build": return Icons.Filled.Build
        case "Icons.Filled.Call": return Icons.Filled.Call
        case "Icons.Filled.CheckCircle": return Icons.Filled.CheckCircle
        case "Icons.Filled.Check": return Icons.Filled.Check
        case "Icons.Filled.Clear": return Icons.Filled.Clear
        case "Icons.Filled.Close": return Icons.Filled.Close
        case "Icons.Filled.Create": return Icons.Filled.Create
        case "Icons.Filled.DateRange": return Icons.Filled.DateRange
        case "Icons.Filled.Delete": return Icons.Filled.Delete
        case "Icons.Filled.Done": return Icons.Filled.Done
        case "Icons.Filled.Edit": return Icons.Filled.Edit
        case "Icons.Filled.Email": return Icons.Filled.Email
        case "Icons.Filled.ExitToApp": return Icons.Filled.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Filled.ExitToApp
        case "Icons.Filled.Face": return Icons.Filled.Face
        case "Icons.Filled.FavoriteBorder": return Icons.Filled.FavoriteBorder
        case "Icons.Filled.Favorite": return Icons.Filled.Favorite
        case "Icons.Filled.Home": return Icons.Filled.Home
        case "Icons.Filled.Info": return Icons.Filled.Info
        case "Icons.Filled.KeyboardArrowDown": return Icons.Filled.KeyboardArrowDown
        case "Icons.Filled.KeyboardArrowLeft": return Icons.Filled.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Filled.KeyboardArrowLeft
        case "Icons.Filled.KeyboardArrowRight": return Icons.Filled.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Filled.KeyboardArrowRight
        case "Icons.Filled.KeyboardArrowUp": return Icons.Filled.KeyboardArrowUp
        case "Icons.Filled.List": return Icons.Filled.List // Compose 1.6 TODO: Icons.AutoMirrored.Filled.List
        case "Icons.Filled.LocationOn": return Icons.Filled.LocationOn
        case "Icons.Filled.Lock": return Icons.Filled.Lock
        case "Icons.Filled.MailOutline": return Icons.Filled.MailOutline
        case "Icons.Filled.Menu": return Icons.Filled.Menu
        case "Icons.Filled.MoreVert": return Icons.Filled.MoreVert
        case "Icons.Filled.Notifications": return Icons.Filled.Notifications
        case "Icons.Filled.Person": return Icons.Filled.Person
        case "Icons.Filled.Phone": return Icons.Filled.Phone
        case "Icons.Filled.Place": return Icons.Filled.Place
        case "Icons.Filled.PlayArrow": return Icons.Filled.PlayArrow
        case "Icons.Filled.Refresh": return Icons.Filled.Refresh
        case "Icons.Filled.Search": return Icons.Filled.Search
        case "Icons.Filled.Send": return Icons.Filled.Send // Compose 1.6 TODO: Icons.AutoMirrored.Filled.Send
        case "Icons.Filled.Settings": return Icons.Filled.Settings
        case "Icons.Filled.Share": return Icons.Filled.Share
        case "Icons.Filled.ShoppingCart": return Icons.Filled.ShoppingCart
        case "Icons.Filled.Star": return Icons.Filled.Star
        case "Icons.Filled.ThumbUp": return Icons.Filled.ThumbUp
        case "Icons.Filled.Warning": return Icons.Filled.Warning

        case "Icons.Rounded.AccountBox": return Icons.Rounded.AccountBox
        case "Icons.Rounded.AccountCircle": return Icons.Rounded.AccountCircle
        case "Icons.Rounded.AddCircle": return Icons.Rounded.AddCircle
        case "Icons.Rounded.Add": return Icons.Rounded.Add
        case "Icons.Rounded.ArrowBack": return Icons.Rounded.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.ArrowBack
        case "Icons.Rounded.ArrowDropDown": return Icons.Rounded.ArrowDropDown
        case "Icons.Rounded.ArrowForward": return Icons.Rounded.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.ArrowForward
        case "Icons.Rounded.Build": return Icons.Rounded.Build
        case "Icons.Rounded.Call": return Icons.Rounded.Call
        case "Icons.Rounded.CheckCircle": return Icons.Rounded.CheckCircle
        case "Icons.Rounded.Check": return Icons.Rounded.Check
        case "Icons.Rounded.Clear": return Icons.Rounded.Clear
        case "Icons.Rounded.Close": return Icons.Rounded.Close
        case "Icons.Rounded.Create": return Icons.Rounded.Create
        case "Icons.Rounded.DateRange": return Icons.Rounded.DateRange
        case "Icons.Rounded.Delete": return Icons.Rounded.Delete
        case "Icons.Rounded.Done": return Icons.Rounded.Done
        case "Icons.Rounded.Edit": return Icons.Rounded.Edit
        case "Icons.Rounded.Email": return Icons.Rounded.Email
        case "Icons.Rounded.ExitToApp": return Icons.Rounded.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.ExitToApp
        case "Icons.Rounded.Face": return Icons.Rounded.Face
        case "Icons.Rounded.FavoriteBorder": return Icons.Rounded.FavoriteBorder
        case "Icons.Rounded.Favorite": return Icons.Rounded.Favorite
        case "Icons.Rounded.Home": return Icons.Rounded.Home
        case "Icons.Rounded.Info": return Icons.Rounded.Info
        case "Icons.Rounded.KeyboardArrowDown": return Icons.Rounded.KeyboardArrowDown
        case "Icons.Rounded.KeyboardArrowLeft": return Icons.Rounded.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.KeyboardArrowLeft
        case "Icons.Rounded.KeyboardArrowRight": return Icons.Rounded.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.KeyboardArrowRight
        case "Icons.Rounded.KeyboardArrowUp": return Icons.Rounded.KeyboardArrowUp
        case "Icons.Rounded.List": return Icons.Rounded.List // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.List
        case "Icons.Rounded.LocationOn": return Icons.Rounded.LocationOn
        case "Icons.Rounded.Lock": return Icons.Rounded.Lock
        case "Icons.Rounded.MailOutline": return Icons.Rounded.MailOutline
        case "Icons.Rounded.Menu": return Icons.Rounded.Menu
        case "Icons.Rounded.MoreVert": return Icons.Rounded.MoreVert
        case "Icons.Rounded.Notifications": return Icons.Rounded.Notifications
        case "Icons.Rounded.Person": return Icons.Rounded.Person
        case "Icons.Rounded.Phone": return Icons.Rounded.Phone
        case "Icons.Rounded.Place": return Icons.Rounded.Place
        case "Icons.Rounded.PlayArrow": return Icons.Rounded.PlayArrow
        case "Icons.Rounded.Refresh": return Icons.Rounded.Refresh
        case "Icons.Rounded.Search": return Icons.Rounded.Search
        case "Icons.Rounded.Send": return Icons.Rounded.Send // Compose 1.6 TODO: Icons.AutoMirrored.Rounded.Send
        case "Icons.Rounded.Settings": return Icons.Rounded.Settings
        case "Icons.Rounded.Share": return Icons.Rounded.Share
        case "Icons.Rounded.ShoppingCart": return Icons.Rounded.ShoppingCart
        case "Icons.Rounded.Star": return Icons.Rounded.Star
        case "Icons.Rounded.ThumbUp": return Icons.Rounded.ThumbUp
        case "Icons.Rounded.Warning": return Icons.Rounded.Warning

        case "Icons.Sharp.AccountBox": return Icons.Sharp.AccountBox
        case "Icons.Sharp.AccountCircle": return Icons.Sharp.AccountCircle
        case "Icons.Sharp.AddCircle": return Icons.Sharp.AddCircle
        case "Icons.Sharp.Add": return Icons.Sharp.Add
        case "Icons.Sharp.ArrowBack": return Icons.Sharp.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.ArrowBack
        case "Icons.Sharp.ArrowDropDown": return Icons.Sharp.ArrowDropDown
        case "Icons.Sharp.ArrowForward": return Icons.Sharp.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.ArrowForward
        case "Icons.Sharp.Build": return Icons.Sharp.Build
        case "Icons.Sharp.Call": return Icons.Sharp.Call
        case "Icons.Sharp.CheckCircle": return Icons.Sharp.CheckCircle
        case "Icons.Sharp.Check": return Icons.Sharp.Check
        case "Icons.Sharp.Clear": return Icons.Sharp.Clear
        case "Icons.Sharp.Close": return Icons.Sharp.Close
        case "Icons.Sharp.Create": return Icons.Sharp.Create
        case "Icons.Sharp.DateRange": return Icons.Sharp.DateRange
        case "Icons.Sharp.Delete": return Icons.Sharp.Delete
        case "Icons.Sharp.Done": return Icons.Sharp.Done
        case "Icons.Sharp.Edit": return Icons.Sharp.Edit
        case "Icons.Sharp.Email": return Icons.Sharp.Email
        case "Icons.Sharp.ExitToApp": return Icons.Sharp.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.ExitToApp
        case "Icons.Sharp.Face": return Icons.Sharp.Face
        case "Icons.Sharp.FavoriteBorder": return Icons.Sharp.FavoriteBorder
        case "Icons.Sharp.Favorite": return Icons.Sharp.Favorite
        case "Icons.Sharp.Home": return Icons.Sharp.Home
        case "Icons.Sharp.Info": return Icons.Sharp.Info
        case "Icons.Sharp.KeyboardArrowDown": return Icons.Sharp.KeyboardArrowDown
        case "Icons.Sharp.KeyboardArrowLeft": return Icons.Sharp.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.KeyboardArrowLeft
        case "Icons.Sharp.KeyboardArrowRight": return Icons.Sharp.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.KeyboardArrowRight
        case "Icons.Sharp.KeyboardArrowUp": return Icons.Sharp.KeyboardArrowUp
        case "Icons.Sharp.List": return Icons.Sharp.List // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.List
        case "Icons.Sharp.LocationOn": return Icons.Sharp.LocationOn
        case "Icons.Sharp.Lock": return Icons.Sharp.Lock
        case "Icons.Sharp.MailOutline": return Icons.Sharp.MailOutline
        case "Icons.Sharp.Menu": return Icons.Sharp.Menu
        case "Icons.Sharp.MoreVert": return Icons.Sharp.MoreVert
        case "Icons.Sharp.Notifications": return Icons.Sharp.Notifications
        case "Icons.Sharp.Person": return Icons.Sharp.Person
        case "Icons.Sharp.Phone": return Icons.Sharp.Phone
        case "Icons.Sharp.Place": return Icons.Sharp.Place
        case "Icons.Sharp.PlayArrow": return Icons.Sharp.PlayArrow
        case "Icons.Sharp.Refresh": return Icons.Sharp.Refresh
        case "Icons.Sharp.Search": return Icons.Sharp.Search
        case "Icons.Sharp.Send": return Icons.Sharp.Send // Compose 1.6 TODO: Icons.AutoMirrored.Sharp.Send
        case "Icons.Sharp.Settings": return Icons.Sharp.Settings
        case "Icons.Sharp.Share": return Icons.Sharp.Share
        case "Icons.Sharp.ShoppingCart": return Icons.Sharp.ShoppingCart
        case "Icons.Sharp.Star": return Icons.Sharp.Star
        case "Icons.Sharp.ThumbUp": return Icons.Sharp.ThumbUp
        case "Icons.Sharp.Warning": return Icons.Sharp.Warning

        case "Icons.TwoTone.AccountBox": return Icons.TwoTone.AccountBox
        case "Icons.TwoTone.AccountCircle": return Icons.TwoTone.AccountCircle
        case "Icons.TwoTone.AddCircle": return Icons.TwoTone.AddCircle
        case "Icons.TwoTone.Add": return Icons.TwoTone.Add
        case "Icons.TwoTone.ArrowBack": return Icons.TwoTone.ArrowBack // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.ArrowBack
        case "Icons.TwoTone.ArrowDropDown": return Icons.TwoTone.ArrowDropDown
        case "Icons.TwoTone.ArrowForward": return Icons.TwoTone.ArrowForward // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.ArrowForward
        case "Icons.TwoTone.Build": return Icons.TwoTone.Build
        case "Icons.TwoTone.Call": return Icons.TwoTone.Call
        case "Icons.TwoTone.CheckCircle": return Icons.TwoTone.CheckCircle
        case "Icons.TwoTone.Check": return Icons.TwoTone.Check
        case "Icons.TwoTone.Clear": return Icons.TwoTone.Clear
        case "Icons.TwoTone.Close": return Icons.TwoTone.Close
        case "Icons.TwoTone.Create": return Icons.TwoTone.Create
        case "Icons.TwoTone.DateRange": return Icons.TwoTone.DateRange
        case "Icons.TwoTone.Delete": return Icons.TwoTone.Delete
        case "Icons.TwoTone.Done": return Icons.TwoTone.Done
        case "Icons.TwoTone.Edit": return Icons.TwoTone.Edit
        case "Icons.TwoTone.Email": return Icons.TwoTone.Email
        case "Icons.TwoTone.ExitToApp": return Icons.TwoTone.ExitToApp // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.ExitToApp
        case "Icons.TwoTone.Face": return Icons.TwoTone.Face
        case "Icons.TwoTone.FavoriteBorder": return Icons.TwoTone.FavoriteBorder
        case "Icons.TwoTone.Favorite": return Icons.TwoTone.Favorite
        case "Icons.TwoTone.Home": return Icons.TwoTone.Home
        case "Icons.TwoTone.Info": return Icons.TwoTone.Info
        case "Icons.TwoTone.KeyboardArrowDown": return Icons.TwoTone.KeyboardArrowDown
        case "Icons.TwoTone.KeyboardArrowLeft": return Icons.TwoTone.KeyboardArrowLeft // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.KeyboardArrowLeft
        case "Icons.TwoTone.KeyboardArrowRight": return Icons.TwoTone.KeyboardArrowRight // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.KeyboardArrowRight
        case "Icons.TwoTone.KeyboardArrowUp": return Icons.TwoTone.KeyboardArrowUp
        case "Icons.TwoTone.List": return Icons.TwoTone.List // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.List
        case "Icons.TwoTone.LocationOn": return Icons.TwoTone.LocationOn
        case "Icons.TwoTone.Lock": return Icons.TwoTone.Lock
        case "Icons.TwoTone.MailOutline": return Icons.TwoTone.MailOutline
        case "Icons.TwoTone.Menu": return Icons.TwoTone.Menu
        case "Icons.TwoTone.MoreVert": return Icons.TwoTone.MoreVert
        case "Icons.TwoTone.Notifications": return Icons.TwoTone.Notifications
        case "Icons.TwoTone.Person": return Icons.TwoTone.Person
        case "Icons.TwoTone.Phone": return Icons.TwoTone.Phone
        case "Icons.TwoTone.Place": return Icons.TwoTone.Place
        case "Icons.TwoTone.PlayArrow": return Icons.TwoTone.PlayArrow
        case "Icons.TwoTone.Refresh": return Icons.TwoTone.Refresh
        case "Icons.TwoTone.Search": return Icons.TwoTone.Search
        case "Icons.TwoTone.Send": return Icons.TwoTone.Send // Compose 1.6 TODO: Icons.AutoMirrored.TwoTone.Send
        case "Icons.TwoTone.Settings": return Icons.TwoTone.Settings
        case "Icons.TwoTone.Share": return Icons.TwoTone.Share
        case "Icons.TwoTone.ShoppingCart": return Icons.TwoTone.ShoppingCart
        case "Icons.TwoTone.Star": return Icons.TwoTone.Star
        case "Icons.TwoTone.ThumbUp": return Icons.TwoTone.ThumbUp
        case "Icons.TwoTone.Warning": return Icons.TwoTone.Warning

        default: return nil
        }
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    public enum ResizingMode : Sendable {
        case tile
        case stretch
    }

    public func resizable() -> Image {
        var image = self
        image.resizingMode = .stretch
        return image
    }

    @available(*, unavailable) // No capInsets support yet
    public func resizable(capInsets: EdgeInsets) -> Image {
        var image = self
        image.capInsets = capInsets
        return image
    }

    @available(*, unavailable) // No resizingMode support yet
    public func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode) -> Image {
        var image = self
        image.capInsets = capInsets
        image.resizingMode = resizingMode
        return image
    }
}

#if !SKIP

// TODO: Process for use in SkipUI

import class CoreGraphics.CGContext
import struct CoreGraphics.CGFloat
import class CoreGraphics.CGImage
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import class Foundation.Bundle


//#if canImport(CoreTransferable)
//import protocol CoreTransferable.Transferable
//
//@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
//extension Image : Transferable {
//
//    /// The representation used to import and export the item.
//    ///
//    /// A ``transferRepresentation`` can contain multiple representations
//    /// for different content types.
//    public static var transferRepresentation: Representation { get { return never() } }
//
//    /// The type of the representation used to import and export the item.
//    ///
//    /// Swift infers this type from the return value of the
//    /// ``transferRepresentation`` property.
//    public typealias Representation = Never
//}
//#endif

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Image {

    /// Creates a system symbol image with a variable value.
    ///
    /// This initializer creates an image using a system-provided symbol. The
    /// rendered symbol may alter its appearance to represent the value
    /// provided in `variableValue`. Use symbols
    /// to find system symbols that support variable
    /// values and their corresponding names.
    ///
    /// The following example shows the effect of creating the `"chart.bar.fill"`
    /// symbol with different values.
    ///
    ///     HStack{
    ///         Image(systemName: "chart.bar.fill", variableValue: 0.3)
    ///         Image(systemName: "chart.bar.fill", variableValue: 0.6)
    ///         Image(systemName: "chart.bar.fill", variableValue: 1.0)
    ///     }
    ///     .font(.system(.largeTitle))
    ///
    /// ![Three instances of the bar chart symbol, arranged horizontally.
    /// The first fills one bar, the second fills two bars, and the last
    /// symbol fills all three bars.](Image-3)
    ///
    /// To create a custom symbol image from your app's asset
    /// catalog, use ``Image/init(_:variableValue:bundle:)`` instead.
    ///
    /// - Parameters:
    ///   - systemName: The name of the system symbol image.
    ///     Use the SF Symbols app to look up the names of system
    ///     symbol images.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect. Use the SF Symbols app to look up which
    ///     symbols support variable values.
    public init(systemName: String, variableValue: Double?) { fatalError() }

    /// Creates a labeled image that you can use as content for controls,
    /// with a variable value.
    ///
    /// This initializer creates an image using a using a symbol in the
    /// specified bundle. The rendered symbol may alter its appearance to
    /// represent the value provided in `variableValue`.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup, as well as
    ///     the localization key with which to label the image.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect.
    ///   - bundle: The bundle to search for the image resource and
    ///     localization content. If `nil`, SkipUI uses the main
    ///     `Bundle`. Defaults to `nil`.
    ///
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil) { fatalError() }

    /// Creates a labeled image that you can use as content for controls, with
    /// the specified label and variable value.
    ///
    /// This initializer creates an image using a using a symbol in the
    /// specified bundle. The rendered symbol may alter its appearance to
    /// represent the value provided in `variableValue`.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect.
    ///   - bundle: The bundle to search for the image resource. If
    ///     `nil`, SkipUI uses the main `Bundle`. Defaults to `nil`.
    ///   - label: The label associated with the image. SkipUI uses
    ///     the label for accessibility.
    ///
    public init(_ name: String, variableValue: Double?, bundle: Bundle? = nil, label: Text) { fatalError() }

    /// Creates an unlabeled, decorative image, with a variable value.
    ///
    /// This initializer creates an image using a using a symbol in the
    /// specified bundle. The rendered symbol may alter its appearance to
    /// represent the value provided in `variableValue`.
    ///
    /// SkipUI ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup.
    ///   - variableValue: An optional value between `0.0` and `1.0` that
    ///     the rendered image can use to customize its appearance, if
    ///     specified. If the symbol doesn't support variable values, this
    ///     parameter has no effect.
    ///   - bundle: The bundle to search for the image resource. If
    ///     `nil`, SkipUI uses the main `Bundle`. Defaults to `nil`.
    ///
    public init(decorative name: String, variableValue: Double?, bundle: Bundle? = nil) { fatalError() }
}

#if canImport(UIKit)
import struct UIKit.ImageResource

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension Image {

    /// Initialize an `Image` with an image resource.
    public init(_ resource: ImageResource) { fatalError() }
}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension Image {

    public struct DynamicRange : Hashable, Sendable {

        /// Restrict the image content dynamic range to the standard range.
        public static let standard: Image.DynamicRange = { fatalError() }()

        /// Allow image content to use some extended range. This is
        /// appropriate for placing HDR content next to SDR content.
        public static let constrainedHigh: Image.DynamicRange = { fatalError() }()

        /// Allow image content to use an unrestricted extended range.
        public static let high: Image.DynamicRange = { fatalError() }()

    
        

        }

    /// Returns a new image configured with the specified allowed
    /// dynamic range.
    ///
    /// The following example enables HDR rendering for a specific
    /// image view, assuming that the image has an HDR (ITU-R 2100)
    /// color space and the output device supports it:
    ///
    ///     Image("hdr-asset").allowedDynamicRange(.high)
    ///
    /// - Parameter range: the requested dynamic range, or nil to
    ///   restore the default allowed range.
    ///
    /// - Returns: a new image.
    public func allowedDynamicRange(_ range: Image.DynamicRange?) -> Image { fatalError() }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension View {

    /// Returns a new view configured with the specified allowed
    /// dynamic range.
    ///
    /// The following example enables HDR rendering within a view
    /// hierarchy:
    ///
    ///     MyView().allowedDynamicRange(.high)
    ///
    /// - Parameter range: the requested dynamic range, or nil to
    ///   restore the default allowed range.
    ///
    /// - Returns: a new view.
    public func allowedDynamicRange(_ range: Image.DynamicRange?) -> some View { return stubView() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Indicates whether SkipUI renders an image as-is, or
    /// by using a different mode.
    ///
    /// The ``TemplateRenderingMode`` enumeration has two cases:
    /// ``TemplateRenderingMode/original`` and ``TemplateRenderingMode/template``.
    /// The original mode renders pixels as they appear in the original source
    /// image. Template mode renders all nontransparent pixels as the
    /// foreground color, which you can use for purposes like creating image
    /// masks.
    ///
    /// The following example shows both rendering modes, as applied to an icon
    /// image of a green circle with darker green border:
    ///
    ///     Image("dot_green")
    ///         .renderingMode(.original)
    ///     Image("dot_green")
    ///         .renderingMode(.template)
    ///
    /// ![Two identically-sized circle images. The circle on top is green
    /// with a darker green border. The circle at the bottom is a solid color,
    /// either white on a black background, or black on a white background,
    /// depending on the system's current dark mode
    /// setting.](SkipUI-Image-TemplateRenderingMode-dots.png)
    ///
    /// You also use `renderingMode` to produce multicolored system graphics
    /// from the SF Symbols set. Use the ``TemplateRenderingMode/original``
    /// mode to apply a foreground color to all parts of the symbol except
    /// those that have a distinct color in the graphic. The following
    /// example shows three uses of the `person.crop.circle.badge.plus` symbol
    /// to achieve different effects:
    ///
    /// * A default appearance with no foreground color or template rendering
    /// mode specified. The symbol appears all black in light mode, and all
    /// white in Dark Mode.
    /// * The multicolor behavior achieved by using `original` template
    /// rendering mode, along with a blue foreground color. This mode causes the
    /// graphic to override the foreground color for distinctive parts of the
    /// image, in this case the plus icon.
    /// * A single-color template behavior achieved by using `template`
    /// rendering mode with a blue foreground color. This mode applies the
    /// foreground color to the entire image, regardless of the user's Appearance preferences.
    ///
    ///```swift
    ///HStack {
    ///    Image(systemName: "person.crop.circle.badge.plus")
    ///    Image(systemName: "person.crop.circle.badge.plus")
    ///        .renderingMode(.original)
    ///        .foregroundColor(.blue)
    ///    Image(systemName: "person.crop.circle.badge.plus")
    ///        .renderingMode(.template)
    ///        .foregroundColor(.blue)
    ///}
    ///.font(.largeTitle)
    ///```
    ///
    /// ![A horizontal layout of three versions of the same symbol: a person
    /// icon in a circle with a plus icon overlaid at the bottom left. Each
    /// applies a diffent set of colors based on its rendering mode, as
    /// described in the preceding
    /// list.](SkipUI-Image-TemplateRenderingMode-sfsymbols.png)
    ///
    /// Use the SF Symbols app to find system images that offer the multicolor
    /// feature. Keep in mind that some multicolor symbols use both the
    /// foreground and accent colors.
    ///
    /// - Parameter renderingMode: The mode SkipUI uses to render images.
    /// - Returns: A modified ``Image``.
    public func renderingMode(_ renderingMode: Image.TemplateRenderingMode?) -> Image { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// The orientation of an image.
    ///
    /// Many image formats such as JPEG include orientation metadata in the
    /// image data. In other cases, you can specify image orientation
    /// in code. Properly specifying orientation is often important both for
    /// displaying the image and for certain kinds of image processing.
    ///
    /// In SkipUI, you provide an orientation value when initializing an
    /// ``Image`` from an existing
    /// .
    @frozen public enum Orientation : UInt8, CaseIterable, Hashable {

        /// A value that indicates the original pixel data matches the image's
        /// intended display orientation.
        case up

        /// A value that indicates a horizontal flip of the image from the
        /// orientation of its original pixel data.
        case upMirrored

        /// A value that indicates a 180° rotation of the image from the
        /// orientation of its original pixel data.
        case down

        /// A value that indicates a vertical flip of the image from the
        /// orientation of its original pixel data.
        case downMirrored

        /// A value that indicates a 90° counterclockwise rotation from the
        /// orientation of its original pixel data.
        case left

        /// A value that indicates a 90° clockwise rotation and horizontal
        /// flip of the image from the orientation of its original pixel
        /// data.
        case leftMirrored

        /// A value that indicates a 90° clockwise rotation of the image from
        /// the orientation of its original pixel data.
        case right

        /// A value that indicates a 90° counterclockwise rotation and
        /// horizontal flip from the orientation of its original pixel data.
        case rightMirrored

        /// Creates a new instance with the specified raw value.
        ///
        /// If there is no value of the type that corresponds with the specified raw
        /// value, this initializer returns `nil`. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     print(PaperSize(rawValue: "Legal"))
        ///     // Prints "Optional("PaperSize.Legal")"
        ///
        ///     print(PaperSize(rawValue: "Tabloid"))
        ///     // Prints "nil"
        ///
        /// - Parameter rawValue: The raw value to use for the new instance.
        public init?(rawValue: UInt8) { fatalError() }

        /// A type that can represent a collection of all values of this type.
        public typealias AllCases = [Image.Orientation]

        /// The raw type that can be used to represent all values of the conforming
        /// type.
        ///
        /// Every distinct value of the conforming type has a corresponding unique
        /// value of the `RawValue` type, but there may be values of the `RawValue`
        /// type that don't have a corresponding value of the conforming type.
        public typealias RawValue = UInt8

        /// A collection of all values of this type.
        public static var allCases: [Image.Orientation] { get { fatalError() } }

        /// The corresponding value of the raw type.
        ///
        /// A new instance initialized with `rawValue` will be equivalent to this
        /// instance. For example:
        ///
        ///     enum PaperSize: String {
        ///         case A4, A5, Letter, Legal
        ///     }
        ///
        ///     let selectedSize = PaperSize.Letter
        ///     print(selectedSize.rawValue)
        ///     // Prints "Letter"
        ///
        ///     print(selectedSize == PaperSize(rawValue: selectedSize.rawValue)!)
        ///     // Prints "true"
        public var rawValue: UInt8 { get { fatalError() } }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// A type that indicates how SkipUI renders images.
    public enum TemplateRenderingMode : Sendable {

        /// A mode that renders all non-transparent pixels as the foreground
        /// color.
        case template

        /// A mode that renders pixels of bitmap images as-is.
        ///
        /// For system images created from the SF Symbol set, multicolor symbols
        /// respect the current foreground and accent colors.
        case original

        

    
        }

    /// A scale to apply to vector images relative to text.
    ///
    /// Use this type with the ``View/imageScale(_:)`` modifier, or the
    /// ``EnvironmentValues/imageScale`` environment key, to set the image scale.
    ///
    /// The following example shows the three `Scale` values as applied to
    /// a system symbol image, each set against a text view:
    ///
    ///     HStack { Image(systemName: "swift").imageScale(.small); Text("Small") }
    ///     HStack { Image(systemName: "swift").imageScale(.medium); Text("Medium") }
    ///     HStack { Image(systemName: "swift").imageScale(.large); Text("Large") }
    ///
    /// ![Vertically arranged text views that read Small, Medium, and
    /// Large. On the left of each view is a system image that uses the Swift symbol.
    /// The image next to the Small text is slightly smaller than the text.
    /// The image next to the Medium text matches the size of the text. The
    /// image next to the Large text is larger than the
    /// text.](SkipUI-EnvironmentAdditions-Image-scale.png)
    ///
    @available(macOS 11.0, *)
    public enum Scale : Sendable {

        /// A scale that produces small images.
        case small

        /// A scale that produces medium-sized images.
        case medium

        /// A scale that produces large images.
        case large
    
        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Scales images within the view according to one of the relative sizes
    /// available including small, medium, and large images sizes.
    ///
    /// The example below shows the relative scaling effect. The system renders
    /// the image at a relative size based on the available space and
    /// configuration options of the image it is scaling.
    ///
    ///     VStack {
    ///         HStack {
    ///             Image(systemName: "heart.fill")
    ///                 .imageScale(.small)
    ///             Text("Small")
    ///         }
    ///         HStack {
    ///             Image(systemName: "heart.fill")
    ///                 .imageScale(.medium)
    ///             Text("Medium")
    ///         }
    ///
    ///         HStack {
    ///             Image(systemName: "heart.fill")
    ///                 .imageScale(.large)
    ///             Text("Large")
    ///         }
    ///     }
    ///
    /// ![A view showing small, medium, and large hearts rendered at a size
    /// relative to the available space.](SkipUI-View-imageScale.png)
    ///
    /// - Parameter scale: One of the relative sizes provided by the image scale
    ///   enumeration.
    @available(macOS 11.0, *)
    public func imageScale(_ scale: Image.Scale) -> some View { return stubView() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// The level of quality for rendering an image that requires interpolation,
    /// such as a scaled image.
    ///
    /// The ``Image/interpolation(_:)`` modifier specifies the interpolation
    /// behavior when using the ``Image/resizable(capInsets:resizingMode:)``
    /// modifier on an ``Image``. Use this behavior to prioritize rendering
    /// performance or image quality.
    public enum Interpolation : Sendable {

        /// A value that indicates SkipUI doesn't interpolate image data.
        case none

        /// A value that indicates a low level of interpolation quality, which may
        /// speed up image rendering.
        case low

        /// A value that indicates a medium level of interpolation quality,
        /// between the low- and high-quality values.
        case medium

        /// A value that indicates a high level of interpolation quality, which
        /// may slow down image rendering.
        case high

        

    
        }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Specifies the current level of quality for rendering an
    /// image that requires interpolation.
    ///
    /// See the article <doc:Fitting-Images-into-Available-Space> for examples
    /// of using `interpolation(_:)` when scaling an ``Image``.
    /// - Parameter interpolation: The quality level, expressed as a value of
    /// the `Interpolation` type, that SkipUI applies when interpolating
    /// an image.
    /// - Returns: An image with the given interpolation value set.
    public func interpolation(_ interpolation: Image.Interpolation) -> Image { fatalError() }

    /// Specifies whether SkipUI applies antialiasing when rendering
    /// the image.
    /// - Parameter isAntialiased: A Boolean value that specifies whether to
    /// allow antialiasing. Pass `true` to allow antialising, `false` otherwise.
    /// - Returns: An image with the antialiasing behavior set.
    public func antialiased(_ isAntialiased: Bool) -> Image { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {

    /// Creates a labeled image based on a Core Graphics image instance, usable
    /// as content for controls.
    ///
    /// - Parameters:
    ///   - cgImage: The base graphical image.
    ///   - scale: The scale factor for the image,
    ///     with a value like `1.0`, `2.0`, or `3.0`.
    ///   - orientation: The orientation of the image. The default is
    ///     ``Image/Orientation/up``.
    ///   - label: The label associated with the image. SkipUI uses the label
    ///     for accessibility.
    public init(_ cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up, label: Text) { fatalError() }

    /// Creates an unlabeled, decorative image based on a Core Graphics image
    /// instance.
    ///
    /// SkipUI ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - cgImage: The base graphical image.
    ///   - scale: The scale factor for the image,
    ///     with a value like `1.0`, `2.0`, or `3.0`.
    ///   - orientation: The orientation of the image. The default is
    ///     ``Image/Orientation/up``.
    public init(decorative cgImage: CGImage, scale: CGFloat, orientation: Image.Orientation = .up) { fatalError() }
}

#if canImport(UIKit)
import class UIKit.UIImage

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
extension Image {

    /// Creates a SkipUI image from a UIKit image instance.
    /// - Parameter uiImage: The UIKit image to wrap with a SkipUI ``Image``
    /// instance.
    public init(uiImage: UIImage) { fatalError() }
}
#endif

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Image {

    /// Initializes an image of the given size, with contents provided by a
    /// custom rendering closure.
    ///
    /// Use this initializer to create an image by calling drawing commands on a
    /// ``GraphicsContext`` provided to the `renderer` closure.
    ///
    /// The following example shows a custom image created by passing a
    /// `GraphicContext` to draw an ellipse and fill it with a gradient:
    ///
    ///     let mySize = CGSize(width: 300, height: 200)
    ///     let image = Image(size: mySize) { context in
    ///         context.fill(
    ///             Path(
    ///                 ellipseIn: CGRect(origin: .zero, size: mySize)),
    ///                 with: .linearGradient(
    ///                     Gradient(colors: [.yellow, .orange]),
    ///                     startPoint: .zero,
    ///                     endPoint: CGPoint(x: mySize.width, y:mySize.height))
    ///         )
    ///     }
    ///
    /// ![An ellipse with a gradient that blends from yellow at the upper-
    /// left to orange at the bottom-right.](Image-2)
    ///
    /// - Parameters:
    ///   - size: The size of the newly-created image.
    ///   - label: The label associated with the image. SkipUI uses the label
    ///     for accessibility.
    ///   - opaque: A Boolean value that indicates whether the image is fully
    ///     opaque. This may improve performance when `true`. Don't render
    ///     non-opaque pixels to an image declared as opaque. Defaults to `false`.
    ///   - colorMode: The working color space and storage format of the image.
    ///     Defaults to ``ColorRenderingMode/nonLinear``.
    ///   - renderer: A closure to draw the contents of the image. The closure
    ///     receives a ``GraphicsContext`` as its parameter.
    public init(size: CGSize, label: Text? = nil, opaque: Bool = false, colorMode: ColorRenderingMode = .nonLinear, renderer: @escaping (inout GraphicsContext) -> Void) { fatalError() }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Orientation : RawRepresentable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Orientation : Sendable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.TemplateRenderingMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.TemplateRenderingMode : Hashable {
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 11.0, *)
extension Image.Scale : Equatable {
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 11.0, *)
extension Image.Scale : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Interpolation : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Interpolation : Hashable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.ResizingMode : Equatable {
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.ResizingMode : Hashable {
}

/// A shape style that fills a shape by repeating a region of an image.
///
/// You can also use ``ShapeStyle/image(_:sourceRect:scale:)`` to construct this
/// style.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct ImagePaint : ShapeStyle {

    /// The image to be drawn.
    public var image: Image { get { fatalError() } }

    /// A unit-space rectangle defining how much of the source image to draw.
    ///
    /// The results are undefined if this rectangle selects areas outside the
    /// `[0, 1]` range in either axis.
    public var sourceRect: CGRect { get { fatalError() } }

    /// A scale factor applied to the image while being drawn.
    public var scale: CGFloat { get { fatalError() } }

    /// Creates a shape-filling shape style.
    ///
    /// - Parameters:
    ///   - image: The image to be drawn.
    ///   - sourceRect: A unit-space rectangle defining how much of the source
    ///     image to draw. The results are undefined if `sourceRect` selects
    ///     areas outside the `[0, 1]` range in either axis.
    ///   - scale: A scale factor applied to the image during rendering.
    public init(image: Image, sourceRect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1), scale: CGFloat = 1) { fatalError() }

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    public typealias Resolved = Never
}

#if canImport(Combine)
import protocol Combine.ObservableObject
import class Combine.PassthroughSubject

/// An object that creates images from SkipUI views.
///
/// Use `ImageRenderer` to export bitmap image data from a SkipUI view. You
/// initialize the renderer with a view, then render images on demand,
/// either by calling the ``render(rasterizationScale:renderer:)`` method, or
/// by using the renderer's properties to create a
/// ,
/// , or
/// .
///
/// By drawing to a ``Canvas`` and exporting with an `ImageRenderer`,
/// you can generate images from any progammatically-rendered content, like
/// paths, shapes, gradients, and more. You can also render standard SkipUI
/// views like ``Text`` views, or containers of multiple view types.
///
/// The following example uses a private `createAwardView(forUser:date:)` method
/// to create a game app's view of a trophy symbol with a user name and date.
/// This view combines a ``Canvas`` that applies a shadow filter with
/// two ``Text`` views into a ``VStack``. A ``Button`` allows the person to
/// save this view. The button's action uses an `ImageRenderer` to rasterize a
/// `CGImage` and then calls a private `uploadAchievementImage(_:)` method to
/// encode and upload the image.
///
///     var body: some View {
///         let trophyAndDate = createAwardView(forUser: playerName,
///                                              date: achievementDate)
///         VStack {
///             trophyAndDate
///             Button("Save Achievement") {
///                 let renderer = ImageRenderer(content: trophyAndDate)
///                 if let image = renderer.cgImage {
///                     uploadAchievementImage(image)
///                 }
///             }
///         }
///     }
///
///     private func createAwardView(forUser: String, date: Date) -> some View {
///         VStack {
///             Image(systemName: "trophy")
///                 .resizable()
///                 .frame(width: 200, height: 200)
///                 .frame(maxWidth: .infinity, maxHeight: .infinity)
///                 .shadow(color: .mint, radius: 5)
///             Text(playerName)
///                 .font(.largeTitle)
///             Text(achievementDate.formatted())
///         }
///         .multilineTextAlignment(.center)
///         .frame(width: 200, height: 290)
///     }
///
/// ![A large trophy symbol, drawn with a mint-colored shadow. Below this, a
/// user name and the date and time. At the bottom, a button with the title
/// Save Achievement allows people to save and upload an image of this
/// view.](ImageRenderer-1)
///
/// Because `ImageRenderer` conforms to
/// , you
/// can use it to produce a stream of images as its properties change. Subscribe
/// to the renderer's ``ImageRenderer/objectWillChange`` publisher, then use the
/// renderer to rasterize a new image each time the subscriber receives an
/// update.
///
/// - Important: `ImageRenderer` output only includes views that SkipUI renders,
/// such as text, images, shapes, and composite views of these types. It
/// does not render views provided by native platform frameworks (AppKit and
/// UIKit) such as web views, media players, and some controls. For these views,
/// `ImageRenderer` displays a placeholder image, similar to the behavior of
/// ``View/drawingGroup(opaque:colorMode:)``.
///
/// ### Rendering to a PDF context
///
/// The ``render(rasterizationScale:renderer:)`` method renders the specified
/// view to any
/// . That
/// means you aren't limited to creating a rasterized `CGImage`. For
/// example, you can generate PDF data by rendering to a PDF context. The
/// resulting PDF maintains resolution-independence for supported members of the
/// view hierarchy, such as text, symbol images, lines, shapes, and fills.
///
/// The following example uses the `createAwardView(forUser:date:)` method from
/// the previous example, and exports its contents as an 800-by-600 point PDF to
/// the file URL `renderURL`. It uses the `size` parameter sent to the
/// rendering closure to center the `trophyAndDate` view vertically and
/// horizontally on the page.
///
///     var body: some View {
///         let trophyAndDate = createAwardView(forUser: playerName,
///                                             date: achievementDate)
///         VStack {
///             trophyAndDate
///             Button("Save Achievement") {
///                 let renderer = ImageRenderer(content: trophyAndDate)
///                 renderer.render { size, renderer in
///                     var mediaBox = CGRect(origin: .zero,
///                                           size: CGSize(width: 800, height: 600))
///                     guard let consumer = CGDataConsumer(url: renderURL as CFURL),
///                           let pdfContext =  CGContext(consumer: consumer,
///                                                       mediaBox: &mediaBox, nil)
///                     else {
///                         return
///                     }
///                     pdfContext.beginPDFPage(nil)
///                     pdfContext.translateBy(x: mediaBox.size.width / 2 - size.width / 2,
///                                            y: mediaBox.size.height / 2 - size.height / 2)
///                     renderer(pdfContext)
///                     pdfContext.endPDFPage()
///                     pdfContext.closePDF()
///                 }
///             }
///         }
///     }
///
/// ### Creating an image from drawing instructions
///
/// `ImageRenderer` makes it possible to create a custom image by drawing into a
/// ``Canvas``, rendering a `CGImage` from it, and using that to initialize an
/// ``Image``. To simplify this process, use the `Image`
/// initializer ``Image/init(size:label:opaque:colorMode:renderer:)``, which
/// takes a closure whose argument is a ``GraphicsContext`` that you can
/// directly draw into.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
final public class ImageRenderer<Content> : ObservableObject where Content : View {

    /// A publisher that informs subscribers of changes to the image.
    ///
    /// The renderer's
    /// publishes `Void` elements.
    /// Subscribers should interpret any event as indicating that the contents
    /// of the image may have changed.
    final public let objectWillChange: PassthroughSubject<Void, Never>

    /// The root view rendered by this image renderer.
    @MainActor final public var content: Content { get { fatalError() } }

    /// The size proposed to the root view.
    ///
    /// The default value of this property, ``ProposedViewSize/unspecified``,
    /// produces an image that matches the original view size. You can provide
    /// a custom ``ProposedViewSize`` to override the view's size in one or
    /// both dimensions.
    @MainActor final public var proposedSize: ProposedViewSize { get { fatalError() } }

    /// The scale at which to render the image.
    ///
    /// This value is a ratio of view points to image pixels. This relationship
    /// means that values greater than `1.0` create an image larger than the
    /// original content view, and less than `1.0` creates a smaller image. The
    /// following example shows a 100 x 50 rectangle view and an image rendered
    /// from it with a `scale` of `2.0`, resulting in an image size of
    /// 200 x 100.
    ///
    ///     let rectangle = Rectangle()
    ///         .frame(width: 100, height: 50)
    ///     let renderer = ImageRenderer(content: rectangle)
    ///     renderer.scale = 2.0
    ///     if let rendered = renderer.cgImage {
    ///         print("Scaled image: \(rendered.width) x \(rendered.height)")
    ///     }
    ///     // Prints "Scaled image: 200 x 100"
    ///
    /// The default value of this property is `1.0`.
    @MainActor final public var scale: CGFloat { get { fatalError() } }

    /// A Boolean value that indicates whether the alpha channel of the image is
    /// fully opaque.
    ///
    /// Setting this value to `true`, meaning the alpha channel is opaque, may
    /// improve performance. Don't render non-opaque pixels to a renderer
    /// declared as opaque. This property defaults to `false`.
    @MainActor final public var isOpaque: Bool { get { fatalError() } }

    /// The working color space and storage format of the image.
    @MainActor final public var colorMode: ColorRenderingMode { get { fatalError() } }

    /// Creates a renderer object with a source content view.
    ///
    /// - Parameter view: A ``View`` to render.
    @MainActor public init(content view: Content) { fatalError() }

    /// The current contents of the view, rasterized as a Core Graphics image.
    ///
    /// The renderer notifies its `objectWillChange` publisher when
    /// the contents of the image may have changed.
    @MainActor final public var cgImage: CGImage? { get { fatalError() } }

    #if canImport(UIKit)
    /// The current contents of the view, rasterized as a UIKit image.
    ///
    /// The renderer notifies its `objectWillChange` publisher when
    /// the contents of the image may have changed.
    @MainActor final public var uiImage: UIImage? { get { fatalError() } }
    #endif
    
    /// Draws the renderer's current contents to an arbitrary Core Graphics
    /// context.
    ///
    /// Use this method to rasterize the renderer's content to a
    /// you provide. The `renderer` closure receives two parameters: the current
    /// size of the view, and a function that renders the view to your
    /// `CGContext`. Implement the closure to provide a suitable `CGContext`,
    /// then invoke the function to render the content to that context.
    ///
    /// - Parameters:
    ///   - rasterizationScale: The scale factor for converting user
    ///     interface points to pixels when rasterizing parts of the
    ///     view that can't be represented as native Core Graphics drawing
    ///     commands.
    ///   - renderer: The closure that sets up the Core Graphics context and
    ///     renders the view. This closure receives two parameters: the size of
    ///     the view and a function that you invoke in the closure to render the
    ///     view at the reported size. This function takes a
    ///     
    ///     parameter, and assumes a bottom-left coordinate space origin.
    @MainActor final public func render(rasterizationScale: CGFloat = 1, renderer: (CGSize, (CGContext) -> Void) -> Void) { fatalError() }

    /// The type of publisher that emits before the object has changed.
    public typealias ObjectWillChangePublisher = PassthroughSubject<Void, Never>
}
#endif

#endif
