//
//  MeMeStatusButton.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/29.
//

import Foundation

@objc open class MeMeStatusButton : UIButton {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    public var selectedChangedBlock:((_ isSelected:Bool)->())?
    
    //MARK: <>生命周期开始
    public override var isSelectedFake: Bool {
        didSet {
            self.selectedChangedBlock?(self.isSelectedFake)
        }
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}

private var useFakeSelectModeKey = "key"

extension UIButton {
    @objc public var useFakeSelectMode: Bool {
        get {
            let timer = objc_getAssociatedObject(self, &useFakeSelectModeKey) as? Bool
            return timer ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &useFakeSelectModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
