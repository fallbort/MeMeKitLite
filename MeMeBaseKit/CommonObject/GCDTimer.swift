//
//  GCDTimer.swift
//  MeMe
//
//  Created by LuanMa on 16/10/9.
//  Copyright © 2016年 sip. All rights reserved.
//

public class GCDTimer {
    fileprivate var _timer: DispatchSourceTimer?

	fileprivate static var timerCount = 0
	fileprivate class func nextIndex() -> Int {
		timerCount += 1
		return timerCount
	}

    public init(name: String? = nil, delay: TimeInterval = 0, interval: TimeInterval,skipFirst:Bool = false, queue: DispatchQueue = DispatchQueue.main, block: @escaping VoidBlock) {
        var isFirst = true
		let timerQueue = DispatchQueue(label: name ?? "meme.timer-\(GCDTimer.nextIndex())")
		let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timer.schedule(deadline: .now() + delay, repeating: interval)
		timer.setEventHandler() {
			queue.async {
                if skipFirst == false || isFirst == false {
                    block()
                }
                isFirst = false
			}
		}
		timer.resume()

		_timer = timer
	}

    public func cancel() {
        guard let timer = _timer else {
            return
        }

        timer.cancel()
        _timer = nil
    }
}

public func create_gcd_dispatch_timer(delay: TimeInterval = 0, interval: TimeInterval,
                               queue: DispatchQueue =  DispatchQueue.main,
                               block: @escaping VoidBlock, cancelBlock: VoidBlock? = nil) -> DispatchSourceTimer {

	let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: DispatchTime.now() + delay, repeating: interval)
	timer.setEventHandler() {
		block()
	}
	if let cancelBlock = cancelBlock {
		timer.setCancelHandler(handler: cancelBlock)
	}
	timer.resume()
	
	return timer
}

