//
//  NumberUtils.swift
//  MeMe
//
//  Created by LuanMa on 2016/10/26.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

public struct NumberUtils {
	public static func toUInt16(bytes: [UInt8]) -> UInt16 {
		var value: UInt16 = 0
		let size = MemoryLayout<UInt16>.size
		let count = min(size, bytes.count)
		for i in 0 ..< count {
			value |= UInt16(bytes[i]) << UInt16(i * 8)
		}
		return value
	}

	public static func toUInt32(bytes: [UInt8]) -> UInt32 {
		var value: UInt32 = 0
		let size = MemoryLayout<UInt32>.size
		let count = min(size, bytes.count)
		for i in 0 ..< count {
			value |= UInt32(bytes[i]) << UInt32(i * 8)
		}
		return value
	}

	public static func toUInt64(bytes: [UInt8]) -> UInt64 {
		var value: UInt64 = 0
		let size = MemoryLayout<UInt64>.size
		let count = min(size, bytes.count)
		for i in 0 ..< count {
			value |= UInt64(bytes[i]) << UInt64(i * 8)
		}
		return value
	}

}
