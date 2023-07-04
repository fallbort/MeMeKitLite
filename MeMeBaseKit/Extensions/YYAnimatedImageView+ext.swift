//
//  YYAnimatedImageView.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/6/12.
//  Copyright © 2017年 sip. All rights reserved.
//

import YYWebImage
import YYImage

public typealias animatedCompletedBlock = (YYAnimatedImageView) -> Void
let FrameKeyPath = "currentAnimatedImageIndex"
let PlayingKeyPath = "currentIsPlayingAnimation"
var PlayingContext = 0

@objc extension YYAnimatedImageView {
    
    private struct AssociatedKeys {
        static var AssociatedName = "AssociatedName"
        static var IsPlayingAssociatedName = "IsPlayingAssociatedName"
    }
    
    public var animatedCompleted: animatedCompletedBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.AssociatedName) as? animatedCompletedBlock
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AssociatedName, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
//    fileprivate var isPlaying: Bool? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.IsPlayingAssociatedName) as? Bool
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.IsPlayingAssociatedName, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
    
    public func listenAnimatedCompleted(_ block: @escaping animatedCompletedBlock) {
        self.animatedCompleted = block
        addObserver(self, forKeyPath: PlayingKeyPath, options: [.new, .old], context: &PlayingContext)
    }
    
    public func unListenAnimatedCompleted() {
        if animatedCompleted != nil {
            self.animatedCompleted = nil
            removeObserver(self, forKeyPath: PlayingKeyPath)
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &PlayingContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if let animatedCompleted = self.animatedCompleted
        {
//            print("currentAnimatedImageIndex:  \(self.currentAnimatedImageIndex)")
            if let totalFrameCount = self.value(forKey: "_totalFrameCount") as? Int, self.currentAnimatedImageIndex == totalFrameCount - 1 {
                if let old = change?[NSKeyValueChangeKey.oldKey] as? Int, old == 1 {
                    animatedCompleted(self)
                }
            }
//            if self.currentIsPlayingAnimation {
//                self.isPlaying = true
//            } else if let isPlaying = isPlaying, isPlaying {
//                // 此时才是停止动画
//                self.isPlaying = false
//                animatedCompleted(self)
//            }
        }
    }
    
}
