//
//  AtomBool.swift
//  LiveCap
//
//  Created by LuanMa on 16/4/27.
//  Copyright © 2016年 FunPlus. All rights reserved.
//

import UIKit

open class AtomValue<T: Equatable> {
	fileprivate var item: T
	fileprivate let locker = NSLock()

	public init(_ value: T) {
		self.item = value
	}

	public var value: T {
		get {
			return item
		}
		set {
			locker.lock()
			defer {
				locker.unlock()
			}

			item = newValue
		}
	}

	public func compareAndSet(_ expect: T, update: T) -> Bool {
		locker.lock()
		defer {
			locker.unlock()
		}

		if expect == item {
			item = update
			return true
		} else {
			return false
		}
	}

	public func getAndSet(_ update: T) -> T {
		locker.lock()
		defer {
			locker.unlock()
		}

		let result = item
		item = update
		return result
	}

	public func get() -> T {
		locker.lock()
		defer {
			locker.unlock()
		}

		return item
	}

	public func set(_ value: T) {
		locker.lock()
		defer {
			locker.unlock()
		}

		item = value
	}
}

extension AtomValue: CustomStringConvertible {
	public var description: String { return "\(item)" }
}
