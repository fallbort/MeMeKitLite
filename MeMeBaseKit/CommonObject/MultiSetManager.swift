//
//  MultiSetManager.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/4.
//

import Foundation

import Foundation
import Cartography
import MeMeKit

public func keyPathSetter<Object: AnyObject, Value>(
    for object: Object,
    keyPath: ReferenceWritableKeyPath<Object, Value>
) -> (Value) -> Void {
    return { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}

public func keyPathGetter<Object: AnyObject, Value>(
    for object: Object,
    keyPath: ReferenceWritableKeyPath<Object, Value>
) -> () -> Value? {
    return { [weak object] in
        return object?[keyPath: keyPath] as? Value
    }
}


public class MultiSetManager {
    public static let shared:MultiSetManager = MultiSetManager()
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    fileprivate init() {
        
    }
    //MARK: <>功能性方法
    
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}

public let MultiDefaultKey:String = "MultiDefaultKey"

extension MultiSetManager {
    private static var multiTrueSetKey:Int?
    private static var multiFalseSetKey:Int?
    //多值获取,true高优先级，比如isHiiden多个有一个是true,那么最终值是true,uniqueKey为唯一识别码
    public static func multiValueMixTrue<T: AnyObject>(uniqueKey:String,object:T,keyPath: ReferenceWritableKeyPath<T, Bool>) -> Bool {
        var valueSets = objc_getAssociatedObject(object, &MultiSetManager.multiTrueSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] ?? [:]
        if let valueSet = valueSets[keyPath] {
            return valueSet.contains(uniqueKey)
        }
        return false
    }
    //多值获取,false高优先级，比如isHiiden多个有一个是false,那么最终值是false,uniqueKey为唯一识别码
    public static func multiValueMixFalse<T: AnyObject>(uniqueKey:String,object:T,keyPath: ReferenceWritableKeyPath<T, Bool>) -> Bool {
        var valueSets = objc_getAssociatedObject(object, &MultiSetManager.multiFalseSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] ?? [:]
        if let valueSet = valueSets[keyPath] {
            return !(valueSet.contains(uniqueKey))
        }
        return true
    }
    
    //多值获取,true高优先级，比如isHiiden多个有一个是true,那么最终值是true,uniqueKey为唯一识别码
    public static func setMultiValueMixTrue<T: AnyObject>(uniqueKey:String,object:T,keyPath: ReferenceWritableKeyPath<T, Bool>,value:Bool) {
        var valueSets = objc_getAssociatedObject(object, &MultiSetManager.multiTrueSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] ?? [:]
        var valueSet = valueSets[keyPath] ?? Set<String>()
        var modified = false
        
        if value == true,valueSet.contains(uniqueKey) == false {
            modified = true
            valueSet.insert(uniqueKey)
        }else if value == false,valueSet.contains(uniqueKey) == true {
            modified = true
            valueSet.remove(uniqueKey)
        }
        if modified == true {
            valueSets[keyPath] = valueSet
            objc_setAssociatedObject(object, &MultiSetManager.multiTrueSetKey, valueSets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if valueSet.count > 0 , keyPathGetter(for: object, keyPath: keyPath)() == false {
            keyPathSetter(for: object, keyPath: keyPath)(true)
        }else if valueSet.count == 0 , keyPathGetter(for: object, keyPath: keyPath)() == true {
            keyPathSetter(for: object, keyPath: keyPath)(false)
        }
    }
    //多值获取,false高优先级，比如isHiiden多个有一个是true,那么最终值是true,uniqueKey为唯一识别码
    public static func setMultiValueMixFalse<T: AnyObject>(uniqueKey:String,object:T,keyPath: ReferenceWritableKeyPath<T, Bool>,value:Bool) {
        var valueSets = objc_getAssociatedObject(object, &MultiSetManager.multiFalseSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] ?? [:]
        var valueSet = valueSets[keyPath] ?? Set<String>()
        var modified = false
        
        if value == true,valueSet.contains(uniqueKey) == true {
            modified = true
            valueSet.remove(uniqueKey)
        }else if value == false,valueSet.contains(uniqueKey) == false {
            modified = true
            valueSet.insert(uniqueKey)
        }
        if modified == true {
            valueSets[keyPath] = valueSet
            objc_setAssociatedObject(object, &MultiSetManager.multiFalseSetKey, valueSets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if valueSet.count > 0 , keyPathGetter(for: object, keyPath: keyPath)() == true {
            keyPathSetter(for: object, keyPath: keyPath)(false)
        }else if valueSet.count == 0 , keyPathGetter(for: object, keyPath: keyPath)() == false {
            keyPathSetter(for: object, keyPath: keyPath)(true)
        }
    }
    //全部记录复制
    public static func copyMultiValueList<T: AnyObject>(from other:T?,to:T) {
        if let other = other {
            if let valueSetOthers = objc_getAssociatedObject(other, &MultiSetManager.multiTrueSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] {
                for (keyPath,valueSetOther) in valueSetOthers {
                    var valueSetTos = objc_getAssociatedObject(to, &MultiSetManager.multiTrueSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] ?? [:]
                    var valueSetTo:Set<String> = valueSetTos[keyPath] ?? Set<String>()
                    for key in valueSetOther {
                        if valueSetTo.contains(key) == false {
                            valueSetTo.insert(key)
                        }
                    }
                    valueSetTos[keyPath] = valueSetTo
                    objc_setAssociatedObject(to, &MultiSetManager.multiTrueSetKey, valueSetTos, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    if valueSetTo.count > 0 , keyPathGetter(for: to, keyPath: keyPath)() == false {
                        keyPathSetter(for: to, keyPath: keyPath)(true)
                    }else if valueSetTo.count == 0 , keyPathGetter(for: to, keyPath: keyPath)() == true {
                        keyPathSetter(for: to, keyPath: keyPath)(false)
                    }
                }
            }

            if let valueSetOthers = objc_getAssociatedObject(other, &MultiSetManager.multiFalseSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] {
                for (keyPath,valueSetOther) in valueSetOthers {
                    var valueSetTos = objc_getAssociatedObject(to, &MultiSetManager.multiFalseSetKey) as? [ReferenceWritableKeyPath<T, Bool>:Set<String>] ?? [:]
                    var valueSetTo:Set<String> = valueSetTos[keyPath] ?? Set<String>()
                    for key in valueSetOther {
                        if valueSetTo.contains(key) == false {
                            valueSetTo.insert(key)
                        }
                    }
                    valueSetTos[keyPath] = valueSetTo
                    objc_setAssociatedObject(to, &MultiSetManager.multiFalseSetKey, valueSetTos, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    if valueSetTo.count > 0 , keyPathGetter(for: to, keyPath: keyPath)() == true {
                        keyPathSetter(for: to, keyPath: keyPath)(false)
                    }else if valueSetTo.count == 0 , keyPathGetter(for: to, keyPath: keyPath)() == false {
                        keyPathSetter(for: to, keyPath: keyPath)(true)
                    }
                }
            }
        }
    }
    
}

