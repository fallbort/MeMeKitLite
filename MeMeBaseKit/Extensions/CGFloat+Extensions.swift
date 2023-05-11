//
//  CGFloat+Extensions.swift
//  MeMe
//
//  Created by funplus on 8/16/19.
//  Copyright © 2019 sip. All rights reserved.
//

import UIKit

extension CGFloat {
    public func format(reserve: Int) -> String {
        let p = CGFloat(pow(10.0, Double(reserve)))
        let num = CGFloat(Int(self * p)) / p
        for i in 0 ..< reserve {
            let re: Float = i == 0 ? 1 : Float(i * 10)
            let yu = fmodf(Float(num) * re, 1)
            if yu == 0 {
                return String(format: "%.\(i)f", num)
            }
        }
        return String(format: "%.\(reserve)f", num)
    }
    
    public func sampleformat(reserve: Int) -> String {
        let p = CGFloat(pow(10.0, Double(reserve)))
        let num = CGFloat(Int(self * p)) / p
        return String(format: "%.\(reserve)f", num)
    }
    
    public static func ceilNum(_ divisor1: CGFloat, _  divisor2: CGFloat) -> Int {
        let result = divisor1 / divisor2
        return Int(ceil(result))
    }
    
    public func pOrN(_ negative: Bool) -> CGFloat {
        return (negative ? -1 : 1) * self
    }
}
