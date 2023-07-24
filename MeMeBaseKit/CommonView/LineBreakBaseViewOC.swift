//
//  LineBreakBaseViewOC.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/24.
//

import Foundation

import Foundation
import Cartography

@objc public class LineBreakBaseViewOC : UIView {
    
    //MARK: <>外部变量
    @objc public var borderMargins: UIEdgeInsets = UIEdgeInsets() {
        didSet {
            internelView.borderMargins = borderMargins
        }
    }
    @objc public var marginY:CGFloat = 0 {
        didSet {
            internelView.marginY = marginY
        }
    }
    @objc public var marginX:CGFloat = 0 {
        didSet {
            internelView.marginX = marginX
        }
    }
    @objc public var maxLine:NSInteger = 9999 {
        didSet {
            internelView.maxLine = maxLine
        }
    }
    @objc public var breakMaxWidth:CGFloat = UIScreen.main.bounds.width {
        didSet {
            internelView.breakMaxWidth = breakMaxWidth
        }
    }
    
    //MARK: <>外部block
    @objc public var itemSizeClosure:((_ index:Int)->CGSize)! {
        didSet {
            internelView.itemSizeClosure = itemSizeClosure
        }
    }
    @objc public var itemLayoutClosure:((_ frame:CGRect,_ index:Int,_ view:UIView?,_ extra:[String:Any]?)->UIView?)! {
        didSet {
            internelView.itemLayoutClosure = itemLayoutClosure
        }
    }
    
    @objc public var itemCount:NSInteger = 0 {
        didSet {
            self.internelView.itemCount = self.itemCount
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
        self.addSubview(internelView)
        constrain(internelView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
    }
    
    //MARK: <>功能性方法
    @objc public func reload() {
        self.internelView.reload()
    }
    //MARK: <>内部View
    lazy var internelView: LineBreakBaseView = {
        let breakView = LineBreakBaseView()
        breakView.borderMargins = self.borderMargins
        breakView.maxLine = self.maxLine
        breakView.marginX = self.marginX   //cell段间距
        breakView.marginY = self.marginY //cell行间距
        breakView.breakMaxWidth = self.breakMaxWidth
        breakView.itemSizeClosure = { [weak self] (index) -> CGSize? in
            guard let `self` = self else {return nil}
            return self.itemSizeClosure(index)
        }
        breakView.itemLayoutClosure = { [weak self](frame,index,view,extra) -> UIView? in
            guard let `self` = self else {return nil}
            return self.itemLayoutClosure(frame,index,view,extra)
        }
        return breakView
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}
