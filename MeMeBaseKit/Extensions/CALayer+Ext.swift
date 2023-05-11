//
//  CALayer+Ext.swift
//  MeMe
//
//  Created by FengMengtao on 2017/9/12.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit

extension CALayer {
    /**
     * 倒计时动画
     **/
    public func zoominoutAnimation(scaleFrom: Double, scaleTo1: Double, dura1: Double, scaleTo2: Double, dura2: Double) {
        
        self.removeAnimation(forKey: "zoominoutAnimation")
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = dura1 + dura2
        groupAnimation.beginTime = 0
        groupAnimation.repeatCount = 1
        
        // Configure the animation
        let scaleAnimation1 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue =  NSNumber(value: scaleFrom)
        scaleAnimation1.toValue = NSNumber(value: scaleTo1)
        scaleAnimation1.duration = dura1
        scaleAnimation1.beginTime = 0
        
        let scaleAnimation2 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation2.fromValue =  NSNumber(value: scaleTo1)
        scaleAnimation2.toValue = NSNumber(value: scaleTo2)
        scaleAnimation2.duration = dura2
        scaleAnimation2.beginTime = dura1
        
        groupAnimation.animations = [scaleAnimation1, scaleAnimation2]
        self.add(groupAnimation, forKey: "zoominoutAnimation")
    }
    
    /**
     * PK结果动画
     **/
    public func zoominAnimation(scaleFrom: Double, scaleTo: Double, dura: Double) {
        
        self.removeAnimation(forKey: "zoominAnimation")
        
        // Configure the animation
        let scaleAnimation1 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue =  NSNumber(value: scaleFrom)
        scaleAnimation1.toValue = NSNumber(value: scaleTo)
        scaleAnimation1.duration = dura
        scaleAnimation1.beginTime = 0
        
        self.add(scaleAnimation1, forKey: "zoominAnimation")
    }
    
    // 水滴抖动动画
    public func scaleAnimation(scaleFrom: Double, scaleTo1: Double, dura1: Double, scaleTo2: Double, dura2: Double, scaleTo3: Double, dura3: Double, scaleTo4: Double, dura4: Double, scaleTo5: Double, dura5: Double, scaleTo6: Double, dura6: Double) {
        
        self.removeAnimation(forKey: "DropScaleAnimation")
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = dura1 + dura2 + dura3 + dura4
        groupAnimation.beginTime = 0
        groupAnimation.repeatCount = 1
        
        // Configure the animation
        let scaleAnimation1 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue =  NSNumber(value: scaleFrom)
        scaleAnimation1.toValue = NSNumber(value: scaleTo1)
        scaleAnimation1.duration = dura1
        scaleAnimation1.beginTime = 0
        
        let scaleAnimation2 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation2.fromValue =  NSNumber(value: scaleTo1)
        scaleAnimation2.toValue = NSNumber(value: scaleTo2)
        scaleAnimation2.duration = dura2
        scaleAnimation2.beginTime = dura1
        
        let scaleAnimation3 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation3.fromValue =  NSNumber(value: scaleTo2)
        scaleAnimation3.toValue = NSNumber(value: scaleTo3)
        scaleAnimation3.duration = dura3
        scaleAnimation3.beginTime = dura1 + dura2
        
        let scaleAnimation4 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation4.fromValue =  NSNumber(value: scaleTo3)
        scaleAnimation4.toValue = NSNumber(value: scaleTo4)
        scaleAnimation4.duration = dura4
        scaleAnimation4.beginTime = dura1 + dura2 + dura3
        
        let scaleAnimation5 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation5.fromValue =  NSNumber(value: scaleTo4)
        scaleAnimation5.toValue = NSNumber(value: scaleTo5)
        scaleAnimation5.duration = dura5
        scaleAnimation5.beginTime = dura1 + dura2 + dura3 + dura4
        
        let scaleAnimation6 = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation6.fromValue =  NSNumber(value: scaleTo5)
        scaleAnimation6.toValue = NSNumber(value: scaleTo6)
        scaleAnimation6.duration = dura6
        scaleAnimation6.beginTime = dura1 + dura2 + dura3 + dura4 + dura5
        
        groupAnimation.animations = [scaleAnimation1, scaleAnimation2, scaleAnimation3, scaleAnimation4, scaleAnimation5, scaleAnimation6]
        
        
        self.add(groupAnimation, forKey: "DropScaleAnimation")
    }
    
    public func move(to: CGPoint ,duration: CGFloat? = 0.25) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = self.value(forKey: "position")
        animation.toValue   = NSValue(cgPoint: to)
        if let duration = duration {
            animation.duration  = Double(duration)
        }
        self.position       = to
        self.add(animation, forKey: "position")
    }
    
    public func move(from: CGPoint ,to: CGPoint ,duration: CGFloat? = 0.25) {
        self.position      = from
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = self.value(forKey: "position")
        animation.toValue   = NSValue(cgPoint: to)
        if let duration = duration {
            animation.duration  = Double(duration)
        }
        self.position       = to
        self.add(animation, forKey: "position")
    }
    
    public func resize(to: CGSize) {
        let oldBounds = self.bounds
        var newBounds = oldBounds
        newBounds.size = to
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = NSValue(cgRect: oldBounds)
        animation.toValue   = NSValue(cgRect: newBounds)
        self.bounds = newBounds
        self.add(animation, forKey: "bounds")
    }
    
    public func addJumpAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let currentY = self.affineTransform().ty
        animation.duration = 1.5
        animation.values = [currentY ,currentY - 10, currentY ,currentY - 10 ,currentY ,currentY]
        animation.keyTimes = [0.0 ,0.17 ,0.34 ,0.51 , 0.68 , 1.0]
        animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        animation.repeatCount = Float(Int.max)
        self.add(animation, forKey: "kViewShakerAnimationKey")
    }
}

