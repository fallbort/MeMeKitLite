//
//  TimeSyncHelper.swift
//  MeMeKit
//
//  Created by fabo on 2023/2/15.
//

import Foundation
import MeMeKit
import RxSwift

public class TimeSyncHelper {
    public static var shared:TimeSyncHelper = TimeSyncHelper()
    //MARK: <>外部变量
    public var ignoreZero = true  //跳过时间0的数值
    
    //MARK: <>外部block
    public var serverUTCDeviationTimeObser = BehaviorSubject<TimeInterval?>(value: nil)
    
    public var serverUTCDeviationTime:TimeInterval {
        return (try? serverUTCDeviationTimeObser.value()) ?? 0
    }
    
    
    //MARK: <>生命周期开始
    deinit {
        localTimer?.cancel()
        localTimer = nil
    }
    fileprivate init() {
        
    }
    //MARK: <>功能性方法
    public func addServerUTCDeviationTime(_ time:TimeInterval) {
        internelServerUTCDeviationTime = time
    }
    
    fileprivate func adjustDeviationTime(time:TimeInterval) {
        lastServerUTCDeviationTimes.append(time)
        if lastServerUTCDeviationTimes.count > 5 {
            lastServerUTCDeviationTimes.removeFirst()
        }
        var minD:TimeInterval?
        var maxD:TimeInterval?
        for time in lastServerUTCDeviationTimes {
            minD = minD != nil ? min(minD!,time) : time
            maxD = maxD != nil ? min(maxD!,time) : time
        }
        
        var newTime:TimeInterval?
        if lastServerUTCDeviationTimes.count > 2 {
            var timeTotal:TimeInterval = 0
            var timeCount:Int = 0
            for time in lastServerUTCDeviationTimes {
                if let minD1 = minD,time == minD1 {
                    minD = nil
                    continue
                }
                if let maxD1 = maxD,time == maxD1 {
                    maxD = nil
                    continue
                }
                timeTotal = timeTotal + time
                timeCount += 1
            }
            newTime = timeTotal / Double(timeCount)
        }else if lastServerUTCDeviationTimes.count == 1 {
            newTime = lastServerUTCDeviationTimes.first
        }
        if let newTime = newTime, newTime != _serverUTCDeviationTime, (abs((_serverUTCDeviationTime ?? 0) - (newTime)) > 2) || (_serverUTCDeviationTime ?? 0) == 0 {
            realAdjustDeviationTime(newTime)
        }else if let newTime = newTime, (abs((_serverUTCDeviationTime ?? 0) - (newTime)) <= 2) {
            startLocalTimeSync(newTime)
        }
    }
    
    fileprivate func realAdjustDeviationTime(_ newTime:TimeInterval) {
        _serverUTCDeviationTime = newTime
        startLocalTimeSync(newTime)
        serverUTCDeviationTimeObser.onNext(newTime)
    }
    
    fileprivate func startLocalTimeSync(_ newTime:TimeInterval) {
        serverSyncedServerTime = newTime
        serverSyncedLocalTime = Date().timeIntervalSince1970
        serverSyncedLocalPassedTime = 0
        if localTimer == nil {
            localTimer?.cancel()
            localTimer = GCDTimer.init(interval: 2.0,skipFirst:true) { [weak self] in
                guard let `self` = self else {return}
                self.serverSyncedLocalPassedTime += 2.0
                let calculateLocalTime:Double = self.serverSyncedLocalTime + self.serverSyncedLocalPassedTime
                let realLocalTime:Double = Date().timeIntervalSince1970
                var diffTime:TimeInterval = 1*60.0
                #if DEBUG
                diffTime = 10*60.0
                #endif
                if abs(calculateLocalTime - realLocalTime) > diffTime {
                    self.lastServerUTCDeviationTimes.removeAll()
                }
            }
        }
        
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var lastServerUTCDeviationTimes: [TimeInterval] = []
    fileprivate var _serverUTCDeviationTime: TimeInterval?
    fileprivate var internelServerUTCDeviationTime: TimeInterval {
        get  {
            return _serverUTCDeviationTime ?? 0
        }
        set {
            if newValue != 0 || ignoreZero == false {
                adjustDeviationTime(time:newValue)
                
            }
        }
    }
    
    fileprivate var serverSyncedServerTime:Double = 0 //服务器同步时间时与服务器差值
    fileprivate var serverSyncedLocalTime:Double = 0  //服务器同步时间时对应的本地时间
    fileprivate var serverSyncedLocalPassedTime:Double = 0 //服务器同步时间后本地走过的时间
    fileprivate var localTimer:GCDTimer? //本地走时间计时器
    //MARK: <>内部block
    
}
