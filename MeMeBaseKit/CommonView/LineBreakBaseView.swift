//
//  TagsView.swift
//  z1j
//
//  Created by xfb on 2019/7/7.
//  Copyright © 2019 xfb. All rights reserved.
//

import Foundation
import UIKit

let LineBreak_isMaxLineEndCellKey = "isMaxLineEndCell"
var LineBreakViewContext = 0

/**
 desc  横排布局视图，必须提供协议里的值
 
 @param
 @param
 @return
 */
public protocol LineBreakViewable {
    //实体总数
    var itemCount:Int! { get set}
    //实体的size回调
    var itemSizeClosure:((_ index:Int)->CGSize?)! { get set}
    //实体的布局回调
    var itemLayoutClosure:((_ frame:CGRect,_ index:Int,_ view:UIView?,_ extra:[String:Any]?)->UIView?)! { get set}
}

open class LineBreakBaseView: TranslateHitView,LineBreakViewable {
    private var reuseableView:[UIView] = []
    
    public var inuseView:[UIView?] = []
    //最大行数
    public var maxLine:Int?
    public var maxCountOneLine:Int?
    //实体的边距,只实现了top,left部分
    public var borderMargins: UIEdgeInsets = UIEdgeInsets()
    //实体之间的间隔
    public var marginY:CGFloat?
    public var marginX:CGFloat?
    //实体总数
    public var itemCount:Int!
    //设置最大宽度
    public var breakMaxWidth:CGFloat?
    //实体的size回调
    public var itemSizeClosure:((_ index:Int)->CGSize?)!
    //实体的布局回调,view表示可重复利用的view
    public var itemLayoutClosure:((_ frame:CGRect,_ index:Int,_ view:UIView?,_ extra:[String:Any]?)->UIView?)!
    
    public init() {
        super.init(frame: CGRect())
        self.setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        self.setupUI()
    }
    
    open func reload() {
        self.invalidateIntrinsicContentSize()
        self.layoutSubviews()
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
        self.removeObserver(self, forKeyPath: "bounds")
    }
    
    
    func setupUI(){
        self.backgroundColor = UIColor.clear
        
        self.addObserver(self, forKeyPath: "frame", options: [.new], context: &LineBreakViewContext)
        self.addObserver(self, forKeyPath: "bounds", options: [.new], context: &LineBreakViewContext)

    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &LineBreakViewContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        guard let keyPath = keyPath else {
            return
        }
        
        guard let object = object as? Self else {
            return
        }
        
        switch keyPath {
        case "frame","bounds":
            if self.frame.width != 0 {
                if oldSize != self.bounds.size {
                    oldSize = self.bounds.size
                    self.invalidateIntrinsicContentSize()
                    self.layoutSubviews()
                }
            }
        default:
            break
        }
    }
    
    open override func layoutSubviews() {
        self.beginLayoutSubviews()
    }
    
    @discardableResult
    func beginLayoutSubviews() -> CGSize {
        return self.relayout(width:self.bounds.size.width,begin: {[weak self] in
            guard let strongSelf = self else {return}
            for view in strongSelf.inuseView {
                if view != nil {
                    strongSelf.reuseableView.append(view!)
                    view!.isHidden = true
                }
            }
            strongSelf.inuseView.removeAll()
        }, realLayout: { [weak self] (rect, index,extra) in
            guard let strongSelf = self else {return}
            if strongSelf.reuseableView.count == 0 {
                let view = strongSelf.itemLayoutClosure(rect,index,nil,extra)
                if view != nil {
                    strongSelf.addSubview(view!)
                    view!.isHidden = false
                    view!.autoresizingMask = .init()
                }
                
                strongSelf.inuseView.append(view)
            }else {
                let view = strongSelf.reuseableView.remove(at: 0)
                let newView = strongSelf.itemLayoutClosure(rect,index,view,extra)
                if newView != view {
                    view.removeFromSuperview()
                    if newView != nil {
                        strongSelf.addSubview(newView!)
                    }
                }
                if newView != nil {
                    newView!.isHidden = false
                    newView!.autoresizingMask = .init()
                }
                
                strongSelf.inuseView.append(newView)
            }
        }) {[weak self] in
            guard let strongSelf = self else {return}
            for view in strongSelf.inuseView {
                if view != nil {
                    strongSelf.reuseableView.append(view!)
                    view!.isHidden = true
                }
            }
            strongSelf.inuseView.removeAll()
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.relayout(width: size.width, begin: nil, realLayout: nil, end: nil);
    }
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return self.relayout(width: targetSize.width, begin: nil, realLayout: nil, end: nil);
    }
    
    open override func sizeToFit() {
        let size = self.beginLayoutSubviews()
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    
    @discardableResult
    func relayout(width:CGFloat,begin:(()->())?, realLayout:((_ frame:CGRect,_ index:Int,_ extra:[String:Any]?)->())?,end:(()->())?) -> CGSize {
        if self.itemSizeClosure != nil && self.itemLayoutClosure != nil && self.itemCount != nil && self.itemCount! > 0 {
            let marginY = self.marginY ?? 0
            let marginX = self.marginX ?? 0
            
            var offsetX = borderMargins.left
            var offsetY = borderMargins.top

            var curLine = 1
            var curLineCount = 0
            if begin != nil {begin!()}
            
            var sizeValid = true
            
            var lineHeight:CGFloat = 0
            for i in 0 ..< self.itemCount {
                var size = self.itemSizeClosure(i)
                if size != nil {
                    lineHeight = lineHeight > size!.height ? lineHeight : size!.height
                    if offsetX + size!.width > width || (self.maxCountOneLine != nil && curLineCount >= self.maxCountOneLine!) {
                        offsetX = 0
                        curLineCount = 0
                        curLine += 1
                        if self.maxLine != nil && self.maxLine! < curLine {
                            break
                        }else{
                            if offsetX + size!.width > width  {
                                size!.width = width
                            }
                            offsetY = offsetY + size!.height + marginY
                            if realLayout != nil {
                                var nextNeedNewLine = false
                                let nextOffsetX = offsetX + size!.width + marginX
                                if nextOffsetX + size!.width > width {
                                    nextNeedNewLine = true
                                }
                                var extra:[String:Any]?
                                if nextNeedNewLine,curLine == self.maxLine! {
                                    extra = extra != nil ? extra : [:]
                                    extra?[LineBreak_isMaxLineEndCellKey] = true
                                }
                                realLayout!(CGRect.init(x: offsetX, y: offsetY, width: size!.width, height: size!.height),i,extra)
                            }
                            offsetX = offsetX + size!.width + marginX
                            curLineCount += 1
                        }
                    }else {
                        if realLayout != nil {
                            var nextNeedNewLine = false
                            let nextOffsetX = offsetX + size!.width + marginX
                            if nextOffsetX + size!.width > width {
                                nextNeedNewLine = true
                            }
                            var extra:[String:Any]?
                            if nextNeedNewLine,curLine == self.maxLine! {
                                extra = extra != nil ? extra : [:]
                                extra?[LineBreak_isMaxLineEndCellKey] = true
                            }
                            realLayout!(CGRect.init(x: offsetX, y: offsetY, width: size!.width, height: size!.height),i,extra)
                        }
                        offsetX = offsetX + size!.width + marginX
                        curLineCount += 1
                    }
                }else{
                    sizeValid = false
                    break
                }
                
            }
            
            if sizeValid == true {
                offsetY = offsetY + lineHeight
                return CGSize.init(width: width, height: offsetY)
            }else {
                if end != nil { end!() }
                return CGSize.init(width: width, height: 0)
            }
        }else{
            if end != nil { end!() }
            return CGSize.init(width: width, height: 0)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            if let breakMaxWidth = breakMaxWidth {
                let size = self.relayout(width: breakMaxWidth, begin: nil, realLayout: nil, end: nil);
                return size
            }else{
                let size = self.relayout(width: self.bounds.size.width, begin: nil, realLayout: nil, end: nil);
                return size
            }
            
        }
    }
    
    private var oldSize:CGSize = CGSize()
}
