//
//  MMVideoPermissionManager.swift
//  MeMeBaseComponents
//
//  Created by fabo on 2022/5/6.
//

import Foundation
import AVFoundation
import SwiftyUserDefaults

fileprivate extension DefaultsKeys {
    static let videoRequested = DefaultsKey<Bool>("meme.broadcast.videoRequested", defaultValue: false)
}

/// 直播视频设置
public class MMVideoPermissionManager {
    static var isVideoRequested: Bool {
        let result = Defaults[key: DefaultsKeys.videoRequested]
        Defaults[key: DefaultsKeys.videoRequested] = true
        return result
    }
    
    public static var hasCapturePermission: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
    }
    
    public class func noCapturePermissionAlert(cancelCompletion: VoidBlock? = nil, confirmCompletion: VoidBlock? = nil) {
        let appname = DeviceInfo.appDisplayName
        let title = String(format: NELocalize.localizedString("System prevents %@ to access camera",bundlePath: MeMeKitBundle, comment: ""), appname)
        let message = String(format: NELocalize.localizedString("To grant the permission: settings -> %@ -> camera",bundlePath: MeMeKitBundle, comment: ""), appname)
        showAuthorizeSettings(title, message: message, cancelCompletion: cancelCompletion, confirmCompletion: confirmCompletion)
    }
    
    public class func requestCapturePermission(isBlock:Bool = true,isShow:Bool = true,cancelIsBlock:Bool = true,complection: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { enabled in
            main_async() {
                let oldRequested = isVideoRequested
                if enabled {
                    complection(enabled)
                } else if oldRequested || cancelIsBlock == false {
                    if isShow == true && oldRequested {
                        var hasCompleted = false
                        if cancelIsBlock == false,isBlock == false {
                            hasCompleted = true
                            complection(enabled)
                        }
                        let appname = DeviceInfo.appDisplayName
                        let title = String(format: NELocalize.localizedString("System prevents %@ to access camera",bundlePath: MeMeKitBundle, comment: ""), appname)
                        let message = String(format: NELocalize.localizedString("To grant the permission: settings -> %@ -> camera",bundlePath: MeMeKitBundle, comment: ""), appname)
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
    
    public class func requestCapturePermissionWithAnswer(complection: @escaping ((Bool)->Void)) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { enabled in
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
}
