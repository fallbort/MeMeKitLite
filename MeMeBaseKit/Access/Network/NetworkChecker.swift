//
//  NetworkChecker.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/5.
//

import Foundation
import CoreTelephony

public class NetworkChecker : NSObject {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    override init() {
        super.init()
    }
    //MARK: <>功能性方法
    public static func isNetworkPermissions() -> Bool {
        var isNetworkPermissions:Bool = false
        let cellularData = CTCellularData()
        ///线程信号量
        let semaphore = DispatchSemaphore(value: 0)
        
        cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
            if state == .notRestricted {
                isNetworkPermissions = true
                
            } else  {
                isNetworkPermissions = false
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return isNetworkPermissions
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}
