//
//  DeviceInfo.swift
//  FunPlusSDK
//
//  Created by Yuankun Zhang on 8/30/16.
//  Copyright © 2016 funplus. All rights reserved.
//

import Foundation
import UIKit
import AdSupport
import CoreTelephony
import SwiftyUserDefaults
import KeychainAccess

fileprivate extension DefaultsKeys {
    var deviceId: DefaultsKey<String?> { .init("meme.deviceId.new") }
}

// MARK: - DeviceInfo

public class DeviceInfo {

    /// Device's identifier for vendor or `nil`.
    static public let identifierForVendor: String? = {
        return UIDevice.current.identifierForVendor?.uuidString
    }()
    
    /// Device's advertising identifier or `nil`.
    static public let advertisingIdentifier: String? = {
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        
        let state: UIApplication.State = UIApplication.shared.applicationState
        
        if state != .background {
            // Chances to crash when calling this in background.
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        } else {
            return nil
        }
    }()
    
    /// Device's operating system name.
    static public let systemName: String = {
        return UIDevice.current.systemName
    }()

    /// Device's operating system version.
    static public let systemVersion: String = {
        return UIDevice.current.systemVersion
    }()
    
    /// Device's model name.
    static public let modelName: String = {
        return UIDevice.current.model
    }()
    
    /// App name or "Unknown".
    static public let appName: String = {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }()
    
    static public let appDisplayName: String = {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Unknown"
    }()
    
    /// App version or "1.0.0".
    static public let appVersion: String = {
#if os(macOS)
        return NSApplication.appVersion
#elseif os(iOS)
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(version) build \(build)"
#endif
    }()
    
    static public let appBuild: Int = {
        if let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let buildNumber = Int(buildString) {
            return buildNumber
        }
        return 0
    }()

    static public let appShortVersion: String = {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }()

    static public let appBundleID: String = {
        if let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            return bundleID
        }
        return ""
    }()
    
    /// App language. It might be different from the device's default language.
    static public let appLanguage: String = {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String ?? "en"
    }()
    
    /// Name of network carrier or "Unknown".
    static public let networkCarrierName: String = {
        return CTTelephonyNetworkInfo().subscriberCellularProvider?.carrierName ?? "Unknown"
    }()

    //缓存的deviceId
    static fileprivate var cacheDeviceId: String?
}

extension DeviceInfo {
    fileprivate static let keychainService: String = {
        return Bundle.main.bundleIdentifier!
    }()
    
    static public var deviceId: String {
        //缓存cacheId，减少deviceId的读取
        if let cacheDeviceId = cacheDeviceId {
            return cacheDeviceId
        }

        /* deviceId的key从3.1.2版本后，发生变化了，用新的逻辑去记录。
         之前的key叫meme.deviceId，现在叫meme.deviceId.new。
         */
        let keychain = Keychain(service: keychainService)
        // 先读缓存
        if let uuid = Defaults[\.deviceId], uuid != "00000000-0000-0000-0000-000000000000" {
            if keychain["deviceId"] != uuid {
                keychain["deviceId"] = uuid
            }

            cacheDeviceId = uuid

            return uuid
        }
        
        if let uuid = keychain["deviceId"], uuid != "00000000-0000-0000-0000-000000000000" {
            Defaults[\.deviceId] = uuid

            cacheDeviceId = uuid

            return uuid
        }
        
        // 无缓存，先读IDFA
        if let uuid = DeviceInfo.advertisingIdentifier, uuid != "00000000-0000-0000-0000-000000000000" {
            Defaults[\.deviceId] = uuid
            keychain["deviceId"] = uuid

            cacheDeviceId = uuid

            return uuid
        }
        
        // 无缓存，无IDFA，读IDFV，重装会变
        if let uuid = DeviceInfo.identifierForVendor, uuid != "00000000-0000-0000-0000-000000000000" {
            Defaults[\.deviceId] = uuid
            keychain["deviceId"] = uuid

            cacheDeviceId = uuid

            return uuid
        }
        
        // 啥也没有，自己弄个UUID，m重装会变
        let uuid = UUID().description
        Defaults[\.deviceId] = uuid
        keychain["deviceId"] = uuid

        cacheDeviceId = uuid

        return uuid
    }
}
