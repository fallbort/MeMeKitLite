//
//  NSObject+BlockObserver.swift
//
//  Created by Solomon English on 11/12/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import Foundation

open class BlockObserver: NSObject {
	let path: String
	
	fileprivate let callback: (Any?) -> Void
	
	public init(path: String, cb: @escaping (Any?) -> Void) {
		self.callback = cb
		self.path = path
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let path = keyPath , path == self.path {
			callback(change?[NSKeyValueChangeKey.newKey])
		}
	}
	
	deinit {
//		log.verbose("deinit: BlockObserver (\(self.path))")
	}
}

open class GenericBlockObserver<T>: NSObject {
	let path: String
	
	fileprivate let callback: (T) -> Void
	
	public init(path: String, cb: @escaping (T) -> Void){
		self.callback = cb
		self.path = path
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let path = keyPath, let val = change?[NSKeyValueChangeKey.newKey] as? T , path == self.path {
			callback(val)
		}
	}
	
	deinit {
//		log.verbose("deinit: GenericBlockObserver (\(self.path))")
	}
}

public extension NSObject {
	public func addBlockObserver(_ path: String, sub: @escaping (Any?) -> Void) -> BlockObserver {
		let wrapped = BlockObserver(path: path, cb: sub)
		self.addObserver(wrapped, forKeyPath: path, options: NSKeyValueObservingOptions.new, context: nil)
		
		return wrapped
	}
	
	public func addBlockObserver<T>(_ path: String, sub: @escaping (T) -> Void) -> GenericBlockObserver<T> {
		let wrapped = GenericBlockObserver<T>(path: path, cb: sub)
		self.addObserver(wrapped, forKeyPath: path, options: NSKeyValueObservingOptions.new, context: nil)
		
		return wrapped
	}
	
	public func removeBlockObserver(_ observer: BlockObserver) {
		self.removeObserver(observer, forKeyPath: observer.path)
	}
	
	public func removeBlockObserver<T>(_ observer: GenericBlockObserver<T>) {
		self.removeObserver(observer, forKeyPath: observer.path)
	}
}

public extension NSObject {
    static func getAddress(_ object:Any) -> String {
        let address = Unmanaged.passUnretained(object as AnyObject).toOpaque()
        return "\(address)"
    }
    
    @objc public func getAddress() -> String {
        return Self.getAddress(self)
    }
}
