//
//  FbCommonCombineCell.swift
//  MeMe
//
//  Created by fabo on 2021/4/14.
//  Copyright © 2021 sip. All rights reserved.
//

import Foundation
import Cartography
import MeMeKit
import YYWebImage

public enum CommonSettingCellComponent : String {
    case block    //从block获取view
    case titleLabel   //纯label样式
    case localImage   //纯本地图片样式
    case netImageCoverImage   //网络图片盖本地图
}

public enum CommonSettingCellPositionX {
    case left   //放在左边
    case center //放在右边
    case right  //放在中间
}

public enum CommonSettingCellSpacer {
    case toSpacer(CGFloat)   //距离上一个同方向component的长度
    case toSpacerLeft(CGFloat)  //距离左边方向component的长度
    case toSpacerRight(CGFloat) //距离右边方向component的长度
    case fixLeft(CGFloat)   //固定距离父cell左边的长度
    case fixRight(CGFloat)  //固定距离父cell右边的长度
    case width(CGFloat)     //设置固定宽度
}

public enum CommonSettingCellPositionY {
    case center //剧中
    case top //剧上
    case bottom //剧下
    case offset(CGFloat)  //上下偏移，center时适用
    case height(CGFloat)  //固定高度，center时适用
    
    case expand  //两边扩展
    case expandOffset(top:CGFloat,bottom:CGFloat)  //间隔，expand时适用
    
}

public class FbCommonSettingCell : UITableViewCell {
    
    //MARK:<>外部变量
    
    //MARK:<>外部block
    public var didClickedBlock:(()->())?
    
    //MARK:<>生命周期开始
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        let subviews = self.backView.subviews
        for oneView in subviews {
            oneView.removeFromSuperview()
        }
        leftViews.removeAll()
        rightViews.removeAll()
        centerView = nil
    }
    
    fileprivate func setupViews() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(actionBtn)
        self.contentView.addSubview(backView)
        
        constrain(actionBtn) {
            $0.edges == $0.superview!.edges
        }
        constrain(backView) {
            $0.edges == $0.superview!.edges
        }
    }
    //MARK:<>功能性方法
    public func combineUI() {
        let subviews = self.backView.subviews
        for oneView in subviews {
            oneView.removeFromSuperview()
        }
        var leftPreView:UIView?
        for oneViewObject in leftViews {
            for oneSpacer in oneViewObject.spacer {
                layoutViewX(view: oneViewObject.view, leftPreView: leftPreView, rightPreView: nil, useLeft: true, spacer: oneSpacer)
            }
            preLayoutViewY(view: oneViewObject.view, posY: oneViewObject.posY)
            
            leftPreView = oneViewObject.view
            
        }
        var rightPreView:UIView?
        for oneViewObject in rightViews {
            for oneSpacer in oneViewObject.spacer {
                layoutViewX(view: oneViewObject.view, leftPreView: nil, rightPreView: rightPreView, useLeft: false, spacer: oneSpacer)
            }
            preLayoutViewY(view: oneViewObject.view, posY: oneViewObject.posY)
            rightPreView = oneViewObject.view
        }
        
        if let centerViewObject = centerView {
            for oneSpacer in centerViewObject.spacer {
                layoutViewX(view: centerViewObject.view, leftPreView: leftPreView, rightPreView: nil, useLeft: true, spacer: oneSpacer)
                layoutViewX(view: centerViewObject.view, leftPreView: nil, rightPreView: rightPreView, useLeft: false, spacer: oneSpacer)
            }
            preLayoutViewY(view: centerViewObject.view, posY: centerViewObject.posY)
        }
    }
    
    fileprivate func layoutViewX(view:UIView,leftPreView:UIView?,rightPreView:UIView?,useLeft:Bool,spacer:CommonSettingCellSpacer) {
        switch spacer {
        case let .toSpacer(spacer):
            if useLeft == true {
                if let leftPreView = leftPreView {
                    backView.addSubview(view)
                    constrain(view,leftPreView) {
                        $0.leading == $1.trailing + spacer
                    }
                }else{
                    backView.addSubview(view)
                    constrain(view) {
                        $0.leading == $0.superview!.leading + spacer
                    }
                }
            }else{
                if let rightPreView = rightPreView {
                    backView.addSubview(view)
                    constrain(view,rightPreView) {
                        $0.trailing == $1.leading - spacer
                    }
                }else{
                    backView.addSubview(view)
                    constrain(view) {
                        $0.trailing == $0.superview!.trailing - spacer
                    }
                }
            }
            
        case let .toSpacerLeft(spacer):
            if useLeft == true {
                if let leftPreView = leftPreView {
                    backView.addSubview(view)
                    constrain(view,leftPreView) {
                        $0.leading == $1.trailing + spacer
                    }
                }else{
                    backView.addSubview(view)
                    constrain(view) {
                        $0.leading == $0.superview!.leading + spacer
                    }
                }
            }
        case let .toSpacerRight(spacer):
            if useLeft == false {
                if let rightPreView = rightPreView {
                    backView.addSubview(view)
                    constrain(view,rightPreView) {
                        $0.trailing == $1.leading - spacer
                    }
                }else{
                    backView.addSubview(view)
                    constrain(view) {
                        $0.trailing == $0.superview!.trailing - spacer
                    }
                }
            }
        case let .fixLeft(spacer):
            if useLeft == true {
                backView.addSubview(view)
                constrain(view) {
                    $0.leading == $0.superview!.leading + spacer
                }
            }
        case let .fixRight(spacer):
            if useLeft == false {
                backView.addSubview(view)
                constrain(view) {
                    $0.trailing == $0.superview!.trailing - spacer
                }
            }
        case let .width(width):
            break  //不在此处设置
        }
    }
    
    fileprivate func preLayoutViewY(view:UIView,posY:[CommonSettingCellPositionY]) {
        let mains = posY.filter { (onePos) -> Bool in
            switch onePos {
            case .top,.bottom,.center,.expand:
                return true
            default:
                return false
            }
        }
        var subs:[CommonSettingCellPositionY] = []
        let offset = posY.first(where: { (onePos) -> Bool in
            if case .offset = onePos {
                return true
            }
            return false
        })
        if let offset = offset {
            subs.append(offset)
        }
        let expandOffset = posY.first(where: { (onePos) -> Bool in
            if case .expandOffset = onePos {
                return true
            }
            return false
        })
        if let expandOffset = expandOffset {
            subs.append(expandOffset)
        }
        for onePosY in mains {
            layoutViewY(view: view, mainPosY: onePosY, subPosY: subs)
        }
    }
    
    //mainPosY只有四种，center or expand top bottom
    fileprivate func layoutViewY(view:UIView,mainPosY:CommonSettingCellPositionY,subPosY:[CommonSettingCellPositionY]) {
        var offsetPosY:CGFloat = 0.0
        let offset = subPosY.first(where: { (posY) -> Bool in
            if case .offset = posY {
                return true
            }
            return false
        })
        if case let .offset(offset) = offset {
            offsetPosY += offset
        }
        if view.superview != nil {
            switch mainPosY {
            case .center:
                constrain(view) {
                    $0.centerY == $0.superview!.centerY + offsetPosY
                }
                
            case .top:
                constrain(view) {
                    $0.top == $0.superview!.top + offsetPosY
                }
                
            case .bottom:
                constrain(view) {
                    $0.bottom == $0.superview!.bottom + offsetPosY
                }
            case .expand:
                let expandOffset = subPosY.first(where: { (posY) -> Bool in
                    if case .expandOffset = posY {
                        return true
                    }
                    return false
                })
                if case let .expandOffset(top: top, bottom: bottom) = expandOffset {
                    constrain(view) {
                        $0.top == $0.superview!.top + top
                        $0.bottom == $0.superview!.bottom + bottom
                    }
                }else {
                    constrain(view) {
                        $0.top == $0.superview!.top
                        $0.bottom == $0.superview!.bottom
                    }
                }
            
            default:
                break   //mainPosY不处理其他类型
            }
        }
    }
    
    
    public func clear() {
        let subviews = self.backView.subviews
        for oneView in subviews {
            oneView.removeFromSuperview()
        }
        leftViews.removeAll()
        rightViews.removeAll()
        centerView = nil
        reusedViews.removeAll()
    }
    //reuseKey区分不同的block样式，同一reuseKey会重用
    public func addOrUpdateBlockView(reuseKey:String,posX:CommonSettingCellPositionX,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY] = [.center],reuseable:Bool = true,viewBlock:((_ oldView:UIView?,_ posX:CommonSettingCellPositionX)->UIView?)) {
        var oldView = getComponent(component: .block)
        if let newView = viewBlock(oldView,posX) {
            addOrUpdateComponet(component: .block, reuseKey: reuseKey, view: newView, posX: posX,spacer: spacer,posY:posY, reuseable: reuseable)
        }
    }
    
    internal func updateBackground(edges:UIEdgeInsets = UIEdgeInsets(),color:UIColor,topCornerRadius:CGFloat = 0,bottomCornerRadius:CGFloat = 0) {
        let backView = UIView()
        backView.clipsToBounds = true
        backFrameView.backgroundColor = color
        backFrameView.layer.cornerRadius = topCornerRadius > 0 ? topCornerRadius : bottomCornerRadius
        backFrameView.removeFromSuperview()
        self.contentView.addSubview(backView)
        backView.addSubview(backFrameView)
        self.contentView.sendSubviewToBack(backView)
        constrain(backView) {
            $0.leading == $0.superview!.leading + edges.left
            $0.trailing == $0.superview!.trailing - edges.right
            $0.top == $0.superview!.top + edges.top
            $0.bottom == $0.superview!.bottom - edges.bottom
        }
        let radius:CGFloat = backFrameView.layer.cornerRadius
        let topExtra:CGFloat = topCornerRadius == 0 ? radius : 0
        let bottomExtra:CGFloat = bottomCornerRadius == 0 ? radius : 0
        constrain(backFrameView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top - topExtra
            $0.bottom == $0.superview!.bottom + bottomExtra
        }
    }
    
    public func addOrUpdateComponet(component:CommonSettingCellComponent,reuseKey:String = "",view:UIView,posX:CommonSettingCellPositionX,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY],reuseable:Bool) {
        let key = getKey(component: component, reuseKey: reuseKey)
        if isViewInReuseabled(view: view, key: key) == false,reuseable == true {
            var oldViews:[UIView] = reusedViews[key] ?? []
            oldViews.append(view)
            reusedViews[key] = oldViews
            let widthEnum = spacer.first(where: { (spacer) -> Bool in
                if case .width = spacer {
                    return true
                }
                return false
            })
            if case let .width(outWidth) = widthEnum {
                constrain(view) {
                    $0.width == outWidth
                }
            }
            
            let heightEnum = posY.first(where: { (posY) -> Bool in
                if case .height = posY {
                    return true
                }
                return false
            })
            if case let .height(outHeight) = heightEnum {
                constrain(view) {
                    $0.height == outHeight
                }
            }
            
        }
        switch posX {
        case .left:
            leftViews.append((view,spacer,posY))
        case .center:
            centerView = (view,spacer,posY)
        case .right:
            rightViews.append((view,spacer,posY))
        }
    }
    
    internal func getComponent(component:CommonSettingCellComponent,reuseKey:String = "") -> UIView? {
        let key = getKey(component: component, reuseKey: reuseKey)
        var foundView:UIView?
        if let views = reusedViews[key] {
            for oneView in views {
                var hasOld = false
                if hasOld == false {
                    hasOld = leftViews.contains(where: {sg_equateableAnyObject(object1: $0.view, object2: oneView)})
                }
                if hasOld == false {
                    hasOld = rightViews.contains(where: {sg_equateableAnyObject(object1: $0.view, object2: oneView)})
                }
                if hasOld == false,let centerView = centerView?.view {
                    hasOld = sg_equateableAnyObject(object1: centerView, object2: oneView)
                }
                if hasOld {
                    continue
                }else{
                    foundView = oneView
                    break
                }
            }
        }
        
        return foundView
    }
    
    fileprivate func isViewInReuseabled(view:UIView,key:String) -> Bool {
        var hasOld = false
        if let views = reusedViews[key] {
            if views.contains(where: {sg_equateableAnyObject(object1: $0, object2: view)}) {
                hasOld = true
            }
        }
        return hasOld
    }
    
    fileprivate func getKey(component:CommonSettingCellComponent,reuseKey:String) -> String {
        return component.rawValue + "-" + reuseKey
    }
    
    // 取出某个对象的地址
    fileprivate func sg_getAnyObjectMemoryAddress(object: AnyObject) -> String {
        let str = Unmanaged<AnyObject>.passUnretained(object).toOpaque()
        return String(describing: str)
    }
    
    // 对比两个对象的地址是否相同
    fileprivate func sg_equateableAnyObject(object1: AnyObject, object2: AnyObject) -> Bool {
        let str1 = sg_getAnyObjectMemoryAddress(object: object1)
        let str2 = sg_getAnyObjectMemoryAddress(object: object2)
        
        if str1 == str2 {
            return true
        } else {
            return false
        }
    }
    
    //MARK:<>内部View
    fileprivate var backFrameView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    public lazy var actionBtn:UIButton = {
        let view = UIButton()
        view.handleControlEvent(.touchUpInside) { [weak self] in
            self?.didClickedBlock?()
        }
        return view
    }()
    fileprivate var backView:UIView = TranslateHitView()
    //MARK:<>内部UI变量
    internal var leftViews:[(view:UIView,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY])] = []   //从左到右
    internal var rightViews:[(view:UIView,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY])] = []   //从右到左
    internal var centerView:(view:UIView,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY])?
    
    internal var reusedViews:[String:[UIView]] = [:]
    //MARK:<>内部数据变量
    //MARK:<>内部block
}

extension FbCommonSettingCell {
    //换背景 edges为背景距四周位置，color为背景色
    public func addOrUpdateBackground(edges:UIEdgeInsets = UIEdgeInsets(),color:UIColor, topCornerRadius:CGFloat = 0,bottomCornerRadius:CGFloat = 0) {
        updateBackground(edges: edges, color: color,topCornerRadius: topCornerRadius,bottomCornerRadius:bottomCornerRadius)
    }
    
    //增加label，title文案，font,textColor,spacer布局
    public func addOrUpdateTitleLabelView(title:String?,font:UIFont,textColor:UIColor,reuseKey:String = "",posX:CommonSettingCellPositionX,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY] = [.center],reuseable:Bool = true) {
        var oldView = getComponent(component: .titleLabel) as? UILabel
        if oldView == nil {
            let textLabel = UILabel()
            textLabel.font = font
            textLabel.textColor = textColor
            textLabel.text = title ?? ""
            if posX == .center {
                textLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
                textLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
            }else{
                textLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
                textLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
            }
            oldView = textLabel
        }
        if let oldView = oldView {
            oldView.text = title ?? ""
            addOrUpdateComponet(component: .titleLabel, reuseKey: reuseKey, view: oldView, posX: posX,spacer: spacer,posY:posY, reuseable: reuseable)
        }
    }
    //增加本地图片样式，title文案，font,textColor,spacer布局
    public func addOrUpdateLocalImageView(image:UIImage?,imageSize:CGSize,reuseKey:String = "",posX:CommonSettingCellPositionX,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY] = [.center],reuseable:Bool = true) {
        var oldView = getComponent(component: .localImage) as? UIImageView
        if oldView == nil {
            let imageView = UIImageView()
            constrain(imageView) {
                $0.height == imageSize.height
                $0.width == imageSize.width
            }
            oldView = imageView
        }
        if let oldView = oldView {
            oldView.image = image
            addOrUpdateComponet(component: .localImage, reuseKey: reuseKey, view: oldView, posX: posX,spacer: spacer,posY:posY, reuseable: reuseable)
        }
    }
    //增加网络图片套本地图片样式
    public func addOrUpdateNetImageCoverImage(imageUrl:URL?,placeHolder:UIImage?,image:UIImage?,netCorner:CGFloat,netSize:CGSize,localCorner:CGFloat,localSize:CGSize,reuseKey:String = "",posX:CommonSettingCellPositionX,spacer:[CommonSettingCellSpacer],posY:[CommonSettingCellPositionY] = [.center],reuseable:Bool = true) {
        var oldView = getComponent(component: .netImageCoverImage)
        if oldView == nil {
            let view = UIView()
            view.isUserInteractionEnabled = false
            let netImageView = YYAnimatedImageView()
            netImageView.tag = 1
            if netCorner > 0 {
                netImageView.layer.cornerRadius = netCorner
                netImageView.clipsToBounds = true
            }
            constrain(netImageView) {
                $0.height == netSize.height
                $0.width == netSize.width
            }
            let imageView = UIImageView()
            if localCorner > 0 {
                imageView.layer.cornerRadius = localCorner
                imageView.clipsToBounds = true
            }
            constrain(imageView) {
                $0.height == localSize.height
                $0.width == localSize.width
            }
            view.addSubview(netImageView)
            view.addSubview(imageView)
            imageView.tag = 2
            constrain(imageView) {
                $0.center == $0.superview!.center
            }
            constrain(netImageView) {
                $0.center == $0.superview!.center
            }
            let totalSizeWidth = max(netSize.width,localSize.width)
            let totalSizeHeight = max(netSize.height,localSize.height)
            constrain(view) {
                $0.height == totalSizeHeight
                $0.width == totalSizeWidth
            }
            oldView = view
        }
        if let oldView = oldView {
            let netImageView = oldView.viewWithTag(1) as? YYAnimatedImageView
            let imageView = oldView.viewWithTag(2) as? UIImageView
            if let imageUrl = imageUrl {
                if let placeHolder = placeHolder {
                    netImageView?.yy_setImage(with: imageUrl, placeholder: placeHolder)
                }else{
                    netImageView?.yy_setImage(with: imageUrl, options: .allowBackgroundTask)
                }
            }else{
                netImageView?.image = nil
            }
            imageView?.image = image
            addOrUpdateComponet(component: .netImageCoverImage, reuseKey: reuseKey, view: oldView, posX: posX,spacer: spacer,posY:posY, reuseable: reuseable)
        }
    }
}

