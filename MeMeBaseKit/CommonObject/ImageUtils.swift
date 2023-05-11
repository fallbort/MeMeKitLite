//
//  ImageUtils.swift
//  MeMe
//
//  Created by funplus on 2016/11/8.
//  Copyright © 2016年 sip. All rights reserved.
//

import UIKit

public class ImageUtils: NSObject {
    public static let liveStreamImageRatio: CGFloat = 360.0/150.0
    public static let highlightImageRatio: CGFloat = 177.0/100.0
    
    public static let channelImageSize: CGSize = {
        let width = UIScreen.main.bounds.size.width * UIScreen.main.scale
        let height = ceil(width * 9.0 / 16.0)
        return CGSize(width: width, height: height)
    }()
    
    public class func Modify(image:UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImg!
    }
    
    public class func generateImage(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    public class func getYYCacheImageByURL(url: URL?) -> UIImage? {
        if let url = url {
            let key = YYWebImageManager.shared().cacheKey(for: url)
            return YYWebImageManager.shared().cache?.getImageForKey(key)
        }
        
        return nil
    }
}
