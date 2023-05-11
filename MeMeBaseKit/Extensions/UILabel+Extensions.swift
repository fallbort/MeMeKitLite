//
//  UILabel+Extensions.swift
//  MeMe
//
//  Created by FengMengtao on 2017/7/13.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit

public class PaddedLabel: UILabel {
    public var padding: UIEdgeInsets?
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.padding = UIEdgeInsets.zero
        super.init(coder: aDecoder)
    }
    
    public override func drawText(in rect: CGRect) {
        if let padding = padding {
            super.drawText(in: rect.inset(by:padding))
        } else {
            super.drawText(in: rect)
        }
    }
    
    public func setPadding(_ padding: UIEdgeInsets) {
        self.padding = padding
    }
    
    // Override -intrinsicContentSize: for Auto layout code
    public override var intrinsicContentSize : CGSize {
        if let padding = padding {
            let superContentSize = super.intrinsicContentSize
            let width = superContentSize.width + padding.left + padding.right
            let heigth = superContentSize.height + padding.top + padding.bottom
            return CGSize(width: width, height: heigth)
        } else {
            return super.intrinsicContentSize
        }
    }
    
    // Override -sizeThatFits: for Springs & Struts code
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let padding = padding {
            let superSizeThatFits = super.sizeThatFits(size)
            let width = superSizeThatFits.width + padding.left + padding.right
            let heigth = superSizeThatFits.height + padding.top + padding.bottom
            return CGSize(width: width, height: heigth)
        } else {
            return super.sizeThatFits(size)
        }
    }
}

extension UILabel {
    public func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}


extension UILabel {
    
    public enum STFakeAnimationDirection: Int {
        case Right = 1       ///< left to right
        case Left = -1       ///< right to left
        case Down = -2       ///< up to down
        case Up = 2          ///< down to up
    }
    
    public func st_startAnimation(direction: STFakeAnimationDirection, toAttributedText: NSAttributedString!) {
        if st_isAnimatin! {
            return
        }
        st_isAnimatin = true
        
        let fakeLabel = UILabel()
        fakeLabel.frame = frame
        fakeLabel.attributedText = toAttributedText
        fakeLabel.textAlignment = textAlignment
        fakeLabel.textColor = textColor
        fakeLabel.font = font
        fakeLabel.backgroundColor = backgroundColor != nil ? backgroundColor : .clear
        self.superview!.addSubview(fakeLabel)
        
        var labelOffsetX: CGFloat = 0.0
        var labelOffsetY: CGFloat = 0.0
        var labelScaleX: CGFloat = 0.1
        var labelScaleY: CGFloat = 0.1
        
        if direction == .Down || direction == .Up {
            labelOffsetY = CGFloat(direction.rawValue) * self.bounds.height / 4.0;
            labelScaleX = 1.0;
        }
        if direction == .Left || direction == .Right {
            labelOffsetX = CGFloat(direction.rawValue) * self.bounds.width / 2.0;
            labelScaleY = 1.0;
        }
        fakeLabel.transform = CGAffineTransform(scaleX: labelScaleX, y: labelScaleY).concatenating(CGAffineTransform(translationX: labelOffsetX, y: labelOffsetY))
        
        UIView.animate(withDuration: Config.STFakeLabelAnimationDuration, animations: { () -> Void in
            fakeLabel.transform = .identity
            self.transform = CGAffineTransform(scaleX: labelScaleX, y: labelScaleY).concatenating(CGAffineTransform(translationX: -labelOffsetX, y: -labelOffsetY))
        }) { (finish: Bool) -> Void in
            self.transform = .identity
            self.attributedText = toAttributedText
            fakeLabel.removeFromSuperview()
            self.st_isAnimatin = false
        }
    }
    
    public func st_startAnimation(direction: STFakeAnimationDirection, toText: String!) {
        if st_isAnimatin! {
            return
        }
        st_isAnimatin = true
        
        let fakeLabel = UILabel()
        fakeLabel.frame = frame
        fakeLabel.text = toText
        fakeLabel.textAlignment = textAlignment
        fakeLabel.textColor = textColor
        fakeLabel.font = font
        fakeLabel.backgroundColor = backgroundColor != nil ? backgroundColor : .clear
        self.superview!.addSubview(fakeLabel)
        
        var labelOffsetX: CGFloat = 0.0
        var labelOffsetY: CGFloat = 0.0
        var labelScaleX: CGFloat = 0.1
        var labelScaleY: CGFloat = 0.1
        
        if direction == .Down || direction == .Up {
            labelOffsetY = CGFloat(direction.rawValue) * self.bounds.height / 4.0;
            labelScaleX = 1.0;
        }
        if direction == .Left || direction == .Right {
            labelOffsetX = CGFloat(direction.rawValue) * self.bounds.width / 2.0;
            labelScaleY = 1.0;
        }
        fakeLabel.transform = CGAffineTransform(scaleX: labelScaleX, y: labelScaleY).concatenating(CGAffineTransform(translationX: labelOffsetX, y: labelOffsetY))
        
        UIView.animate(withDuration: Config.STFakeLabelAnimationDuration, animations: { () -> Void in
            fakeLabel.transform = .identity
            self.transform = CGAffineTransform(scaleX: labelScaleX, y: labelScaleY).concatenating(CGAffineTransform(translationX: -labelOffsetX, y: -labelOffsetY))
        }) { (finish: Bool) -> Void in
            self.transform = .identity
            self.text = toText
            fakeLabel.removeFromSuperview()
            self.st_isAnimatin = false
        }
    }
    
    // animation duration
    private struct Config {
        static var STFakeLabelAnimationDuration = 0.7
    }
    
    // st_isAnimating asscoiate key
    private struct AssociatedKeys {
        static var STFakeLabelAnimationIsAnimatingKey = "STFakeLabelAnimationIsAnimatingKey"
    }
    
    // default is false
    private var st_isAnimatin: Bool? {
        get {
            let isAnimating = objc_getAssociatedObject(self, &AssociatedKeys.STFakeLabelAnimationIsAnimatingKey) as? Bool
            // if variable is not set, return false as default
            guard let _ = isAnimating else {
                return false
            }
            return isAnimating
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.STFakeLabelAnimationIsAnimatingKey, newValue as Bool?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

