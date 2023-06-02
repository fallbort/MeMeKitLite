//
//  PhotosUtils.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/9/25.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit
import Photos

public class PhotosUtils: NSObject {

    // 检测相册权限
    public class func checkAuthorizationStatus(authoried: @escaping ()->Void, failed: (()->Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            authoried()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() {
                if $0 == .authorized {
                    authoried()
                } else {
                    failed?()
                }
            }
        case .restricted, .denied:
            failed?()
        default:
            break
        }
    }
    
    // 获取所有相册集合
    public class func fetchAllGroups(complete: @escaping ([PHAssetCollection])->Void,
                              photos: @escaping ([PHAsset])->Void,
                              failed: (()->Void)?)
    {
        PhotosUtils.fetchSmartPhotosGroups { result in
            guard let result = result else {
                failed?()
                return
            }
            
            async {
                var allGroups = [PHAssetCollection]()
                var allphotos = [PHAsset]()
                
                result.enumerateObjects({ (collection, index, stop) in
                    let photoSet = PHAsset.fetchAssets(in: collection, options: nil)
                    if photoSet.count > 0 {
                        allGroups.append(collection)
                    }
                    photoSet.enumerateObjects({ (asset, idx, stop) in
                        allphotos.append(asset)
                    })
                })

                // 遍历用户自定义的相册
//                let users: PHFetchResult<PHCollection> = PHCollection.fetchTopLevelUserCollections(with: PHFetchOptions())
//                users.enumerateObjects({ (collection, index, stop) in
//                    xxxx.append(collection)
//                })
                
                async_main {
                    complete(allGroups)
                }
            }
        }
    }

    // 获取指定相册中的图片集合
    public class func fetchAssets(group: PHAssetCollection, complete: @escaping ([PHAsset])->Void) {
        var allphotos = [PHAsset]()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let photoSet = PHAsset.fetchAssets(in: group, options: options)
        photoSet.enumerateObjects({ (asset, idx, stop) in
            allphotos.append(asset)
        })
        complete(allphotos)
    }
    
    // 获取指定大小的图片，size默认是原图
    public class func fetchPhoto(asset: PHAsset,
                          size: CGSize = PHImageManagerMaximumSize,
                          complete: @escaping (UIImage?)->Void)
    {
        var targetSize = size
        if targetSize != PHImageManagerMaximumSize {
            let scale = UIScreen.main.scale
            targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        }
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = false
        options.resizeMode = .fast
        options.deliveryMode = .fastFormat
        PHCachingImageManager.default().requestImage(for: asset,
                                                     targetSize: targetSize,
                                                     contentMode: .aspectFill,
                                                     options: options)
        { (image, info) in
            complete(image)
        }
    }
    
    // 获取图片的二进制数据
    public class func fetchPhotoData(asset: PHAsset, complete: @escaping (Data?)->Void)
    {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = false
        PHCachingImageManager.default().requestImageData(for: asset, options: options)
        { (data, str, orientation, info) in
            complete(data)
        }
    }
    
    public class func fetchSmartPhotosGroups(complete: @escaping (PHFetchResult<PHAssetCollection>?)->Void) {
        checkAuthorizationStatus(authoried: {
            let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            complete(result)
        }) {
            // not authorized
            complete(nil)
        }
    }

}
