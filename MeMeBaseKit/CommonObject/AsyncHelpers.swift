//
//  AsyncHelpers.swift
//
//  Created by Solomon English on 11/10/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import Foundation

public func main_async(_ task: @escaping () -> Void) {
	if Thread.current.isMainThread {
		task()
	} else {
		DispatchQueue.main.async(execute: task)
	}
}

public func main_async(delay: TimeInterval, task: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
}

public func main_sync(_ task: () -> Void) {
	if Thread.current.isMainThread {
		task()
	} else {
		DispatchQueue.main.sync(execute: task)
	}
}

public func back_async(_ task: @escaping () -> Void) {
	DispatchQueue.global().async(execute: task)
}

public func back_async(delay: TimeInterval, task: @escaping () -> Void) {
	DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: task)
}

public func back_sync(_ task: VoidBlock) {
	DispatchQueue.global().sync(execute: task)
}

// helpful wrapper for making async calls
public func async(queue: DispatchQueue = DispatchQueue.global(), work: @escaping () -> Void) {
    queue.async(execute: work)
}

// helpful wrapper for joining the main thread
public func async_main(_ work: @escaping () -> Void) {
    if !Thread.current.isMainThread {
        DispatchQueue.main.async(execute: work)
    } else {
        work()
    }
}

// will lock a mutex on the given object
public func synchronized(_ on: AnyObject, cb: () -> Void) {
    objc_sync_enter(on)
    cb()
    objc_sync_exit(on)
}

@discardableResult public func delay(_ seconds: Double, queue: DispatchQueue = .main, closure: @escaping () -> Void) -> DispatchWorkItem {
	let work = DispatchWorkItem(block: closure)
	queue.asyncAfter(wallDeadline: .now() + seconds, execute: work)
	return work
}

// calls the closure after delay seconds on the main thread
public func timeout(_ delay: Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping VoidBlock) -> CancelableTimeoutBlock {
	return CancelableTimeoutBlock(delay: delay, queue: queue, closure: closure, cancelled: nil)
}

public func timeout(_ delay: Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping VoidBlock, cancelled: VoidBlock?) -> CancelableTimeoutBlock {
	return CancelableTimeoutBlock(delay: delay, queue: queue, closure: closure, cancelled: cancelled)
}

// allows for canceling a timeout after it's been kicked off
open class CancelableTimeoutBlock {
	fileprivate var shouldCancel = false

	public var cancelled = false
	public var completed = false
	public var isEnd = false
    public var willEnd = false

    public init(delay seconds: Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping VoidBlock, cancelled: VoidBlock? = nil) {
		queue.asyncAfter(
			deadline: DispatchTime.now() + seconds, execute: {
                self.willEnd = true
				if !self.shouldCancel {
					closure()
					self.completed = true
				} else {
					cancelled?()
					self.cancelled = true
				}
				self.isEnd = true
		})
	}

	open func cancel() {
		shouldCancel = true
	}
}
