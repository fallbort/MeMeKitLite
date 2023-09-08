//
//  LocalStoreCleanManager.swift
//  MeMe
//
//  Created by fabo on 2022/7/16.
//  Copyright © 2022 sip. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

@objc public class LocalStoreCleanManager : NSObject {
    @objc public static let share:LocalStoreCleanManager = LocalStoreCleanManager()
    //MARK: <>外部变量
    //MARK: <>外部block
    @objc public var clearExtraBlock:(()->())?
    
    //MARK: <>生命周期开始
    override init() {
        super.init()
    }
    //MARK: <>功能性方法
    @objc public func clean(execExtraBlock:VoidBlock? = nil) {
        clearExtraBlock?()
        clearAllUserDefaults()
        let urls:[URL] = [FileUtils.libraryDirectory,
                          FileUtils.cachesDirectory,
                          FileUtils.temporaryDirectory,
                          FileUtils.documentDirectory]
        
        for url in urls {
            let path = url.path
            FileUtils.forceRemoveDir(path)
        }
        execExtraBlock?()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { [weak self] in
            exit(0)
        }
    }
    
    fileprivate func clearAllUserDefaults() {
        Defaults.defaults.removeAll()
        Defaults.defaults.synchronize()
//        let userDefaults = UserDefaults.standard
//        let dics = userDefaults.dictionaryRepresentation()
//        for key in dics {
//            userDefaults.removeObject(forKey: key.key)
//        }
//        userDefaults.synchronize()
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}
