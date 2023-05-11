//
//  FPSMonitor.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/2/15.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit
import Foundation

public class FPSMonitor {
    
    public static let shared = FPSMonitor()
    
    open var fps: Float = 0
    public var lastTime: CFTimeInterval = 0
    public var updateInterval: CFTimeInterval = 0.25
    public var historyCount: UInt = 0
    public var historySum: CFTimeInterval = 0
    public var enable: Bool {
        get { return !displayLink.isPaused }
        set {
            let center = NotificationCenter.default
            if newValue {
                center.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
                center.addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
                displayLink.isPaused = false
            } else {
                center.removeObserver(self)
                displayLink.isPaused = true
            }
        }
    }
    
    fileprivate lazy var displayLink: CADisplayLink = {
        let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(displayLinkProc))
        displayLink.isPaused = true
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        return displayLink
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        displayLink.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    @objc fileprivate func displayLinkProc() {
        historyCount += UInt(displayLink.frameInterval)
        
        let interval: CFTimeInterval = displayLink.timestamp - lastTime
        if ( interval >= updateInterval ) {
            lastTime = displayLink.timestamp
            fps = Float(historyCount) / Float(interval)
//            log.verbose("FPS = \(self.fps)")
            historyCount = 0;
        }
    }
    
    // 切换前台
    @objc fileprivate func applicationDidBecomeActiveNotification() {
        guard enable else {
            return
        }
        
        displayLink.isPaused = false
    }
    
    // 切换后台
    @objc fileprivate func applicationWillResignActiveNotification() {
        guard enable else {
            return
        }
        
        displayLink.isPaused = true
    }
    
}
