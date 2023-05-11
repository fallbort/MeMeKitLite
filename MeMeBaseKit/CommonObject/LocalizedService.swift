//
//  LocalizedService.swift
//  MeMe
//
//  Created by Mingde on 24/01/2018.
//  Copyright © 2018 sip. All rights reserved.
//

public extension LocalizedService {
    static let zh_Hant_Default = "zh-Hant_Default"
    static let zh_Hans_Default = "zh-Hans_Default"
    static let en_Default = "en_Default"
    static let ja_Default = "ja_Default"
    static let id_Default = "id_Default"
    static let hi_Default = "hi_Default"
    static let ta_Default = "ta-IN_Default"
    static let te_Default = "te-IN_Default"
    static let kn_Default = "kn-IN_Default"
    static let mr_Default = "mr-IN_Default"
}

public class LocalizedService {
    public class func eventOperationString(_ key: String, _ arguments: CVarArg... ) -> String {
        // 第一维度，用户终身分区（）没有小语种了  不判断了
//        if LocalUserService.countryRegionCode == "IN" {
//            return String(format: NSLocalizedString(key, tableName: LocalizedService.en_IN, bundle: .main, value: "", comment: ""),arguments: arguments)
//        }
        
        // 第二维度，系统语言
        switch LanguageService.currentLanguageCode {
        // 繁中
        case "zh-tw":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.zh_Hant_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        // 简中
        case "zh-cn":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.zh_Hans_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        // 日语
        case "ja-jp":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.ja_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        case "id":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.id_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        case "hi-in":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.hi_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        case "ta-in":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.ta_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        case "te-in":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.te_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        case "kn-in":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.kn_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        case "mr-in":
            return String(format: NSLocalizedString(key, tableName: LocalizedService.mr_Default, bundle: .main, value: "", comment: ""),arguments: arguments)
        // 英语
        default:
            return String(format: NSLocalizedString(key, tableName:LocalizedService.en_Default, bundle: .main, value:"", comment: ""),
                          arguments: arguments)
        }
    }
}
