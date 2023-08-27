//
//  MMSearchBar.swift
//  MeMeKit
//
//  Created by xfb on 2023/8/13.
//

import Foundation

import Foundation
import Cartography

var IsFirstResponderContext = 0

@objc public class MMSearchBar : UIView {
    
    //MARK: <>外部变量
    @objc public var showCancelBtn:Bool = true {
        didSet {
            self.setMultiValueMixFalse(uniqueKey: "force", keyPath: \MMSearchBar.realHiddenCancelBtn, value: !showCancelBtn)
        }
    }
    //MARK: <>外部block
    @objc public var endClickedBlock:((_ isEnd:Bool,_ fromCancel:Bool)->())?
    @objc public var searchBlock:((_ text:String)->())?
    
    //MARK: <>生命周期开始
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangedNotification(_:)), name: UITextField.textDidChangeNotification, object: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.hexString(toColor: "f0f0f0")
        let cancelBack = UIView()
        cancelBack.clipsToBounds = true
        self.addSubview(self.backView)
        backView.addSubview(self.icon)
        backView.addSubview(self.textField)
        backView.addSubview(self.clearBtn)
        self.addSubview(cancelBack)
        cancelBack.addSubview(self.cancelBtn)
        
        constrain(backView) {
            $0.left == $0.superview!.left + 12
            $0.centerY == $0.superview!.centerY
            $0.height == 32
        }
        constrain(icon) {
            $0.left == $0.superview!.left + 12
            $0.centerY == $0.superview!.centerY
            $0.width == 20
            $0.height == 20
        }
        constrain(self.clearBtn) {
            $0.right == $0.superview!.right - 4
            $0.centerY == $0.superview!.centerY
            $0.width == 22
            $0.height == 22
        }
        constrain(self.textField,self.icon,self.clearBtn) {
            $0.left == $1.right + 8
            $0.right == $2.left - 4
            $0.centerY == $0.superview!.centerY
            $0.height == 30
        }
        constrain(cancelBack,backView) {
            $0.left == $1.right
            $0.right == $0.superview!.right - 12
            $0.centerY == $1.centerY
            $0.height == $1.height
            cancelWidthLayout = $0.width == 0 ~ 88
        }
        constrain(cancelBtn) {
            $0.left == $0.superview!.left + 12
            $0.right == $0.superview!.right ~ 788
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
        let oldHidden = self.realHiddenCancelBtn
        self.realHiddenCancelBtn = oldHidden
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    @objc public lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = UIColor.hexString(toColor: "ffffff")
        return view
    }()
    @objc public lazy var icon: UIImageView = {
        let view = UIImageView()
        let image = UIImage.init(named: "search", inBundlePath: MeMeKitBundle).yy_imageByResize(to: CGSize.init(width: 20, height: 20))
        view.image = image;
        return view
    }()
    
    @objc public lazy var textField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.placeholder = NELocalize.localizedString("搜索",comment: "")
        view.returnKeyType = .search
        return view
    }()
    
    @objc public lazy var cancelBtn: UIButton = {
        let view = UIButton()
        view.setTitle(NELocalize.localizedString("取消",comment: ""), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let titleColor = UIColor.init(red: 71 / 255.0, green: 112 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        view.setTitleColor(titleColor, for: .normal)
        view.setEnlargeEdge(10)
        view.handleControlEvent(.touchUpInside) { [weak self] in
            self?.endClickedBlock?(true,true)
            self?.textField.text = ""
            self?.searchBlock?("")
            self?.clearBtn.setMultiValueMixFalse(uniqueKey: "change", keyPath: \UIView.isHidden, value: true)
            self?.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: true)
            self?.setMultiValueMixFalse(uniqueKey: "change", keyPath: \MMSearchBar.realHiddenCancelBtn, value: true)
            self?.textField.resignFirstResponder()
        }
        view.setContentHuggingPriority(UILayoutPriority.init(899), for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority.init(899), for: .horizontal)
        return view
    }()
    
    @objc public lazy var clearBtn: UIButton = {
        let view = UIButton()
        view.setEnlargeEdge(5)
        let image = UIImage.init(named: "clear_circle", inBundlePath: MeMeKitBundle).yy_imageByResize(to: CGSize.init(width: 22, height: 22))?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = UIColor.hexString(toColor: "a0a0a0")
        view.handleControlEvent(.touchUpInside) { [weak self] in
            if let text = self?.textField.text, text.count > 0 {
                self?.textField.text = ""
                self?.searchBlock?("")
                if self?.textField.isFirstResponder != true {
                    self?.textField.becomeFirstResponder()
                }
                self?.clearBtn.setMultiValueMixFalse(uniqueKey: "change", keyPath: \UIView.isHidden, value: true)
                if (self?.textField.isFirstResponder == true) {
                    self?.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: true)
                }else{
                    self?.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: false)
                }
                self?.setMultiValueMixFalse(uniqueKey: "change", keyPath: \MMSearchBar.realHiddenCancelBtn, value: true)
            }else{
                if self?.textField.isFirstResponder != true {
                    self?.textField.becomeFirstResponder()
                }
            }
        }
        view.isHidden = true
        return view
    }()
    //MARK: <>内部UI变量
    fileprivate var cancelWidthLayout:NSLayoutConstraint?
    
    fileprivate var realHiddenCancelBtn:Bool = true {
        didSet {
            cancelWidthLayout?.priority = realHiddenCancelBtn == true ? UILayoutPriority.init(888) : UILayoutPriority.init(88)
        }
    }
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}

extension MMSearchBar : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let text = textField.text ?? ""
        self.searchBlock?(text)
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endClickedBlock?(false,false)
        let text = self.textField.text ?? ""
        if text.count > 0 {
            self.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: false)
        }else{
            self.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: true)
        }
        
        self.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \MMSearchBar.realHiddenCancelBtn, value: false)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: true)
        self.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \MMSearchBar.realHiddenCancelBtn, value: true)
        let text = self.textField.text ?? ""
        if text.count == 0 {
            self.endClickedBlock?(true,false)
        }
    }
    
    @objc func textFieldDidChangedNotification(_ notification: Foundation.Notification) {
        if let object = notification.object as? UITextField, object == self.textField  {
            let text = self.textField.text ?? ""
            self.clearBtn.setMultiValueMixFalse(uniqueKey: "change", keyPath: \UIView.isHidden, value: text.count == 0)
            if (self.textField.isFirstResponder == true) {
                self.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: true)
            }else{
                self.clearBtn.setMultiValueMixFalse(uniqueKey: "edit", keyPath: \UIView.isHidden, value: false)
            }
            self.setMultiValueMixFalse(uniqueKey: "change", keyPath: \MMSearchBar.realHiddenCancelBtn, value: text.count == 0)
        }
    }
}
