//
//  CellStatusKeeper.swift
//  MeMeKit
//
//  Created by fabo on 2022/8/5.
//

import Foundation
import RxSwift

public class CellStatusKeeper<IdValue:Hashable&Comparable,StatusValue> {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    public var changedObser = PublishSubject<[IdValue]>()
    public var changedBehaviorObser = BehaviorSubject<[IdValue]>(value: [])
    public var changingObser = PublishSubject<[IdValue]>()
    
    
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
    public func resetAll(status:[IdValue:StatusValue],skipObser:Bool = false) {
        statusChangingLock.lock()
        let newDict = self.status.merged(with: status)
        let newAllKeys:[IdValue] = (Array<IdValue>)(newDict.keys)
        self.status = status
        statusChangingLock.unlock()
        
        if skipObser == false {
            if newAllKeys.count > 0 {
                changedObser.onNext(newAllKeys)
                changedBehaviorObser.onNext(newAllKeys)
            }
        }
    }
    
    public func setStatus(id:IdValue,value:StatusValue) {
        self.setStatus(status: [id:value])
    }
    
    public func setStatus(status:[IdValue:StatusValue]) {
        statusChangingLock.lock()
        let newAllKeys:[IdValue] = (Array<IdValue>)(status.keys)
        self.status.merge(with: status)
        statusChangingLock.unlock()
        
        if newAllKeys.count > 0 {
            changedObser.onNext(newAllKeys)
            changedBehaviorObser.onNext(newAllKeys)
        }
    }
    
    
    
    public func getFirstStatus() -> StatusValue? {
        return self.getAllStatus().first?.value
    }
    
    public func getStatus(id:IdValue) -> StatusValue? {
        return self.getStatus(ids:[id])[id]
    }
    
    public func getStatus(ids:[IdValue]) -> [IdValue:StatusValue] {
        var resDict = [IdValue:StatusValue]()
        statusChangingLock.lock()
        for id in ids {
            let res = self.status[id]
            resDict[id] = res
        }
        statusChangingLock.unlock()
        return resDict
    }
    
    public func getAllStatus() -> [IdValue:StatusValue] {
        var resDict = [IdValue:StatusValue]()
        statusChangingLock.lock()
        resDict = self.status
        statusChangingLock.unlock()
        return resDict
    }
    
    @discardableResult
    public func setChanging(id:IdValue,changing:Bool) -> Bool {
        return self.setChanging(changings: [id:changing])[id] ?? false
    }
    
    //返回是否成功开始改变的dict
    @discardableResult
    public func setChanging(changings:[IdValue:Bool]) -> [IdValue:Bool] {
        var retDict = [IdValue:Bool]()
        statusChangingLock.lock()
        for (id,changing) in changings {
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
            retDict[id] = ret
        }
        statusChangingLock.unlock()
        
        let changingIds:[IdValue] = retDict.compactMap { id,success in
            if success == true {
                return id
            }else{
                return nil
            }
        }
        if changingIds.count > 0 {
            changingObser.onNext(changingIds)
        }
        return retDict
    }
    
    public func getChanging(id:IdValue) -> Bool {
        return self.getChanging(ids: [id])[id] ?? false
    }
    
    public func getChanging(ids:[IdValue]) -> [IdValue:Bool] {
        var changingDict = [IdValue:Bool]()
        statusChangingLock.lock()
        for id in ids {
            changingDict[id] = statusChanging[id] ?? false
        }
        
        statusChangingLock.unlock()
        return changingDict
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var status:[IdValue:StatusValue] = [:]
    fileprivate var statusChanging:[IdValue:Bool] = [:]
    fileprivate lazy var statusChangingLock = NSLock()
    
    //MARK: <>内部block
}


public class CellEqualStatusKeeper<IDValue2:Hashable&Comparable,StatusValue2:Equatable> :CellStatusKeeper<IDValue2, StatusValue2>  {

    //返回是否都相等
    public func isValuesEqualed () -> Bool {
        var isEqualed = true;
        statusChangingLock.lock()
        var oldEqualedValue:StatusValue2?
        for (_,value) in self.status {
            if oldEqualedValue != nil {
                if value == oldEqualedValue {
                    
                }else{
                    isEqualed = false;
                    break;
                }
            }
            oldEqualedValue = value;
        }
        statusChangingLock.unlock()
        return isEqualed;
    }
    
}
