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
    @objc public func addTo(_ parent:UIViewController,rect:CGRect) {
        parent.addChild(self)
        parent.view.addSubview(self.view)
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
