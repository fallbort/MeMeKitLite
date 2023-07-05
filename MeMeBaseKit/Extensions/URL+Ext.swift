//
//  URL+Ext.swift
//  MeMe
//
//  Created by LuanMa on 2016/11/13.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation
import MeMeKit

extension NSURL {
    @objc public class func objc_url(withStringByImg stringByImg: String) -> NSURL? {
        return NSURL(string: MeMeKitConfig.converCDNBlock(stringByImg))
    }
}

extension URLRequest {
    public func getHTML(content: @escaping (String?) -> Void) {
        let task = URLSession.shared.dataTask(with: self) { Data, URLResponse, Error in
            if let data = Data, let html = String(data: data, encoding: String.Encoding.utf8) {
                content(html)
            } else {
                content(nil)
            }
        }
        task.resume()
    }
}


extension URL {
    fileprivate static var _documentsDirectory: String?
    
    static public func plistURL(path: String = "") -> URL {
        var documentsDirectory:String = ""
        if let dict = _documentsDirectory {
            documentsDirectory = dict
        }else{
            documentsDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
            if Thread.isMainThread {
                _documentsDirectory = documentsDirectory
            } else {
                DispatchQueue.main.sync {
                    _documentsDirectory = documentsDirectory
                }
            }
        }
        return URL(fileURLWithPath: documentsDirectory).appendingPathComponent("\(path).plist")
    }
    
    public init?(stringByImg: String) {
        self.init(string: MeMeKitConfig.converCDNBlock(stringByImg))
    }
    
    public var queryMap: [String: String]? {
		if let query = query {
			var map = [String: String]()
			let components = query.components(separatedBy: "&")
			for component in components {
				let fields = component.components(separatedBy: "=")
				if fields.count >= 2 {
					map[fields[0]] = fields[1]
				}
			}
			return map
		}
		return nil
	}
    
    /*******工程内所有分享与跳转web页统一增加参数（去重）*******/
    public func packaging() -> URL {
        if let url = MeMeKitConfig.converH5Block(self.absoluteString) {
            return url
        }
        return self
    }
    public func getURLParameter()->[String: String]{
        var parameter = [String: String]()
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems {
            for queryItem in queryItems {
                if let strValue = queryItem.value {
                    parameter[queryItem.name] = strValue
                }
            }
        }
        return parameter
    }
}
