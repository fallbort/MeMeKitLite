//
//  MMPhotoPermissionManager.swift
//  MeMeBaseComponents
//
//  Created by fabo on 2022/5/6.
//

import Foundation
import Photos

/// 直播视频设置
public class MMPhotoPermissionManager {
    public class func photoLibraryAuthorization(completion: ((_ authorized:Bool)->())? = nil) {
        PHPhotoLibrary.requestAuthorization() { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                main_async() {
                    completion?(true)
                }
            default:
                main_async() {
                    showPhotoAllowSettings(cancelCompletion: {completion?(false)}, confirmCompletion: {completion?(false)})
                }
            }
        }
    }
    
    fileprivate class func showPhotoAllowSettings(cancelCompletion: VoidBlock? = nil, confirmCompletion: VoidBlock? = nil) {
        let appname = DeviceInfo.appDisplayName
        let title = String(format: NELocalize.localizedString("System prevents %@ to access photo gallery",bundlePath: MeMeKitBundle, comment: ""), appname)
        let message = String(format: NELocalize.localizedString("To grant the permission: settings -> %@ -> microphone",bundlePath: MeMeKitBundle, comment: ""), appname)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: NELocalize.localizedString("Cancel", comment: ""), style: .cancel) {action in
            cancelCompletion?()
        }
        alert.addAction(actionCancel)
        
        let actionSet = UIAlertAction(title: NELocalize.localizedString("Settings", comment: ""), style: .default) { action in
            if let URL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(URL)
            }
            confirmCompletion?()
        }
        alert.addAction(actionSet)
        let vc = ScreenUIManager.topViewController()
        vc?.present(alert, animated: true, completion: nil)
    }
}

extension MMPhotoPermissionManager {
    public static func saveImage(image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { isSuccess, error in
            DispatchQueue.main.async {
                if isSuccess {
                    HUD.flash2(String(format: NELocalize.localizedString("保存成功",bundlePath: MeMeKitBundle, comment: "")))
                } else {
                    HUD.flash2(String(format: NELocalize.localizedString("保存失败",bundlePath: MeMeKitBundle, comment: "")))
                }
            }
        }
    }
}
