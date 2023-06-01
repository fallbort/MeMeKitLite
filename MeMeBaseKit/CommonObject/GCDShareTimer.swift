//
//  GCDShareTimer.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/1.
//

import Foundation
import RxSwift

//一个不是很准的计时器，只是保持全app唯一,节省资源消耗
public class GCDShareTimer {
    public static var shared = GCDShareTimer()
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    fileprivate init() {
        
    }
    //MARK: <>功能性方法
    public func flash() {  //观察时间变量后，需要flash才能启动定时器
        let hasObservers = timeObser.hasObservers
        self.lock.lock()
        let hasTimer = gcdTimer != nil
        self.lock.unlock()
        if hasObservers == true,hasTimer == false {
            self.queue.async {
                self.startTimer()
            }
            
        }else if hasTimer == true {
            self.queue.async {
                self.clear()
            }
        }
    }
    
    fileprivate func clear() {
        let hasObservers = timeObser.hasObservers
        
        self.lock.lock()
        let hasTimer = gcdTimer != nil
        if hasObservers == false && hasTimer == true {
            self.gcdTimer?.cancel()
            self.gcdTimer = nil
            self.timepassed = 0.0
        }
        self.lock.unlock()
    }
    
    fileprivate func startTimer() {
        let interval:Double = 0.5
        let tickBlock:(VoidBlock) = { [weak self] in
            guard let `self` = self else {return}
            self.timepassed += interval
            let hasObservers = self.timeObser.hasObservers
            if hasObservers == false {
                self.queue.async { [weak self] in
                    self?.clear()
                }
            }else{
                DispatchQueue.global().async { [weak self] in
                    guard let `self` = self else {return}
                    self.timeObser.onNext(self.timepassed)
                }
            }
        }
        let hasObservers = timeObser.hasObservers
        
        self.lock.lock()
        let hasTimer = gcdTimer != nil
        if hasObservers == true && hasTimer == false {
            self.timepassed = 0
        }
        self.lock.unlock()

        let timer = GCDTimer.init(interval: interval,skipFirst: true,block: tickBlock)
        var added = false
        let hasObservers2 = timeObser.hasObservers
        self.lock.lock()
        let hasTimer2 = gcdTimer != nil
        if hasObservers2 == true && hasTimer2 == false {
            self.gcdTimer = timer
            added = true
        }
        self.lock.unlock()
        if added == false {
            timer.cancel()
        }
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    public var timeObser = BehaviorSubject<Double>(value: 0.0) //返回时间，代表走了多少时间,单位s,首次不一定是0
    
    
    fileprivate var _queue:DispatchQueue?
    fileprivate var queue:DispatchQueue {
        if let queue = _queue {
            return queue
        }else{
            let newQueue = DispatchQueue(label: "net.zj1.GCDShareTimer", qos: .default)
            _queue = newQueue
            return newQueue
        }
    }
    
    fileprivate var gcdTimer:GCDTimer?
    fileprivate var timepassed:Double = 0
    fileprivate var lock:NSLock = NSLock()
    
    //MARK: <>内部block
    
}
