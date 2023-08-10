//
//  MeMePlaceholderTextView.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/10.
//

import Foundation

import Foundation
import Cartography

@objc public class MeMePlaceholderTextView : UIView {
    //MARK: <>外部变量
    @objc public var text:String {
        get {
            self.textView.text
        }
        set {
            self.textView.text = newValue
            self.curNum = newValue.count
            refreshNum()
        }
    }
    
    @objc public var maxNum:NSInteger = 200 {
        didSet {
            refreshNum()
        }
    }
    
    @objc public weak var delegate: UITextViewDelegate? {
        didSet {
            
        }
    }
    
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
        refreshNum()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(self.backFrameView)
        self.addSubview(self.placeholderLabel)
        self.addSubview(self.textView)
        self.addSubview(self.numLabel)
        
        constrain(self.backFrameView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
        
        constrain(self.placeholderLabel) {
            $0.left == $0.superview!.left + 8
            $0.top == $0.superview!.top + 12
        }
        
        constrain(self.textView) {
            $0.left == $0.superview!.left + 4
            $0.right == $0.superview!.right - 4
            $0.top == $0.superview!.top + 4
            $0.bottom == $0.superview!.bottom - 4
        }
        
        constrain(self.numLabel) {
            $0.right == $0.superview!.right - 10
            $0.bottom == $0.superview!.bottom - 10
        }
    }
    
    //MARK: <>功能性方法
    func refreshNum() {
        self.numLabel.text = "\(self.curNum)/\(self.maxNum)"
        if self.curNum  > self.maxNum {
            self.numLabel.textColor = .red
        }else{
            self.numLabel.textColor =  UIColor.hexString(toColor: "#999999")!
        }
    }
    //MARK: <>内部View
    @objc public lazy var textView: UITextView = {
        let view = UITextView()
        view.font = ThemeLite.Font.pingfang(size: 14)
        view.textColor = UIColor.hexString(toColor: "#222222")!
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets()
        view.delegate = self
        return view
    }()
    
    @objc public var backFrameView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.hexString(toColor: "#E0E0E0")!.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    @objc public var placeholderLabel: UILabel = {
        let view = UILabel()
        view.font = ThemeLite.Font.pingfang(size: 14)
        view.textColor =  UIColor.hexString(toColor: "#999999")!
        return view
    }()
    
    @objc public var numLabel: UILabel = {
        let view = UILabel()
        view.font = ThemeLite.Font.pingfang(size: 14)
        view.textColor =  UIColor.hexString(toColor: "#999999")!
        return view
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var curNum:NSInteger = 0
    //MARK: <>内部block
    
}

extension MeMePlaceholderTextView : UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.curNum = textView.text.count
        self.refreshNum()
        if textView.text.count > 0 {
            self.placeholderLabel.isHidden = true
        }else{
            self.placeholderLabel.isHidden = false
        }
        self.delegate?.textViewDidChange?(textView)
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.delegate?.textViewShouldBeginEditing?(textView) ?? true
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.delegate?.textViewShouldEndEditing?(textView) ?? true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.textViewDidEndEditing?(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.textViewDidBeginEditing?(textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
}
