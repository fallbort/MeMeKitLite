//
//  ImageView+MeMe.swift
//  MeMe
//
//  Created by LFY on 2022/5/29.
//  Copyright © 2022 sip. All rights reserved.
//

import UIKit
//import Kingfisher
//import KingfisherWebP

public enum MeMeWebImageOptions {
    case none
}

//由于图片内存占用空间较大，所以一次性的图片内存，或者低频的内存，可以使用此方法记录，统一删除，已减少内存占用
public class MeMeImageTempCacheManager {
    public static let shared: MeMeImageTempCacheManager = MeMeImageTempCacheManager()
    //用于存储临时图片
//    private var tempImageCacheSet: Set = Set<URL>()

    private var tempImageCacheArray: MeMeSafeArray<URL> = MeMeSafeArray<URL>()

    //是否开启自动释放内存，true开始定时检查，false取消检查
    private var _autoreleaseImageMemory: Bool = false
    public var autoreleaseImageMemory: Bool {
        get {
            return _autoreleaseImageMemory
        }
        set(nValue) {
            //设置开启自动检查，并且之前没有开启过
            if nValue && !_autoreleaseImageMemory {
                //开启自动检查
                _checkMemory()
            }

            _autoreleaseImageMemory = nValue
        }
    }

    //定时检查内存，默认5秒
    public var autoCheckMemoryTimeInterval: TimeInterval = 5

    //内存最大占比
    private var _memoryUsageMax: Float = 0.4

    //检查内存
    private func _checkMemory() {
        //异步监听内存使用
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + autoCheckMemoryTimeInterval) {[weak self] in
            guard let self = self else {
                return
            }

            //读取内存占比
            let memoryUsage = SystemUtil.memoryUsage()
            /*
            let freeMemory = SystemUtil.freeMemory()
            let usedMemory = SystemUtil.usedMemory()
            print("========usedMemory=\(usedMemory) memoryUsage=\(memoryUsage) freeMemory=\(freeMemory)")

            print("========memoryUsage=\(memoryUsage) ")
             */
            //判断是否清理内存
            if memoryUsage >= self._memoryUsageMax {
//                print("========memoryUsage22222")
                //清理内存
                self.clearImageAllCache()

                //当大于峰值时，进行复位
                if self._memoryUsageMax >= 0.5 {
                    self._memoryUsageMax = 0.4
                } else {
                    //每次清理内存峰值累加，已减少频繁内存释放。
                    //0.4 0.43 0.46 0.49
                    self._memoryUsageMax = self._memoryUsageMax + 0.03
                }
            }

            //递归调用，循环监听内存
            if self._autoreleaseImageMemory {
                self._checkMemory()
            }
        }
    }

    //添加临时图片
    public func addTempImageUrl(url: URL?) {
        guard let url = url else {
            return
        }
//        self.tempImageCacheSet.insert(url)

        if self.tempImageCacheArray.contains(url) {
            return
        }

        self.tempImageCacheArray.append(url)
    }

    //清除临时图片
    public func clearImageAllTempCache() {
        /*
        for url in tempImageCacheArray {
            //清理yy
            let key = YYWebImageManager.shared().cacheKey(for: url)
            YYWebImageManager.shared().cache?.memoryCache.removeObject(forKey: key)

            //清理kingfisher
//            KingfisherManager.shared.cache.memoryStorage.remove(forKey: url.absoluteString)
        }
         */
        for i in 0 ..< self.tempImageCacheArray.count {
            if let url = self.tempImageCacheArray[i] {
                //清理yy
                let key = YYWebImageManager.shared().cacheKey(for: url)
                YYWebImageManager.shared().cache?.memoryCache.removeObject(forKey: key)
            }
        }

        //清理url
        tempImageCacheArray.removeAll()
    }

    //清理所有图片内存
    public func clearImageAllCache() {
        //清理yy
        YYWebImageManager.shared().cache?.memoryCache.removeAllObjects()

        //清理kingfisher
//        KingfisherManager.shared.cache.memoryStorage.removeAll()

        //清理url
//        tempImageCacheSet.removeAll()
        tempImageCacheArray.removeAll()
    }
}

public class MeMeImageViewComponents {
    //初始化组件
    public static func meme_setupWebPProcessor() {
        /*
        //初始化webp
        KingfisherManager.shared.defaultOptions += [
          .processor(WebPProcessor.default),
          .cacheSerializer(WebPSerializer.default)
        ]
         */
    }
}
/*
//动图
public typealias MeMeAnimatedImageView = AnimatedImageView

//YYImageCache.shared().getImageForKey(imageUrl)
class MeMeImageCache {
    static var shared = MeMeImageCache()
    func getImage(forKey: String?) -> UIImage? {
        guard let key = forKey else {
            return nil
        }

        let semaphore = DispatchSemaphore(value: 1)

        var image: UIImage? = nil
        KingfisherManager.shared.cache.retrieveImage(forKey: key) { result in
            switch result {
            case .success(let value):
                image = value.image
                semaphore.signal()
            default:
                semaphore.signal()
                break
            }
        }

        semaphore.wait()

        return image
    }
}
*/
/*
extension UIImage {

    func meme_image(radius byRoundCornerRadius: CGFloat) -> UIImage {
        return self.meme_image(radius: byRoundCornerRadius, fitSize: self.size)
    }
    func meme_image(radius byRoundCornerRadius: CGFloat, fitSize: CGSize) -> UIImage {
        return self.kf.image(withRadius: Radius.widthFraction(byRoundCornerRadius), fit: fitSize)
    }
}
 */

extension UIImageView {
    public func meme_setImage(with imageUrl: URL?) {
//        self.kf.setImage(with: imageUrl)
        self.yy_setImage(with: imageUrl)
    }

    public func meme_setImage(with imageUrl: URL?, placeholder: UIImage?) {
//        self.kf.setImage(with: imageUrl, placeholder: placeholder)
        self.yy_setImage(with: imageUrl, placeholder: placeholder)
    }

    public func meme_setImage(with imageUrl: URL?, options:MeMeWebImageOptions?) {
//        self.kf.setImage(with: imageUrl, options: nil)
        self.yy_setImage(with: imageUrl)
    }

    /*
    func meme_setImage(with imageUrl: URL?, placeholder: UIImage?, options: MeMeWebImageOptions = .none, completion:((UIImage?)->())?) {
        self.kf.setImage(with: imageUrl, placeholder: placeholder, options: nil) { result in
            if let completion = completion {
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure(let error):
                    completion(nil)
                }
            }
        }
    }

    func meme_setImage(with imageUrl: URL?, placeholder: UIImage?, options: MeMeWebImageOptions = .none, progress:((_ receivedSize: Int, _ expectedSize: Int)->())?, completion:((UIImage?)->())?) {
        self.kf.setImage(with: imageUrl, placeholder: placeholder, options: nil) { receivedSize, totalSize in
            if let progress = progress {
                progress(Int(receivedSize), Int(totalSize))
            }
        } completionHandler: { result in
            if let completion = completion {
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure(let error):
                    completion(nil)
                }
            }
        }
    }
     */

    public func meme_cancelCurrentImageRequest(){
//        self.kf.cancelDownloadTask()
        self.yy_cancelCurrentImageRequest()
    }
}
