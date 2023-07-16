//
//  UIScrollView+Ext.swift
//  LiveCap
//
//  Created by LuanMa on 16/4/21.
//  Copyright © 2016年 FunPlus. All rights reserved.
//

import Foundation
import UIKit

// EmptyView
private var ActivityIndicatorViewName = "LSActivityIndicatorView"
private var EmptyViewName = "LSEmptyView"
private var FooterViewName = "LSFooterView"
private var ScrollEnabledWhenEmptyName = "LSScrollEnabledWhenEmpty"
private var EmptyViewHeightName = "LSEmptyViewHeight"
private var ScrollWasEnabledName = "LSScrollWasEnabled"

extension UITableView {
    public var fun_footerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &FooterViewName) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &FooterViewName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var isEmpty: Bool {
        for section in 0 ..< numberOfSections {
            if numberOfRows(inSection: section) > 0 {
                return false
            }
        }
        return true
    }
    
    public func data_reloadData() {
        reloadData()
    }
    
    public func showEmptyView(_ shown: Bool) {
        if let emptyView = emptyView {
            if shown {
                var frame = bounds
                if let headerView = tableHeaderView {
                    frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - headerView.bounds.height)
                }
                
                
                if let emptyViewHeight = emptyViewHeight, emptyViewHeight > 0 {
                    frame = CGRect(x: 0, y: 0, width: frame.width, height: emptyViewHeight)
                }
                
                emptyView.frame = frame
                tableFooterView = emptyView
            } else {
                tableFooterView = UIView(frame: CGRect.zero)
            }
        }
    }
    
    public func showEmptyView(height: CGFloat) {
        if let emptyView = emptyView {
            emptyViewHeight = height
            emptyView.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
            tableFooterView = emptyView
        }
    }
    
    public func fun_beginLoadData() {
        if scrollWasEnabled == nil {
            scrollWasEnabled = isScrollEnabled
        }
        isScrollEnabled = false
        
        var activityIndicatorView = self.activityIndicatorView
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicatorView?.color = UIColor.hexString(toColor: "0x4A4A4A")
            self.activityIndicatorView = activityIndicatorView
        }
        
        if let view = activityIndicatorView , !subviews.contains(view) {
            addSubview(view)
        }
        
        activityIndicatorView?.center = CGPoint(x: self.center.x, y: self.center.y - 60)
        activityIndicatorView?.isHidden = false
        activityIndicatorView?.startAnimating()
    }
    
    public func fun_endLoadData() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.isHidden = true
        
        fun_checkEmpty()
    }
    
    public func fun_reloadData() {
        data_reloadData()
        fun_endLoadData()
    }
    
    
    public func fun_checkEmpty() {
        if self.scrollWasEnabled == nil {
            self.scrollWasEnabled = isScrollEnabled
        }
        
        let dataEmpty = isEmpty
        showEmptyView(dataEmpty)
        
        if let scrollEnabledWhenEmpty = scrollEnabledWhenEmpty , dataEmpty {
            isScrollEnabled = scrollEnabledWhenEmpty
        } else if let scrollWasEnabled = self.scrollWasEnabled , !dataEmpty {
            isScrollEnabled = scrollWasEnabled
        }
    }
}

extension UICollectionView {
    public var isEmpty: Bool {
        for section in 0 ..< numberOfSections {
            if numberOfItems(inSection: section) > 0 {
                return false
            }
        }
        return true
    }
    
    public func showEmptyView(_ shown: Bool) {
        if let emptyView = emptyView {
            if shown {
                emptyView.frame = bounds
                addSubview(emptyView)
            } else {
                emptyView.removeFromSuperview()
            }
        }
    }
    
    public func data_reloadData() {
        reloadData()
    }
    
    public func fun_beginLoadData() {
        if scrollWasEnabled == nil {
            scrollWasEnabled = isScrollEnabled
        }
        isScrollEnabled = false
        
        var activityIndicatorView = self.activityIndicatorView
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicatorView?.color = UIColor.hexString(toColor: "0x4A4A4A")
            self.activityIndicatorView = activityIndicatorView
        }
        
        if let view = activityIndicatorView , !subviews.contains(view) {
            addSubview(view)
        }
        
        activityIndicatorView?.center = CGPoint(x: self.center.x, y: self.center.y - 60)
        activityIndicatorView?.isHidden = false
        activityIndicatorView?.startAnimating()
    }
    
    public func fun_endLoadData() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.isHidden = true
        
        fun_checkEmpty()
    }
    
    public func fun_reloadData() {
        data_reloadData()
        fun_endLoadData()
    }
    
    
    public func fun_checkEmpty() {
        if self.scrollWasEnabled == nil {
            self.scrollWasEnabled = isScrollEnabled
        }
        
        let dataEmpty = isEmpty
        showEmptyView(dataEmpty)
        
        if let scrollEnabledWhenEmpty = scrollEnabledWhenEmpty , dataEmpty {
            isScrollEnabled = scrollEnabledWhenEmpty
        } else if let scrollWasEnabled = self.scrollWasEnabled , !dataEmpty {
            isScrollEnabled = scrollWasEnabled
        }
    }
}

extension UIScrollView {
    
    public var activityIndicatorView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &ActivityIndicatorViewName) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &ActivityIndicatorViewName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var emptyView: UIView? {
        get {
            return objc_getAssociatedObject(self, &EmptyViewName) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &EmptyViewName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var scrollEnabledWhenEmpty: Bool? {
        get {
            return objc_getAssociatedObject(self, &ScrollEnabledWhenEmptyName) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &ScrollEnabledWhenEmptyName, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var emptyViewHeight: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &EmptyViewHeightName) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &EmptyViewHeightName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var scrollWasEnabled: Bool? {
        get {
            return objc_getAssociatedObject(self, &ScrollWasEnabledName) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &ScrollWasEnabledName, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func showFrame() -> CGRect {
        return CGRect(x: bounds.minX + contentInset.left, y: bounds.minY + contentInset.top, width: bounds.width - contentInset.left - contentInset.right, height: bounds.height - contentInset.top - contentInset.bottom)
    }
    
}


private func swizzle(_ vc: UIScrollView.Type) {
    
    [
        (#selector(vc.layoutSubviews), #selector(vc.ls_layoutSubviews)),
        ].forEach { original, swizzled in
            
            if let originalMethod = class_getInstanceMethod(vc, original),
                let swizzledMethod = class_getInstanceMethod(vc, swizzled) {
                
                let didAddViewDidLoadMethod = class_addMethod(vc,
                                                              original,
                                                              method_getImplementation(swizzledMethod),
                                                              method_getTypeEncoding(swizzledMethod))
                
                if didAddViewDidLoadMethod {
                    class_replaceMethod(vc,
                                        swizzled,
                                        method_getImplementation(originalMethod),
                                        method_getTypeEncoding(originalMethod))
                } else {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
    }
}

extension UIScrollView {
    
    final public class func doSwizzle() {
        DispatchQueue.once(token: "UIScrollView+layoutSubviews") {
            swizzle(self)
        }
    }
    
	public func isTop() -> Bool {
		return contentOffset.y <= 0
	}

	public func isBottom() -> Bool {
		if contentSize.height < bounds.height {
			return true
		} else {
			return contentOffset.y >= contentSize.height - bounds.height
		}
	}
    
    public func scrollToBottomAnimated(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: contentSize.height - bounds.height), animated: animated)
    }
    
    @objc func ls_layoutSubviews() {
        super.layoutSubviews()
        if let empty = emptyView {
            empty.frame = bounds
        }
        if let indicator = activityIndicatorView {
            indicator.frame = bounds
        }
    }
}

extension UIScrollView {
    @objc public func moveToCenterX(pointX:CGFloat,animate:Bool) {
        let centerX = pointX
        var targetOffsetX = centerX - self.bounds.width / 2.0
        let minOffsetX = 0 - self.contentInset.left
        let maxOffsestX = self.contentSize.width + self.contentInset.right - self.bounds.width
        targetOffsetX = max(minOffsetX,targetOffsetX)
        targetOffsetX = min(maxOffsestX,targetOffsetX)
        self.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animate)
    }
}
