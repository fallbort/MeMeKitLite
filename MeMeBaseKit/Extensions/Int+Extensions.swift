//
//  Int+Extensions.swift
//  LiveCap
//
//  Created by Solomon English on 3/3/16.
//  Copyright © 2016 FunPlus. All rights reserved.
//

import Foundation

extension Int {
    
    public var boolean: Bool? {
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return nil
        }
    }
    
	fileprivate static var _numberFormatterOneMax: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.locale = Locale.current
		formatter.maximumFractionDigits = 1
		
		return formatter
	}()

	fileprivate static var _numberFormatterZeroMax: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.locale = Locale.current
		formatter.maximumFractionDigits = 0
		
		return formatter
	}()
	
	public func toShortString() -> String {
		let isNegative = self < 0
		var number = isNegative ? self * -1 : self
		var dnumber = Double(number)
		
		guard number >= 1000 else {
			return String(number)
		}
		
		var index = 0
		
		// Updated to use correct SI Symbol ( http://en.wikipedia.org/wiki/SI_prefix )
		let suffix = ["", "k", "M", "G", "T", "P", "E"]
		
		while (number >= 1000) {
			number = number / 1000
			dnumber = dnumber / 1000
			index += 1
		}
		
		let formatter = (dnumber < 100.0) && ((dnumber.truncatingRemainder(dividingBy: 1)) * 10) > 1 ? Int._numberFormatterOneMax : Int._numberFormatterZeroMax
		let str = "\(isNegative ? "-" : "")\(formatter.string(from: NSNumber(value: dnumber)) ?? "0")\(suffix[index])"
		
		return str
	}
    
    public func toSIString(_ separation: String = "-") -> String {
        let isNegative = self < 0
        var number = isNegative ? self * -1 : self
        var dnumber = Double(number)
        
        var index = 0
        
        // Updated to use correct SI Symbol ( http://en.wikipedia.org/wiki/SI_prefix )
        let suffix = ["", "K", "M", "G", "T", "P", "E"]
        
        while (number >= 1000) {
            number = number / 1000
            dnumber = dnumber / 1000
            index += 1
        }
        
        let formatter = (dnumber < 100.0) && ((dnumber.truncatingRemainder(dividingBy: 1.0)) * 10.0) > 1.0 ? Int._numberFormatterOneMax : Int._numberFormatterZeroMax
        let str = "\(isNegative ? separation : "")\(formatter.string(from: NSNumber(value: dnumber)) ?? "0")\(suffix[index])"
        
        return str
    }
    
    public func toSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let result = formatter.string(from: NSNumber(value: self))
        return result ?? ""
    }
    
    public func toInt64() -> Int64 {
        return Int64(self)
    }
    
    public func ceilNum(_ divisor: CGFloat) -> Int {
        let result = CGFloat(self) / divisor
        return Int(ceil(result))
    }
    
    public func ceilNum(_ divisor: Int) -> Int {
        let result = CGFloat(self) / CGFloat(divisor)
        return Int(ceil(result))
    }
}
