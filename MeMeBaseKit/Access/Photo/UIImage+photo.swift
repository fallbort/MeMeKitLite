//
//  UIImage+photo.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/2.
//

import Foundation
import Photos

extension UIImage {
    @objc public func saveToCameraAlbum(complete:((Bool)->())? = nil) {
        PHPhotoLibrary.requestAuthorization() { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                self.saveToCameraAlbumComplete = complete
                UIImageWriteToSavedPhotosAlbum(self, self, #selector(UIImage.image(_:didFinishSavingWithError:contextInfo:)), nil)
            default:
                DispatchQueue.main.async {
                    complete?(false)
                }
            }
        }
    }
    
    @objc public func saveToAlbum(folder: String,complete:((Bool)->())? = nil) {
        PHPhotoLibrary.requestAuthorization() { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                // 创建相册
                self.creatFolder(folder: folder) { success in
                    if success {
                        // 首先获取相册的集合
                        let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
                        // 对获取到集合进行遍历
                        var foundList:PHCollection?
                        collectonResuts.enumerateObjects({ (list, index, stop) in
                            // 遍历所需要的相册目录
                            if list.localizedTitle == folder {
                                stop.pointee = true
                                foundList = list
                            }
                        })
                        
                        if let foundList = foundList {
                            PHPhotoLibrary.shared().performChanges({
                                // 创建一个Asset
                                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: self)
                                // 为Asset创建一个占位符，放到相册编辑请求中，编辑相册
                                if let placeHolder = assetRequest.placeholderForCreatedAsset,
                                    let collectonRequest = PHAssetCollectionChangeRequest(for: foundList as! PHAssetCollection)
                                {
                                    // 相册中添加照片
                                    let assets: [PHObjectPlaceholder] = [placeHolder]
                                    collectonRequest.addAssets(assets as NSArray)
                                }
                            }, completionHandler: { (success, error) in
                                DispatchQueue.main.async {
                                    complete?(success)
                                }
                            })
                        }else{
                            DispatchQueue.main.async {
                                complete?(false)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            complete?(false)
                        }
                    }
                }
            default:
                DispatchQueue.main.async {
                    complete?(false)
                }
            }
        }
    }
    
    fileprivate func creatFolder(folder: String, completion: @escaping (Bool)->Void ) {
        if isExistFolder(folder: folder) {
           completion(true)
        } else {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: folder)
            }, completionHandler: { (success, error) in
                completion(success)
            })
        }
    }
    
    fileprivate func isExistFolder(folder: String) -> Bool {
        var isExist = false
        let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        collectonResuts.enumerateObjects({ (list, index, stop) in
            if list.localizedTitle == folder {
                isExist = true
            }
        })
        return isExist
    }
}

extension UIImage {
    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        let complete = self.saveToCameraAlbumComplete
        self.saveToCameraAlbumComplete = nil
        DispatchQueue.main.async {
            complete?(error == nil)
        }
    }
}

private var saveToCameraAlbumBlock = "saveToCameraAlbum"
private var saveToAlbumBlock = "saveToAlbum"

extension UIImage {
    fileprivate var saveToCameraAlbumComplete: ((Bool)->())? {
        get {
            let timer = objc_getAssociatedObject(self, &saveToCameraAlbumBlock) as? ((Bool)->())
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &saveToCameraAlbumBlock, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    fileprivate var saveToAlbumComplete: ((Bool)->())? {
        get {
            let timer = objc_getAssociatedObject(self, &saveToAlbumBlock) as? ((Bool)->())
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &saveToAlbumBlock, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}
