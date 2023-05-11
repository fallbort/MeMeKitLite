//
//  TagsView.swift
//  z1j
//
//  Created by xfb on 2019/7/7.
//  Copyright © 2019 xfb. All rights reserved.
//

import Foundation
import UIKit

/**
 desc  横排布局按钮，必须提供var models:[String]!，var styleBtn:UIButton!的值
 
 @param
 @param
 @return
 */
public protocol LineBreakButtonViewable {
    var btn_models:[String]! {get set}
    var styleBtnClosure:(()->UIButton)! {get set}
}

open class LineBreakButtonView: LineBreakBaseView,LineBreakButtonViewable {
    //样式label
    private var styleLabel:UILabel!
    private var styleCornerSize:CGSize!
    private var _labelHeight:CGFloat?
    
    var insetX:CGFloat?
    var insetY:CGFloat?
    //可以手动设置label高度
    var labelHeight:CGFloat! {
        get {
            if self._labelHeight == nil {
                let size = self.calculateLabelHeight()
                self._labelHeight = size?.height
            }
            return self._labelHeight
        }
        set {
            self._labelHeight = newValue
        }
    }
    
    open var btn_models:[String]! {
        didSet {
            if self.btn_models != nil && self.btn_models!.count > 0 {
                self.itemCount = self.btn_models!.count
                self.reload()
            }else {
                self.itemCount = 0
                self.reload()
            }
        }
    }
    
    //样式按钮
    open var styleBtnClosure:(()->UIButton)! {
        didSet {
            if self.styleBtnClosure != nil {
                let oldHeight = self._labelHeight
                if oldHeight != nil {
                    if let oldCalHeight = self.calculateLabelHeight()?.height, oldHeight == oldCalHeight {
                        self._labelHeight = nil
                    }
                }
                let label = UILabel.init()
                label.font = self.styleBtnClosure().titleLabel?.font
                self.styleLabel = label
                
            }else{
                self.styleLabel = nil
                self._labelHeight = nil
            }
            
        }
    }
    //角标样式按钮
    var styleCornerBtnClosure:(()->UIButton)! {
        didSet {
            if self.styleCornerBtnClosure != nil {
                let btn = self.styleCornerBtnClosure()
                let image = btn.image(for: .normal)
                if image != nil {
                    self.styleCornerSize = image?.size
                }else {
                    self.styleCornerSize = btn.intrinsicContentSize
                }
                
            }else{
                self.styleCornerSize = nil
            }
        }
    }
    
    //主按钮点击
    var btnClickedClosure:((_ index:Int)->())?
    //角标按钮点击
    var cornerBtnClickedClosure:((_ index:Int)->())?
    
    func getButton(index:Int) -> UIButton? {
        if self.inuseView.count > index {
            return self.inuseView[index]?.viewWithTag(1) as? UIButton
        }else{
            return nil
        }
    }
    
    func getCornerButton(index:Int) -> UIButton? {
        if self.inuseView.count > index {
            return self.inuseView[index]?.viewWithTag(2) as? UIButton
        }else{
            return nil
        }
    }
    
    //setup入口
    override func setupUI() {
        super.setupUI()
        
        self.itemSizeClosure = { [weak self] (index) -> CGSize? in
            guard let strongSelf = self else {return nil}
            return strongSelf.itemSize(index: index)
        }
        self.itemLayoutClosure = { [weak self](frame,index,view,extra) -> UIView? in
            guard let strongSelf = self else {return nil}
            return strongSelf.itemLayout(frame:frame, index:index, view:view,extra:extra)
        }
       
    }
    
    private func calculateLabelHeight() -> CGSize? {
        if self.styleLabel != nil {
            self.styleLabel.text = "计算高度专用"
            let size = self.styleLabel?.sizeThatFits(CGSize.init(width: UIScreen.main.bounds.size.width, height: 0))
            return size
        }else {
            return nil
        }
    }
    
    func itemSize(index:Int) -> CGSize? {
        if self.styleBtnClosure != nil && self.styleLabel != nil {
            self.styleLabel.text = self.btn_models[index]
            let size = self.styleLabel.sizeThatFits(CGSize.init(width: UIScreen.main.bounds.size.width, height: 0))
            var sizeHeight = self.labelHeight + 2*(self.insetY ?? 0)
            var sizeWidth = size.width + 2*(self.insetX ?? 0)
            
            if  self.styleCornerBtnClosure != nil {
                let cornerSize = self.styleCornerSize
                sizeHeight = sizeHeight + cornerSize!.height / 2
                sizeWidth = sizeWidth + cornerSize!.width / 2
            }
            return CGSize.init(width: sizeWidth, height: sizeHeight)
        }
        return nil
    }
    
    func itemLayout(frame:CGRect,index:Int,view:UIView?,extra:[String:Any]?)->UIView? {
        if self.styleBtnClosure != nil {
            var newView = view
            if newView == nil {
                newView = UIView.init(frame: frame)
                newView?.backgroundColor = .clear
                let button = self.styleBtnClosure()
                button.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
                button.autoresizingMask = .init()
                button.tag = 1
                newView?.addSubview(button)
            }
            
            let content = self.btn_models[index]
            let button = newView?.viewWithTag(1) as? UIButton
            var cornerBtn = newView?.viewWithTag(2) as? UIButton
            button?.setTitle(content, for: .normal)
            
            newView?.frame = frame
            if self.styleCornerBtnClosure == nil {
                button?.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
                cornerBtn?.removeFromSuperview()
            }else{
                if cornerBtn == nil {
                    cornerBtn = self.styleCornerBtnClosure()
                    cornerBtn!.addTarget(self, action: #selector(cornerBtnClicked(sender:)), for: .touchUpInside)
                    cornerBtn!.autoresizingMask = .init()
                    newView?.addSubview(cornerBtn!)
                    cornerBtn!.tag = 2
                }
                let cornerSize = self.styleCornerSize!
                button?.frame = CGRect.init(x: 0, y: cornerSize.height / (CGFloat)(2), width: frame.size.width - cornerSize.width / (CGFloat)(2), height: frame.size.height - cornerSize.height / (CGFloat)(2))
                cornerBtn?.frame = CGRect.init(x: frame.size.width - cornerSize.width, y: 0, width: cornerSize.width, height: cornerSize.width)
            }
        
            return newView
        }
        return nil
    }
    
    @objc private func btnClicked(sender:UIButton){
        if self.btnClickedClosure != nil {
            for (i,_) in self.inuseView.enumerated() {
                let btn = self.getButton(index: i)
                if btn == sender {
                    self.btnClickedClosure!(i)
                    break
                }
            }
        }
    }
    
     @objc private func cornerBtnClicked(sender:UIButton){
        if self.cornerBtnClickedClosure != nil {
            for (i,_) in self.inuseView.enumerated() {
                let btn = self.getCornerButton(index: i)
                if btn == sender {
                    self.cornerBtnClickedClosure!(i)
                    break
                }
            }
        }
    }
    
}
