//
//  HUD.swift
//  MeMe
//
//  Created by funplus on 2017/2/14.
//  Copyright © 2017年 sip. All rights reserved.
//

import MBProgressHUD
import MeMeKit

public class MMHud: MBProgressHUD {
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        bezelView.addCornerRadius(CGSize(width: bezelView.height, height: bezelView.height))
//    }
    
    public override func hide(animated: Bool) {
        main_async {
            super.hide(animated: animated)
        }
    }
    
    public override func hide(animated: Bool, afterDelay: TimeInterval) {
        main_async {
            super.hide(animated: animated, afterDelay: afterDelay)
        }
    }
    
}

 @objc public class HUD : NSObject {
    @objc public class func flash2(
        _ text: String,
        mode: MBProgressHUDMode = .text,
        toView: UIView? = UIApplication.shared.keyWindow,
        isbelow: Bool = false,
        belowInset:CGFloat = -1,
        delay: TimeInterval = 2.0,
        theHud: MMHud? = nil
    ) {
        main_async {
            if let toView = toView {
                let hud = theHud ?? MMHud.showAdded(to: toView, animated: true)
                hud.mode = mode
                hud.label.text = text
                hud.label.numberOfLines = 0
                if isbelow {
                    hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
                }else if belowInset >= 0 {
                    let bounds = toView.bounds
                    let bottom = bounds.size.height / 2.0 - 40.0
                    hud.offset = CGPoint(x: 0, y: bottom - belowInset)
                }
                hud.isUserInteractionEnabled = false
                hud.hide(animated: true, afterDelay: delay)
            }
        }
    }
    
    class func loading(_ task: @escaping ()->Void) {
        let hud = MMHud.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.isUserInteractionEnabled = false
        async {
            // 后台操作
            task()
    
            main_async {
                hud.hide(animated: true)
            }
        }
    }
    
}
