//
//  CircleScrollView.swift
//  MeMe
//
//  Created by LuanMa on 16/10/9.
//  Copyright © 2016年 sip. All rights reserved.
//

import UIKit
import Cartography
import YYWebImage
import YYImage
import MeMeKit

enum CircleScrollDirection {
    case horizontal
    case vertical
}

@objc
protocol CircleScrollViewDelegate: AnyObject {
    func prefixImageUrl() -> URL?
    func currentImageUrl() -> URL?
    func nextImageUrl() -> URL?
    
    @objc optional func scroll(previousNext: Int) //拖动调用
    @objc optional func willChangToNext(_ next: Bool) //滚动前调用
    @objc optional func changedToNext(_ next: Bool) //滚动后调用
    @objc optional func endChangedToNext(_ next: Bool) //用户在直播间滑动滚动结束后调用
    @objc optional func clicked()
}

class CircleScrollView: UIScrollView {
    var scrollPreviousNext: Int = 0  {  //拖动： -1显示出上一个区域  1下一个区域  0没有拖动
        didSet {
            if scrollPreviousNext != oldValue {
                circleDelegate?.scroll?(previousNext: scrollPreviousNext)
            }
        }
    }
    fileprivate var placeHolder:UIImage?
    fileprivate var childViews = [ItemControl]()
//    fileprivate var statusBarHidden: Bool?

    fileprivate(set) var blurred = false
    var direction: CircleScrollDirection {
        didSet {
//            if direction == .vertical {
//                statusBarHidden = UIApplication.shared.isStatusBarHidden
//            }
            resetupViews()
            reloadData()
        }
    }
    
    var sysPagingEnabled = true //是否用系统的翻页效果
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath ==  "statusBarHidden" {
            contentOffset = CGPoint(x: 0, y: size.height)
        }
    }

    weak var circleDelegate: CircleScrollViewDelegate? {
        didSet {
            reloadData()
        }
    }

    override var bounds: CGRect {
        didSet {
            if oldValue.size != bounds.size{
                resetupViews()
            }
//            else if oldValue != bounds, direction == .vertical, let statusBarHidden = statusBarHidden, statusBarHidden != UIApplication.shared.isStatusBarHidden {
//                statusBarHidden = UIApplication.shared.isStatusBarHidden
//                contentOffset = CGPoint(x: 0, y: size.height)
//            }
        }
    }

    weak var followingView: UIView? {
        didSet {
            if let oldView = oldValue {
                oldView.removeFromSuperview()
            }

            if let followingView = followingView {
                let size = bounds.size
                switch direction {
                case .horizontal:
                    followingView.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
                case .vertical:
                    followingView.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
                }
                addSubview(followingView)
            }
        }
    }

    init(frame: CGRect, direction: CircleScrollDirection = .horizontal, blurred: Bool = false, itemImg: UIImage? = nil, imgBgColor: UIColor? = nil, pagingEnabled: Bool = true) {
        self.direction = direction
        self.blurred = blurred
        self.placeHolder = itemImg
        super.init(frame: frame)
        self.sysPagingEnabled = pagingEnabled
        setupViews(imgBgColor: imgBgColor)
        isPagingEnabled = true
        if !pagingEnabled {
            bounces = false
            decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
            if #available(iOS 11.0, *), direction == .vertical {
                self.contentInset = UIEdgeInsets(top: -StatusBarHeight, left: 0, bottom: -PhoneBottom, right: 0)
            }
        }
        
        if direction == .vertical {
            UIApplication.shared.addObserver(self, forKeyPath: "statusBarHidden", options: .new, context: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        direction = .horizontal
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    deinit {
        if direction == .vertical {
            UIApplication.shared.removeObserver(self, forKeyPath: "statusBarHidden")
        }
        childViews.removeAll()
        circleDelegate = nil
    }
}

extension CircleScrollView {
    func reloadData() {
        for (i, childView) in childViews.enumerated() {
            let imageURL: URL?
            switch i {
            case 0:
                imageURL = circleDelegate?.prefixImageUrl()
            case 1:
                imageURL = circleDelegate?.currentImageUrl()
            case 2:
                imageURL = circleDelegate?.nextImageUrl()
            default:
                imageURL = nil
            }

            let imageView = childView.imageView
            imageView.image = nil
            if let showUrl = imageURL {
                imageView.yy_setImage(with: showUrl,placeholder: self.placeHolder)
            }
        }

        isScrollEnabled = circleDelegate?.nextImageUrl() != nil
    }

    func scrollPrefix() {
        circleDelegate?.willChangToNext?(false)
        setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        circleDelegate?.endChangedToNext?(false)
    }

    func scrollNext() {
        circleDelegate?.willChangToNext?(true)
        switch direction {
        case .horizontal:
            setContentOffset(CGPoint(x: bounds.size.width * 2, y: 0), animated: true)
        case .vertical:
            setContentOffset(CGPoint(x: 0, y: bounds.size.height * 2), animated: true)
        }
        circleDelegate?.endChangedToNext?(true)
    }

    @objc func clickItem(_ sender: AnyObject?) {
        circleDelegate?.clicked?()
    }
}

extension CircleScrollView {
    fileprivate func setupViews(imgBgColor: UIColor? = nil) {
        for i in 0 ... 2 {
            let view = ItemControl(frame: CGRect.zero, blurred: blurred, bgColor: imgBgColor)
            if i == 1 {
                view.addTarget(self, action: #selector(CircleScrollView.clickItem(_:)), for: .touchUpInside)
            }
            childViews.append(view)
            addSubview(view)
        }

        backgroundColor = UIColor.clear
        scrollsToTop = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isDirectionalLockEnabled = true
        delegate = self
    }

    fileprivate func resetupViews() {
        let size = bounds.size
        for (i, childView) in childViews.enumerated() {
            switch direction {
            case .horizontal:
                childView.frame = CGRect(x: size.width * CGFloat(i), y: 0, width: size.width, height: size.height)
            case .vertical:
                childView.frame = CGRect(x: 0, y: size.height * CGFloat(i), width: size.width, height: size.height)
            }
        }

        switch direction {
        case .horizontal:
            followingView?.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width * CGFloat(childViews.count), height: size.height)
            contentOffset = CGPoint(x: size.width, y: 0)
        case .vertical:
            followingView?.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
            contentSize = CGSize(width: size.width, height: size.height * CGFloat(childViews.count))
            contentOffset = CGPoint(x: 0, y: size.height)
        }
    }

    fileprivate func correct() {
        switch direction {
        case .horizontal:
            if contentOffset.x != size.width {
                contentOffset = CGPoint(x: size.width, y: 0)
            }
        case .vertical:
            if contentOffset.y != size.height {
                contentOffset = CGPoint(x: 0, y: size.height)
            }
        }
    }
    
    fileprivate func endScrollView(_ scrollView: UIScrollView) {
        defer {
            correct()
        }
        self.isUserInteractionEnabled = true
        let size = scrollView.bounds.size
        var index: Int
        switch direction {
        case .horizontal:
            if size.width == 0 {
                return
            }
            index = Int(scrollView.contentOffset.x / size.width)
        case .vertical:
            if size.height == 0 {
                return
            }
            index = Int(scrollView.contentOffset.y / size.height)
        }
        
        guard index != 1 else {
            return
        }

        if index < 1 {
            index = 0
        } else {
            index = 2
        }

        let currentchildView = childViews[index]
        childViews[1].imageView.image = currentchildView.imageView.image

        followingView?.isHidden = true
        defer {
            followingView?.isHidden = false
        }

        switch direction {
        case .horizontal:
            contentOffset = CGPoint(x: size.width, y: 0)
        case .vertical:
            contentOffset = CGPoint(x: 0, y: size.height)
        }
        
        circleDelegate?.changedToNext?(index > 1)

        childViews[0].imageView.image = nil
        if let imageURL = circleDelegate?.prefixImageUrl() {
            childViews[0].imageView.yy_setImage(with: imageURL,placeholder: self.placeHolder)
        }

        childViews[2].imageView.image = nil
        if let imageURL = circleDelegate?.nextImageUrl() {
            childViews[2].imageView.yy_setImage(with: imageURL,placeholder: self.placeHolder)
        }
    }
    
    func isGo(_ moveY: CGFloat, _ velocity: CGFloat) -> Bool {
        return abs(moveY) >= bounds.size.height * 0.5 || (abs(velocity) > 0 && abs(moveY) >= bounds.size.height * 0.07 )
    }
    
    func move(y: CGFloat) -> CGFloat {
        if y > 0 {
            circleDelegate?.willChangToNext?(true)
            return bounds.size.height * 2
        }
        circleDelegate?.willChangToNext?(false)
        return 0
    }
    
    func targetOffset(moveY: CGFloat, velocity: CGFloat) -> CGFloat {
        if (moveY > 0 && velocity < 0) || (moveY < 0 && velocity > 0) {
            if isGo(moveY, velocity) {
                return bounds.size.height
            } else {
               return move(y: moveY)
            }
        } else {
           if isGo(moveY, velocity) {
                return move(y: moveY)
            } else {
                return bounds.size.height
            }
        }
    }
}

extension CircleScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isDragging {
            return
        }
        let offsetY = scrollView.contentOffset.y
        if offsetY > self.height {
            scrollPreviousNext = 1
        } else if offsetY < self.height {
            scrollPreviousNext = -1
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if sysPagingEnabled {return}
        let pointeeY = targetOffset(moveY: scrollView.contentOffset.y - bounds.size.height, velocity: velocity.y)
        self.isUserInteractionEnabled = false
        let next = scrollView.contentOffset.y > bounds.size.height
        if pointeeY == bounds.size.height {
            targetContentOffset.pointee.y = pointeeY
        } else {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.contentOffset = CGPoint(x: 0, y: pointeeY)
            }) { [weak self] _ in
                self?.circleDelegate?.endChangedToNext?(next)
                self?.scrollPreviousNext = 0
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endScrollView(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScrollView(scrollView)
        scrollPreviousNext = 0
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        endScrollView(scrollView)
    }
}

class ItemControl: UIControl {
    lazy var imageView:YYAnimatedImageView = {
        let view = YYAnimatedImageView()
        return view
    }()
    
    fileprivate lazy var sheetLayout: VisualEffectView = {
        let view = VisualEffectView()
        let effect = UIBlurEffect(style: .light)
        view.effect = effect
        return view
    }()

    init(frame: CGRect, blurred: Bool, bgColor: UIColor? = nil) {
        super.init(frame: frame)
        setupViews(blurred)
        if let bgColor = bgColor {
            imageView.backgroundColor = bgColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViews(_ blurred: Bool) {
        clipsToBounds = true
        addSubview(imageView)
        constrain(imageView) {
            $0.edges == $0.superview!.edges
        }

        if blurred {
            addSubview(sheetLayout)
            constrain(sheetLayout) {
                $0.edges == $0.superview!.edges
            }
        }
    }
}
