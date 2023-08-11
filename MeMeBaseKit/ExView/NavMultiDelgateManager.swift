//
//  NavMultiDelgateManager.swift
//  Party
//
//  Created by fabo on 2022/7/26.
//  Copyright © 2022 sip. All rights reserved.
//

import Foundation

import Foundation
import Cartography
import MeMeKit

@objc public class NavMultiDelgateManager : NSObject {
    @objc public static let shared:NavMultiDelgateManager = NavMultiDelgateManager()
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    fileprivate override init() {
        super.init()
    }
    //MARK: <>功能性方法
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    public var navDelegates:WeakReferenceArray<NavigationMultiDelegate> = WeakReferenceArray<NavigationMultiDelegate>()
    
    //MARK: <>内部block
    
}

extension NavMultiDelgateManager : UINavigationControllerDelegate {
    @objc public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navDelegates.excuteObject { object in
            object?.navigationController(navigationController, willShow: viewController, animated: animated)
        }
    }
    
    @objc public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navDelegates.excuteObject { object in
            object?.navigationController(navigationController, didShow: viewController, animated: animated)
        }
    }
}

@objc public protocol NavigationMultiDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
}

extension NavigationMultiDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}
}
