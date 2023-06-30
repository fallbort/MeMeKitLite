//
//  MeMeCustomButton.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/30.
//

import Foundation

import Foundation
import Cartography
import MeMeKit

@objc public class MeMeBlockButton : UIControl {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    @objc public var isHighlightedChangedBlock:((_ value:Bool)->())?
    @objc public var isEnabledChangedBlock:((_ value:Bool)->())?
    @objc public var isSelectedChangedBlock:((_ value:Bool)->())?
    @objc public var isStateChangedBlock:((_ btn:MeMeBlockButton)->())?
    @objc public var layoutViewForStateChangedBlock:((_ btn:MeMeBlockButton,_ oldView:UIView?)->UIView?)? {
        didSet {
            refreshContentView()
        }
    }
    
    //MARK: <>生命周期开始
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(backView)
        constrain(backView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            zeroWidthLayout = $0.width == 0 ~ 888
            zeroHeightLayout = $0.height == 0 ~ 888
        }
    }
    
    //MARK: <>功能性方法
    func refreshContentView() {
        let oldView = self.contentView
        self.contentView = self.layoutViewForStateChangedBlock?(self,nil)
        if (oldView?.getAddress() != self.contentView?.getAddress()) {
            oldView?.removeFromSuperview()
        }
        if let contentView = self.contentView {
            contentView.removeFromSuperview()
            self.backView.addSubview(contentView)
            constrain(contentView) {
                $0.left == $0.superview!.left
                $0.right == $0.superview!.right
                $0.top == $0.superview!.top
                $0.bottom == $0.superview!.bottom
            }
            
            zeroHeightLayout?.priority = UILayoutPriority(100)
            zeroWidthLayout?.priority = UILayoutPriority(100)
        }else{
            zeroHeightLayout?.priority = UILayoutPriority(888)
            zeroWidthLayout?.priority = UILayoutPriority(888)
        }
    }
    //MARK: <>内部View
    var backView: TranslateHitView = {
        let view = TranslateHitView()
        return view
    }()
    //MARK: <>内部UI变量
    var zeroHeightLayout:NSLayoutConstraint?
    var zeroWidthLayout:NSLayoutConstraint?
    //MARK: <>内部数据变量
    public override var isHighlighted: Bool {
        didSet {
            self.isHighlightedChangedBlock?(self.isHighlighted)
            self.isStateChangedBlock?(self)
            self.refreshContentView()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            self.isEnabledChangedBlock?(self.isEnabled)
            self.isStateChangedBlock?(self)
            self.refreshContentView()
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            self.isSelectedChangedBlock?(self.isSelected)
            self.isStateChangedBlock?(self)
            self.refreshContentView()
        }
    }
    
    var contentView:UIView?
    //MARK: <>内部block
    
}
