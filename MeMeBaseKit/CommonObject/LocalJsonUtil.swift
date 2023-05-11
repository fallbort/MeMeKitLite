//
//  LocalJsonUtil.swift
//  LiveStream
//
//  Created by 邢海华 on 16/6/29.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

public class LocalJsonParser<E: Mappable> {

    public init() {
        
    }
	public func parseArray(_ dataPath: String, rootNote: String = "list") -> [E]? {
		let path = Bundle.main.path(forResource: dataPath, ofType: "json")
		let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!))
		do {
			let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: Any]
			let jsonArray = json[rootNote]
			return Mapper<E>().mapArray(JSONObject: jsonArray)
		} catch let error as NSError {
			print("parse error: \(error.localizedDescription)")
		}
		return nil
	}
    
    public func parseArray(jsonStr: String?, rootNote: String = "list") -> [E]? {
        guard let jsonStr = jsonStr else {
            return nil
        }
        do {
            let json = try JSONSerialization.jsonObject(with: jsonStr.data(using: String.Encoding.utf8)!, options: []) as! [String: Any]
            let jsonArray = json[rootNote]
            return Mapper<E>().mapArray(JSONObject: jsonArray)
        } catch let error as NSError {
            print("parse error: \(error.localizedDescription)")
        }
        return nil
    }

}
