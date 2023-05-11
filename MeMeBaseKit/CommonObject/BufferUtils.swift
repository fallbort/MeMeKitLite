//
//  BufferUtils.swift
//  MeMe
//
//  Created by LuanMa on 2016/11/16.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

public typealias Byte = UInt8

public func toByteArray<T>(_ value: T) -> [UInt8] {
	var value = value
	return withUnsafeBytes(of: &value) { Array($0) }
}

public func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
	return value.withUnsafeBytes {
		$0.baseAddress!.load(as: T.self)
	}
}

