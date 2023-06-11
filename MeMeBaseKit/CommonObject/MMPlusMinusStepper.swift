//
//  MMPlusMinusStepper.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/8.
//

import Foundation
import Cartography

@objc public class MMPlusMinusStepper : UIView {
    
    //MARK: <>外部变量
    @objc public var lineColor:UIColor? {
        didSet {
            self.backView.layer.borderColor = (lineColor ?? UIColor.hexString(toColor: "cacaca"))!.cgColor
            self.verticalLineView.layer.borderColor = (lineColor ?? UIColor.hexString(toColor: "cacaca"))!.cgColor
        }
    }
    @objc public var textColor:UIColor? {
        didSet {
            self.textLabel.textColor = textColor ?? UIColor.hexString(toColor: "000000")
        }
    }
    
    @objc public var value:NSInteger = 0 {
        didSet {
            self.textLabel.text = "\(value)"
            checkBtnEnable()
        }
    }
    @objc public var minValue:NSInteger = 0 {
        didSet{
            checkBtnEnable()
        }
    }
    @objc public var maxValue:NSInteger = 999 {
        didSet{
            checkBtnEnable()
            adjustTextContainerWidth()
        }
    }
    
    //MARK: <>外部block
    @objc public var didChangedBlock:((NSInteger)->())?
    
    //MARK: <>生命周期开始
    deinit {
        self.timer?.cancel()
        self.timer = nil
    }
    @objc public init() {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        self.addSubview(backView)
        self.addSubview(verticalLineView)
        verticalLineView.addSubview(textLabel)
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        
        constrain(backView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
        constrain(verticalLineView) {
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            textContainerWidth = $0.width == 0 ~ UILayoutPriority.init(760)
        }
        
        constrain(textLabel) {
            $0.left >= $0.superview!.left
            $0.right <= $0.superview!.right
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
        constrain(leftBtn,verticalLineView) {
            $0.left == $0.superview!.left
            $0.right == $1.left
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            leftBtnWidth = $0.width == 24 ~ UILayoutPriority.init(888)
        }
        constrain(rightBtn,verticalLineView) {
            $0.left == $1.right
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            rightBtnWidth = $0.width == 24 ~ UILayoutPriority.init(888)
        }
        
        constrain(leftBtn,rightBtn) {
            $0.width == $1.width
        }
        
        constrain(self) {
            $0.height == 28 ~ UILayoutPriority.init(800)
        }
        
        adjustTextContainerWidth()
        adjustBtnWidth()

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.adjustBtnWidth()
        backView.layer.cornerRadius = self.bounds.height / 2.0
    }
    
    @objc func touchedDown(_ sender:UIButton?) {
        self.curOneStep = 1
        self.timePassed = 0
        self.nextLeftTime = 0.6
        self.lastFisrtLeftTime = 0.6
        self.timer?.cancel()
        self.timer = GCDTimer.init(interval: 0.1,skipFirst: true, block: { [weak self] in
            guard let `self` = self else {return}
            if self.timePassed > 0, self.nextLeftTime <= 0 {
                if sender == self.leftBtn {
                    self.minusOne(self.curOneStep)
                }else if sender == self.rightBtn {
                    self.plusOne(self.curOneStep)
                }
                if self.lastFisrtLeftTime >= 0.5 {
                    self.nextLeftTime = self.lastFisrtLeftTime - 0.4
                }else if self.lastFisrtLeftTime >= 0.3 {
                    self.nextLeftTime = self.lastFisrtLeftTime - 0.2
                }else{
                    self.nextLeftTime = self.lastFisrtLeftTime - 0.1
                }
                
                self.nextLeftTime = self.nextLeftTime <= 0.1 ? 0.1 : self.nextLeftTime
                let lastFisrtLeftTime = self.lastFisrtLeftTime
                self.lastFisrtLeftTime = self.nextLeftTime
                if lastFisrtLeftTime == self.lastFisrtLeftTime,self.curOneStep < 10 {
                    self.curOneStep += 1
                }
            }
            self.timePassed += 0.1
            self.nextLeftTime -= 0.1
        })
    }
    
    @objc func touchCancelled(_ sender:UIButton?) {
        self.timer?.cancel()
        self.timer = nil
    }
    
    @objc func touchUpInside(_ sender:UIButton?) {
        if self.timePassed == 0 {
            if sender == self.leftBtn {
                if curOneStep == 1 {
                    self.minusOne(curOneStep)
                }
            }else if sender == self.rightBtn {
                if curOneStep == 1 {
                    self.plusOne(curOneStep)
                }
            }
        }
        self.timer?.cancel()
        self.timer = nil
    }
    
    @objc func touchUpOutside(_ sender:UIButton?) {
        self.timer?.cancel()
        self.timer = nil
    }
    
    func minusOne(_ oneStep:NSInteger) {
        let oldValue = self.value
        var value = self.value
        value -= oneStep
        value = value < self.minValue ? self.minValue : value
        self.value = value
        if oldValue != value {
            self.didChangedBlock?(value)
            self.checkBtnEnable()
        }
    }
    
    func plusOne(_ oneStep:NSInteger) {
        let oldValue = self.value
        var value = self.value
        value += oneStep
        value = value > self.maxValue ? self.maxValue : value
        self.value = value
        if oldValue != value {
            self.didChangedBlock?(value)
            self.checkBtnEnable()
        }
    }
    
    //MARK: <>功能性方法
    func adjustTextContainerWidth() {
        let label = UILabel()
        label.font = textLabel.font
        label.text = "\(maxValue)"
        let labelSize = label.sizeThatFits(CGSize())
        textContainerWidth?.constant = labelSize.width + 4.0
    }
    
    func checkBtnEnable() {
        leftBtn.isEnabled = value <= minValue ? false : true
        rightBtn.isEnabled = value >= maxValue ? false : true
    }
    
    func adjustBtnWidth() {
        let halfWidth:CGFloat = self.bounds.height / 2.0
        self.leftBtnWidth?.constant = halfWidth * 2 - 2.0
        self.rightBtnWidth?.constant = halfWidth * 2 - 2.0
    }
    //MARK: <>内部View
    lazy var backView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.hexString(toColor: "cacaca")!.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var verticalLineView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.hexString(toColor: "cacaca")!.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = ThemeLite.Font.regular(size: 14)
        view.textColor =  UIColor.hexString(toColor: "#000000")!
        return view
    }()
    
    lazy var leftBtn: UIButton = {
        let view = UIButton()
        view.setTitle("-", for: .normal)
        view.setTitleColor(textColor ?? UIColor.hexString(toColor: "000000"), for: .normal)
        view.setTitleColor(UIColor.hexString(toColor: "cacaca"), for: .disabled)
        view.isEnabled = value <= minValue ? false : true
        view.addTarget(self, action: #selector(touchedDown(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(touchCancelled(_:)), for: .touchCancel)
        view.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        view.contentEdgeInsets = UIEdgeInsets.init(top: -1, left: 2, bottom: 1, right: -2)
        view.setEnlargeEdge(5)
        return view
    }()
    
    lazy var rightBtn: UIButton = {
        let view = UIButton()
        view.setTitle("+", for: .normal)
        view.setTitleColor(textColor ?? UIColor.hexString(toColor: "000000"), for: .normal)
        view.setTitleColor(UIColor.hexString(toColor: "cacaca"), for: .disabled)
        view.isEnabled = value >= maxValue ? false : true
        view.addTarget(self, action: #selector(touchedDown(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(touchCancelled(_:)), for: .touchCancel)
        view.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(touchUpOutside(_:)), for: .touchUpOutside)
        view.contentEdgeInsets = UIEdgeInsets.init(top: -1, left: -2, bottom: 1, right: 2)
        view.setEnlargeEdge(5)
        return view
    }()
    //MARK: <>内部UI变量
    var textContainerWidth:NSLayoutConstraint?
    var leftBtnWidth:NSLayoutConstraint?
    var rightBtnWidth:NSLayoutConstraint?
    var timer:GCDTimer?
    var timePassed:Double = 0
    var nextLeftTime:Double = 1.0
    var lastFisrtLeftTime:Double = 1.0
    var curOneStep = 1
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}
