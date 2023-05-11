//
//  NSObject+Ext.swift
//  MeMeKit
//
//  Created by fabo on 2022/12/29.
//

import Foundation

public protocol InDeInitProtocol : AnyObject {
    
}

private var InDeInitKey = "InDeInitKey"

extension InDeInitProtocol {
    public var isInDeinit: Bool {
        get {
            let timer = objc_getAssociatedObject(self, &InDeInitKey) as? Bool
            return timer ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &InDeInitKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

extension NSObject : InDeInitProtocol {
    
}

public struct MultiBoolKey {
    public static var key = "MultiBoolDefaultKey"
}

extension NSObject {
    private static var multiHiddenName:Int?
    public func multiHidden(key:String) -> Bool {
        var hiddenSet = objc_getAssociatedObject(self, &NSObject.multiHiddenName) as? Set<String> ?? Set<String>()
        return hiddenSet.contains(key)
    }
    public func setMultiHidden(key:String,isHidden:Bool) {
        var hiddenSet = objc_getAssociatedObject(self, &NSObject.multiHiddenName) as? Set<String> ?? Set<String>()
        var modified = false
        if isHidden == true,hiddenSet.contains(key) == false {
            modified = true
            hiddenSet.insert(key)
        }else if isHidden == false {
            modified = true
            hiddenSet.remove(key)
        }
        if modified == true {
            objc_setAssociatedObject(self, &NSObject.multiHiddenName, hiddenSet, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if hiddenSet.count > 0 , self.getRealMultiHidden() == false {
            self.setRealMultiHidden(true)
        }else if hiddenSet.count == 0 , self.getRealMultiHidden() == true {
            self.setRealMultiHidden(false)
        }
    }
    public func copyMultiHiddenList(from other:NSObject?) {
        if let other = other, let hiddenSetOther = objc_getAssociatedObject(other, &NSObject.multiHiddenName) as? Set<String> {
            var hiddenSetThis = objc_getAssociatedObject(self, &NSObject.multiHiddenName) as? Set<String> ?? Set<String>()
            for key in hiddenSetOther {
                if hiddenSetThis.contains(key) == false {
                    hiddenSetThis.insert(key)
                }
            }
            objc_setAssociatedObject(self, &NSObject.multiHiddenName, hiddenSetThis, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if hiddenSetThis.count > 0 , self.getRealMultiHidden() == false {
                self.setRealMultiHidden(true)
            }else if hiddenSetThis.count == 0 , self.getRealMultiHidden() == true {
                self.setRealMultiHidden(false)
            }
        }
    }
    
    @objc public func setRealMultiHidden(_ hidden:Bool) {
        
    }
    
    @objc public func getRealMultiHidden() -> Bool {
        return false
    }
    
}


extension NSObject {
    private static var multiDisableName:Int?
    public func multiDisable(key:String) -> Bool {
        var hiddenSet = objc_getAssociatedObject(self, &NSObject.multiDisableName) as? Set<String> ?? Set<String>()
        return hiddenSet.contains(key)
    }
    public func setMultiDisable(key:String,isDisable:Bool) {
        var disableSet = objc_getAssociatedObject(self, &NSObject.multiDisableName) as? Set<String> ?? Set<String>()
        var modified = false
        if isDisable == true,disableSet.contains(key) == false {
            modified = true
            disableSet.insert(key)
        }else if isDisable == false {
            modified = true
            disableSet.remove(key)
        }
        if modified == true {
            objc_setAssociatedObject(self, &NSObject.multiDisableName, disableSet, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if disableSet.count > 0 , self.getRealMultiDisable() == false {
            self.setRealMultiDisable(true)
        }else if disableSet.count == 0 , self.getRealMultiDisable() == true {
            self.setRealMultiDisable(false)
        }
    }
    public func copyMultiDisableList(from other:NSObject?) {
        if let other = other, let disableSetOther = objc_getAssociatedObject(other, &NSObject.multiDisableName) as? Set<String> {
            var disableSetThis = objc_getAssociatedObject(self, &NSObject.multiDisableName) as? Set<String> ?? Set<String>()
            for key in disableSetOther {
                if disableSetThis.contains(key) == false {
                    disableSetThis.insert(key)
                }
            }
            objc_setAssociatedObject(self, &NSObject.multiDisableName, disableSetThis, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if disableSetThis.count > 0 , self.getRealMultiDisable() == false {
                self.setRealMultiDisable(true)
            }else if disableSetThis.count == 0 , self.getRealMultiDisable() == true {
                self.setRealMultiDisable(false)
            }
        }
    }
    
    @objc public func setRealMultiDisable(_ hidden:Bool) {
        
    }
    
    @objc public func getRealMultiDisable() -> Bool {
        return false
    }
}


extension UIApplication {
    private static var multiIdleDisableName:Int?
    @objc public func multiIdleTimerDisable(key:String) -> Bool {
        var hiddenSet = objc_getAssociatedObject(self, &UIApplication.multiIdleDisableName) as? Set<String> ?? Set<String>()
        return hiddenSet.contains(key)
    }
    @objc public func setMultiIdleTimerDisable(key:String,isDisable:Bool) {
        var disableSet = objc_getAssociatedObject(self, &UIApplication.multiIdleDisableName) as? Set<String> ?? Set<String>()
        var modified = false
        if isDisable == true,disableSet.contains(key) == false {
            modified = true
            disableSet.insert(key)
        }else if isDisable == false {
            modified = true
            disableSet.remove(key)
        }
        if modified == true {
            objc_setAssociatedObject(self, &UIApplication.multiIdleDisableName, disableSet, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if disableSet.count > 0 , self.getRealMultiIdleTimerDisable() == false {
            self.setRealMultiIdleTimerDisable(true)
        }else if disableSet.count == 0 , self.getRealMultiIdleTimerDisable() == true {
            self.setRealMultiIdleTimerDisable(false)
        }
    }
    @objc public func copyMultiIdleTimerDisableList(from other:NSObject?) {
        if let other = other, let disableSetOther = objc_getAssociatedObject(other, &UIApplication.multiIdleDisableName) as? Set<String> {
            var disableSetThis = objc_getAssociatedObject(self, &UIApplication.multiIdleDisableName) as? Set<String> ?? Set<String>()
            for key in disableSetOther {
                if disableSetThis.contains(key) == false {
                    disableSetThis.insert(key)
                }
            }
            objc_setAssociatedObject(self, &UIApplication.multiIdleDisableName, disableSetThis, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if disableSetThis.count > 0 , self.getRealMultiIdleTimerDisable() == false {
                self.setRealMultiIdleTimerDisable(true)
            }else if disableSetThis.count == 0 , self.getRealMultiIdleTimerDisable() == true {
                self.setRealMultiIdleTimerDisable(false)
            }
        }
    }
    
    @objc public func setRealMultiIdleTimerDisable(_ hidden:Bool) {
        UIApplication.shared.isIdleTimerDisabled = hidden
    }
    
    @objc public func getRealMultiIdleTimerDisable() -> Bool {
        return UIApplication.shared.isIdleTimerDisabled
    }
}
