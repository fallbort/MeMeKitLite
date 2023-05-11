//
//  AESUtil.swift
//  LiveStream
//
//  Created by 邢海华 on 16/6/16.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

public class AESUtil {
	public class func encrypt(string: String, key: Data, iv: Data) -> Data {
		var enCtx = rijndael_context()
		var keyArray: [UInt8] = key.UInt8Array
		var ivArray: [UInt8] = iv.UInt8Array
		var dataInArray = string.UInt8Array
		rijndael_setup_encrypt(&enCtx, &keyArray, keyArray.count)

		var dataOutArray: [UInt8] = [UInt8](repeating: 0, count: dataInArray.count)
		var start: size_t = 0

		rijndael_cfb_encrypt(&enCtx, true, &dataInArray, &dataOutArray, dataInArray.count, &ivArray, &start)

		return Data(bytes: UnsafePointer<UInt8>(dataOutArray), count: dataOutArray.count)
	}

	public class func decrypt(data: Data, key: Data, iv: Data) -> String {
		var deCtx = rijndael_context()
		var dataInArray = data.UInt8Array
		var keyArray = key.UInt8Array
		var ivArrayDe = iv.UInt8Array
		rijndael_setup_encrypt(&deCtx, &keyArray, keyArray.count)

		var dataOutArray: [UInt8] = [UInt8](repeating: 0, count: dataInArray.count)
		var startDe: size_t = 0

		rijndael_cfb_encrypt(&deCtx, false, &dataInArray, &dataOutArray, dataInArray.count, &ivArrayDe, &startDe)

		if let outString = String(bytes: dataOutArray, encoding: String.Encoding.utf8) {
			return outString
		}
		return ""
	}
}
