//
//  RankTabBar.swift
//  MeMe
//
//  Created by 邢海华 on 16/8/17.
//  Copyright © 2016年 sip. All rights reserved.
//

import UIKit

public enum StyleType {
    case none
    case line
    case customBean
    case bgImage
    case border
}

public class RankTabBar: UIView {

    static let Width = CGFloat(250)
    static let Height = CGFloat(52)
    
    public var shrink: CGFloat = 1
    fileprivate var selfWidth: CGFloat = 0
    public var itemColorChangeFollowContentScroll = true
    public var noscroll = false
    public var leftOffset: CGFloat = 0
    public var topOffset: CGFloat = 0
    public var bottomOffset: CGFloat = 0
    public var itemWidth: CGFloat = 0  // 只有在可滑动的情况下有效，如果不可滑动，那直接忽略此属性
    public var itemBetween: CGFloat = 24  //按钮内部的空隙
    public var itemSpacer: CGFloat = 0.0  //按钮之间的间距
    public var buttonsBottomSpacer: CGFloat = 0.0
    public var selectionIndicatorWidth: CGFloat = 16
    public var autoFitBtnWidth: Bool = false //自适应button宽度
    public var autoFitBtnMinWidth: CGFloat = 0
    fileprivate var ItemBarDifference: CGFloat = 5
    
    fileprivate var style: StyleType
    fileprivate var showBottomLine = false
    public var average = true
    
    lazy var btnsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    var changeBgColor: Bool {
        switch style {
        case .border:
            return true
        default:
            return false
        }
    }
    
    fileprivate var lineView: UIView?
    var _lineViewColor: UIColor?

    var lineViewColor: UIColor {
        get {
            if let _lineViewColor = _lineViewColor {
                return _lineViewColor
            }
          return UIColor.hexString(toColor: "eeE8E8E8")!
        }
    }
    public var _lineColor: UIColor?
    fileprivate var lineColor: UIColor {
        get {
            if let _lineColor = _lineColor {
                return _lineColor
            }
            return UIColor.hexString(toColor: "0xff1e76")!
        }
    }
        
    public var _btnNormalColor: UIColor?
    fileprivate var btnNormalColor: UIColor {
        get {
            if let _btnNormalColor = _btnNormalColor {
                return _btnNormalColor
            }
            switch style {
            case .line:
                return UIColor.hexString(toColor: "0x3c3c3c")!
            case .none:
                return UIColor.hexString(toColor: "0xFFFFFF")!
            case .customBean:
                return UIColor.hexString(toColor: "0xFFFFFF")!
            default:
                return UIColor.hexString(toColor: "0x3c3c3c")!
            }
        }
    }
    
    public var _btnSelectedColor: UIColor?
    fileprivate var btnSelectedColor: UIColor {
        get {
            if let _btnSelectedColor = _btnSelectedColor {
                return _btnSelectedColor
            } else if shrink < 1 {
                return btnNormalColor
            }
            switch style {
            case .line:
                return UIColor.hexString(toColor: "0xff1e76")!
            case .border:
                return UIColor.hexString(toColor: "0xff1e76")!
            default:
                return UIColor.hexString(toColor: "0xFFFFFF")!
            }
        }
    }
    
    public var btnHighColor: UIColor?
    
    public var _btnTitleFont: UIFont?
    fileprivate var btnTitleFont: UIFont {
        get {
            if let _btnTitleFont = _btnTitleFont {
                return _btnTitleFont
            }
            switch style {
            case .line:
                return ThemeLite.Font.regular(size: 17, overrideWeight: .bold)
            case .none:
                return ThemeLite.Font.regular(size: 17, overrideWeight: .bold)
            case .customBean:
                return ThemeLite.Font.regular(size: 14, overrideWeight: .bold)
            case .bgImage:
                return ThemeLite.Font.regular(size: 14, overrideWeight: .bold)
            case .border:
                return ThemeLite.Font.medium(size: 14)
            }
        }
    }
    
    var _btnNormalBgColor: UIColor?
    fileprivate var btnNormalBgColor: UIColor {
        get {
            return UIColor.hexString(toColor: "0xFFFFFF")!
        }
    }
    
    var _btnSelectedBgColor: UIColor?
    fileprivate var btnSelectedBgColor: UIColor {
        get {
            switch style {
            case .border:
                return UIColor.hexString(toColor: "fff4f8")!
            default:
                return UIColor.hexString(toColor: "0xFFFFFF")!
            }
        }
    }
    
    public var _btnSelectedTitleFont: UIFont? {
        didSet{
            if buttons.count > selectedIndex {
                buttons[selectedIndex].titleLabel?.font = _btnSelectedTitleFont
            }
        }
    }
    
    lazy var minorTitleFont: UIFont = ThemeLite.Font.bold(size: 12)
    lazy var minorTitleNormalColor: UIColor = UIColor.hexString(toColor: "0x3c3c3c")!
    lazy var minorTitleSelectedColor: UIColor = UIColor.hexString(toColor: "0xff1e76")!
    
    public var buttonTitles: [String]? {
        didSet {
            if let buttonTitles = buttonTitles, buttonTitles.count > 0 {
                for button in buttons {
                    button.removeFromSuperview()
                }
                var btns = [UIButton]()
                for (i, title) in buttonTitles.enumerated() {
                    let button = UIButton(type: .custom)
                    button.setTitle(title, for: .normal)
                    button.setTitleColor(btnNormalColor, for: .normal)
                    button.setTitleColor(btnSelectedColor, for: .selected)
                    if style == .border {
                        button.clipsToBounds = true
                        button.layer.cornerRadius = 6
                        button.layer.borderWidth = 1
                        button.layer.borderColor = UIColor.hexString(toColor: "0xededed")!.cgColor
                    }
                    
                    if let btnHighColor = btnHighColor {
                        button.setTitleColor(btnHighColor, for: .highlighted)
                    }else{
                        button.setTitleColor(btnNormalColor, for: .highlighted)
                    }
                    
                    button.contentMode = .bottom
                    if i == 0 {
                        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -4.5, bottom: buttonsBottomSpacer, right: -4.5)
                    } else if i == (buttonTitles.count - 1) {
                        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -4.5, bottom: buttonsBottomSpacer, right: -4.5)
                    } else {
                        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -3.5, bottom: buttonsBottomSpacer, right: -3.5)
                    }
                    if shrink < 1 {
                        if selectedIndex == i, let selectedFont = self._btnSelectedTitleFont {
                            button.titleLabel?.font = selectedFont.withSize(selectedFont.pointSize / shrink)
                        } else {
                            button.titleLabel?.font = btnTitleFont.withSize(btnTitleFont.pointSize / shrink)
                        }
                        buttonTransform(button: button, scale: shrink)
                        button.titleLabel?.textAlignment = .center
                    } else {
                        if selectedIndex == i, let selectedFont = self._btnSelectedTitleFont {
                            button.titleLabel?.font = selectedFont
                        } else {
                            button.titleLabel?.font = btnTitleFont
                        }
                    }
                    btns.append(button)
                }
                buttons = btns
            }
        }
    }
    
    var labelMinorTitles: [String]? {
        didSet {
            if let labelMinorTitles = labelMinorTitles, labelMinorTitles.count > 0 {
                for label in minorLabels {
                    label.removeFromSuperview()
                }
                var labels = [UILabel]()
                for (i, title) in labelMinorTitles.enumerated() {
                    let label = UILabel()
                    label.isUserInteractionEnabled = false
                    label.font = minorTitleFont
                    label.textColor = minorTitleNormalColor
                    label.textAlignment = .center
                    label.text = title
                    
                    label.tag = 101 + i
                    labels.append(label)
                }
                minorLabels = labels
            }
        }
    }
    
    public var buttons = [UIButton]() {
        didSet {
            if buttons.count > 0 {
                setupViewLayout()
                setupViewProperty()
                setupIndicatorView(false)
                if noscroll {
                    self.btnsScrollView.width = btnsScrollView.contentSize.width + 1
                    self.width = btnsScrollView.width
                }
                if selectedIndex >= buttons.count {
                    selectedIndex = buttons.count - 1
                }
            }
        }
    }
    
    var minorLabels = [UILabel]() {
        didSet {
            if minorLabels.count > 0 {
                setupViewLayout()
                setupViewProperty()
                setupIndicatorView(false)
            }
        }
    }
    
    var lineIndicatorImage: UIImage?
    
    lazy var lineIndicator: UIImageView = {
        let view = UIImageView(image: lineIndicatorImage)
        view.contentMode = .center
        view.width = selectionIndicatorWidth
        switch style {
        case .line:
            view.height = 3
        case .customBean:
            view.height = lineIndicatorImage == nil ? 2 : 5
        default:
            view.height = 2
        }
        if lineIndicatorImage == nil {
            view.backgroundColor = lineColor
            view.layer.cornerRadius = view.height / 2
            view.layer.masksToBounds = true
        }
        return view
    }()
    
    var indicatorBgImage: UIImage?
    fileprivate var indicatorInset:UIEdgeInsets?  //扩大模式
    
    fileprivate lazy var bgimageIndicator: UIImageView = {
        var height = self.height
        var width = itemWidth
        if let inset = indicatorInset {
            height -= inset.top + inset.bottom
            width -= inset.left + inset.right
        }
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        if indicatorInset != nil {
            view.contentMode = .scaleToFill
        }else{
            view.contentMode = .scaleAspectFit
        }  
        view.image = indicatorBgImage
        return view
    }()
    
    internal var selectionIndicator: UIView? {
        get{
            if style == .border {
                return nil
            }
            if style == .bgImage {
                return bgimageIndicator
            }
            return lineIndicator
        }
    }

    var selectedIndex: Int {
        didSet {
            if selectedIndex == oldValue || selectedIndex < 0 || selectedIndex > buttons.count - 1 {
                return
            }
            
            if oldValue >= 0 && oldValue < buttons.count {
                buttons[oldValue].isSelected = false
                if changeBgColor {
                    buttons[oldValue].backgroundColor = btnNormalBgColor
                }
                if buttons[oldValue].layer.borderWidth > 0 {
                    buttons[oldValue].layer.borderColor = buttons[oldValue].layer.borderColor?.copy(alpha: 1)
                }
                
                if _btnSelectedTitleFont != nil {
                    buttons[oldValue].titleLabel?.font = btnTitleFont
                }
                self.buttonTransform(button: self.buttons[oldValue], scale: self.shrink)
                
                if oldValue < minorLabels.count {
                    minorLabels[oldValue].textColor = minorTitleNormalColor
                }
            }

            if selectedIndex >= 0 && selectedIndex < buttons.count {
                buttons[selectedIndex].isSelected = true
                if changeBgColor {
                    buttons[selectedIndex].backgroundColor = btnSelectedBgColor
                }
                if buttons[selectedIndex].layer.borderWidth > 0 {
                    buttons[selectedIndex].layer.borderColor = buttons[selectedIndex].layer.borderColor?.copy(alpha: 0)
                }
                if _btnSelectedTitleFont != nil {
                    buttons[selectedIndex].titleLabel?.font = _btnSelectedTitleFont
                }
                if selectedIndex < minorLabels.count {
                    minorLabels[selectedIndex].textColor = minorTitleSelectedColor
                }
            }
            setupIndicatorView(true)
            didSelectChanged?(oldValue)
            didSelectChanged?(selectedIndex)
        }
    }
    var onSelected: ((Int) -> Void)?
    var didSelectChanged: ((Int) -> Void)?
    
    public override var clipsToBounds: Bool {
        didSet {
            self.btnsScrollView.clipsToBounds = clipsToBounds
        }
    }

    public init(frame: CGRect, style: StyleType = .line, showBottomLine: Bool = false,defaultIndex:Int = 0,indicatorInset:UIEdgeInsets? = nil) {
        self.selectedIndex = defaultIndex
        self.selfWidth = frame.width
        self.style = style
        self.showBottomLine = showBottomLine
        self.indicatorInset = indicatorInset
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        if showBottomLine {
            bottomOffset = 1
            let lineView = UIView(frame: CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1))
            lineView.backgroundColor = lineViewColor
            addSubview(lineView)
            self.lineView = lineView
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in subviews {
            guard let button = view as? UIButton else {
                continue
            }

            let subPoint = button.convert(point, from: self)
            if button.point(inside: subPoint, with: event) {
                return button
            }
        }
        return super.hitTest(point, with: event)
    }
    
    private struct AssociatedKeys {
        static var AssociatedTitle = "AssociatedTitle"
        static var AssociatedBadge = "AssociatedBadge"
    }
    
    public func reloadBtnStyles() {
        for i in 0..<buttons.count {
            let button = buttons[i]
            button.setTitleColor(btnNormalColor, for: .normal)
            button.setTitleColor(btnSelectedColor, for: .selected)
            if style == .border {
                button.clipsToBounds = true
                button.layer.cornerRadius = 6
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.hexString(toColor: "0xededed")!.cgColor
            }
            
            if let btnHighColor = btnHighColor {
                button.setTitleColor(btnHighColor, for: .highlighted)
            }else{
                button.setTitleColor(btnNormalColor, for: .highlighted)
            }
        }
    }
    
    //badge的位置以titlelabel的原始大小为基准
    func rebaseBadgeView(btn:UIButton,offsetLabel:CGPoint) {
        if let extensionBadge = btn.extensionBadge {
            btn.layoutIfNeeded()
            var titleFrame = btn.titleLabel?.frame ?? CGRect()
            var extensionSourceFrame = extensionBadge.frame
            extensionSourceFrame.origin = CGPoint.init(x: titleFrame.origin.x + offsetLabel.x, y: titleFrame.origin.y + offsetLabel.y)
            let extensionFrame = CGRect.init(x: extensionSourceFrame.origin.x - titleFrame.origin.x, y: extensionSourceFrame.origin.y - titleFrame.origin.y, width: extensionSourceFrame.width, height: extensionSourceFrame.height)
            objc_setAssociatedObject(self, &AssociatedKeys.AssociatedTitle, NSValue.init(cgRect: titleFrame), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKeys.AssociatedBadge, NSValue.init(cgRect: extensionFrame), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if let scale = btn.titleLabel?.transform.a {
            buttonTransform(button: btn, scale: scale)
        }
    }
    
}

extension RankTabBar {
    fileprivate func setupViewProperty() {
        if selectedIndex < buttons.count {
            buttons[selectedIndex].isSelected = true
            if changeBgColor {
                buttons[selectedIndex].backgroundColor = btnSelectedBgColor
            }
            if buttons[selectedIndex].layer.borderWidth > 0 {
                buttons[selectedIndex].layer.borderColor = buttons[selectedIndex].layer.borderColor?.copy(alpha: 0)
            }
            if selectedIndex < minorLabels.count {
                minorLabels[selectedIndex].textColor = minorTitleSelectedColor
            }
            buttonTransform()
        } else if buttons.count > 0,selectedIndex < buttons.count {
            let index = buttons.count - 1
            buttons[index].isSelected = true
            if changeBgColor {
                buttons[index].backgroundColor = btnSelectedBgColor
            }
            if buttons[index].layer.borderWidth > 0 {
                buttons[index].layer.borderColor = buttons[selectedIndex].layer.borderColor?.copy(alpha: 0)
            }
            selectedIndex = index
            if index < minorLabels.count {
                minorLabels[selectedIndex].textColor = minorTitleSelectedColor
            }
            buttonTransform(button: buttons[index], scale: 1)
        }
        for (i, button) in buttons.enumerated() {
            button.tag = i + 1
            button.addTarget(self, action: #selector(RankTabBar.clickIndexButton(_:)), for: .touchUpInside)
        }
    }
    
    public override func layoutSubviews() {
        if frame.width != selfWidth {
            for subview in btnsScrollView.subviews {
                if let btn = subview as? UIButton, self.buttons.contains(btn) {
                    btn.removeFromSuperview()
                }
                if let minorLabel = subview as? UILabel, self.minorLabels.contains(minorLabel) {
                    minorLabel.removeFromSuperview()
                }
            }
            setupViewLayout()
            setupIndicatorView(false)
        }
        selfWidth = frame.width
    }

    fileprivate func setupViewLayout() {
        addSubview(btnsScrollView)
        sendSubviewToBack(btnsScrollView)
        if let lineView = lineView {
            sendSubviewToBack(lineView)
        }
        btnsScrollView.frame = CGRect(x: -leftOffset, y: 0, width: self.width + leftOffset, height: self.height)
        let totalSpacer:CGFloat = buttons.count > 0 ? CGFloat((buttons.count - 1))*itemSpacer : 0.0
        var itemsWidth: CGFloat = 0
        if average {
            itemWidth = (self.btnsScrollView.width - totalSpacer) / CGFloat(buttons.count)
        }
        
        for (index, button) in buttons.enumerated() {
            btnsScrollView.addSubview(button)
            var itemW = itemWidth
            
            button.titleLabel?.sizeToFit()
            if itemWidth == 0 {
                let oldTitleSize = button.titleLabel?.intrinsicContentSize
                if let labelW = button.titleLabel?.width {
                    if let oldWidth: CGFloat = oldTitleSize?.width, oldWidth > labelW + itemBetween {
                        itemW = oldWidth
                    } else {
                        itemW = labelW + itemBetween
                    }
                }
            }
            
            if let titleWidth = button.titleLabel?.width,
               autoFitBtnWidth == true {
                let newWidth = titleWidth + 12 + itemBetween/2
                if autoFitBtnMinWidth > 0 {
                    itemW = newWidth > autoFitBtnMinWidth ? newWidth : autoFitBtnMinWidth
                }else {
                    itemW = newWidth
                }
            }
            
            button.frame = CGRect(x: itemsWidth + (index > 0 ? itemSpacer : 0), y: topOffset, width: itemW, height: self.height - topOffset)
            
            if index < minorLabels.count {
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
                let minorLabel = minorLabels[index]
                minorLabel.frame = CGRect(x: itemsWidth, y: self.height / 2 + 3, width: itemW, height: self.height / 2 - 3)
                btnsScrollView.addSubview(minorLabel)
            }
            itemsWidth = button.right
        }
        
        btnsScrollView.contentSize = CGSize(width: itemsWidth, height: self.frame.height)
    }

    //滚动标题选中按钮居中
    fileprivate func scrollCenter() {
        if selectedIndex < buttons.count {
            let selectedBtn = buttons[selectedIndex]
            if btnsScrollView.contentSize.width <= self.btnsScrollView.width {
                return
            }
            var offsetX = selectedBtn.centerX - self.btnsScrollView.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            let maxOffsetX = btnsScrollView.contentSize.width - self.btnsScrollView.width
            if offsetX > maxOffsetX {
                offsetX = maxOffsetX
            }
            btnsScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        }
    }
    
    //滚动到最左边
    func scrollLeft() {
        btnsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    func setupIndicatorView(_ animate: Bool) {
        if selectedIndex < buttons.count {
            buttonTransform()
            if animate {
                UIView.animate(withDuration: TimeInterval(0.3), animations: { [weak self] in
                    self?.scrollCenter()
                    self?.doSetupIndicatorView()
                })
            } else {
                doSetupIndicatorView()
            }
        }
    }

    fileprivate func doSetupIndicatorView() {
        guard let selectionIndicator = selectionIndicator, style != .none else {
            return
        }
        if selectionIndicator.superview == nil {
        btnsScrollView.insertSubview(selectionIndicator, at: 0)
            selectionIndicator.bottom = self.height - bottomOffset
        }
        let btn = buttons[selectedIndex]
        switch style {
        case .line:
            selectionIndicator.width = selectionIndicatorWidth
            selectionIndicator.centerX = btn.centerX
        default:
            selectionIndicator.centerX = btn.centerX
        }
    }
    
    fileprivate func IndicatorWidth(btn: UIButton) -> CGFloat {
        if style == .line || style == .customBean {
            if let width = btn.titleLabel?.intrinsicContentSize.width {
                return width - ItemBarDifference * 2
            } else {
                return 22
            }
        } else {
            if btn.width == 0{
                return self.btnsScrollView.width / CGFloat(buttons.count)
            }
            return btn.width
        }
    }
    
    @objc func clickIndexButton(_ sender: UIButton) {
        let index = sender.tag - 1
        selectedIndex = index
        onSelected?(index)
    }

    func updateSubViewsWhen(scrollView: UIScrollView) {
        self.updateSelectionIndicator(scrollView: scrollView)
        self.updateColor(scrollView: scrollView)
    }
    
    fileprivate func locationView(btn: UIButton) -> UIView? {
        guard let title = btn.titleLabel else {
            return nil
        }
        return title
    }
    
    fileprivate func updateSelectionIndicator(scrollView: UIScrollView) {
        if style == .none { return }
        
        let leftIndex = Int(scrollView.contentOffset.x / scrollView.width)
        if leftIndex >= buttons.count - 1 {
            return
        }
        let leftButton = buttons[leftIndex]
        let rightButton = buttons[leftIndex + 1]
        
         let offsetX = scrollView.contentOffset.x - CGFloat(leftIndex) * scrollView.width  //scroll移动距离
        let movePercent = offsetX / scrollView.width //scroll移动的百分比
        let btnsLength = rightButton.centerX - leftButton.centerX //线要移动的距离
        let moveLength = movePercent * btnsLength //bar上线移动的距离
        if style == .line {
            if movePercent < 0.5 { //靠左 增大
                selectionIndicator?.width = selectionIndicatorWidth + moveLength * 2
                selectionIndicator?.left = leftButton.centerX - selectionIndicatorWidth / 2
            } else if movePercent > 0.5 { //靠右 缩小
                selectionIndicator?.width = btnsLength * 2 + selectionIndicatorWidth - moveLength * 2
                selectionIndicator?.right = rightButton.centerX + selectionIndicatorWidth / 2
            }
        } else {
            selectionIndicator?.centerX = leftButton.centerX + moveLength
        }
    }
    
    fileprivate func updateColor(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.size.width
        
        let leftIndex = Int(offsetX / scrollViewWidth)
        let rightIndex = leftIndex + 1
        if leftIndex >= buttons.count {
           return 
        }
        let leftBtn = buttons[leftIndex]
        var rightBtn: UIButton? = nil
        if rightIndex < buttons.count {
            rightBtn = buttons[rightIndex]
        }
        // 计算右边按钮偏移量
        var rightScale = offsetX / scrollViewWidth
        // 只想要 0~1
        rightScale = rightScale - CGFloat(leftIndex)
        let leftScale = 1.0 - rightScale
        
        if itemColorChangeFollowContentScroll {
            var normalRed: CGFloat = 0
            var normalGreen: CGFloat = 0
            var normalBlue: CGFloat = 0
            var normalAlpha: CGFloat = 0
            btnNormalColor.getRed(&normalRed, green: &normalGreen, blue: &normalBlue, alpha: &normalAlpha)
            
            var selectedRed: CGFloat = 0
            var selectedGreen: CGFloat = 0
            var selectedBlue: CGFloat = 0
            var selectedAlpha: CGFloat = 0
            btnSelectedColor.getRed(&selectedRed, green: &selectedGreen, blue: &selectedBlue, alpha: &selectedAlpha)
            if normalRed != selectedRed
            || normalGreen != selectedGreen
            || normalBlue != normalBlue
            || normalAlpha != selectedAlpha {
                // 获取选中和未选中状态的颜色差值
                let redDiff = selectedRed - normalRed
                let greenDiff = selectedGreen - normalGreen
                let blueDiff = selectedBlue - normalBlue
                let alphaDiff = selectedAlpha - normalAlpha
                
                // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
                leftBtn.titleLabel?.textColor = UIColor(red: leftScale * redDiff + normalRed,
                                                        green: leftScale * greenDiff + normalGreen,
                                                        blue: leftScale * blueDiff + normalBlue,
                                                        alpha: leftScale * alphaDiff + normalAlpha)
                rightBtn?.titleLabel?.textColor = UIColor(red: rightScale * redDiff + normalRed,
                                                          green: rightScale * greenDiff + normalGreen,
                                                          blue: rightScale * blueDiff + normalBlue,
                                                          alpha: rightScale * alphaDiff + normalAlpha)
            }
            
            if changeBgColor {
                var normalBGRed: CGFloat = 0
                var normalBGGreen: CGFloat = 0
                var normalBGBlue: CGFloat = 0
                var normalBGAlpha: CGFloat = 0
                btnNormalBgColor.getRed(&normalBGRed, green: &normalBGGreen, blue: &normalBGBlue, alpha: &normalBGAlpha)
                
                var selectedBGRed: CGFloat = 0
                var selectedBGGreen: CGFloat = 0
                var selectedBGBlue: CGFloat = 0
                var selectedBGAlpha: CGFloat = 0
                btnSelectedBgColor.getRed(&selectedBGRed, green: &selectedBGGreen, blue: &selectedBGBlue, alpha: &selectedBGAlpha)
                if normalBGRed != selectedBGRed
                || normalBGGreen != selectedGreen
                || normalBGBlue != normalBGBlue
                || normalBGAlpha != selectedBGAlpha {
                    let redDiff = selectedBGRed - normalBGRed
                    let greenDiff = selectedBGGreen - normalBGGreen
                    let blueDiff = selectedBGBlue - normalBGBlue
                    let alphaDiff = selectedBGAlpha - normalBGAlpha
                    
                    leftBtn.backgroundColor = UIColor(red: leftScale * redDiff + normalBGRed,
                                                            green: leftScale * greenDiff + normalBGGreen,
                                                            blue: leftScale * blueDiff + normalBGBlue,
                                                            alpha: leftScale * alphaDiff + normalBGAlpha)
                    rightBtn?.backgroundColor = UIColor(red: rightScale * redDiff + normalBGRed,
                                                              green: rightScale * greenDiff + normalBGGreen,
                                                              blue: rightScale * blueDiff + normalBGBlue,
                                                              alpha: rightScale * alphaDiff + normalBGAlpha)
                }
            }
            if leftBtn.layer.borderWidth > 0 {
                leftBtn.layer.borderColor = leftBtn.layer.borderColor?.copy(alpha: 1 - leftScale)
                rightBtn?.layer.borderColor = leftBtn.layer.borderColor?.copy(alpha: 1 - rightScale)
            }
            if shrink < 1 {
                self.transfButton(leftBtn, scale: leftScale)
                if let rightBtn = rightBtn {
                    self.transfButton(rightBtn, scale: rightScale)
                }
            }
        }
    }
    
    func transfButton(_ button: UIButton, scale: CGFloat) {
        let transfS = scale * (1 - shrink) + shrink
        buttonTransform(button: button, scale: transfS)
    }
    
    func createImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    func reloadScrollViewContentSize() {
        var itemsWidth: CGFloat = 0
        for button in buttons {
            button.left = itemsWidth
            itemsWidth += button.width
        }
        btnsScrollView.contentSize = CGSize(width: itemsWidth, height: self.frame.height)
    }
    
    func buttonTransform(button: UIButton, scale: CGFloat = 1) {
        if shrink < 1 {
            if scale > (( 1 - shrink) / 2 + shrink) {
                button.titleLabel?.font = ThemeLite.Font.bold(size: btnTitleFont.pointSize / shrink)
            } else {
                button.titleLabel?.font = btnTitleFont.withSize(btnTitleFont.pointSize / shrink)
            }
            let oldTitleSize = button.titleLabel?.intrinsicContentSize
            button.titleLabel?.transform = CGAffineTransform.init(scaleX: scale , y: scale)
            button.titleLabel?.sizeToFit()
            let sourceTitleFrame = button.titleLabel?.frame ?? CGRect()
            if let labelW = button.titleLabel?.width {
                if scale < 1, let oldWidth: CGFloat = oldTitleSize?.width, (oldWidth > labelW + itemBetween) {
                    button.width = oldWidth
                } else {
                    button.width = labelW + itemBetween
                }
            }
            if let lineHeight = button.titleLabel?.font.lineHeight, let titleHeight = button.titleLabel?.height {
                let topEdge = (lineHeight - titleHeight) / 2
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -topEdge, right: 0)
            }
            if let extensionBadge = button.extensionBadge {
                if let titleFrame = (objc_getAssociatedObject(self, &AssociatedKeys.AssociatedTitle) as? NSValue)?.cgRectValue,titleFrame.width > 0,titleFrame.height > 0,let extensionFrame = (objc_getAssociatedObject(self, &AssociatedKeys.AssociatedBadge) as? NSValue)?.cgRectValue {
                    let tilteCenter = CGPoint.init(x: titleFrame.width/2.0, y: titleFrame.height/2.0)
                    let extensionCenter = extensionFrame.center
                    let badgePosRate = CGPoint.init(x:(extensionCenter.x - tilteCenter.x)/(titleFrame.width/2.0),y:(extensionCenter.y - tilteCenter.y)/(titleFrame.height/2.0))
                    var thisTitleFrame = button.titleLabel?.frame ?? CGRect()
                    let btnBounds = button.bounds
                    thisTitleFrame.origin = CGPoint.init(x: btnBounds.width/2 - thisTitleFrame.width/2, y: btnBounds.height/2 - thisTitleFrame.height/2)
                    let thisTitleCenter = CGPoint.init(x: thisTitleFrame.width/2.0, y: thisTitleFrame.height/2.0)
                    let distWidth = thisTitleCenter.x + badgePosRate.x * (thisTitleFrame.width / 2.0)
                    let distHeight = thisTitleCenter.y + badgePosRate.y * (thisTitleFrame.height / 2.0)
                    let point = CGPoint.init(x: distWidth + thisTitleFrame.origin.x, y: distHeight + thisTitleFrame.origin.y)
                    extensionBadge.center = point
                }
            }
            reloadScrollViewContentSize()
        }
    }
    
    func buttonTransform() {
        buttonTransform(button: buttons[selectedIndex], scale: 1)
    }
}

