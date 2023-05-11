//
//  PointerArray+Extensions.swift
//  MeMe
//
//  Created by Mingde on 2017/10/10.
//  Copyright © 2017年 sip. All rights reserved.

/* Swift下的NSPointerArray扩展，便于用weak修饰Array的需要，如多个delegate的添加
 *
 * UnsafePointer - > http://swifter.tips/unsafe/
 * UnsafeMutablePointer -> http://www.jianshu.com/p/62354aea4034
 *
 */

import Foundation

extension NSPointerArray {
    
    public func addObject(_ object: AnyObject?) {
        guard let strongObject = object else {
            return
        }
        
        // 不能重复添加
        if isContainObject(object) {
            return
        }
        
        let unsafePointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(unsafePointer)
    }
    
    public func removeObject(_ object: AnyObject?) {
        var index: Int?
        
        //得找到对应对象
        let objectAddress = Unmanaged.passUnretained(object as AnyObject).toOpaque()
        for i in 0..<allObjects.count {
            let oneObjectPointer = pointer(at: i)
            if "\(oneObjectPointer)" == "\(objectAddress)" {
                index = i
            }
        }
        
        if let aIndex = index {
            guard aIndex < count else {
                return
            }
            //才能通过index移除
            removePointer(at: aIndex)
        }
    }
}

extension NSPointerArray {
   
    fileprivate func isContainObject(_ object: AnyObject?) -> Bool {
        var index: Int?
        
        //得找到对应对象
        for i in 0..<allObjects.count {
            if self.object(at: i)?.hash == object?.hash {
                index = i
            }
        }
        
        if let aIndex = index {
            guard aIndex < count else {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    fileprivate func object(at index: Int) -> AnyObject? {
        guard index < count else {
            return nil
        }
        
        return self.allObjects[index] as AnyObject
    }
    
}


