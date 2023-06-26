//
//  OCCellStatusKeeper.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/17.
//

import Foundation
import RxSwift

@objc public class OCCellStatusKeeper : NSObject {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    @objc public var changedWithInitBlock:((_ keys:[String])->())? {
        didSet {
            let keys:[String] = (try? self.keeper.changedBehaviorObser.value()) ?? []
            self.changedWithInitBlock?(keys);
        }
    }
    @objc public var changedBlock:((_ keys:[String])->())?
    @objc public var changingBlock:((_ keys:[String])->())?
    
    
    //MARK: <>生命周期开始
    @objc public override init() {
        super.init()
        keeper.changedObser.subscribe(onNext: { [weak self] keys in
            guard let `self` = self else { return }
            self.changedBlock?(keys)
        }).disposed(by: self.mmDisposeBag)
        keeper.changedBehaviorObser.subscribe(onNext: { [weak self] keys in
            guard let `self` = self else { return }
            self.changedWithInitBlock?(keys)
        }).disposed(by: self.mmDisposeBag)
        keeper.changingObser.subscribe(onNext: { [weak self] keys in
            guard let `self` = self else { return }
            self.changingBlock?(keys)
        }).disposed(by: self.mmDisposeBag)
    }
    //MARK: <>功能性方法
    @objc public func clean() {
        keeper.clean()
    }

    @objc public func resetAll(status: [String : AnyObject], skipObser: Bool = false) {
        keeper.resetAll(status: status,skipObser: skipObser)
    }

    @objc public func setStatus(id: String, value: AnyObject) {
        keeper.setStatus(id: id, value: value)
    }
    
    @objc public func setStatus(status: [String : AnyObject]) {
        keeper.setStatus(status: status)
    }
    
    @objc public func getFirstStatus() -> AnyObject? {
        return keeper.getFirstStatus()
    }

    @objc public func getStatus(id: String) -> AnyObject? {
        return keeper.getStatus(id: id)
    }
    
    @objc public func getStatus(ids: [String]) -> [String:AnyObject] {
        return keeper.getStatus(ids: ids)
    }
    
    @objc public func getAllStatus() -> [String:AnyObject] {
        return keeper.getAllStatus()
    }
    
    //所有值都相等
    @objc public func isValuesEqualed () -> NSNumber? {
        if let isEqual = keeper.isValuesEqualed() {
            return NSNumber.init(value: isEqual)
        }
        return nil
    }

    @discardableResult
    @objc public func setStartChanging(id:String) -> Bool {
        return keeper.setStartChanging(id: id,completeBlock: nil)
    }
    
    @discardableResult
    @objc public func setStartChanging(id:String,completeBlock:@escaping ((AnyObject?)->())) -> Bool {
        return keeper.setStartChanging(id: id,completeBlock: completeBlock)
    }
    
    @objc public func setEndChanging(id:String) {
        keeper.setEndChanging(id: id)
    }
    
    @discardableResult
    @objc public func setChanging(changings: [String: Bool]) -> [String: Bool] {
        return keeper.setChanging(changings: changings)
    }
    
    @objc public func setChanging(changings: [String: Bool],completeBlock:@escaping ((AnyObject?)->())) -> [String: Bool] {
        var blocks = [String:((AnyObject?)->())]()
        for key in changings.keys {
            if (changings[key] == true) {
                blocks[key] = completeBlock
                break
            }
        }
        
        return keeper.setChanging(changings: changings,completeBlocks: blocks)
    }

    @objc public func getChanging(id: String) -> Bool {
        return keeper.getChanging(id: id)
    }
    
    @objc public func getChanging(ids: [String]) -> [String:Bool] {
        return keeper.getChanging(ids: ids)
    }
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var keeper = CellStatusKeeper<String,AnyObject>()
    //MARK: <>内部block
    
}
