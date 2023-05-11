//
//  MeMeBaseGlobals.swift
//  MeMeBaseKit
//
//  Created by fabo on 2020/6/2.
//  Copyright © 2020 meme. All rights reserved.
//

import Foundation
//import XCGLogger

//public let log = XCGLogger.default
public typealias VoidBlock = () -> Void

public let StatusBarStyleDarkContent: UIStatusBarStyle = {
    if #available(iOS 13.0, *) {
        return UIStatusBarStyle.darkContent
    } else {
        return UIStatusBarStyle.default
    }
}()

public enum ReachabilityState: Int {
    case wifi, cellular, none
}

public let isPad = UIDevice.current.userInterfaceIdiom == .pad
public let isIPhoneX = (UIWindow.keyWindowSafeAreaInsets().bottom > 0)
public let StatusBarHeight = UIApplication.shared.statusBarFrame.size.height == 0 ? (isIPhoneX ? 44 : 20) : UIApplication.shared.statusBarFrame.size.height
public let StatusBarHeight2: CGFloat = isIPhoneX ? 24.0 : 0.0
public let NavigationBarHeight = StatusBarHeight + 44.0
public let PhoneBottom: CGFloat = isIPhoneX ? 34.0 : 0.0
public let PhoneBottom2: CGFloat = isIPhoneX ? 20.0 : 0.0
public let PhoneTop: CGFloat = isIPhoneX ? 44.0 : 0.0    //兼容ios12使用


public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

///是否是小屏幕，如screen3_5Inch, .screen4Inch, .screen4_7Inch
public func isSmallScreenSize() -> Bool {
    switch Device.size() {
    case .screen3_5Inch, .screen4Inch, .screen4_7Inch :
        return true
        
    default:
        return false
    }
}

public func isXStatusBarHeight(_ defaultHeight: CGFloat,isLandscape:Bool) -> CGFloat {
    if isLandscape {
        return defaultHeight
    }
    return StatusBarHeight == 0 ? defaultHeight : StatusBarHeight
}


public func statusBarHeight(byLandscape: Bool) -> CGFloat {
    if byLandscape {
        return 11
    } else {
        return StatusBarHeight
    }
}
