//
//  Dictionary+Merge.swift
//  MeMe
//
//  Created by FengMengtao on 2016/12/3.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    public mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    public func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
    
    public mutating func removeAllValues<T:Equatable>(value removeValue:T) {
        let newDict = self.allValuesDict(value:removeValue)
        for key in Array(newDict.keys) {
            self.removeValue(forKey: key)
        }
    }
    
    public func allValuesDict<T:Equatable>(value outValue:T) -> Self {
        let newDict = self.filter { (key,value) -> Bool in
            if let value = value as? T, value == outValue {
                return true
            }else{
                return false
            }
        }
        return newDict
    }
    
    public func toJsonString() -> String? {
        do {
            let jsondata = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            let str = NSString.getFromNoCrash(jsondata, encoding: String.Encoding.utf8.rawValue) as String?
            return str
        } catch let error {
//            log.verbose("\(error)")
            return nil
        }
    }
}
