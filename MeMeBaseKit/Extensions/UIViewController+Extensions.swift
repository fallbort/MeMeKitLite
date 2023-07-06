//
//  UIViewController+Extensions.swift
//  MeMe
//
//  Created by funplus on 2018/6/1.
//  Copyright © 2018年 sip. All rights reserved.
//

import UIKit
import Photos


extension UIViewController {
    @objc public func addTo(_ parent:UIViewController,view:UIView? = nil,rect:CGRect) {
        parent.addChild(self)
        if let view = view {
            view.addSubview(self.view)
        }else{
            parent.view.addSubview(self.view)
        }
        self.view.frame = rect
        self.didMove(toParent: parent)
    }
    
    @objc public func removeMe() {
        if self.parent != nil {
            self.willMove(toParent: nil)
        }
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension UIViewController {
    @objc public func showErrorMessage(_ message: String) {
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NELocalize.localizedString("OK", comment: ""), style: .default, handler: { action in
            controller.dismiss(animated: true, completion: nil)
        }))
        present(controller, animated: true, completion: nil)
    }
    
    @discardableResult
    @objc public func showAlertMessage(title:String,message:String? = nil,comfirm:String = NELocalize.localizedString("OK"),cancel:String = NELocalize.localizedString("Cancel"),comfirmBlock:(()->())? = nil, cancelBlock:(()->())? = nil) -> UIViewController? {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: comfirm, style: .default) { _ in
            comfirmBlock?()
        }
        alert.addAction(okAction)
        if cancel.count > 0 {
            let cancelAction = UIAlertAction(title: cancel, style: .cancel) { _ in
                cancelBlock?()
            }
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
        return alert
    }
}
