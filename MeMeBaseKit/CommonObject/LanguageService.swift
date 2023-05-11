//
//  LanguageService.swift
//  LiveStream
//
//  Created by LuanMa on 16/6/20.
//  Copyright © 2016年 sip. All rights reserved.
//

@objc public class LanguageService: NSObject {
    
    public static let en     = "en"
    public static let zhHant = "zh-tw"
    public static let zhHK   = "zh-tw"
    public static let zhTW   = "zh-tw"
    public static let zhHans = "zh-cn"
    public static let ja     = "ja-jp"
    public static let id     = "id"
    public static let hi     = "hi"
    public static let te     = "te-IN"
    public static let mr     = "mr-IN"
    public static let ta     = "ta-IN"
    public static let kn     = "kn-IN"

    
    public enum LanguageKey: String {
        case en = "en"
        case zhHant = "zh-Hant"
        case zhHK   = "zh-HK"
        case zhTW   = "zh-TW"
        case zhHans = "zh-Hans"
        case ja     = "ja"
        case id     = "id-ID"
        case hi     = "hi"
        case te     = "te-IN"
        case mr     = "mr-IN"
        case ta     = "ta-IN"
        case kn     = "kn-IN"
    }
    // 服务端语言code 转本地语言code
    public static let codeToLanguageMap = ["en": "en",
                              "zh-tw": "zh-Hant",
                              "zh-cn": "zh-Hans",
                              "id-id": "id",
                              "ja-jp": "ja",
                              "hi-in": "hi",
                              "te-in": "te-IN",
                              "mr-in": "mr-IN",
                              "ta-in": "ta-IN",
                              "kn-in": "kn-IN",
    ]
    // 目前传的"语言码"
    public static let LanguageMap = ["en": "en",
                              "zh-Hant": "zh-tw",
                              "zh-HK": "zh-tw",
                              "zh-TW": "zh-tw",
                              "zh-Hans": "zh-cn",
                              "id": "id-id",
                              "ja": "ja-jp",
                              "hi": "hi-in",
                              "te-IN": "te-in",
                              "mr-IN": "mr-in",
                              "ta-IN": "ta-in",
                              "kn-IN": "kn-in",
    ]
    
    public static let LanguageToCountryMap = ["zh-Hant": "TW",
                                 "zh-HK": "TW",
                                 "zh-TW": "TW",
                                 "zh-Hans": "CN",
                                 "id":"ID",
                                 "ja": "JP",
                                 "hi": "IN",
                                 "te-IN": "IN",
                                 "mr-IN": "IN",
                                 "ta-IN": "IN",
                                 "kn-IN": "IN",
    ]
    
    // zendesk传的"语言码"
	private static let ZendeskMap = ["en": "en",
	                                   "zh-Hans": "zh-Hans",
	                                   "zh-Hant": "zh-Hant",
	                                   "zh-HK": "zh-Hant",
	                                   "zh-TW": "zh-Hant",
                                       "id": "en",
                                       "ja": "ja",
                                       "hi": "hi-IN",
                                       "te-IN": "te-IN",
                                       "mr-IN": "mr-IN",
                                       "ta-IN": "ta-IN",
                                       "kn-IN": "kn-IN",]
    
    // MemeInGame传的"语言码"
    private static let MemeInGameMap = ["en": "en-US",
                                       "zh-Hans": "zh-CN",
                                       "zh-Hant": "zh-TW",
                                       "zh-HK": "zh-TW",
                                       "zh-TW": "zh-TW",
                                       "id": "id-ID",
                                       "ja": "ja-JP",
                                       "hi": "hi-IN",
                                       "te-IN": "te-IN",
                                       "mr-IN": "mr-IN",
                                       "ta-IN": "ta-IN",
                                       "kn-IN": "kn-IN",]
   
    @objc public static var currentLanguageCode: String  {
        set {
            
        }get {
            return findLanguageCode(from: LanguageMap)
        }
    }
    public class func zendeskLanguageCode() -> String {
        return findLanguageCode(from: ZendeskMap)
    }
    
    public class func memeInGameLanguageCode() -> String {
        return findLanguageCode(from: MemeInGameMap)
    }
    
    public class func resetCurrentLanguageCode() {
    }
    
    @objc public static func findCountryByLanguageCode() -> String {
         if NELocalize.isUsingCustomSetting(), Locale.current.regionCode == "IN" {
            return "IN"
        }
        for var preferredLang in Locale.preferredLanguages {
            while !preferredLang.isEmpty {
                if let value = LanguageToCountryMap[preferredLang] {
                    return value
                } else {
                    if let range = preferredLang.range(of: "-", options: .backwards) {
                        preferredLang = String(preferredLang[..<range.lowerBound])
                    } else {
                        break
                    }
                }
            }
        }
        return "TW"
    }
    public class  func currentSettingLanguageCode() -> String {
        return findLanguageCode(from: LanguageMap)
    }
    private static func findLanguageCode(from languageMap: [String: String]) -> String {
        
        // 如果存在自定义语言项，使用自定义语言项覆盖"跟随系统"的。
        if NELocalize.isUsingCustomSetting() {
            let languageCustom =  NELocalize.currentSettingLanguage()
            if let value = languageMap[languageCustom] {
                return value
            }
        }
        
        for var preferredLang in Locale.preferredLanguages {
            while !preferredLang.isEmpty {
                if let value = languageMap[preferredLang] {
                    return value
                } else {
                    if let range = preferredLang.range(of: "-", options: .backwards) {
                        preferredLang = String(preferredLang[..<range.lowerBound])
                    } else {
                        break
                    }
                }
            }
        }
        
        return languageMap["en"] ?? "en"
    }
    
    public class func isChineseLanguage() -> Bool {
        if LanguageService.currentLanguageCode == LanguageService.zhHant ||
            LanguageService.currentLanguageCode == LanguageService.zhHK ||
            LanguageService.currentLanguageCode == LanguageService.zhTW ||
            LanguageService.currentLanguageCode == LanguageService.zhHans {
            return true
        }
        
        return false
    }
    
    public class func isZhAndJaLanguage() -> Bool {
        if LanguageService.currentLanguageCode == LanguageService.zhHant ||
            LanguageService.currentLanguageCode == LanguageService.zhHK ||
            LanguageService.currentLanguageCode == LanguageService.zhTW ||
            LanguageService.currentLanguageCode == LanguageService.zhHans ||
            LanguageService.currentLanguageCode == LanguageService.ja {
            return true
        }
        
        return false
    }
}

public struct LanguagesStruct {
    public var languages: [String: [String: String]]?
    public var languages2: [String: String]?
    private var _title: String?
    public var title: String {
        get {
            if let _title = _title {
                return _title
            }
            return  languages?[LanguageService.currentLanguageCode]?["title"] ?? languages?["en"]?["title"] ?? ""
        }
        set {
            _title = newValue
        }
    }
    
    public var currentValue: String? {
        get {
            return languages2?[LanguageService.currentLanguageCode] ?? languages2?["en"] ?? languages2?.first?.1
        }
    }
    
    public init() {
        
    }
    
    public init(json: String) {
        let data = json.data(using: String.Encoding.utf8)
        if let data = data,
            let dict = try? JSONSerialization.jsonObject(
                with: data,
                options: .mutableContainers) as? [String : String] {
              languages2 = dict
        }
    }
}


