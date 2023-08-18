//
//  MeMeShowManager.swift
//  MeMeKit
//
//  Created by xfb on 2023/4/11.
//

import Foundation

import Foundation
import Cartography

@objc public class MeMeShowManager : NSObject {
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    @objc private override init() {
        super.init()
    }
    //MARK: <>功能性方法
    @objc public static func commonCenterShow(superController:UIViewController,rootVC:UIViewController,size:CGSize = CGSize(),offset:CGPoint = CGPoint(),cornerRadius:CGFloat = -1, clips:Bool = true,isTranslateView:Bool = false,tapDismiss:Bool = true) {
        let size:CGSize? = size != CGSize() ? size : nil
        let cornerRadius:CGFloat? = cornerRadius >= 0 ? cornerRadius : nil
        CommonCenterShowController.commonShow(superController: superController,size: size, offset:offset, cornerRadius: cornerRadius,clips:clips,isTranslateView: isTranslateView,tapDismiss: tapDismiss) { controller in
            controller.outVC = rootVC
            if size == nil {
                controller.contentSizeInPopup = rootVC.contentSizeInPopup
            }
            rootVC.meme_closeBlock = { [weak controller] animate in
                controller?.close(animate)
            }
        }
    }
    
    @objc public static func commonBottomShow(superController:UIViewController,rootVC:UIViewController,isCornerLandscape:Bool = false,fadeColor:UIColor? = nil,topRadius:CGFloat = -1,needClip:Bool = true,tapDismiss:Bool = true) {
        let topRadius:CGFloat = topRadius >= 0 ? topRadius : 8
        CommonBottomShowController.commonShowCard(superController: superController,isCornerLandscape:isCornerLandscape,fadeColor:fadeColor,topRadius: topRadius,needClip: needClip,tapDismiss: tapDismiss) { controller in
            controller?.outVC = rootVC
            controller?.contentSizeInPopup = rootVC.contentSizeInPopup
            rootVC.meme_closeBlock = { [weak controller] animate in
                controller?.closeRoot(animate: animate)
            }
        }
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}

