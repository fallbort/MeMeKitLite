//
//  UIView+Extensions.swift
//  LiveCap
//
//  Created by Solomon English on 1/28/16.
//  Copyright © 2016 FunPlus. All rights reserved.
//

import WebKit

import UIKit
import Foundation
import Cartography

public let badgePointWidth: CGFloat = 3 //小红点的宽高
public let badgeFontSize: CGFloat = 7.0 //字体的大小

// UIView+Badge
extension UIView {
    
    private struct AssociatedKeys {
        static var AssociatedLableName = "AssociatedLableName"
        static var AssociatedPointName = "AssociatedPointName"
    }
    
    public var extensionBadge: UILabel? {
        get {
            return badge
        }
    }
    
    fileprivate var badge: UILabel? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.AssociatedLableName) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AssociatedLableName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var badgeCenter: CGPoint {
        get {
            if let objc = objc_getAssociatedObject(self, &AssociatedKeys.AssociatedPointName) {
                return objc as! CGPoint
            } else {
                return .zero
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AssociatedPointName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func showBadge(_ color: UIColor = .red, frame: CGRect) {
        if self.badge == nil {
            let badgeView = UILabel(frame: frame)
            badgeView.backgroundColor = color
            badgeView.layer.cornerRadius = frame.height/2
            badgeView.layer.masksToBounds = true
            badgeView.text = nil
            self.addSubview(badgeView)
            self.bringSubviewToFront(badgeView)
            self.badge = badgeView
        }
    }
    
    @objc public func showBadge(_ count: Int = 0,maxCount:Int = 99, color: UIColor = .red, frame: CGRect =  CGRect(origin: .zero, size: CGSize(width: badgePointWidth, height: badgePointWidth)), font:UIFont, format: String = "") {
        if self.badge == nil {
            let badgeView = UILabel(frame: frame)
            if frame.origin == .zero {
                badgeView.center = badgeCenter
            }
            badgeView.backgroundColor = color
            badgeView.layer.cornerRadius = size.height / 2
            badgeView.layer.masksToBounds = true
            self.addSubview(badgeView)
            self.bringSubviewToFront(badgeView)
            self.badge = badgeView
        }
        
        if let badge = self.badge, count > 0 {
            badge.textColor = UIColor.white
            badge.font = font
            badge.textAlignment = .center
            badge.text = format + (count > maxCount ? "\(maxCount)+" : "\(count)")
            let oldHeight = badge.frame.height
            badge.sizeToFit()
            var badgeframe = badge.frame
            badgeframe.size.width += 4
            badgeframe.size.height = oldHeight;
            if (badgeframe.width < badgeframe.height) {
                badgeframe.widthEx = badgeframe.height
            }
            badge.frame = badgeframe
            if frame.origin == .zero {
                badge.center = badgeCenter
            }
            badge.layer.cornerRadius = badge.height / 2
        } else if let badge = self.badge, count == 0{
            badge.text = nil
            badge.frame = CGRect.zero
        }
    }
    
    public func showEllipseBadge(_ count: Int = 0,
                          color: UIColor = .red,
                          size: CGSize = CGSize(width: badgePointWidth, height: badgePointWidth),
                          font:UIFont,
                          format: String = "") {
        if self.badge == nil {
            let badgeView = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
            badgeView.center = badgeCenter
            badgeView.backgroundColor = color
            badgeView.layer.cornerRadius = size.height / 2;
            badgeView.layer.masksToBounds = true;
            self.addSubview(badgeView)
            self.bringSubviewToFront(badgeView)
            self.badge = badgeView
        }
        
        if let badge = self.badge, count > 0 {
            badge.textColor = UIColor.white
            badge.font = font
            badge.textAlignment = .center
            badge.text = format + "\(count)"
            badge.center = badgeCenter
            badge.layer.cornerRadius = badge.height / 2
        }
    }
    
    @objc public func hideBadge() {
        self.badge?.removeFromSuperview()
        self.badge = nil
    }
    
    public func getBadgeView() -> UIView? {
        return badge
    }
    
}

extension UIView {
    
    public var viewSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }
    
	public func addCornerRadiusAnimation(_ from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
		let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.fromValue = from
		animation.toValue = to
		animation.duration = duration
		layer.add(animation, forKey: "cornerRadius")
		layer.cornerRadius = to
	}

    @objc public func addCornerRadius(_ size: CGSize, for corner: UIRectCorner = .allCorners) {
        let rounded = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: size)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        layer.mask = shape
    }
    
    public func cornerFillRadius(height: CGFloat) {
        let finalSize = CGSize(width: self.width, height: height)
        let layerHeight = finalSize.height * 0.2
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height - layerHeight))
        bezier.addLine(to: CGPoint(x: 0, y: finalSize.height - 1))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height - 1))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height - layerHeight))
        bezier.addQuadCurve(to: CGPoint(x: 0, y: finalSize.height - layerHeight),
                            controlPoint: CGPoint(x: finalSize.width / 2, y: (finalSize.height - layerHeight) - 40))
        layer.path = bezier.cgPath
        
        layer.fillColor = UIColor.hexString(toColor: "f0faff")?.cgColor
        self.layer.addSublayer(layer)
    }
    
	public func rawSize() -> CGSize {
		let rawWidth = self.bounds.width * UIScreen.main.scale
		let rawHeight = self.bounds.height * UIScreen.main.scale

		return CGSize(width: rawWidth, height: rawHeight)
	}

	public func rawWidth(_ defaultWidth: Int = 0) -> Int {
		let width = self.frame.width * UIScreen.main.scale
		return width > 0 ? Int(width) : defaultWidth
	}

	public func rawWidthOrScreen() -> Int {
		var width = self.frame.width * UIScreen.main.scale
		if width == 0 {
			width = UIScreen.main.bounds.width * UIScreen.main.scale
		}
		return Int(width)
	}
}

private var tapClosureKey: Void?
private var tapGestureKey: Void?
private var logPressClosureKey: Void?
private var logPressGestureKey: Void?
public typealias TapClosure = @convention(block) () -> ()

extension UIView {
    public func addSwipeListener(_ target: AnyObject, action: Selector, direction: UISwipeGestureRecognizer.Direction = .right) {
        let gr = UISwipeGestureRecognizer(target: target, action: action)
        gr.direction = direction
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    
    public func removeSwipeListener() {
        if let gestureRecognizers = gestureRecognizers {
            for gesture in gestureRecognizers {
                if gesture is UISwipeGestureRecognizer {
                    removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    @objc public func handleTapGesture(closure: @escaping TapClosure) {
        removeTapGesture()
        let dealObject: AnyObject = unsafeBitCast(closure, to: AnyObject.self)
        objc_setAssociatedObject(self, &tapClosureKey, dealObject, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(callTapClosure(_:)))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &tapGestureKey, gesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc public func callTapClosure(_ tap: UITapGestureRecognizer) {
        let closureObject: AnyObject = objc_getAssociatedObject(self, &tapClosureKey) as AnyObject
        let closure = unsafeBitCast(closureObject, to: TapClosure.self)
        closure()
    }
    
    @objc public func removeTapGesture() {
        if let gesture = objc_getAssociatedObject(self, &tapGestureKey) as? UITapGestureRecognizer {
            removeGestureRecognizer(gesture)
            objc_setAssociatedObject(self, &tapGestureKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc public func handleLongPressGesture(closure: @escaping TapClosure) {
        removeLongPressGesture()
        let dealObject: AnyObject = unsafeBitCast(closure, to: AnyObject.self)
        objc_setAssociatedObject(self, &logPressClosureKey, dealObject, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(callLongPressClosure(_:)))
        addGestureRecognizer(gesture)
        objc_setAssociatedObject(self, &logPressGestureKey, gesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc public func callLongPressClosure(_ longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            let closureObject: AnyObject = objc_getAssociatedObject(self, &logPressClosureKey) as AnyObject
            let closure = unsafeBitCast(closureObject, to: TapClosure.self)
            closure()
        default:
            break
        }
    }
    
    @objc public func removeLongPressGesture() {
        if let gesture = objc_getAssociatedObject(self, &logPressGestureKey) as? UILongPressGestureRecognizer {
            removeGestureRecognizer(gesture)
            objc_setAssociatedObject(self, &logPressGestureKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
	public func addOnClickListener(_ target: AnyObject, action: Selector) {
		let gr = UITapGestureRecognizer(target: target, action: action)
		gr.numberOfTapsRequired = 1
		isUserInteractionEnabled = true
        gr.cancelsTouchesInView = false
		addGestureRecognizer(gr)
	}

    public func removeOnClickListener() {
        if let gestureRecognizers = gestureRecognizers {
            for gesture in gestureRecognizers {
                if gesture is UITapGestureRecognizer {
                    removeGestureRecognizer(gesture)
                }
            }
        }
    }

	@objc public var superController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
    
    @objc public var superNavController: UINavigationController? {
        var superController = self.superController
        var nav:UINavigationController?
        while nav == nil,superController != nil {
            nav = superController?.navigationController
            superController = superController?.parent
        }
        return nav
    }
}

// MARK: - snap image
extension UIView {
	public func containsWKWebView() -> Bool {
		if self.isKind(of: WKWebView.self) {
			return true
		}

		for subView in self.subviews {
			if subView.containsWKWebView() {
				return true
			}
		}
		return false
	}

	public func snapImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

		drawHierarchy(in: bounds, afterScreenUpdates: containsWKWebView())
		let image = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()
		return image
	}
    
    public func capture() -> UIImage? {
        if let window = UIApplication.shared.keyWindow,
            let context = UIGraphicsGetCurrentContext()
        {
            UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
            window.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        } else {
            return snapImage()
        }
    }
    
    public func move(layer: CALayer ,to: CGPoint) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = layer.value(forKey: "position")
        animation.toValue   = NSValue(cgPoint: to)
        layer.position      = to
        layer.add(animation, forKey: "position")
    }
    
    public func move(layer: CALayer ,from: CGPoint ,to: CGPoint) {
        layer.position      = from
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = layer.value(forKey: "position")
        animation.toValue   = NSValue(cgPoint: to)
        layer.position      = to
        layer.add(animation, forKey: "position")
    }
    
    public func resize(layer: CALayer ,to: CGSize) {
        let oldBounds = layer.bounds
        var newBounds = oldBounds
        newBounds.size = to
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = NSValue(cgRect: oldBounds)
        animation.toValue   = NSValue(cgRect: newBounds)
        layer.bounds = newBounds
        layer.add(animation, forKey: "bounds")
    }
}

extension UIView {
    public func drawDashLine(lineLength: Int, lineSpacing: Int, lineColor: UIColor)
    {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.frame.width/2, y: self.frame.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = self.frame.width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    //返回所有符合条件的subview
    public func findSubview(_ condition: (UIView) -> Bool, result: (UIView) -> Void) {
        if condition(self) {
            result(self)
        }
        for subview in self.subviews {
            subview.findSubview(condition, result: result)
        }
    }
    //返回第一个找到的符合条件的subview
    public func findSubview(_ condition: (UIView) -> Bool) -> UIView? {
        for subview in self.subviews {
            if condition(subview) {
                return subview
            } else if let ssubview = subview.findSubview(condition) {
                return ssubview
            }
        }
        return nil
    }
}

extension UIView {
    public func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    @objc public  func getViewStacks() -> [Any] {
        var stacks:[Any] = []
        stacks.append(self)
        var view = self
        var controller:UIViewController? = self.superController
        while let superView = view.superview {
            let superCon = superView.superController
            if let controller = controller, superCon != controller {
                stacks.append(controller)
            }
            stacks.append(superView)
            controller = superCon
            view = superView
        }
        return stacks
    }
    
    @objc public  func getViewStacksLog() -> String {
        return getViewStacks().map({ (oneObject) -> String in
            return "\(type(of: oneObject))"
        }).joined(separator: ",")
    }
}

extension UIView {
    
    public func roundCorner(roundingCorners: UIRectCorner, cornerRadius: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    public func removeAllLayout() {
        if let superConstraints = superview?.constraints.filter({$0.firstItem?.isEqual(self) == true}), superConstraints.count > 0 {
            superview?.removeConstraints(superConstraints)
        }
    }
}

extension UIView {
    private struct AssociatedBorderLineLayer {
        static var AssociatedName = "AssociatedName"
    }
    public func borderLine(color: UIColor, radius: CGFloat, gapLength: CGFloat) {
        let layer = CAShapeLayer.init()
        layer.lineWidth = 1
        layer.strokeColor = color.cgColor
        layer.fillColor = nil
        layer.path = UIView.bottomlessRoundedRect(in: self.bounds, radius: radius, gapLength: gapLength)
        self.layer.addSublayer(layer)
    }
    
    public func addBorderLine(width:CGFloat, color: UIColor?,backColor:UIColor? = .clear, radius: CGFloat, rectCorner: UIRectCorner) {
        if let oldLayer = objc_getAssociatedObject(self, &AssociatedBorderLineLayer.AssociatedName) as? CAShapeLayer {
            oldLayer.removeFromSuperlayer()
        }
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:rectCorner , cornerRadii: CGSize.init(width: radius, height: radius));
        let layer = CAShapeLayer.init();
        layer.path = path.cgPath;
        layer.lineWidth = width;
        layer.lineCap = .square;
        layer.strokeColor = color?.cgColor ?? UIColor.clear.cgColor
        //  注意直接填充layer的颜色，不需要设置控件view的backgroundColor
        layer.fillColor = backColor?.cgColor ?? UIColor.clear.cgColor
        if let firstLayer = self.layer.sublayers?.first {
            self.layer.insertSublayer(layer, below: firstLayer)
        }else{
            self.layer.addSublayer(layer)
        }
        objc_setAssociatedObject(self, &AssociatedBorderLineLayer.AssociatedName, layer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func removeBorderLine() {
        if let oldLayer = objc_getAssociatedObject(self, &AssociatedBorderLineLayer.AssociatedName) as? CAShapeLayer {
            oldLayer.removeFromSuperlayer()
        }
    }
    
    public static func bottomlessRoundedRect(in rect: CGRect, radius: CGFloat, gapLength: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: (rect.width - gapLength) / 2, y: 0) )
        path.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: 0, y: rect.height), radius: radius)
        path.addArc(tangent1End: CGPoint(x: 0, y: rect.height), tangent2End: CGPoint(x: rect.width, y: rect.height), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.width, y: rect.height), tangent2End: CGPoint(x: rect.width, y: 0), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.width, y: 0), tangent2End: CGPoint(x: rect.width - radius, y: 0), radius: radius)
        path.addLine(to: CGPoint(x: (rect.width + gapLength) / 2, y: 0))
        path.move(to: CGPoint(x: (rect.width + gapLength) / 2, y: 0))
        return path
    }
    
    public func getConvertedPoint(to baseView: UIView) -> CGPoint {
        var pnt = self.frame.origin
        guard var superView = self.superview else {
            return pnt
        }
        while superView != baseView {
            pnt = superView.convert(pnt, to: superView.superview)
            if let ssuperview = superView.superview {
                superView = ssuperview
            } else {
                break
            }
        }
        return superView.convert(pnt, to: baseView)
    }
    
    public func getConvertedFrame(to baseView: UIView) -> CGRect {
        var rect = self.frame
        guard var superView = self.superview else {
            return rect
        }
        while superView != baseView {
            rect = superView.convert(rect, to: superView.superview)
            if let ssuperview = superView.superview {
                superView = ssuperview
            } else {
                break
            }
        }
        return superView.convert(rect, to: baseView)
    }
}

extension UIView {
    private struct AssociatedSpinnerKeys {
        static var AssociatedName = "AssociatedName"
    }
    public enum SpinnerType {
        case wholeDark
        case normalWhite
        case white
        case tinyWhite
    }
    //展示转菊花
     public func showSpinner(_ style:SpinnerType = .wholeDark) {
        removeSpinner()
        let spinnerView = UIView()
        spinnerView.frame = self.bounds
        switch style {
        case .tinyWhite:
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
            let ai = UIActivityIndicatorView.init(style: .white)
            ai.startAnimating()
            ai.center = spinnerView.center
            spinnerView.addSubview(ai)
        case .wholeDark:
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
            let ai = UIActivityIndicatorView.init(style: .gray)
            ai.startAnimating()
            ai.center = spinnerView.center
            spinnerView.addSubview(ai)
        case .normalWhite:
            let indicatorBack = UIView()
            indicatorBack.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            indicatorBack.backgroundColor = UIColor.hexString(toColor: "88000000")
            indicatorBack.layer.cornerRadius = 12.0
            indicatorBack.clipsToBounds = true
            spinnerView.addSubview(indicatorBack)
            indicatorBack.center = CGPoint.init(x: spinnerView.width/2.0, y: spinnerView.height/2.0)
            let ai = UIActivityIndicatorView.init(style: .white)
            ai.startAnimating()
            ai.center = CGPoint.init(x: indicatorBack.width/2.0, y: indicatorBack.height/2.0)
            indicatorBack.addSubview(ai)
        case .white:
            let indicatorBack = UIView()
            indicatorBack.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            spinnerView.addSubview(indicatorBack)
            indicatorBack.center = CGPoint.init(x: spinnerView.width/2.0, y: spinnerView.height/2.0)
            let ai = UIActivityIndicatorView.init(style: .white)
            ai.startAnimating()
            ai.center = CGPoint.init(x: indicatorBack.width/2.0, y: indicatorBack.height/2.0)
            indicatorBack.addSubview(ai)
        }

        self.addSubview(spinnerView)
        
        objc_setAssociatedObject(self, &AssociatedSpinnerKeys.AssociatedName, spinnerView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func removeSpinner() {
        let value = objc_getAssociatedObject(self, &AssociatedSpinnerKeys.AssociatedName) as? UIView
        value?.removeFromSuperview()
        objc_setAssociatedObject(self, &AssociatedSpinnerKeys.AssociatedName, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

private var widthLayoutKey = "thisWidthLayoutKey"
private var heightLayoutKey = "thisHeightLayoutKey"

extension UIView {
    public var thisWidthLayout: NSLayoutConstraint? {
        get {
            let timer = objc_getAssociatedObject(self, &widthLayoutKey) as? NSLayoutConstraint
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &widthLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var thisHeightLayout: NSLayoutConstraint? {
        get {
            let timer = objc_getAssociatedObject(self, &heightLayoutKey) as? NSLayoutConstraint
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &heightLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private var isSelectedFakeKey = "isSelectedFakeKey"
private var isSelectedFakeBlockKey = "isSelectedFakeBlockKey"
extension UIView {
    @objc public var isSelectedFake: Bool {
        get {
            let timer = objc_getAssociatedObject(self, &isSelectedFakeKey) as? Bool
            return timer ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &isSelectedFakeKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            isSelectedFakeBlock?(newValue)
        }
    }
    
    @objc public var isSelectedFakeBlock: ((Bool)->())? {
        get {
            let timer = objc_getAssociatedObject(self, &isSelectedFakeBlockKey) as? ((Bool)->())
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &isSelectedFakeBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            newValue?(isSelectedFake)
        }
    }
}

extension UIView {
    public func setImage(color: UIColor, size: CGSize, roundingCorners: UIRectCorner? = nil, cornerRadius: CGSize? = nil, shadowColor: UIColor? = nil,borderWidth:CGFloat? = nil,borderColor:UIColor? = nil) {
        // Add rounded corners
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(origin: CGPoint(), size: size)
        let corners = roundingCorners ?? .allCorners
        let fillRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let roundedRect = shadowColor == nil ? fillRect : fillRect.insetBy(dx: 4, dy: 4)
        let radiusSize = cornerRadius ?? CGSize()
        maskLayer.path = UIBezierPath(roundedRect: maskLayer.frame, byRoundingCorners: corners, cornerRadii: radiusSize).cgPath
        self.layer.mask = maskLayer

        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = color.cgColor
        borderLayer.strokeColor = borderColor?.cgColor ?? UIColor.clear.cgColor
        borderLayer.lineWidth = borderWidth ?? 0
        borderLayer.frame = maskLayer.frame
        self.layer.addSublayer(borderLayer)
    }
}

extension UIView {
    //margin离边框距离
    @objc public func addLeftRightLayout(views:[UIView],width:CGFloat,seperator:CGFloat,leftMargin:CGFloat,rightMargin:CGFloat,closeRight:Bool = true) {
        for view in views {
            if let layout = view.leftRightWidthLayout {
                layout.constant = width
            }else{
                if view.leftRightWidthLayout == nil {
                    constrain(view) { [weak view] in
                        view?.leftRightWidthLayout = $0.width == width
                    }
                }
            }
        }
        self.addLeftRightLayout(views: views, seperator: seperator, leftMargin: leftMargin, rightMargin: rightMargin,toTopBottom: true,closeRight: closeRight)
    }
    @objc public func addLeftRightLayout(views:[UIView],seperator:CGFloat,leftMargin:CGFloat,rightMargin:CGFloat,toTopBottom:Bool = false,closeRight:Bool = true) {
        for oneView in views {
            if let closeLayout = oneView.leftRightCloseLayout {
                oneView.removeConstraint(closeLayout)
                oneView.leftRightCloseLayout = nil
            }
            oneView.removeFromSuperview()
        }
        for oneView in self.subviews {
            if let closeLayout = oneView.leftRightCloseLayout {
                oneView.removeConstraint(closeLayout)
                oneView.leftRightCloseLayout = nil
            }
            oneView.removeFromSuperview()
        }
        var preView:UIView?
        for (index,view) in views.enumerated() {
            self.addSubview(view)
            if let preView = preView {
                if let layout = view.leftRightLayout {
                    view.leftRightLayout = constrain(view,preView,replace: layout) {
                        $0.left == $1.right + seperator
                        $0.centerY == $0.superview!.centerY
                        if toTopBottom {
                            $0.top == $0.superview!.top ~ 888
                            $0.bottom == $0.superview!.bottom ~ 889
                        }
                    }
                }else{
                    view.leftRightLayout = constrain(view,preView) {
                        $0.left == $1.right + seperator
                        $0.centerY == $0.superview!.centerY
                        if toTopBottom {
                            $0.top == $0.superview!.top ~ 888
                            $0.bottom == $0.superview!.bottom ~ 889
                        }
                    }
                }
            }else{
                if let layout = view.leftRightLayout {
                    view.leftRightLayout = constrain(view,replace: layout) {
                        $0.left == $0.superview!.left + leftMargin
                        $0.centerY == $0.superview!.centerY
                        if toTopBottom {
                            $0.top == $0.superview!.top ~ 888
                            $0.bottom == $0.superview!.bottom ~ 889
                        }
                    }
                }else{
                    view.leftRightLayout = constrain(view) {
                        $0.left == $0.superview!.left + leftMargin
                        $0.centerY == $0.superview!.centerY
                        if toTopBottom {
                            $0.top == $0.superview!.top ~ 888
                            $0.bottom == $0.superview!.bottom ~ 889
                        }
                    }
                }
                
            }
            preView = view
        }
        if let preView = preView,closeRight == true {
            constrain(preView) {
                preView.leftRightCloseLayout = $0.right == $0.superview!.right - rightMargin ~ 888
            }
        }
    }
}

private var commonLayoutKey:String? = nil
private var commonCloseKey:String? = nil
private var leftRightLayoutKey:String? = nil
private var leftRightCloseLayoutKey:String? = nil
private var leftRightWidthLayoutKey:String? = nil

extension UIView {
    public var commonLayout: ConstraintGroup? {
        get {
            let timer = objc_getAssociatedObject(self, &commonLayoutKey) as? ConstraintGroup
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &commonLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var commonCloseLayout: NSLayoutConstraint? {
        get {
            let timer = objc_getAssociatedObject(self, &commonCloseKey) as? NSLayoutConstraint
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &commonCloseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var leftRightLayout: ConstraintGroup? {
        get {
            let timer = objc_getAssociatedObject(self, &leftRightLayoutKey) as? ConstraintGroup
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &leftRightLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var leftRightWidthLayout: NSLayoutConstraint? {
        get {
            let timer = objc_getAssociatedObject(self, &leftRightWidthLayoutKey) as? NSLayoutConstraint
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &leftRightWidthLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var leftRightCloseLayout: NSLayoutConstraint? {
        get {
            let timer = objc_getAssociatedObject(self, &leftRightCloseLayoutKey) as? NSLayoutConstraint
            return timer
        }
        
        set {
            objc_setAssociatedObject(self, &leftRightCloseLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


extension UIView {
    @objc public static func getGridentView(layer:CAGradientLayer) -> UIView {
        let view = FrameObserView()
        view.layer.addSublayer(layer)
        view.didBoundsChangedBlock = { bounds in
            layer.frame = bounds
        }
        return view
    }
}

private var isCoverNavAndTabBarKey = "key"

extension UIView {
    @objc public var isCoverMeMeNavAndTabBar: Bool {
        get {
            let timer = objc_getAssociatedObject(self, &isCoverNavAndTabBarKey) as? Bool
            return timer ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &isCoverNavAndTabBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
