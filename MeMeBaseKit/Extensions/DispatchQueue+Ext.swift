//
//  DispatchQueue+Ext.swift
//  MeMe
//
//  Created by LuanMa on 2016/10/26.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

extension DispatchQueue {
	
	private static var _onceTracker = [String]()
	
	/**
	Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	
	- parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
	- parameter block: Block to execute once
	*/
	public class func once(token: String, block: VoidBlock) {
		objc_sync_enter(self)

		defer {
			objc_sync_exit(self)
		}
		
		if _onceTracker.contains(token) {
			return
		}
		
		_onceTracker.append(token)
		block()
	}
    
    public static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
