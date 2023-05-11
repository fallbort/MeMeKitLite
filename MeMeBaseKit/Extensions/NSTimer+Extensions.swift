//
//  NSTimer+Extensions.swift
//  LiveCap
//
//  Created by Solomon English on 2/12/16.
//  Copyright © 2016 FunPlus. All rights reserved.
//

import Foundation

private class NSTimerActor {
	let block: () -> Void
	
	init(_ block: @escaping () -> Void) {
		self.block = block
	}
	
	@objc func fire() {
		block()
	}
}

extension Timer {
	// NOTE: `new` class functions are a workaround for a crashing bug when using convenience initializers (18720947)
	
	/// Create a timer that will call `block` once after the specified time.
	///
	/// **Note:** the timer won't fire until it's scheduled on the run loop.
	/// Use `NSTimer.after` to create and schedule a timer in one step.
	public class func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
		let actor = NSTimerActor(block)
		return self.init(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: false)
	}
	
	/// Create a timer that will call `block` repeatedly in specified time intervals.
	///
	/// **Note:** the timer won't fire until it's scheduled on the run loop.
	/// Use `NSTimer.every` to create and schedule a timer in one step.
	public class func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
		let actor = NSTimerActor(block)
		return self.init(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: true)
	}
	
	/// Create and schedule a timer that will call `block` once after the specified time.
	public class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
		let timer = Timer.new(after: interval, block)
		timer.start()
		return timer
	}
	
	/// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
	public class func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
		let timer = Timer.new(every: interval, block)
		timer.start()
		return timer
	}
	
	/// Schedule this timer on the run loop
	///
	/// By default, the timer is scheduled on the current run loop for the default mode.
	/// Specify `runLoop` or `modes` to override these defaults.
    public func start(runLoop: RunLoop = RunLoop.current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [RunLoop.Mode.default] : modes
		
		for mode in modes {
			runLoop.add(self, forMode: mode)
		}
	}
}

extension Timer {
    public class func schedule(delay: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
    
    public class func schedule(repeatInterval interval: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
    
    public class func schedule(delay: TimeInterval, repeatInterval interval: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
}
