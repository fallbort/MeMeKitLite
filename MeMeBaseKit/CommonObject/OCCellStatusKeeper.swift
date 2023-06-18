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

    @objc public func getStatus(id: String) -> AnyObject? {
        return keeper.getStatus(id: id)
    }
    
    @objc public func getStatus(ids: [String]) -> [String:AnyObject] {
        return keeper.getStatus(ids: ids)
    }

    @discardableResult
    @objc public func setChanging(id: String, changing: Bool) -> Bool {
        return keeper.setChanging(id: id, changing: changing)
    }
    
    @discardableResult
    @objc public func setChanging(changings: [String: Bool]) -> [String: Bool] {
        return keeper.setChanging(changings: changings)
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
