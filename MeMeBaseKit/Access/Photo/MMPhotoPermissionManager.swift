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
        let title = NELocalize.localizedString("System prevents MeMe to access photo gallery", comment: "")
        let message = NELocalize.localizedString("To grant the permission: settings -> MeMe -> photos", comment: "")
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
