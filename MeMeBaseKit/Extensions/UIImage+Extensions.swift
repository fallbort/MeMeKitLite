//
//  UIImage+Extensions.swift
//
//  Created by Solomon English on 11/10/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import UIKit
import Photos
import Accelerate
import CoreImage
import CoreGraphics
import Foundation
import MeMeKit

public enum ImageType: String {
	case png
	case jpeg = "jpg"
}

extension UIImage {
    
    private struct AssociatedKeys {
        static var isfailureKey = "isfailure"
    }
    
    public var isfailure: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isfailureKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isfailureKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc public class func imageWithColor(color: UIColor, width: CGFloat, height: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //cornerMode:1 [.UIRectCorner.bottomLeft,UIRectCorner.topRight],2 [.UIRectCorner.bottomRight,UIRectCorner.topLeft] 3 [.UIRectCorner.allCorners]
    @objc public class func imageWithColor(color: UIColor, width: CGFloat, height: CGFloat,cornerMode:NSInteger,cornerRadius:CGSize = CGSize()) -> UIImage? {
        var corners:UIRectCorner?
        if cornerMode == 1 {
            corners = [UIRectCorner.bottomLeft,UIRectCorner.topRight]
        }else if cornerMode == 2 {
            corners = [UIRectCorner.bottomRight,UIRectCorner.topLeft]
        }else if cornerMode == 3 {
            corners = [UIRectCorner.allCorners]
        }
        let image = UIImage.init(color: color, size: CGSize.init(width: width, height: height),roundingCorners: corners,cornerRadius:cornerRadius)
        return image
    }

    public convenience init(color: UIColor, size: CGSize, roundingCorners: UIRectCorner? = nil, cornerRadius: CGSize? = nil, shadowColor: UIColor? = nil,borderWidth:CGFloat? = nil,borderColor:UIColor? = nil) {
		
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
		let currentContext = UIGraphicsGetCurrentContext()
		let fillRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        if let cornerRadius = cornerRadius {
            
        }else{
            currentContext?.setFillColor(color.cgColor)
            currentContext?.fill(fillRect)
        }

		currentContext?.saveGState()

		if let shadowColor = shadowColor {
			currentContext?.setShadow(offset: CGSize(width: 0, height: 1), blur: 2, color: shadowColor.cgColor)
		}

		if let cornerRadius = cornerRadius {
			let corners = roundingCorners ?? .allCorners
			let roundedRect = shadowColor == nil ? fillRect : fillRect.insetBy(dx: 4, dy: 4)

			let roundedPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: corners, cornerRadii: cornerRadius)
			currentContext?.addPath(roundedPath.cgPath)
            currentContext?.setFillColor(color.cgColor)
            currentContext?.fillPath()
            
            currentContext?.addPath(roundedPath.cgPath)
            if let borderWidth = borderWidth {
                currentContext?.setLineWidth(borderWidth)
                currentContext?.setStrokeColor(borderColor?.cgColor ?? UIColor.clear.cgColor)
                currentContext?.strokePath()
            }
		}

		currentContext?.restoreGState()

		let image = UIGraphicsGetImageFromCurrentImageContext()
        if let cgImage = image?.cgImage, let scale = image?.scale {
            self.init(cgImage: cgImage, scale: scale, orientation: .up)
        } else {
            self.init()
        }
		UIGraphicsEndImageContext()
	}
    
    public convenience init?(gradientColors:[UIColor],start:CGPoint,end:CGPoint, size:CGSize = CGSizeMake(10, 10) )
    {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject? in return color.cgColor } as NSArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)
        // 第二个参数是起始位置，第三个参数是终止位置
        let newStart = CGPoint.init(x: size.width * start.x, y: size.height * start.y)
        let newEnd = CGPoint.init(x: size.width * end.x, y: size.height * end.y)
        if let context = context,let gradient = gradient {
            context.drawLinearGradient(gradient, start: newStart, end: newEnd, options: CGGradientDrawingOptions(arrayLiteral: .drawsBeforeStartLocation,.drawsAfterEndLocation))
        }
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

	public func fun_resizeTo(_ size: CGSize) -> UIImage {
		let hasAlpha = false
		let scale: CGFloat = 1

		UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
		draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

		let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return scaledImage!
	}

	public func squareCropImageToSideLength(_ sideLength: CGFloat) -> UIImage {
		// input size comes from image
		let inputSize = size

		// round up side length to avoid fractional output size
		let newSideLength = CGFloat(ceilf(Float(sideLength)))

		// output size has sideLength for both dimensions
		let outputSize = CGSize(width: newSideLength, height: newSideLength)

		// calculate scale so that smaller dimension fits sideLength
		let scale = max(sideLength / inputSize.width, sideLength / inputSize.height)

		// scaling the image with this scale results in this output size
		let scaledInputSize = CGSize(width: inputSize.width * scale, height: inputSize.height * scale)

		// determine point in center of "canvas"
		let center = CGPoint(x: outputSize.width / 2.0, y: outputSize.height / 2.0)

		// calculate drawing rect relative to output Size
		let outputRect = CGRect(x: center.x - scaledInputSize.width / 2.0,
			y: center.y - scaledInputSize.height / 2.0,
			width: scaledInputSize.width,
			height: scaledInputSize.height)

		// begin a new bitmap context, scale 0 takes display scale
		UIGraphicsBeginImageContextWithOptions(outputSize, true, 1)

		// optional: set the interpolation quality.
		// For this you need to grab the underlying CGContext
		let ctx = UIGraphicsGetCurrentContext()
		ctx!.interpolationQuality = .high

		// draw the source image into the calculated rect
		draw(in: outputRect)

		// create new image from bitmap context
		let outImage = UIGraphicsGetImageFromCurrentImageContext()

		// clean up
		UIGraphicsEndImageContext()

		// pass back new image
		return outImage!
	}
    
    public static func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

	public static func imageText(_ text: String, color: UIColor, fontSize: CGFloat) -> UIImage {
		let font = UIFont.systemFont(ofSize: fontSize)
		let style = NSMutableParagraphStyle()
		style.alignment = .center

		let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: color
		]

		let str = text as NSString
        let size = str.size(withAttributes: attributes)

		UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), false, UIScreen.main.scale)

		str.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), withAttributes: attributes)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}

	public static func roundRectImageWithSize(_ size: CGSize, cornerRadius: CGFloat, withColor color: UIColor, lineColor: UIColor? = nil, lineWidth: CGFloat = 0) -> UIImage {
		let image: UIImage
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		if let ctx = UIGraphicsGetCurrentContext() {
			ctx.setAllowsAntialiasing(true)

			let roundedPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
			ctx.addPath(roundedPath.cgPath)
			ctx.setFillColor(color.cgColor)
			if let lineColor = lineColor {
				ctx.setLineWidth(lineWidth)
				ctx.setStrokeColor(lineColor.cgColor)
				ctx.strokePath()
			}
			ctx.fillPath()

			image = UIGraphicsGetImageFromCurrentImageContext()!
		} else {
//            log.verbose("No context!")
			image = UIImage()
		}
		UIGraphicsEndImageContext()
		return image
	}

	public static func cycleImageWithSize(_ size: CGSize, withColor color: UIColor) -> UIImage {
		let image: UIImage

		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		if let ctx = UIGraphicsGetCurrentContext() {
			ctx.setAllowsAntialiasing(true)

			ctx.addEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
			ctx.setFillColor(color.cgColor)
			ctx.setLineWidth(0)
			ctx.fillPath()

			image = UIGraphicsGetImageFromCurrentImageContext()!
		} else {
//            log.verbose("No context!")
			image = UIImage()
		}

		UIGraphicsEndImageContext()

		return image
	}

	public func templateImage() -> UIImage {
		return withRenderingMode(.alwaysTemplate)
	}

	public func imageCropWithRect(_ rect: CGRect) -> UIImage? {
		var theRect: CGRect
		if scale > 1.0 {
			theRect = CGRect(x: rect.minX * scale, y: rect.minY * scale, width: rect.width * scale, height: rect.height * scale)
		} else {
			theRect = rect
		}

		if let imageRef = self.cgImage?.cropping(to: theRect) {
			return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
		} else {
			return nil
		}
	}

	fileprivate var originalSize: (width: Int, height: Int) {
		var width: Int
		var height: Int
		if let cgImage = self.cgImage {
			width = cgImage.width
			height = cgImage.height
		} else {
			width = Int(size.width * scale)
			height = Int(size.height * scale)
		}

		switch imageOrientation {
		case .up, .upMirrored, .down, .downMirrored:
			return (width, height)
		default:
			return (height, width)
		}
	}

	public func resizedImageByWidth(_ width: Int) -> UIImage? {
		let originalSize = self.originalSize
		let ratio = CGFloat(width) / CGFloat(originalSize.width)

		return self.bitmapInBounds(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(originalSize.height) * ratio))
	}

	public func resizedImage(maxWidth width: Int) -> UIImage? {
		let originalSize = self.originalSize
		if originalSize.width < width {
			return self
		} else {
			let ratio = CGFloat(width) / CGFloat(originalSize.width)
			return self.bitmapInBounds(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(originalSize.height) * ratio))
		}
	}

	public func resizedImageByHeight(_ height: Int) -> UIImage? {
		let originalSize = self.originalSize
		let ratio = CGFloat(height) / CGFloat(originalSize.height)

		return self.bitmapInBounds(CGRect(x: 0, y: 0, width: CGFloat(originalSize.width) * ratio, height: CGFloat(height)))
	}

	public func resizedImageWithMinimumSize(_ size: CGSize) -> UIImage? {
		let originalSize = self.originalSize
		let widthRatio = size.width / CGFloat(originalSize.width)
		let heightRatio = size.height / CGFloat(originalSize.height)
		let scaleRatio = min(widthRatio, heightRatio)

		return self.bitmapInBounds(CGRect(x: 0, y: 0, width: CGFloat(originalSize.width) * scaleRatio, height: CGFloat(originalSize.height) * scaleRatio))
	}
	
	public func resizedImage(scale: CGFloat) -> UIImage? {
		let newSize = CGSize(width: size.width * scale, height: size.height * scale)
		UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
		self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return result
	}

	public func resizedImageWithMaximumSize(_ size: CGSize) -> UIImage? {
		let originalSize = self.originalSize
		let widthRatio = size.width / CGFloat(originalSize.width)
		let heightRatio = size.height / CGFloat(originalSize.height)
		let scaleRatio = max(widthRatio, heightRatio)

		return self.bitmapInBounds(CGRect(x: 0, y: 0, width: CGFloat(originalSize.width) * scaleRatio, height: CGFloat(originalSize.height) * scaleRatio))
	}

	public func imageScaledToSize(_ newSize: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
		self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return result!
	}

	public func bitmapInBounds(_ bounds: CGRect) -> UIImage? {
		if let cgImage = self.cgImage {
			let width = Int(bounds.size.width)
			let height = Int(bounds.size.height)
			let bitsPerComponent = cgImage.bitsPerComponent
			let bytesPerRow = cgImage.bytesPerRow
			let colorSpace = cgImage.colorSpace
			let bitmapInfo = cgImage.bitmapInfo

			let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
			context?.interpolationQuality = .high
			context?.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))
			if let scaledImage = context?.makeImage() {
				return UIImage(cgImage: scaledImage)
			}
		}
		return nil
	}

	public func blurImage(_ radius: Float = 10) -> UIImage? {
		guard let ciImage = UIKit.CIImage(image: self) else {
			return nil
		}

		let params: [String: Any] = [kCIInputImageKey: ciImage, kCIInputRadiusKey: NSNumber(value: radius as Float)]
        guard let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur", parameters: params) else {
			return nil
		}

		guard let resultImage = gaussianBlurFilter.outputImage else {
			return nil
		}

		return UIImage(ciImage: resultImage)
	}

	public func imageMaskColor(_ maskColor: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)

		let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let context = UIGraphicsGetCurrentContext()
		context?.scaleBy(x: 1.0, y: -1.0)
		context?.translateBy(x: 0.0, y: -(imageRect.size.height))

		context?.clip(to: imageRect, mask: cgImage!) // 选中选区 获取不透明区域路径
		context?.setFillColor(maskColor.cgColor) // 设置颜色
		context?.fill(imageRect)

		let newImage = UIGraphicsGetImageFromCurrentImageContext() // 提取图片

		UIGraphicsEndImageContext()

		return newImage!
	}

	public class func imageWithAssertOrFile(_ assertName: String, filePath: String? = nil) -> UIImage? {
		if let filePath = filePath , FileManager().fileExists(atPath: filePath), let image = UIImage(contentsOfFile: filePath) {
			return image
		}

		return UIImage(named: assertName)
	}

	public func save(type: ImageType, toFile filepath: String) -> Bool {
		let imageData: Data?
		switch type {
		case .png:
            imageData = self.pngData()
		case .jpeg:
			imageData = self.jpegData(compressionQuality:0.65)
		}

		if let data = imageData {
			return data.write(toFile: filepath)
		}

		return false
	}
    
    public class func watermark(_ image: UIImage) -> UIImage? {
        guard let watermarkImage = UIImage.init(named: "ic_watermark") else {
            return nil
        }
        
        let imageSize = image.size
        let radio = CGFloat(640) / imageSize.width
        let markSize = CGSize(width: watermarkImage.size.width * 1.5, height: watermarkImage.size.height * 1.5)
        let size = CGSize(width: imageSize.width * radio, height: imageSize.height * radio)
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        watermarkImage.draw(in: CGRect(x: size.width - markSize.width - 16, y: size.height - markSize.height - 12, width: markSize.width, height: markSize.height))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    public func watermark(_ image: UIImage? = UIImage(named: "ic_watermark"), point: CGPoint? = nil) -> UIImage? {
        guard let image = image else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let p = point ?? CGPoint(x: 10, y: self.size.height/3)
        image.draw(in: CGRect(origin: p, size: image.size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    public class func albumWatermark(_ image: UIImage) -> UIImage? {
        if image.size.width == image.size.height {
            return UIImage.watermark(image)
        }
        return image
    }
    
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

// compress
extension UIImage {
    
    // instance method
    public func compressImageToSize(size: Int) -> Data? {
        var compressedScale: CGFloat = 0.5
        guard var data = self.jpegData(compressionQuality:compressedScale) else {
//            log.verbose("compress image error")
            return nil
        }
        
        while data.count > size {
            compressedScale *= 0.5
            if let tmpImg = UIImage(data: data), let tmpData = tmpImg.jpegData(compressionQuality:compressedScale) {
                data = tmpData
            } else {
//                log.verbose("compress image error")
                return nil
            }
        }
        
        return data
    }
    
    public func compressImageQuality(maxSize: Int) -> Data? {
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: compression) else { return nil }
        if data.count < maxSize { return data }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<20 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality:compression)!
            print("In compressing quality loop, image size =", data.count / 1024, "KB")
            if CGFloat(data.count) < CGFloat(maxSize) * 0.9 {
                min = compression
            } else if data.count > maxSize {
                max = compression
            } else {
                break
            }
        }
        print("After compressing quality, image size =", data.count / 1024, "KB")
        return data
    }
    
    public func resize(maxImageSize:CGFloat = 1024,maxSizeWithKB:CGFloat = 1024) -> NSData? {

        //先调整分辨率
        var newSize = CGSize(width :self.size.width, height :self.size.height);
        
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize(width :self.size.width / tempWidth, height :self.size.height / tempWidth);
        }
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize(width :self.size.width / tempHeight, height :self.size.height / tempHeight);
        }
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if newImage != nil {
            //调整大小
            var imageData = newImage?.jpegData(compressionQuality:1.0)
            var sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0
            
            var resizeRate = 0.9
            while (sizeOriginKB > maxSizeWithKB && resizeRate > 0.1) {
                imageData = newImage?.jpegData(compressionQuality: CGFloat(resizeRate))
                sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0
                resizeRate = resizeRate - 0.1
            }
            return imageData! as NSData
        }else{
            return nil
        }
    }
    
    public func normalizedImage() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let normalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return normalImage
    }
}

// 高斯模糊
extension UIImage {
    /// 高斯模糊
    public func gaussianBlur(blur: CGFloat) -> UIImage {
        guard let img = self.cgImage, let inProvider = img.dataProvider else { return self }
        
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        var blurAmount = blur
        if (blurAmount < 0.0 || blurAmount > 1.0) {
            blurAmount = 0.5
        }
        
        var boxSize = Int(blurAmount * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        
        let inBitmapData =  inProvider.data
        let inBitmapDataPtr = CFDataGetBytePtr(inBitmapData)
        
        inBuffer.width = vImagePixelCount(img.width)
        inBuffer.height = vImagePixelCount(img.height)
        inBuffer.rowBytes = img.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: inBitmapDataPtr)
        
        //手动申请内存
        let pixelBuffer = malloc(img.bytesPerRow * img.height)
        
        outBuffer.width = vImagePixelCount(img.width)
        outBuffer.height = vImagePixelCount(img.height)
        outBuffer.rowBytes = img.bytesPerRow
        outBuffer.data = pixelBuffer
        
        var error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if (kvImageNoError != error) {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if (kvImageNoError != error) {
                error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                                   &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                                   UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        
        var result: UIImage?
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        if let ctx = CGContext(data: outBuffer.data,
                               width: Int(outBuffer.width),
                               height: Int(outBuffer.height),
                               bitsPerComponent: 8,
                               bytesPerRow: outBuffer.rowBytes,
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
            let imageRef = ctx.makeImage()
        {
            
            result = UIImage(cgImage: imageRef)
        } else {
            result = self
        }
        //手动申请内存
        free(pixelBuffer)
        return result!
    }
    
}

extension UIImage {
     public func grayImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil , width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        var cgImg: CGImage? = nil
        if let cgImage = self.cgImage {
            context?.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
            cgImg = context?.makeImage()
        }
        if let cgImg = cgImg {
            let grayImage = UIImage.init(cgImage: cgImg)
            return grayImage
        }
        return nil
    }
}
