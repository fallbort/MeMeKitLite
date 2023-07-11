//
//  MeMeActionSheetSystem.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/10.
//

import Foundation

import Foundation
import Cartography
import MeMeKit

private var UIActionSheetOwner = "owner"

extension UIActionSheet {
    var sheetMeMeOwner: MeMeActionSheetSystem? {
        get {
            let timer = objc_getAssociatedObject(self, &UIActionSheetOwner) as? MeMeActionSheetSystem
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &UIActionSheetOwner, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

@objc public class MeMeActionSheetSystem : NSObject {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    @objc public init(title:String?,cancelButtonTitle:String?) {
        super.init()
        let actionSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil)
        self.sheet = actionSheet
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: <>功能性方法
    @objc public func addButton(withTitle:String,block:VoidBlock?) {
        self.btns.append((withTitle,block))
        self.sheet?.addButton(withTitle: withTitle)
    }
    
    @objc public func show(in inView:UIView) {
        self.sheet?.show(in: inView)
        self.weakSheet = self.sheet
        self.sheet = nil
        self.weakSheet?.sheetMeMeOwner = self
        
    }
    //MARK: <>内部View
    //MARK: <>内部UI变量
    fileprivate var sheet:UIActionSheet?
    fileprivate var weakSheet:UIActionSheet?
    //MARK: <>内部数据变量
    fileprivate var btns:[(title:String,block:VoidBlock?)] = []
    //MARK: <>内部block
    
}

extension MeMeActionSheetSystem : UIActionSheetDelegate {
    public func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let index = buttonIndex - 1
        if index >= 0, index < self.btns.count {
            let btn = self.btns[index]
            btn.block?()
        }
    }
}
