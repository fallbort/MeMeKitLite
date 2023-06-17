//
//  CellStatusKeeper.swift
//  MeMeKit
//
//  Created by fabo on 2022/8/5.
//

import Foundation
import RxSwift

public class CellStatusKeeper<IdValue:Hashable,StatusValue> {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    public var changedObser = PublishSubject<IdValue?>()
    public var changedBehaviorObser = BehaviorSubject<IdValue?>(value: nil)
    public var changingObser = PublishSubject<IdValue?>()
    
    
    //MARK: <>生命周期开始
    public init() {
        
    }
    //MARK: <>功能性方法
    public func clean() {
        statusChangingLock.lock()
        statusChanging.removeAll()
        status.removeAll()
        statusChangingLock.unlock()
    }
    
    //ret为是否设置成功
    public func resetAll(status:[IdValue:StatusValue],skipObser:Bool = true) {
        statusChangingLock.lock()
        self.status = status
        statusChangingLock.unlock()
        
        if skipObser == false {
            changedObser.onNext(nil)
            changedBehaviorObser.onNext(nil)
        }
    }
    
    public func setStatus(id:IdValue,value:StatusValue) {
        statusChangingLock.lock()
        self.status[id] = value
        statusChangingLock.unlock()
        
        changedObser.onNext(id)
        changedBehaviorObser.onNext(id)
    }
    
    public func getStatus(id:IdValue) -> StatusValue? {
        statusChangingLock.lock()
        let res = self.status[id]
        statusChangingLock.unlock()
        return res
    }
    
    @discardableResult
    public func setChanging(id:IdValue,changing:Bool) -> Bool {
        statusChangingLock.lock()
        var ret = false
        if changing == true {
            let oldChanging = statusChanging[id]
            if oldChanging != true {
                statusChanging[id] = true
                ret = true
            }
        }else{
            statusChanging[id] = false
            ret = true
        }
        statusChangingLock.unlock()
        
        if ret == true {
            changingObser.onNext(id)
        }
        return ret
    }
    
    public func getChanging(id:IdValue) -> Bool {
        statusChangingLock.lock()
        let oldChanging = statusChanging[id]
        statusChangingLock.unlock()
        return oldChanging ?? false
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var status:[IdValue:StatusValue] = [:]
    fileprivate var statusChanging:[IdValue:Bool] = [:]
    fileprivate lazy var statusChangingLock = NSLock()
    
    //MARK: <>内部block
    
}
