//
//  ScreenUIManager.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/14.
//

import Foundation

@objc public class ScreenUIManager : NSObject {
    @objc public static let shared = ScreenUIManager()
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    fileprivate override init() {
        super.init()
        
    }
    //MARK: <>功能性方法
    @objc public static func topWindow() -> UIWindow? {
        var window = UIApplication.shared.keyWindow
        // 是否为当前显示的window
        if ((window?.windowLevel.rawValue) != 0) {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel.rawValue == 0{
                    window = windowTemp
                    break
                }
            }
        }
 
        return window
    }
    
    /// 获取顶部控制器 无要求
    @objc public static func topViewController() -> UIViewController? {
        let vc  = self.topWindow()?.rootViewController
        return getTopVC(withCurrentVC: vc)
    }
    
    @objc public static func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
            if VC == nil {
                return nil
            }
            if let presentVC = VC?.presentedViewController {
                //modal出来的 控制器
                return getTopVC(withCurrentVC: presentVC)
            }else if let tabVC = VC as? UITabBarController {
                // tabBar 的跟控制器
                if let selectVC = tabVC.selectedViewController {
                    return getTopVC(withCurrentVC: selectVC)
                }
                return nil
            } else if let naiVC = VC as? UINavigationController {
                // 控制器是 nav
                return getTopVC(withCurrentVC:naiVC.visibleViewController)
            } else {
                // 返回顶控制器
                return VC
            }
        }
     
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}
