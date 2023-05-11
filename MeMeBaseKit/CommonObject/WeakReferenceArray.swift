//
//  WeakReferenceArray.swift
//  MeMe
//
//  Created by Mingde on 2017/10/11.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit

public class WeakReferenceArray<T> {
    
    private var weakArray = NSPointerArray(options: .weakMemory)
    
    fileprivate var rwLock = pthread_rwlock_t()
    
    deinit {
        pthread_rwlock_destroy(&rwLock)
    }
    
    public init() {
        pthread_rwlock_init(&rwLock, nil)
    }
    
    public func addObject(_ item: T) {
        pthread_rwlock_wrlock(&rwLock)
        weakArray.addObject(item as AnyObject)
        pthread_rwlock_unlock(&rwLock)
    }
    
    public func removeObject(_ item: T) {
        pthread_rwlock_wrlock(&rwLock)
        weakArray.removeObject(item as AnyObject)
        pthread_rwlock_unlock(&rwLock)
    }
    
    public func count() -> Int {
        pthread_rwlock_rdlock(&rwLock)
        let count = weakArray.count
        pthread_rwlock_unlock(&rwLock)
        return count
    }
    
    public func excuteObject(_ block:@escaping ((T?)->Void)) {
        pthread_rwlock_rdlock(&rwLock)
        let objects = weakArray.allObjects  //防止多线程中迭代时变化
        pthread_rwlock_unlock(&rwLock)
        objects.forEach({
            block($0 as? T)
        })
    }
    
    public func reverseExcuteObject(_ block:@escaping ((T?)->Void)) {
        pthread_rwlock_rdlock(&rwLock)
        let count: Int = weakArray.count
        let objects = weakArray.allObjects.reversed()
        pthread_rwlock_unlock(&rwLock)
        if count >= 1 {
            objects.forEach({
                block($0 as? T)
            })
        }
    }
    
    
    public func excuteObjectWithIndex(_ block:@escaping ((T?,Int)->Void)) {
        let objects = weakArray.allObjects  //防止多线程中迭代时变化
        var idx = 0
        objects.forEach({
            block($0 as? T,idx)
            idx += 1
        })
    }
    
    public func reverseExcuteObjectWithIndex(_ block:@escaping ((T?,Int)->Void)) {
        let count: Int = weakArray.count
        
        guard count >= 1 else {
            return
        }
        var idx = count - 1
        let objects = weakArray.allObjects.reversed()
        objects.forEach({
            block($0 as? T,idx)
            idx -= 0
        })
    }
    
    public func allObjects() -> [Any] {
        pthread_rwlock_rdlock(&rwLock)
        let objects = weakArray.allObjects
        pthread_rwlock_unlock(&rwLock)
        return objects
    }
}
