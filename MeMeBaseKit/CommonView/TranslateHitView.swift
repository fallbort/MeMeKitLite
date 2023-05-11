//
//  TranslateHitView.swift
//  MeMe
//
//  Created by admin on 2020/4/8.
//  Copyright © 2020 sip. All rights reserved.
//

import UIKit

@objc open class TranslateHitView : UIView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }else{
            if self.isHidden == false && self.alpha > 0.01 && self.isUserInteractionEnabled == true {
                let subs = self.subviews
                for oneView in subs.reversed() {
                    if oneView.isHidden == false && oneView.alpha > 0.01 && oneView.isUserInteractionEnabled == true {
                        let subPoint = oneView.convert(point, from: self)
                        if oneView.point(inside: subPoint, with: event) {
                            let testView = oneView.hitTest(subPoint, with: event)
                            if testView != nil {
                                return testView
                            }
                        }else if oneView is TranslateHitView {
                            let testView = oneView.hitTest(subPoint, with: event)
                            if testView != nil {
                                return testView
                            }
                        }
                    }
                }
            }
        }
        return view
    }
}
