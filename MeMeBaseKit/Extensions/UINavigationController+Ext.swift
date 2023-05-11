//
//  UINavigationController+Ext.swift
//  MeMeKit
//
//  Created by fabo on 2023/3/1.
//

import Foundation

private var UINavigationControllerDeleagtesKey:String?

extension UINavigationController : UINavigationControllerDelegate {
    public var delegates: WeakReferenceArray<UINavigationControllerDelegate> {
        get {
            let weakArray = objc_getAssociatedObject(self, &UINavigationControllerDeleagtesKey) as? WeakReferenceArray<UINavigationControllerDelegate>
            if let weakArray = weakArray {
                return weakArray
            }else{
                let newArray = WeakReferenceArray<UINavigationControllerDelegate>()
                objc_setAssociatedObject(self, &UINavigationControllerDeleagtesKey, newArray, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newArray
            }
        }
    }
    
    @objc public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.delegates.excuteObject { delegate in
            delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
        }
    }
    
    @objc public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.delegates.excuteObject { delegate in
            delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
        }
    }
}
