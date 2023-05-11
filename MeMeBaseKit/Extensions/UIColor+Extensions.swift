//
//  UIColor+Extensions.swift
//  LiveCap
//
//  Created by LuanMa on 16/3/3.
//  Copyright © 2016年 FunPlus. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
	public var rgba: String {
		get {
			var red: CGFloat = 0
			var green: CGFloat = 0
			var blue: CGFloat = 0
			var alpha: CGFloat = 0

			self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

			return "#" + String(format: "%02X", Int(255 * red)) + String(format: "%02X", Int(255 * green)) + String(format: "%02X", Int(255 * blue)) + String(format: "%02X", Int(255 * alpha))
		}
	}

	public convenience init(rgba: String, alpha: CGFloat) {
		let percent = 255 * alpha / 100
		let st = NSString(format: "%02X", Int(floor(percent)))

		self.init(rgba: "\(rgba)\(st)")
	}

    public class func getRGBs(str: String) -> [CGFloat] {
        var hex1: CGFloat = 0.0
        var hex2: CGFloat = 0.0
        var hex3: CGFloat = 0.0
        var hex4: CGFloat?

        if str.hasPrefix("#") {
            let index = str.index(str.startIndex, offsetBy: 1)
            let hex = str.substring(from: index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.count) {
                case 3:
                    hex1 = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    hex2 = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    hex3 = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    hex1 = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    hex2 = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    hex3 = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    hex4 = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    hex1 = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    hex2 = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    hex3 = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    hex1 = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    hex2 = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    hex3 = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    hex4 = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    ""
//                    log.warning("Invalid RGB string[\(str)], number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
//                log.warning("Scan hex error")
            }
        } else {
//            log.warning("Invalid RGB string[\(str)], missing '#' as prefix")
        }
        var rgbs = [hex1, hex2, hex3]
        if let hex4 = hex4 {
            rgbs.append(hex4)
        }
        return rgbs
    }
        
        
	public convenience init(rgba: String) {
        var rgbs = UIColor.getRGBs(str: rgba)
        while rgbs.count < 4 {
            rgbs.append(1)
        }
		self.init(red: rgbs[0], green: rgbs[1], blue: rgbs[2], alpha: rgbs[3])
	}
    
    public convenience init(argb: String) {
        var rgbs = UIColor.getRGBs(str: argb)
        while rgbs.count < 4 {
            rgbs.insert(1, at: 0)
        }
        self.init(red: rgbs[1], green: rgbs[2], blue: rgbs[3], alpha: rgbs[0])
    }
}

extension UIColor {
	public convenience init(hex: Int) {
		let r: CGFloat = CGFloat(Double((hex & 0xFF0000) >> 16) / 255.0)
		let g: CGFloat = CGFloat(Double((hex & 0xFF00) >> 8) / 255.0)
		let b: CGFloat = CGFloat(Double(hex & 0xFF) / 255.0)
		self.init(red: r, green: g, blue: b, alpha: 1)
	}

	public convenience init(ahex: Int64) {
		let a: CGFloat = CGFloat(Double((ahex & 0xFF000000) >> 24) / 255.0)
		let r: CGFloat = CGFloat(Double((ahex & 0xFF0000) >> 16) / 255.0)
		let g: CGFloat = CGFloat(Double((ahex & 0xFF00) >> 8) / 255.0)
		let b: CGFloat = CGFloat(Double(ahex & 0xFF) / 255.0)
		self.init(red: r, green: g, blue: b, alpha: a)
	}
    
    public convenience init(hex: Int, alpha: CGFloat) {
        let r: CGFloat = CGFloat(Double((hex & 0xFF0000) >> 16) / 255.0)
        let g: CGFloat = CGFloat(Double((hex & 0xFF00) >> 8) / 255.0)
        let b: CGFloat = CGFloat(Double(hex & 0xFF) / 255.0)
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    public convenience init(hexStr: String, alpha: CGFloat) {
        let scanner = Scanner(string: hexStr)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: CGFloat(r) / 0xff,
                  green: CGFloat(g) / 0xff,
                  blue: CGFloat(b) / 0xff,
                  alpha: alpha)
    }
}
