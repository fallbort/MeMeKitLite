//
//  String+Extensions.swift
//
//  Created by Solomon English on 11/10/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import Foundation
import CommonCrypto
import YYImage
import YYText

public struct RegexHelper {
	public let regex: NSRegularExpression

	public init(_ pattern: String) throws {
		try regex = NSRegularExpression(pattern: pattern,
			options: .caseInsensitive)
	}

	public func match(_ input: String) -> Bool {
		let matches = regex.matches(in: input,
			options: [],
			range: NSMakeRange(0, input.count))
		return matches.count > 0
	}
}

infix operator =~: AdditionPrecedence
extension String {
	public static func =~ (lhs: String, rhs: String) -> Bool {
		do {
			return try RegexHelper(rhs).match(lhs)
		} catch _ {
			return false
		}
	}
}

public let unknown = "unknown"
infix operator ???: NilCoalescingPrecedence
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
	switch optional {
	case let value?: return String(describing: value)
	case nil: return defaultValue()
	}
}

extension String {
    public static func UUIDString() -> String {
		return UUID().uuidString
	}

    public func split(_ on: String) -> [String] {
		return (self as NSString).components(separatedBy: on)
	}

    public func splitOnFirst(_ string: String) -> [String] {
		let match = (self as NSString).range(of: string)
		if match.location != NSNotFound {
			let first = (self as NSString).substring(with: NSMakeRange(0, match.location))
			let second = (self as NSString).substring(with: NSMakeRange(match.location + match.length, ((self as NSString).length - match.location) - match.length))

			return [first, second]
		}

		return [self]
	}

    public func contains(_ find: String) -> Bool {
		return self.range(of: find) != nil
	}

    public func containsNormalized(_ find: String) -> Bool {
		return self.range(of: find, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil
	}


    /**
     替换所有匹配的字符串
     - parameter string: 被替换字符
     - parameter withString: 用来替换的字符
     - returns : 替换后的内容
     */
    public func replace(_ string: String, withString: String) -> String {
		return self.replacingOccurrences(of: string, with: withString)
	}
    
    /**
     只替换第一个匹配的字符串
     - parameter string: 被替换字符
     - parameter withString: 用来替换的字符
     - returns : 替换后的内容
     */
    public func replaceFirst(_ string: String, withString: String) -> String {
        return self.replacingOccurrences(of: string, with: withString,range: self.range(of: string))
    }

    public func replaceCf() -> String {
        return self.replacingOccurrences(of: "\\p{Cf}", with: "", options: .regularExpression)
    }

    public static func msTimeString(remainTime: TimeInterval) -> String {
		let minutes = floor(remainTime / 60)
		let seconds = round(remainTime - (minutes * 60))
		let timeString = String(format: "%02d:%02d", Int(minutes), Int(seconds))

		return timeString
	}
    
    public static func hmsTimeString(remainTime: TimeInterval) -> String {
        let hours = Int(remainTime/60.0/60.0)
        let hoursTime = TimeInterval(hours)*60.0*60.0
        let minutes = Int((remainTime - hoursTime)/60.0)
        let minutesTime = TimeInterval(minutes)*60.0
        let seconds = Int(remainTime - hoursTime - minutesTime)
        let timeString = String(format: "%02d:%02d:%02d", Int(hours), Int(minutes), Int(seconds))
        
        return timeString
    }
    
    public static func dhmsTimeString(remainTime: TimeInterval) -> String {
        let days = Int(remainTime/60.0/60.0/24)
        let daysTime = TimeInterval(days)*60.0*60.0*24
        let hours = Int((remainTime - daysTime)/60.0/60.0)
        let hoursTime = TimeInterval(hours)*60.0*60.0
        let minutes = Int((remainTime - daysTime - hoursTime)/60.0)
        let minutesTime = TimeInterval(minutes)*60.0
        let seconds = Int(remainTime - daysTime - hoursTime - minutesTime)
        let timeString = String(format: "%02d%@ %02d:%02d:%02d", Int(days), NELocalize.localizedString("forecast_day"), Int(hours), Int(minutes), Int(seconds))
        
        return timeString
    }

	// MARK : - Crypto

    public var md5: String? {
		guard let str = self.cString(using: String.Encoding.utf8) else {
			return nil
		}

		let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
		let digestLen = Int(CC_MD5_DIGEST_LENGTH)
		let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

		CC_MD5(str, strLen, result)

		let hash = NSMutableString()
		for i in 0 ..< digestLen {
			hash.appendFormat("%02x", result[i])
		}
//		result.deallocate(capacity: digestLen)
        result.deallocate()

		return hash as String
	}

    public func base64EncodeToData() -> Data? {
		return self.data(using: String.Encoding.utf8)?.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0))
	}
    
    public func base64EncodeToString() -> String? {
        return self.data(using: String.Encoding.utf8)?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    

	// MARK: - Hashtags

    public func toHashtagString() -> String {
		if isValidHashtag() {
			return self
		}

		let validCharacters = CharacterSet.alphanumerics
		let unwantedCharacters = validCharacters.inverted
		let components = self.components(separatedBy: unwantedCharacters)
		return components.joined(separator: "")
	}

    public func isValidHashtag() -> Bool {
		if isEmpty {
			return false
		}

		let validCharacters = CharacterSet.alphanumerics
		let unwantedCharacters = validCharacters.inverted
		if let range = rangeOfCharacter(from: unwantedCharacters) {
			return !range.isEmpty
		} else {
			return false
		}
	}

    public func isValidUsername() -> Bool {
		let usernameRegex = "[A-Z0-9a-z]{3,30}"
		let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [usernameRegex])

		return predicate.evaluate(with: self)
	}

    public func isValidEmail() -> Bool {
		return self =~ "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
	}

	// MARK: - UI

    public func widthWithFont(_ font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
		let attributedString = NSAttributedString(string: self, attributes: attributes)
		return attributedString.size().width
	}

    public func URLEncodedString() -> String {
		var output = ""
		for char in self {
			if char == " " {
				output += "+"
			} else if char == "." || char == "-" || char == "_" || char == "~"
			|| (char >= "a" && char <= "z")
			|| (char >= "A" && char <= "Z")
			|| (char >= "0" && char <= "9") {
				output += String(char)
			} else if let unicodeValue = String(char).unicodeScalars.first?.value {
				let hex = NSString(format: "%02X", unicodeValue)
				output += "%\(hex)"
			}
		}

		return output
	}
    
    public func escape() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
        } else {
            let batchSize = 50
            var index = self.startIndex
            
            while index != self.endIndex {
                let startIndex = index
                let endIndex = self.index(index, offsetBy: batchSize, limitedBy: self.endIndex) ?? self.endIndex
                let range = startIndex..<endIndex
                
                let substring = self.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }

    public func trim() -> String {
		return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
    public var UInt8Array: [UInt8] {
        let dataArray: [UInt8] = Array(self.utf8)
        return dataArray
    }
}

extension String {
    public mutating func uriIconed() {
        if self.count > 0 && !self.hasSuffix(".jpg") && !self.hasSuffix(".jpeg") && !self.hasSuffix(".png") && !self.hasSuffix(".gif") {
            self += "@\(Int(UIScreen.main.scale))x.png"
        }
    }
}

extension String {
    public func appendShadow(font:UIFont, color: UIColor = UIColor.white, shadowColor: UIColor = UIColor.hexString(toColor: "4A4A4A")!, kernAttribute: CGFloat = 0.5, size: CGSize = CGSize(width: 0, height: 1)) -> NSMutableAttributedString {
        let contentAttrString = NSMutableAttributedString(string: self)
        let shadow = String.textShadow(color: shadowColor, size: size)
        let contentAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.kern: kernAttribute, NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.backgroundColor: UIColor.hexString(toColor: "00000000")!, NSAttributedString.Key.shadow: shadow]
        contentAttrString.addAttributes(contentAttributes, range: NSMakeRange(0, contentAttrString.length))
        return contentAttrString
    }
    
    public static func textShadow(color: UIColor = UIColor.hexString(toColor: "4A4A4A")!, size: CGSize = CGSize(width: 0, height: 1)) -> NSShadow {
		let shadow = NSShadow()
		shadow.shadowColor = color
		shadow.shadowOffset = size
		return shadow
    }
    
}

extension String {
    
    public func mySubString(to index: Int) -> String {
        guard self.count > index, index >= 0 else {
            return ""
        }
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    public func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}

extension String {
    public func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize: CGSize = .zero
        if size.equalTo(.zero) {
            textSize = self.size(withAttributes: [NSAttributedString.Key.font: font])
        } else {
            let stringRect = self.boundingRect(with: size,
                                               options: .usesFontLeading,
                                               attributes: [NSAttributedString.Key.font: font],
                                               context: nil)
            textSize = stringRect.size
        }
		return textSize
    }
}

extension String {
    // get link
    public func getLinks() -> [NSTextCheckingResult]? {
        let regulaStr = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        
        let regex = try? NSRegularExpression.init(pattern: regulaStr, options: NSRegularExpression.Options.caseInsensitive)
        
        let nsString = self as NSString
        let matches = regex?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange.init(location: 0, length: nsString.length))
        
        return matches
    }
}

extension String {
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    public var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    public var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    public var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    public func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    public func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
}

///包含敏感词
extension String {
    public var containsEmoji:Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,  // Misc symbols
            0x2700...0x27BF,  // Dingbats
            0xFE00...0xFE0F:  // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
}

extension String {
    
    public func highLightString(highStr: String, highColor: UIColor, color: UIColor, font: UIFont) -> NSAttributedString {
        if let range = self.range(of: highStr), !range.isEmpty {
            let attributedString = NSMutableAttributedString(string: String(self[..<range.lowerBound]))
            attributedString.yy_color = color
            attributedString.yy_font = font
            let highString = NSMutableAttributedString(string: highStr)
            highString.yy_color = highColor
            highString.yy_font = font
            attributedString.append(highString)
            let tmp = NSMutableAttributedString(string: String(self[range.upperBound...]))
            tmp.yy_color = color
            tmp.yy_font = font
            attributedString.append(tmp)
            return attributedString
        } else {
            return NSAttributedString(string: self)
        }
    }
    
    ///（如果backwards参数设置为true，则返回最后出现的位置）
    public func positionOf(sub:String, backwards:Bool = false) -> Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
}

extension String{
    public func gradient(colors: [UIColor], font:UIFont)->UIImage? {
        if colors.count == 0 {
            return  nil
        }
        let name:String = NSAttributedString.Key.font.rawValue
        let textSize: CGSize = (self).size(withAttributes: [NSAttributedString.Key(rawValue: name):font])
        let width:CGFloat = textSize.width + 150        // max 1024 due to Core Graphics limitations
        let height:CGFloat = textSize.height       // max 1024 due to Core Graphics limitations
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!)
        var locations:[CGFloat] = []
        let rgbColorspace = CGColorSpaceCreateDeviceRGB()
        var ncolors =  [CGColor]()
        if textSize.width == 0 {
            return nil
        }
        let cha = width / textSize.width
        if cha < 1 {
            return nil
        }
        for _ in 1 ... Int(cha) {
            for color in  colors {
                ncolors.append(color.cgColor)
            }
        }
        
        for i in 0 ... ncolors.count {
            locations.append(CGFloat(i) * (1 / CGFloat(ncolors.count)))
        }
        if let glossGradient = CGGradient(colorsSpace: rgbColorspace, colors: ncolors as CFArray, locations: locations) {
            let topCenter = CGPoint(x: 0, y: 0);
            let bottomCenter = CGPoint(x: width, y: 0);
            context?.drawLinearGradient(glossGradient, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
            
            UIGraphicsPopContext()
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return  gradientImage
        }
        return  nil
    }
    
    public func gradientVertical(colors: [UIColor], inWidth: CGFloat, inHeight: CGFloat) -> UIImage? {
        if colors.count == 0 {
            return  nil
        }
        UIGraphicsBeginImageContext(CGSize(width: inWidth, height: inHeight))
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!)
        var locations:[CGFloat] = []
        let rgbColorspace = CGColorSpaceCreateDeviceRGB()
        var ncolors =  [CGColor]()
        for color in colors {
            ncolors.append(color.cgColor)
        }
        
        for i in 0 ..< ncolors.count {
            locations.append(CGFloat(i) * (1 / CGFloat(ncolors.count - 1)))
        }
        if let glossGradient = CGGradient(colorsSpace: rgbColorspace, colors: ncolors as CFArray, locations: locations) {
            let topCenter = CGPoint(x: inWidth/2, y: 0);
            let bottomCenter = CGPoint(x: inWidth/2, y: inHeight);
            context?.drawLinearGradient(glossGradient, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
            
            UIGraphicsPopContext()
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return  gradientImage
        }
        return  nil
    }
}

extension NSMutableAttributedString {
    
    open func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil) -> CGSize {
        let range = NSRange(location: 0, length: self.length)
        self.addAttributes([NSAttributedString.Key.font: font], range: range)
        if lineSpacing != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing!
            self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        let rect = self.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        var size = rect.size
        
        if let currentLineSpacing = lineSpacing {
            // 文本的高度减去字体高度小于等于行间距，判断为当前只有1行
            let spacing = size.height - font.lineHeight
            if spacing <= currentLineSpacing && spacing > 0 {
                size = CGSize(width: size.width, height: font.lineHeight)
            }
        }
        
        return size
    }
    
    open func boundingRect(with constrainedSize: CGSize, font: UIFont, lineSpacing: CGFloat? = nil, lines: Int) -> CGSize {
        if lines < 0 {
            return .zero
        }
        
        let size = boundingRect(with: constrainedSize, font: font, lineSpacing: lineSpacing)
        if lines == 0 {
            return size
        }
        
        let currentLineSpacing = (lineSpacing == nil) ? (font.lineHeight - font.pointSize) : lineSpacing!
        let maximumHeight = font.lineHeight*CGFloat(lines) + currentLineSpacing*CGFloat(lines - 1)
        if size.height >= maximumHeight {
            return CGSize(width: size.width, height: maximumHeight)
        }
        
        return size
    }
}

extension String {
    public func convertToDictionary(_ opt: JSONSerialization.ReadingOptions = [])->[String : Any?]? {
        if self.count > 0,let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: opt) as? [String: Any?]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func convert<T>(_ opt: JSONSerialization.ReadingOptions = [])->T? {
        if self.count > 0,let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: opt) as? T
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension String {
    public func getFormatContentType(params: [String]) -> String {
        var formatString: String = self
        for index in 0..<params.count {
            formatString = formatString.replace("%\(index+1)s", withString: "%\(index+1)@")
        }
        formatString = formatString.replace("%s", withString: "%@")
        do {
            let resultString: String = try String(format: formatString, arguments: params)
            return resultString
        } catch {
            return ""
        }
    }
}

// MARK:显示数值转换
extension String {
    public enum ShowType {
        case source    //原文字
        case dotPerThreeBit  //三数字一点 19,123
        case dotPerThreeBit_force  //截取其中数字做三数字一点 19,123位朋友
        case justTenThousandLocalize //多语言”万“  21.00万
        case justTenThousandLocalize2   //多语言”万“  21.00万,大于亿时显示亿
        case justTenThousandLocalizeNoble1 //多语言”万“,用于贵族1，奇怪的逻辑  21.00万
        case justTenThousandLocalizeNoble2 //多语言”万“,用于贵族2，奇怪的逻辑  21.00万
        case justTenThousandLocalizeNoble3 //多语言”万“,用于贵族3，奇怪的逻辑  21万
        case numWanAndYiLocalize(isZhAndJaLanguage:Bool) //显示万,亿;英文K,M
        case justTenThousand  //万 21W
        case justThousand  //千    21K
        case tenThousandAndThousand1  //k,w  100K ,100W,100k ~ 9999k 显示K，1000w ~ 9999w 显示W
        case timeHourMinute  //时分显示  19时0分
        case indeM(region:String?) // k, w, 大于100W印度区域显示M,其他区域显示W,对k为单位的小数点后一位数字进行四舍五入
        case communityDistance  //显示社区tab的距离
        case communityMomentTime  //显示社区动态时间
        case videoTime //视频显示的时间格式，122:33
        case k_And_M  //k,m,    1,000K 显示K,1,000M 显示M
        case historyTime(seprator:String) //当天：10:01,昨天：昨天10：01，前天：01/02.是否换行
        case tinyLocalizeTime //3分钟,6秒
    }
    
    //params: reserve,用于保留小数长度等
    public static func comfortShowString<T:CustomStringConvertible>(_ source:T,type:ShowType,reserve:Int? = nil) -> String {
        if let ret = comfortShowOptionalString(source, type: type,reserve: reserve) {
            return ret
        }
        return ""
    }
    
    //params: reserve,用于保留小数长度等
    public static func comfortShowOptionalString<T:CustomStringConvertible>(_ source:T?,type:ShowType,reserve:Int? = nil) -> String? {
        if source != nil {
            let str = "\(source!)"
            var dest:String = str
            if str.count > 0 {
                switch type {
                case .source:
                    return dest
                case .dotPerThreeBit:
                    let dot:Character = ","
                    if let _ = str.isPureInt64() {
                        let bits:Int = str.count
                        for i in (1...bits) {
                            if i % 3 == 1 && i != 1 {
                                dest.insert(dot, at: dest.index(dest.startIndex,offsetBy: bits - i + 1))
                            }
                        }
                    }
                case .dotPerThreeBit_force:
                    let dot:Character = ","
                    let bits:Int = str.count
                    var startBits = 0
                    for i in (1...bits) {
                        let oneChar = str.subString(start: bits - i, length: 1)
                        if let _ = oneChar.isPureInt() {
                            startBits += 1
                        }else {
                            startBits = 0
                        }
                        if startBits % 3 == 1 && startBits != 1 {
                            dest.insert(dot, at: dest.index(dest.startIndex,offsetBy: bits - i + 1))
                        }
                    }
                case let .numWanAndYiLocalize(isZhAndJaLanguage):
                    let reserve = reserve == nil ? 1 : reserve!
                    if let sourceInt = str.isPureInt64() {
                        if isZhAndJaLanguage {
                            if sourceInt > 99999999 {
                                dest = (CGFloat(sourceInt) / 100000000).format(reserve: reserve) + NELocalize.localizedString("number100million", comment: "")
                            }else if sourceInt > 9999 {
                                dest = (CGFloat(sourceInt) / 10000).format(reserve: reserve) + NELocalize.localizedString("noble_wan", comment: "")
                            }
                        }else{
                            if sourceInt > 999999 {
                                dest = (CGFloat(sourceInt) / 1000000).format(reserve: reserve) + NELocalize.localizedString("number100million", comment: "")
                            }else if sourceInt > 999 {
                                dest = (CGFloat(sourceInt) / 1000).format(reserve: reserve) + NELocalize.localizedString("noble_wan", comment: "")
                            }
                        }
                        
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justTenThousandLocalize:
                    let reserve = reserve == nil ? 2 : reserve!
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 9999 {
                            dest = (CGFloat(sourceInt) / 10000).format(reserve: reserve) + NELocalize.localizedString("noble_wan", comment: "")
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justTenThousandLocalize2:
                    let reserve = reserve == nil ? 2 : reserve!
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 99999999 {
                            dest = (CGFloat(sourceInt) / 100000000).format(reserve: reserve) + NELocalize.localizedString("number100million", comment: "")
                        }else if sourceInt > 9999 {
                            dest = (CGFloat(sourceInt) / 10000).format(reserve: reserve) + NELocalize.localizedString("noble_wan", comment: "")
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justTenThousandLocalizeNoble1:
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 9999999 {
                            dest = String(format: "%.2f", Float(sourceInt)/1000000) + NELocalize.localizedString("noble_wan", comment: "")
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justTenThousandLocalizeNoble2:
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 99999 {
                            dest = String(format: "%.2f", Float(sourceInt)/10000) + NELocalize.localizedString("noble_wan", comment: "")
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justTenThousandLocalizeNoble3:
                    if let sourceInt = str.isPureInt64() {
                        dest = "\(sourceInt / 10000)" + NELocalize.localizedString("noble_wan", comment: "")
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justTenThousand:
                    let reserve = reserve == nil ? 0 : reserve!
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 9999 {
                            dest = (CGFloat(sourceInt) / 10000).format(reserve: reserve) + "W"
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .justThousand:
                    let reserve = reserve == nil ? 0 : reserve!
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 999 {
                            dest = (CGFloat(sourceInt) / 1000).format(reserve: reserve) + "K"
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .tenThousandAndThousand1:
                    if let num = str.isPureInt64() {
                        // 100k ~ 999k && 1000k ~ 9999k
                        if num >= 100000 && num < 10000000 {
                            dest = String.comfortShowString(num, type: .justThousand)
                        }
                            // 1000w ~ 9999w
                        else if num >= 10000000 && num < 100000000 {
                            dest = String.comfortShowString(num, type: .justTenThousand)
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                    
                case .timeHourMinute:
                    if let sourceDouble = str.isPureInt64() {
                        dest = String(format: NELocalize.localizedString("list_hour", comment: ""), "\(sourceDouble / 60)") + String(format: NELocalize.localizedString("list_points", comment: ""), "\(sourceDouble % 60)")
                    }
                case let .indeM(region):
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 999999 {
                            if region == "India" {
                                dest = (CGFloat(sourceInt) / 1000000).format(reserve: 1) + "m"
                            } else {
                                dest = (CGFloat(sourceInt) / 10000).format(reserve: 1) + "w"
                            }
                        } else if sourceInt > 999 {
                            let roundNum = roundf(Float(sourceInt) / 100)
                            dest = (CGFloat(roundNum) / 10).sampleformat(reserve: 1) + "k"
                        }
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case .communityDistance:
                    if let sourceDouble = str.isPureDouble() {
                        if sourceDouble <= 1000.0 {
                            dest = "1.0km"
                        }else if sourceDouble < 100.0*1000.0 {
                            dest = String(format: "%.1fkm", Float(sourceDouble)/1000.0)
                        }else{
                            dest = ""
                        }
                    }
                case .communityMomentTime:
                    if let sourceDouble = str.isPureDouble() {
                        let curTime = Date().timeIntervalSince1970
                        let passed = curTime - sourceDouble
                        if passed < 60.0*60.0 {
                            var passed = Int(passed/60.0)
                            passed = passed < 1 ? 1 : passed
                            dest = String(format: NELocalize.localizedString("me_community_time1"), "\(passed)")
                        }else if passed < 6.0*60.0*60.0 {
                            var passed = Int(passed/3600.0)
                            passed = passed < 1 ? 1 : passed
                            dest = String(format: NELocalize.localizedString("me_community_time2"), "\(passed)")
                        }else{
                            dest = ""
                        }
                    }
                case .videoTime:
                    var timestamp:Double = 0
                    if let source = source as? Double {
                        timestamp = source
                    }else if let time = str.isPureDouble() {
                        timestamp = time
                    }
                    let second = Int(timestamp) % 60
                    let minitue = Int(timestamp) / 60
                    let tiemStr = "\(minitue > 9 ? "" : "0")\(minitue):\(second > 9 ? "" : "0")\(second)"
                    return tiemStr
                case .k_And_M:
                    let reserve = reserve == nil ? 1 : reserve!
                    if let sourceInt = str.isPureInt64() {
                        if sourceInt > 999999 {
                            dest = (CGFloat(sourceInt) / 1000000).format(reserve: reserve) + "M"
                        }else if sourceInt > 999 {
                            dest = (CGFloat(sourceInt) / 1000).format(reserve: reserve) + "K"
                        }
                        
                        dest = String.comfortShowString(dest, type: .dotPerThreeBit_force)
                    }
                case let .historyTime(seprator):
                    var timestamp:Double = 0
                    if let source = source as? Double {
                        timestamp = source
                    }else if let time = str.isPureDouble() {
                        timestamp = time
                    }
                    var prefixStr: String = ""
                    
                    let dateNow = Date()
                    let dateSelf = Date(timeIntervalSince1970: timestamp)
                    
                    let calendar = Calendar.current
                    
                    if calendar.isDateInToday(dateSelf) {
                        // 是今天
                        prefixStr = ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        dest = dateFormatter.string(from: dateSelf)
                    } else if calendar.isDateInYesterday(dateSelf) {
                        // 是昨天
                        prefixStr = NELocalize.localizedString("昨天", comment: "totest")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        dest = prefixStr + seprator + dateFormatter.string(from: dateSelf)
                    }else{
                        prefixStr = ""
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd"
                        dest = dateFormatter.string(from: dateSelf)
                    }
                case .tinyLocalizeTime:
                    dest = String.comfortShowString(str, type: .videoTime)
                }
            }
            return dest
        }
        return nil
    }
    
    public func isPureInt() -> Int? {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        let success = scan.scanInt(&val) && scan.isAtEnd
        if success == true {
            return val
        }else {
            return nil
        }
    }
    
    public func isPureInt64() -> Int64? {
        let scan: Scanner = Scanner(string: self)
        var val:Int64 = 0
        let success = scan.scanInt64(&val) && scan.isAtEnd
        if success == true {
            return val
        }else {
            return nil
        }
    }
    
    public func isPureDouble() -> Double? {
        let scan: Scanner = Scanner(string: self)
        var val:Double = 0
        let success = scan.scanDouble(&val) && scan.isAtEnd
        if success == true {
            return val
        }else {
            return nil
        }
    }
    
    //根据开始位置和长度截取字符串
    public func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    public func isContainCJKOrCNCharacter() -> Bool {
        let regulaStr = "(\\p{Han}|\\p{InCJK_Symbols_and_Punctuation}|\\p{Hangul}|\\p{Katakana}|\\p{Hiragana}|\\p{Bopomofo}|\\p{Tibetan}|\\p{Yi})"
        
        do {
            let regex = try? NSRegularExpression.init(pattern: regulaStr, options: NSRegularExpression.Options.caseInsensitive)
            
            if let matches = regex?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange.init(location: 0, length: self.count)), matches.count > 0 {
                return true
            }
            
        } catch {
//            //log.debug("isContainCJKOrCNCharacter RegularExpression error:\(error)")
        }
        
        return false
    }
    //获取按英文中文日文形式区分多语言省略,len代表英文形式的数字最大个数，其他语言减半
    public func getLocalOmitString(_ len:Int,withDot:Bool = true) -> String {
        var newText:Substring = self[self.startIndex...]
        if newText.count > len {
            if len > 0 {
                let first = newText.index(newText.startIndex, offsetBy: 0)
                let last = newText.index(newText.startIndex, offsetBy: len - 1)
                newText = newText[first...last]
            }else{
                newText = ""
            }
        }
        var needOmit = newText.count < self.count
        while newText.isNeedLocalOmit(len),newText.count > 0 {
            needOmit = true
            if newText.count > 1 {
                let last = newText.index(newText.endIndex, offsetBy: -1 )
                newText = newText[..<last]
            }else{
                newText = ""
            }
        }
        if needOmit,withDot == true {
            let newStr = "\(newText)..."
            return newStr
        }
        return String(newText)
    }
    
    public func isNeedLocalOmit(_ len:Int) -> Bool {
        var need = false
        var n = (self as NSString).length
        let m = self.utf8.count
        let chinese = (m - n) / 2
        let eng = (3*n - m) / 2
        if chinese*2 + eng > len {
            need = true
        }else{
            need = false
        }
        return need
    }
    
    public func getLocalOmitLen() -> Int {
        var len = 0
        var n = (self as NSString).length
        let m = self.utf8.count
        let chinese = (m - n) / 2
        let eng = (3*n - m) / 2
        len = chinese*2 + eng
        return len
    }
    
    public func hasSpecialCharacter() -> Bool {
        var pattern = "^.*([`~!@#$%^&*()+=|{}_\\-':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]).*"
        var pre = NSPredicate(format: "SELF MATCHES %@", pattern)
        let has = pre.evaluate(with: self)
        return has
    }
    
    public func exceptSepecialCharacter(_ maxLocalLen:Int) -> String {
        var newStr:String = ""
        var currentIndex = 0
        while currentIndex < self.count,(maxLocalLen > 0 && newStr.isNeedLocalOmit(maxLocalLen) == false) || maxLocalLen <= 0 {
            let subString = self.subString(start: currentIndex,length: 1)
            if subString.hasSpecialCharacter() == false {
                newStr += subString
            }
            currentIndex += 1
        }
        return newStr
    }
}

extension Substring {
    public func isNeedLocalOmit(_ len:Int) -> Bool {
        var need = false
        var n = (self as NSString).length
        let m = self.utf8.count
        let chinese = (m - n) / 2
        let eng = (3*n - m) / 2
        if chinese*2 + eng > len {
            need = true
        }else{
            need = false
        }
        return need
    }
    
    public func getLocalOmitLen() -> Int {
        var len = 0
        var n = (self as NSString).length
        let m = self.utf8.count
        let chinese = (m - n) / 2
        let eng = (3*n - m) / 2
        len = chinese*2 + eng
        return len
    }
}

extension String {
    public func converURL(assItems: [String: String]) -> URL? {
        guard let urlComps = NSURLComponents(string: self) else {
            return nil
        }
        var urlItems = [URLQueryItem]()
        for assItem in assItems {
            urlItems.append(URLQueryItem(name: assItem.key, value: assItem.value))
        }
        if let queryItems = urlComps.queryItems {
            for queryItem in queryItems {
                if assItems[queryItem.name] == nil {
                    urlItems.append(queryItem)
                }
            }
        }
        urlComps.queryItems = urlItems
        return urlComps.url
    }
}

extension String {
    public func base64Decoding() -> Data? {
        let decodeData = NSData.init(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        return decodeData as Data?
    }
}

extension String {
    //%1$,优化成%1$@
    public func formatLocalize() -> String {
        var newStr = self
        for index in 1..<10 {
            if newStr.contains("%\(index)$@") == false {
                newStr = newStr.replace("%\(index)$", withString: "%\(index)$@")
            }
        }
        return newStr
    }
}
