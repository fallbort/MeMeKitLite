//
//  Data+Ext.swift
//  LiveStream
//
//  Created by 邢海华 on 16/6/17.
//  Copyright © 2016年 sip. All rights reserved.
//  
//  http://stackoverflow.com/questions/37922333/how-to-append-int-to-the-new-data-struct-swift-3
//

import CommonCrypto

public protocol BinaryConvertible {
	init()
}

extension Int: BinaryConvertible {}
extension UInt: BinaryConvertible {}
extension UInt8: BinaryConvertible {}
extension UInt16: BinaryConvertible {}
extension UInt32: BinaryConvertible {}
extension UInt64: BinaryConvertible {}
extension Int8: BinaryConvertible {}
extension Int16: BinaryConvertible {}
extension Int32: BinaryConvertible {}
extension Int64: BinaryConvertible {}

extension Data {
	public var UInt8Array: [UInt8] {
		let count = self.count / MemoryLayout<UInt8>.size
		var dataInArray = [UInt8](repeating: 0, count: count)
		(self as NSData).getBytes(&dataInArray, length: count * MemoryLayout<UInt8>.size)
		return dataInArray
	}

    public func toHexString() -> String {
        let tokenChars = (self as NSData).bytes.bindMemory(to: CChar.self, capacity: self.count)
        var tokenString = ""
        for i in 0..<self.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }

        return tokenString
    }

    @discardableResult
    public func write(toFile filepath: String) -> Bool {
		let fileURL = URL(fileURLWithPath: filepath, isDirectory: false)
		do {
			try self.write(to: fileURL)
			return true
		} catch {
//            log.verbose("\(error)")
		}

		return false
	}

	public func extract<T: BinaryConvertible>(index: Int) -> T {
		let startIndex = index
		let endIndex = startIndex + MemoryLayout<T>.size

		var output = T()
		let buffer = UnsafeMutableBufferPointer(start: &output, count: 1)
		let _ = copyBytes(to: buffer, from: startIndex ..< endIndex)

		return output
	}
	
	public mutating func appendValue<SourceType>(_ newElement: SourceType) {
		var value = newElement
		let buffer = UnsafeBufferPointer(start: &value, count: 1)
		append(buffer)
	}
}

extension Data {
    public func getMD5String() -> String {
      var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
      _ = withUnsafeBytes { (bytes) in
        CC_MD5(bytes, CC_LONG(count), &digest)
      }
      var digestHex = ""
      for index in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
        digestHex += String(format: "%02x", digest[index])
      }
      return digestHex
    }
}

extension Data {
    public func convertToDictionary(_ opt: JSONSerialization.ReadingOptions = [])->[String : Any?]? {
        let data = self
        if data.count > 0 {
            do {
                return try JSONSerialization.jsonObject(with: data, options: opt) as? [String: Any?]
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }else{
            return nil
        }
        
    }
    
    public func convert<T>(_ opt: JSONSerialization.ReadingOptions = [])->T? {
        let data = self
        if data.count > 0 {
            do {
                return try JSONSerialization.jsonObject(with: data, options: opt) as? T
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }else{
            return nil
        }
        
    }
}
