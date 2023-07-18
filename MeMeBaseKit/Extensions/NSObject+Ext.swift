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

public protocol MultiSetProtocol : AnyObject {
    
}

extension MultiSetProtocol {
    public func multiValueMixTrue<Self>(uniqueKey:String,keyPath: ReferenceWritableKeyPath<Self, Bool>) -> Bool where Self : AnyObject {
        return MultiSetManager.multiValueMixTrue(uniqueKey: uniqueKey, object: self as! Self, keyPath: keyPath)
    }
    //多值获取,false高优先级，比如isHiiden多个有一个是false,那么最终值是false,uniqueKey为唯一识别码
    public func multiValueMixFalse<Self>(uniqueKey:String,keyPath: ReferenceWritableKeyPath<Self, Bool>) -> Bool where Self : AnyObject {
        return MultiSetManager.multiValueMixFalse(uniqueKey: uniqueKey, object: self as! Self, keyPath: keyPath)
    }
    
    //多值获取,true高优先级，比如isHiiden多个有一个是true,那么最终值是true,uniqueKey为唯一识别码
    public func setMultiValueMixTrue<Self>(uniqueKey:String,keyPath: ReferenceWritableKeyPath<Self, Bool>,value:Bool) where Self : AnyObject {
        MultiSetManager.setMultiValueMixTrue(uniqueKey: uniqueKey, object: self as! Self, keyPath: keyPath, value: value)
    }
    //多值获取,false高优先级，比如isHiiden多个有一个是true,那么最终值是true,uniqueKey为唯一识别码
    public func setMultiValueMixFalse<Self>(uniqueKey:String,keyPath: ReferenceWritableKeyPath<Self, Bool>,value:Bool) where Self : AnyObject {
        MultiSetManager.setMultiValueMixFalse(uniqueKey: uniqueKey, object: self as! Self, keyPath: keyPath, value: value)
    }
    //全部记录复制
    public func copyMultiValueList<Self>(from other:Self?) where Self : AnyObject {
        MultiSetManager.copyMultiValueList(from: other, to: self as! Self)
    }
    
}

extension NSObject : MultiSetProtocol {
    
}


extension NSObject
{
    // MARK:返回className
    public var className:String{
        get{
          let name =  type(of: self).description()
            if(name.contains(".")){
                let names = name.components(separatedBy: ".")
                guard names.count > 0 else  { return "" }
                return names[1];
            }else{
                return name;
            }

        }
    }

}

extension NSObject {
    @objc public func convertToDictionary(string:String)->[String : Any] {
        let opt:JSONSerialization.ReadingOptions = []
        var dict:[String:Any] = [:]
        if string.count > 0,let data = string.data(using: .utf8) {
            do {
                dict = (try JSONSerialization.jsonObject(with: data, options: opt) as? [String: Any]) ?? [:]
            } catch {
                print(error.localizedDescription)
            }
        }
        return dict
    }
}
