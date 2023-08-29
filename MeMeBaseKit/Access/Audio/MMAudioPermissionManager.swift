//
//  MMAudioPermissionManager.swift
//  MeMeBaseComponents
//
//  Created by fabo on 2022/5/6.
//

import Foundation
import AVFoundation
import SwiftyUserDefaults

fileprivate extension DefaultsKeys {
    static let audioRequested = DefaultsKey<Bool>("meme.broadcast.audioRequested", defaultValue: false)
}

/// 直播视频设置
public class MMAudioPermissionManager {
    static var isAudioRequested: Bool {
        let result = Defaults[key: DefaultsKeys.audioRequested]
        Defaults[key: DefaultsKeys.audioRequested] = true
        return result
    }
    
    public static var hasMicrophonePermission: Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    
    public class func noMicrophonePermission(cancelCompletion: VoidBlock? = nil, confirmCompletion: VoidBlock? = nil) {
        let appname = DeviceInfo.appDisplayName
        let title = String(format: NELocalize.localizedString("System prevents %@ to access microphone",bundlePath: MeMeKitBundle, comment: ""), appname)
        let message = String(format: NELocalize.localizedString("To grant the permission: settings -> %@ -> microphone",bundlePath: MeMeKitBundle, comment: ""), appname)
        showAuthorizeSettings(title, message: message, cancelCompletion: cancelCompletion, confirmCompletion: confirmCompletion)
    }
    //isblock,cancelIsBlock,阻止回调继续
    public class func requestMicrophonePermission(isBlock:Bool = true,isShow:Bool = true,cancelIsBlock:Bool = true,complection: @escaping ((Bool)->())) {
        AVAudioSession.sharedInstance().requestRecordPermission() { enabled in
            main_async() {
                let oldRequested = isAudioRequested
                if enabled {
                    complection(true)
                } else if oldRequested || cancelIsBlock == false {
                    if isShow == true && oldRequested {
                        var hasCompleted = false
                        if cancelIsBlock == false,isBlock == false {
                            hasCompleted = true
                            complection(enabled)
                        }
                        let appname = DeviceInfo.appDisplayName
                        let title = String(format: NELocalize.localizedString("System prevents %@ to access microphone",bundlePath: MeMeKitBundle, comment: ""), appname)
                        let message = String(format: NELocalize.localizedString("To grant the permission: settings -> %@ -> microphone",bundlePath: MeMeKitBundle, comment: ""), appname)
                        showAuthorizeSettings(title, message: message) {
                            if hasCompleted == false, cancelIsBlock == false {
                                complection(enabled)
                            }
                        } confirmCompletion: {
                            if hasCompleted == false, isBlock == false {
                                complection(enabled)
                            }
                        }
                    }else{
                        if isBlock == false {
                            complection(enabled)
                        }
                    }
                }
            }
        }
    }
    
    public class func requestMicrophonePermissionWithAnswer(complection: @escaping ((Bool)->Void)) {
        AVAudioSession.sharedInstance().requestRecordPermission() { enabled in
            main_async() {
                complection(enabled)
            }
        }
    }
    
    fileprivate class func showAuthorizeSettings(_ title: String, message: String, cancelCompletion: VoidBlock? = nil, confirmCompletion: VoidBlock? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: NELocalize.localizedString("Cancel",bundlePath: MeMeKitBundle, comment: ""), style: .cancel) { action in
            cancelCompletion?()
        }
        let actionSet = UIAlertAction(title: NELocalize.localizedString("Settings",bundlePath: MeMeKitBundle, comment: ""), style: .default) { action in
            if let URL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(URL)
            }
            confirmCompletion?()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionSet)
        let vc = ScreenUIManager.topViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
    
    
    public class func setAllowHaptics(key:String,_ enable:Bool) {
        if enable == true {
            allowHapticsList[key] = enable
        }else {
            allowHapticsList.removeValue(forKey: key)
        }
        refreshHaptics()
    }
    
    public class func refreshHaptics() {
        let realEnable = Array(allowHapticsList.values).contains(where: {$0 == true}) == true
        do {
            if #available(iOS 13.0, *) {
                try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(realEnable)
            } else {
                // Fallback on earlier versions
            }
        }catch {
            
        }
    }
    
    fileprivate static var allowHapticsList:[String:Bool] = [:]
}
