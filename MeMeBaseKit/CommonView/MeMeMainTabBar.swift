//
//  MeMeMainTabBar.swift
//  LiveStream
//
//  Created by LuanMa on 16/6/12.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation
import Cartography
import MeMeKit

@objc public class MeMeMainTabBar : TranslateHitView {
    
    //MARK: <>外部变量
    @objc public var items:[MeMeBlockButton] = [] {
        didSet {
            for item in oldValue {
                item.removeFromSuperview()
            }
            let oldSelected = self.selectedIndex
            self._curIndex = -1
            self.addActions()
            self.layoutItems()
            self.selectedIndex = oldSelected
        }
    }
    
    @objc public var indexChangedBlock:((_ index:NSInteger)->())?
    
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        self.backgroundColor = .white
        let line = UIView()
        line.backgroundColor = UIColor.hexString(toColor: "#EDEDED")
        self.addSubview(line)
        self.addSubview(backView)
        constrain(backView) {
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.width == 0 ~ 100
        }
        constrain(line) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.height == 1
        }
    }
    
    //MARK: <>功能性方法
    fileprivate func layoutItems() {
        if self.items.count > 0 {
            let width:CGFloat = floor(UIScreen.main.bounds.width / CGFloat(self.items.count))
            let margin:CGFloat = (UIScreen.main.bounds.width - width * CGFloat(self.items.count)) / 2.0
            var preview:UIView?
            for item in items {
                item.removeFromSuperview()
                self.backView.addSubview(item)
                if let preview = preview {
                    constrain(item,preview) {
                        $0.left == $1.right
                        $0.top == $0.superview!.top
                        $0.bottom == $0.superview!.bottom
                        $0.width == $1.width
                    }
                }else{
                    constrain(item) {
                        $0.left == $0.superview!.left
                        $0.top == $0.superview!.top
                        $0.bottom == $0.superview!.bottom
                        $0.width == width
                    }
                }
                preview = item
            }
            if let preview = preview {
                constrain(preview) {
                    $0.right == $0.superview!.right
                }
            }
        }
        
    }
    
    fileprivate func addActions() {
        for (index,item) in self.items.enumerated() {
            item.handleTapGesture { [weak self,weak item] in
                guard let `self` = self else {return}
                guard let item = item else {return}
                self.selectedIndex = index
                self.indexChangedBlock?(self.selectedIndex)
            }
        }
    }
    
    fileprivate func refresSelectItem() {
        for (index,item) in self.items.enumerated() {
            if index == self.selectedIndex {
                item.isSelected = true
            }else{
                item.isSelected = false
            }
        }
    }
    
    //MARK: <>内部View
    fileprivate var backView: TranslateHitView = {
        let view = TranslateHitView()
        return view
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var _curIndex:NSInteger = -1
    @objc public var selectedIndex:NSInteger {
        get {
            return _curIndex
        }
        set {
            let oldValue = self._curIndex
            self._curIndex = newValue
            if oldValue != newValue {
                self.refresSelectItem()
            }
        }
    }
    
    @objc public static var barHeight:CGFloat {
        let extraBottom:CGFloat = UIWindow.keyWindowSafeAreaInsets().bottom > 0 ? UIWindow.keyWindowSafeAreaInsets().bottom : 0
        let barBottom:CGFloat = extraBottom + 58.0
        return barBottom
    }
    //MARK: <>内部block
    
}
