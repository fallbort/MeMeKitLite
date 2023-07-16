//
//  MeMeNavigationBar.swift
//  LinYu
//
//  Created by xfb on 2023/6/29.
//

import Foundation

import Foundation
import Cartography

@objc public class MeMeNavigationBar : UIView {
    
    //MARK: <>外部变量
    @objc public var tilte:String = "" {
        didSet {
            self.titleLabel.text = tilte
        }
    }
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let top = StatusBarHeight
        self.addSubview(navBackView)
        navBackView.addSubview(self.navLeftView)
        navBackView.addSubview(self.navRightView)
        navBackView.addSubview(self.titleBackView)
        titleBackView.addSubview(self.titleLabel)
        
        constrain(navBackView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top + top
            $0.bottom == $0.superview!.bottom
            $0.height == 44.0
        }
        constrain(self.navLeftView) {
            $0.left == $0.superview!.left + 12
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.width == 0 ~ 100
        }
        constrain(self.navRightView) {
            $0.right == $0.superview!.right - 12
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.width == 0 ~ 100
        }
        constrain(self.titleBackView,self.navLeftView,self.navRightView) {
            $0.centerX == $0.superview!.centerX
            $0.left == $1.right + 2
            $0.right == $2.left - 2
            $0.top == $0.superview!.top ~ 900
            $0.bottom == $0.superview!.bottom ~ 900
            $0.centerY == $0.superview!.centerY
            $0.width == 0 ~ 100
        }
        
        constrain(self.titleLabel) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
        
        self.titleBackView.setContentHuggingPriority(UILayoutPriority.init(222), for: .horizontal)
        self.titleBackView.setContentCompressionResistancePriority(UILayoutPriority.init(222), for: .vertical)
        
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.init(223), for: .horizontal)
        self.titleLabel.setContentCompressionResistancePriority(UILayoutPriority.init(224), for: .vertical)
        
        self.navLeftView.setContentHuggingPriority(UILayoutPriority.init(888), for: .horizontal)
        self.navLeftView.setContentCompressionResistancePriority(UILayoutPriority.init(888), for: .vertical)
        
        self.navRightView.setContentHuggingPriority(UILayoutPriority.init(888), for: .horizontal)
        self.navRightView.setContentCompressionResistancePriority(UILayoutPriority.init(888), for: .vertical)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: <>功能性方法
    public func addLeftRightBtns(btnInfos:[(image:UIImage?,text:String?,block:VoidBlock?)],isLeft:Bool) {
        for oneView in self.navLeftViews {
            oneView.removeFromSuperview()
        }
        var btns:[UIButton] = [];
        for info in btnInfos {
            let button = UIButton()
            if let image = info.image {
                button.setImage(info.image, for: .normal)
            }
            if let text = info.text {
                button.setTitle(info.text, for: .normal)
            }
            constrain(button) {
                $0.width == 24
                $0.height == 24
            }
            button.setEnlargeEdge(15)
            button.handleControlEvent(.touchUpInside) { [weak self] in
                info.block?()
            }
            btns.append(button)
        }
        if isLeft == true {
            self.navLeftViews = btns;
            self.layoutBtns(btns: btns, backView: self.navLeftView)
        }else{
            self.navRightViews = btns;
            self.layoutBtns(btns: btns, backView: self.navRightView)
        }
        
    }
    
    @objc public func addLeftBtns(btns:[UIView]) {
        for oneView in self.navLeftViews {
            oneView.removeFromSuperview()
        }
        self.navLeftViews = btns;
        self.layoutBtns(btns: btns, backView: self.navLeftView)
    }
    
    @objc public func addRightBtns(btns:[UIView]) {
        for oneView in self.navRightViews {
            oneView.removeFromSuperview()
        }
        self.navRightViews = btns;
        self.layoutBtns(btns: btns, backView: self.navRightView)
    }
    
    @objc public func addTitleView(view:UIView?) {
        for oneView in self.titleBackView.subviews {
            oneView.removeFromSuperview()
        }
        self.titleLabel.removeAllLayout()
        if let view = view {
            self.titleBackView.addSubview(view)
            constrain(view) {
                $0.centerX == $0.superview!.centerX
                $0.left >= $0.superview!.left
                $0.right <= $0.superview!.right
                $0.top >= $0.superview!.top
                $0.bottom <= $0.superview!.bottom
                $0.centerY == $0.superview!.centerY
            }
        }else{
            self.titleBackView.addSubview(self.titleLabel)
            constrain(self.titleLabel) {
                $0.left == $0.superview!.left
                $0.right == $0.superview!.right
                $0.top == $0.superview!.top
                $0.bottom == $0.superview!.bottom
            }
        }
        
    }
    
    func layoutBtns(btns:[UIView],backView:UIView) {
        for oneView in backView.subviews {
            oneView.removeFromSuperview()
        }
        
        var preView:UIView?
        for btn in btns {
            let systemSize = btn.systemLayoutSizeFitting(CGSize())
            backView.addSubview(btn)
            if let preView = preView {
                constrain(btn,preView) {
                    $0.left == $1.right + 5
                    if systemSize.height == 0 {
                        $0.top == $0.superview!.top
                        $0.bottom == $0.superview!.bottom
                    }
                    $0.width >= 24
                }
            }else{
                constrain(btn) {
                    $0.left == $0.superview!.left
                    if systemSize.height == 0 {
                        $0.top == $0.superview!.top
                        $0.bottom == $0.superview!.bottom
                    }else{
                        $0.centerY == $0.superview!.centerY
                    }
                    if systemSize.width == 0 {
                        $0.width == 24
                    }
                }
            }
            preView = btn
        }
        if let preView = preView {
            constrain(preView) {
                $0.right == $0.superview!.right
            }
        }
    }
    
    //MARK: <>内部View
    @objc public var titleLabel: UILabel = {
        let view = UILabel()
        view.font = ThemeLite.Font.regular(size: 18)
        view.textColor =  UIColor.hexString(toColor: "#222222")!
        view.textAlignment = .center
        return view
    }()
    
    var titleBackView: UIView = {
        let view = UIView()
        return view
    }()
    
    var navBackView: UIView = {
        let view = UIView()
        return view
    }()
    
    var navLeftView: UIView = {
        let view = UIView()
        return view
    }()
    
    var navRightView: UIView = {
        let view = UIView()
        return view
    }()
    //MARK: <>内部UI变量
    
    //MARK: <>内部数据变量
    var navLeftViews:[UIView] = []
    var navRightViews:[UIView] = []
    
    @objc public static var fixHeight:CGFloat = {
        return StatusBarHeight + 44.0
    }()
    //MARK: <>内部block
    
}
