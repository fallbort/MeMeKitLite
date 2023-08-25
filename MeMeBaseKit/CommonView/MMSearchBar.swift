//
//  MMSearchBar.swift
//  MeMeKit
//
//  Created by xfb on 2023/8/13.
//

import Foundation

import Foundation
import Cartography

@objc public class MMSearchBar : UIView {
    
    //MARK: <>外部变量
    @objc public var showCancelBtn:Bool = true {
        didSet {
            cancelWidthLayout?.priority = showCancelBtn == true ? UILayoutPriority.init(888) : UILayoutPriority.init(88)
        }
    }
    //MARK: <>外部block
    @objc public var endClickedBlock:VoidBlock?
    @objc public var searchBlock:((_ text:String)->())?
    
    //MARK: <>生命周期开始
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let cancelBack = UIView()
        cancelBack.clipsToBounds = true
        self.addSubview(self.backView)
        backView.addSubview(self.icon)
        backView.addSubview(self.textField)
        self.addSubview(cancelBack)
        cancelBack.addSubview(self.cancelBtn)
        
        constrain(backView) {
            $0.left == $0.superview!.left + 22
            $0.centerY == $0.superview!.centerY
            $0.height == 32
        }
        constrain(icon) {
            $0.left == $0.superview!.left + 12
            $0.centerY == $0.superview!.centerY
            $0.width == 20
            $0.height == 20
        }
        constrain(self.textField,self.icon) {
            $0.left == $1.right + 8
            $0.right == $0.superview!.right - 12
            $0.centerY == $0.superview!.centerY
            $0.height == 30
        }
        constrain(cancelBack,backView) {
            $0.left == $1.right
            $0.right == $0.superview!.right - 22
            $0.centerY == $1.centerY
            $0.height == $1.height
            cancelWidthLayout = $0.width == 0 ~ 88
        }
        constrain(cancelBtn) {
            $0.left == $0.superview!.left + 18
            $0.right == $0.superview!.right ~ 788
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    @objc public lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    @objc public lazy var icon: UIImageView = {
        let view = UIImageView()
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
        view.setTitleColor(.white, for: .normal)
        view.setEnlargeEdge(10)
        view.handleControlEvent(.touchUpInside) { [weak self] in
            if let text = self?.textField.text, text.count > 0 {
                self?.textField.text = ""
                self?.searchBlock?("")
            }else{
                self?.endClickedBlock?()
            }
        }
        view.setContentHuggingPriority(UILayoutPriority.init(899), for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority.init(899), for: .horizontal)
        return view
    }()
    //MARK: <>内部UI变量
    fileprivate var cancelWidthLayout:NSLayoutConstraint?
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}

extension MMSearchBar : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBlock?(textField.text ?? "")
        return true
    }
}
