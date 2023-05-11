//
//  JsonUtil.swift
//  MeMe
//
//  Created by 邢海华 on 16/8/15.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

public class JsonUtil {

	public class func dicToJson(_ params: [String: Any]) -> String? {
		var jsonString: String?
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
			jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
		} catch {

		}
		return jsonString
	}

	public class func jsonToDic(_ jsonStr: String?) -> [String: Any]? {
		guard let jsonStr = jsonStr else {
			return nil
		}
		do {
			let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
			let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
			// //log.debug("\(jsonDictionary)")
			return jsonDictionary
		} catch {

		}
		return nil
	}

}

