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
    @objc public var changedWithInitBlock:((_ key:String?)->())? {
        didSet {
            let key = (try? self.keeper.changedBehaviorObser.value())
            self.changedWithInitBlock?(key);
        }
    }
    @objc public var changedBlock:((_ key:String?)->())?
    @objc public var changingBlock:((_ key:String?)->())?
    
    
    //MARK: <>生命周期开始
    @objc public override init() {
        super.init()
        keeper.changedObser.subscribe(onNext: { [weak self] key in
            guard let `self` = self else { return }
            self.changedBlock?(key)
        }).disposed(by: self.mmDisposeBag)
        keeper.changedBehaviorObser.subscribe(onNext: { [weak self] key in
            guard let `self` = self else { return }
            self.changedWithInitBlock?(key)
        }).disposed(by: self.mmDisposeBag)
        keeper.changingObser.subscribe(onNext: { [weak self] key in
            guard let `self` = self else { return }
            self.changingBlock?(key)
        }).disposed(by: self.mmDisposeBag)
    }
    //MARK: <>功能性方法
    @objc public func clean() {
        keeper.clean()
    }

    @objc public func resetAll(status: [String : AnyObject], skipObser: Bool = true) {
        keeper.resetAll(status: status,skipObser: skipObser)
    }

    @objc public func setStatus(id: String, value: AnyObject) {
        keeper.setStatus(id: id, value: value)
    }

    @objc public func getStatus(id: String) -> AnyObject? {
        keeper.getStatus(id: id)
    }

    @discardableResult
    @objc public func setChanging(id: String, changing: Bool) -> Bool {
        return keeper.setChanging(id: id, changing: changing)
    }

    @objc public func getChanging(id: String) -> Bool {
        return keeper.getChanging(id: id)
    }
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var keeper = CellStatusKeeper<String,AnyObject>()
    //MARK: <>内部block
    
}
