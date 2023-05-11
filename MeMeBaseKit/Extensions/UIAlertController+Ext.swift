//
//  UIAlertController+Ext.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/8/2.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit
import Foundation

extension UIAlertController {
    
    public func setBarButtonItem(barButtonItem :UIBarButtonItem) {
        if isPad {
            self.modalPresentationStyle = .popover
            let popPresenter = self.popoverPresentationController
            popPresenter?.barButtonItem = barButtonItem
        }
    }
    
    public func setSourceView(sourceView :UIView) {
        if isPad {
            self.modalPresentationStyle = .popover
            let popPresenter = self.popoverPresentationController
            popPresenter?.sourceView = sourceView
            popPresenter?.sourceRect = sourceView.bounds
        }
    }
}

extension UIAlertController {
    
    public var attrTitle: NSAttributedString? {
        set { self.setValue(newValue, forKey: "attributedTitle") }
        get { return self.value(forKey: "attributedTitle") as? NSAttributedString }
    }
    
    public var attrMessage: NSAttributedString? {
        set { self.setValue(newValue, forKey: "attributedMessage") }
        get { return self.value(forKey: "attributedMessage") as? NSAttributedString }
    }
    
    public func cancelAction(text: String,
                      textColor: UIColor? = nil,
                      font: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),
                      alignment: NSTextAlignment = .center,
                      handler: ((UIAlertAction) -> Swift.Void)? = nil)
    {
        let cancelAction = UIAlertAction(title: text, style: .cancel, handler: handler)
        if let textColor = textColor {
            cancelAction.setValue(textColor, forKey: "titleTextColor")
        }
        cancelAction.setValue(NSNumber(value: alignment.rawValue), forKey: "titleTextAlignment")
        addAction(cancelAction)
    }
    
    public func okAction(text: String,
                  textColor: UIColor? = nil,
                  font: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular),
                  alignment: NSTextAlignment = .center,
                  handler: ((UIAlertAction) -> Swift.Void)? = nil)
    {
        let okAction = UIAlertAction(title: text, style: .default, handler: handler)
        if let textColor = textColor {
            okAction.setValue(textColor, forKey: "titleTextColor")
        }
        okAction.setValue(NSNumber(value: alignment.rawValue), forKey: "titleTextAlignment")
//        okAction.setValue(font, forKey: "titleFont")
        addAction(okAction)
    }
    
}
