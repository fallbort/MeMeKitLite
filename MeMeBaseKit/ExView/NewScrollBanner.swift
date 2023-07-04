//
//  NewScrollBanner.swift
//  LiveStream
//
//  Created by LuanMa on 16/6/16.
//  Copyright © 2016年 sip. All rights reserved.
//

import UIKit
import MeMeKit
import Cartography

public protocol NewScrollBannerContent {
    var coverUrl:String {get}
}

private let LoopInterval = TimeInterval(4)
private let LoadDataInterval = TimeInterval(30 * 60)

public class NewScrollBanner: UIView {
    fileprivate var circleScrollView:CircleScrollView
    
    fileprivate lazy var pageControl: UIPageControl = {
        let control = UIPageControl(frame: CGRect.zero)
        control.currentPageIndicatorTintColor = UIColor.white
        control.pageIndicatorTintColor = UIColor.init(white: 1, alpha: 0.4)
        control.isEnabled = false
        control.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        return control
    }()
    
    public var bannerInfoList = [NewScrollBannerContent]() {
        didSet {
            guard bannerInfoList.count > 0 else {
                return
            }
            pageControl.isHidden = bannerInfoList.count < 2
            pageControl.numberOfPages = bannerInfoList.count
            
            currentIndex = 0
            
           
            startScrollAnimation()
        }
    }
    
    public var currentIndex = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            circleScrollView.reloadData()
            circleScrollView.contentOffset = CGPoint(x: circleScrollView.width, y: 0)
        }
    }
    fileprivate var loopTask: CancelableTimeoutBlock?
    
    public var didSelectBanner: ((NewScrollBannerContent, Int) -> Void)?
    
    public init(frame: CGRect,placeHolder:UIImage? = nil) {
        self.circleScrollView = CircleScrollView(frame: CGRect.zero, direction: .horizontal, blurred: false, itemImg: placeHolder, pagingEnabled: true)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewScrollBanner {
    
    func startScrollAnimation() {
        loopTask?.cancel()
        guard bannerInfoList.count > 1 else {
            return
        }
        
        loopTask = timeout(LoopInterval) { [weak self] in
            self?.scrollNext()
        }
    }
    
    func stopScrollAnimation() {
        loopTask?.cancel()
    }
    
    fileprivate func setupView() {
        addSubview(circleScrollView)
        addSubview(pageControl)
        
        constrain(circleScrollView) {
            $0.edges == $0.superview!.edges
        }
        
        constrain(pageControl) {
            $0.centerX == $0.superview!.centerX
            $0.bottom == $0.superview!.bottom - 4
            $0.height == 5
        }
        
        circleScrollView.circleDelegate = self
    }
    
    fileprivate func scrollNext() {
        if bannerInfoList.count > 1 {
            circleScrollView.scrollNext()
        }
    }
}

extension NewScrollBanner: CircleScrollViewDelegate {
    func clicked() {
        guard bannerInfoList.count > 0 else {
            return
        }
        
        let index = currentIndex
        guard bannerInfoList.count > 0 && index >= 0 && index < bannerInfoList.count else {
            return
        }
        didSelectBanner?(bannerInfoList[index], index)
    }
    
    func changedToNext(_ next: Bool) {
        guard bannerInfoList.count > 0 else {
            return
        }
        
        let delta = next ? 1 : -1
        let index = currentIndex + delta
        
        if index < 0 {
            currentIndex = bannerInfoList.count - 1
        } else if index >= bannerInfoList.count {
            currentIndex = 0
        } else {
            currentIndex = index
        }
        pageControl.currentPage = currentIndex
        startScrollAnimation()
    }
    
    func prefixImageUrl() -> URL? {
        guard bannerInfoList.count > 1 else {
            return nil
        }
        
        if currentIndex > 0 {
            let index = currentIndex - 1
            return URL(stringByImg: bannerInfoList[index % bannerInfoList.count].coverUrl)
        } else if let urlString = bannerInfoList.last?.coverUrl {
            return URL(stringByImg: urlString)
        }
        
        return nil
    }
    
    func currentImageUrl() -> URL? {
        let index = currentIndex
        guard bannerInfoList.count > 0 && index >= 0 && index < bannerInfoList.count else {
            return nil
        }
        return URL(stringByImg: bannerInfoList[index].coverUrl)
    }
    
    func nextImageUrl() -> URL? {
        guard bannerInfoList.count > 1 else {
            return nil
        }
        
        if currentIndex < bannerInfoList.count - 1 {
            return URL(stringByImg: bannerInfoList[currentIndex + 1].coverUrl)
        } else if let urlString = bannerInfoList.first?.coverUrl {
            return URL(stringByImg: urlString)
        }
        
        return nil
    }
}

