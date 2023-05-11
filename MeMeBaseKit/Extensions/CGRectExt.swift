//
//  CGRectExt.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/2/19.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit

extension CGRect {
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }
    
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
    }
    
    //已有了,会冲突
    public var widthEx: CGFloat {
        get {
            return self.size.width
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: newValue, height: self.height)
        }
    }
    //已有了,会冲突
    public var heightEx: CGFloat {
        get {
            return self.size.height
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: self.width, height: newValue)
        }
    }
    
    
    public var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            y = newValue
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.origin.y + self.size.height
        }
        set {
            self = CGRect(x: x, y: newValue - height, width: width, height: height)
        }
    }
    
    public var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.x = newValue
        }
    }
    
    public var right: CGFloat {
        get {
            return x + width
        }
        set {
            self = CGRect(x: newValue - width, y: y, width: width, height: height)
        }
    }
    
    
    public var midXEx: CGFloat {
        get {
            return self.x + self.width / 2
        }
        set {
            self = CGRect(x: newValue - width / 2, y: y, width: width, height: height)
        }
    }
    
    public var midYEx: CGFloat {
        get {
            return self.y + self.height / 2
        }
        set {
            self = CGRect(x: x, y: newValue - height / 2, width: width, height: height)
        }
    }
    
    
    public var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self = CGRect(x: newValue.x - width / 2, y: newValue.y - height / 2, width: width, height: height)
        }
    }
    
    public func frame(append: CGFloat) -> CGRect {
        CGRect(x: x - append, y: y - append, width: width + append * 2, height: height + append * 2)
    }
}

extension CGSize{
    public func rectCentered(at:CGPoint) -> CGRect{
        let dx = self.width/2
        let dy = self.height/2
        let origin = CGPoint(x: at.x - dx, y: at.y - dy )
        return CGRect(origin: origin, size: self)
    }
    
    public func scaleBy(_ factor:CGFloat) -> CGSize{
        return CGSize(width: self.width*factor, height: self.height*factor)
    }
}

extension Double {
    public var degrees: Double {
        return self * Double.pi / 180.0
    }
    
    public var radians: Double {
        return self * 180.0 / Double.pi
    }
}
