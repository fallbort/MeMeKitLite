//
//  VisualEffectView.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/5/8.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit

open class VisualEffectView: UIVisualEffectView {

    /// Returns the instance of UIBlurEffect.
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    /**
     Tint color.
     
     The default value is nil.
     */
    @objc open var colorTint: UIColor? {
        get { return _value(forKey: "colorTint") as? UIColor }
        set { _setValue(newValue, forKey: "colorTint") }
    }
    
    /**
     Tint color alpha.
     
     The default value is 0.0.
     */
    @objc open var colorTintAlpha: CGFloat {
        get { return _value(forKey: "colorTintAlpha") as! CGFloat }
        set { _setValue(newValue, forKey: "colorTintAlpha") }
    }
    
    /**
     Blur radius.
     
     The default value is 0.0.
     */
    @objc open var blurRadius: CGFloat {
        get { return _value(forKey: "blurRadius") as! CGFloat }
        set { _setValue(newValue, forKey: "blurRadius") }
    }
    
    /**
     Scale factor.
     
     The scale factor determines how content in the view is mapped from the logical coordinate space (measured in points) to the device coordinate space (measured in pixels).
     
     The default value is 1.0.
     */
    @objc open var scale: CGFloat {
        get { return _value(forKey: "scale") as! CGFloat }
        set { _setValue(newValue, forKey: "scale") }
    }
    
    // MARK: - Initialization
    
    @objc public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        scale = 1
    }
    
    // MARK: - Helpers
    
    /// Returns the value for the key on the blurEffect.
    private func _value(forKey key: String) -> Any? {
        return blurEffect.value(forKeyPath: key)
    }
    
    /// Sets the value for the key on the blurEffect.
    private func _setValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        self.effect = blurEffect
    }

}

extension VisualEffectView {
    
    @objc func tint(_ color: UIColor, blurRadius: CGFloat) {
        self.colorTint = color
        self.colorTintAlpha = 0.6
        self.blurRadius = blurRadius
    }
    
}
