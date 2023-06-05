//
//  UIButton+Extensions.swift
//  LiveCap
//
//  Created by Solomon English on 11/27/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import UIKit

public enum ButtonEdgeInsetsStyle: Int {
    case top        // image在上，label在下
    case left       // image在左，label在右
    case bottom     // image在下，label在上
    case right      // image在右，label在左
}

private var closureKey: Void?
public typealias ActionClosure = @convention(block) () -> ()
extension UIButton {

    @objc public func handleControlEvent(_ event: UIControl.Event, closure: @escaping ActionClosure) {
        let dealObject: AnyObject = unsafeBitCast(closure, to: AnyObject.self)
        objc_setAssociatedObject(self, &closureKey, dealObject, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.removeTarget(self, action: #selector(callActionClosure(_:)), for: event)
        self.addTarget(self, action: #selector(callActionClosure(_:)), for: event)
    }
    
    @objc public func callActionClosure(_ btn: UIButton) {
        let closureObject: AnyObject = objc_getAssociatedObject(self, &closureKey) as AnyObject
        let closure = unsafeBitCast(closureObject, to: ActionClosure.self)
        closure()
    }

}

extension UIButton {
    
    @objc public func setPadding(_ image: CGFloat, vertical: CGFloat, horizontal: CGFloat) {
		let insetAmount = image / 2.0
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        self.contentEdgeInsets = UIEdgeInsets(top: vertical, left: insetAmount + horizontal, bottom: vertical, right: insetAmount + horizontal)
	}
    
    @objc public func setShadowTitle(title: String, titleColor: UIColor = .white, shadowColor: UIColor = .black, shadowOffset: CGSize = CGSize(width: 0, height: 1), for: UIControl.State) {
        let contentAttrString = NSMutableAttributedString(string: title)
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = shadowOffset
        shadow.shadowBlurRadius = 1
        let contentAttributes = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.backgroundColor: UIColor.clear, NSAttributedString.Key.shadow: shadow]
        contentAttrString.addAttributes(contentAttributes, range: NSMakeRange(0, contentAttrString.length))
        setAttributedTitle(contentAttrString, for: .normal)
    }
    
    @objc public func setBackground(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension UIButton {
    /**
     *  设置button的titleLabel和imageView的布局样式，及间距
     *
     *  @param style titleLabel和imageView的布局样式
     *  @param space titleLabel和imageView的间距
     */
    public func layoutEdgeInsetsStyle(_ style: ButtonEdgeInsetsStyle = .top, space: CGFloat = 4) {
        guard let imageView = self.imageView else { return }
        guard let titleLabel = self.titleLabel else { return }
        
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height
        let labelWidth = min(titleLabel.intrinsicContentSize.width, self.frame.size.width)
        let labelHeight = titleLabel.intrinsicContentSize.height

        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets: UIEdgeInsets = .zero
        var labelEdgeInsets: UIEdgeInsets = .zero
        
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-space/2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWith, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-space/2.0, bottom: 0, right: imageWith+space/2.0)
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
    
}

// UIView+Padding
extension UIButton {
    
    public func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: (self.frame.size.width - imageSize.width) / 2 - 5,
            bottom: 0,
            right: 0
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -(self.frame.size.width - titleSize.width) / 2 - 10,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
    public func centerButtonAndImageWithSpacing(_ spacing: CGFloat) {
        let insetAmount = spacing / 2.0
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
