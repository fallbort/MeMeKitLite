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
        let title = NELocalize.localizedString("System prevents MeMe to access microphone", comment: "")
        let message = NELocalize.localizedString("To grant the permission: settings -> MeMe -> microphone", comment: "")
        showAuthorizeSettings(title, message: message, cancelCompletion: cancelCompletion, confirmCompletion: confirmCompletion)
    }
    
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
                        let title = NELocalize.localizedString("System prevents MeMe to access microphone", comment: "")
                        let message = NELocalize.localizedString("To grant the permission: settings -> MeMe -> microphone", comment: "")
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
        let actionCancel = UIAlertAction(title: NELocalize.localizedString("Cancel", comment: ""), style: .cancel) { action in
            cancelCompletion?()
        }
        let actionSet = UIAlertAction(title: NELocalize.localizedString("Settings", comment: ""), style: .default) { action in
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
}
