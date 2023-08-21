//
//  MMRankController.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/13.
//

import Foundation

import Foundation
import Cartography

public protocol MMRankControllerDelegete {
    func tabDidChanged(from:UIViewController?,to:UIViewController)
    func tabIsMoving()
}

extension MMRankControllerDelegete {
    public func tabDidChanged(from:UIViewController?,to:UIViewController) {}
    public func tabIsMoving() {}
}

@objc open class MMRankController : UIViewController {
    
    //MARK: <>外部变量
    public var initSkipIndex:Int?
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    required public init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.hasTranslate = true

        segment.onSelected = { [weak self] index in
            self?.scrollToIndex(index)
            self?.selectedIndex = index
            
        }
        
        if let initSkipIndex = initSkipIndex, initSkipIndex < controllers.count {
            self._selectedIndex = initSkipIndex
            indexHadShowedList.append(_selectedIndex)
            self.scrollToIndex(initSkipIndex)
            self.initSkipIndex = nil
        }else{
            indexHadShowedList.append(self.selectedIndex)
        }
        
        setupViews()
        
        setupSubControllers()
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        for (i, controller) in controllers.enumerated() {
            if i == selectedIndex { continue }
            if controller.parent != nil {
                controller.view.removeFromSuperview()
                controller.removeFromParent()
            }
        }
    }
    
    func segmentOnSelected(_ index: Int) {
        
    }
    
    open func setupSubControllers() {
        updateSelectedIndex(selectedIndex)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configScrollViewSize()
    }
    
    
    func configScrollViewSize() {
        let isSetContentOffset = (scrollView.contentSize.width != scrollView.bounds.size.width * CGFloat(controllers.count) || scrollView.contentSize.height != scrollView.height)
        if isSetContentOffset {
            scrollView.contentSize = CGSize(width : scrollView.bounds.size.width * CGFloat(controllers.count), height: scrollView.bounds.size.height)
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width * CGFloat(selectedIndex), y: 0)
            for subview in scrollView.subviews {
                subview.frame = CGRect(x: CGFloat(subview.tag) * scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            }
        }
    }
    
    func updateSelectedIndex(_ index: Int) {
        
        guard index < controllers.count else {
            return
        }
        
        if segment.selectedIndex == index && controllers[index] == selectedViewController {
            return
        }
        
        if let prevController = selectedViewController  {
            prevController.viewWillDisappear(true)
        }
        if selectedViewController?.parent != nil {
            selectedViewController?.willMove(toParent: nil)
        }
        selectedViewController?.removeFromParent()
        
        segment.selectedIndex = index
        
        let currentController = controllers[index]
        if currentController.parent == nil {
            currentController.view.frame = CGRect(x: CGFloat(index) * scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            currentController.view.tag = index
            scrollView.addSubview(currentController.view)
        }
        addChild(currentController)
        currentController.didMove(toParent: self)
        selectedViewController = currentController
        updateSelectedController(currentController)
        _selectedIndex = index
        scrollToIndex(index)
    }
    
    func updateSelectedController(_ controller: UIViewController?) {
    
    }
    
    open func setupViews() {
        view.addSubview(scrollView)
        if segmentInView {
            view.addSubview(segment)
        }
        if segmentInView {
            constrain(scrollView, segment) {
                $0.left == $0.superview!.left
                $0.right == $0.superview!.right
                scrollViewTopConstraint =  $0.top == $1.bottom
                $0.bottom == $0.superview!.bottom
            }
        } else {
            constrain(scrollView) {
                $0.edges == $0.superview!.edges
            }
        }
        
    }
    
    func resetUI() {
        selectedIndex = 0
        scrollToIndex(0)
    }
    
    internal func scrollToIndex(_ index: Int) {
        let x = scrollView.bounds.size.width * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: abs(selectedIndex - index) == 1)
    }
    
    internal func scrollViewdidScroll(_ scrollView: UIScrollView) {
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    public lazy var scrollView: TraslatePanScrollVIew = {
        let scrollView = TraslatePanScrollVIew(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.clipsToBounds = true
        return scrollView
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    var scrollViewTopConstraint: NSLayoutConstraint?
    internal var segmentInView: Bool {
        get {
            return false
        }
    }
    
    open var segment: RankTabBar {
        get {
            return RankTabBar(frame: .zero)
        }
    }
    
    open var controllers: [UIViewController] {
        get {
            return [UIViewController]()
        }
    }
    
    var selectedViewController: UIViewController?
    internal var _selectedIndex = 0
    var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            guard newValue >= 0 && newValue < controllers.count && newValue != _selectedIndex else {
                return
            }
            
            if self.view.frame.width > 0.0 {
                let oldController = selectedViewController
                _selectedIndex = newValue
                updateSelectedIndex(_selectedIndex)
                segmentOnSelected(_selectedIndex)
                if let newController = selectedViewController {
                    for (index,controller) in controllers.enumerated() {
                        if indexHadShowedList.contains(where: {$0 == index}) {
                            if newController == controller {
                                controller.viewWillAppear(true)
                                controller.viewDidAppear(true)
                            }else if oldController == controller{
                                controller.viewWillDisappear(true)
                                controller.viewDidDisappear(true)
                            }
                        }else{
                            indexHadShowedList.append(index)
                        }
                        if let controller = controller as? MMRankControllerDelegete {
                            controller.tabDidChanged(from: oldController, to: newController)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate var indexHadShowedList:[Int] = []  //index对应的页面曾经出现过
    //MARK: <>内部block
    
}


extension MMRankController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let oldController = selectedViewController
            if let newController = selectedViewController {
                for controller in controllers {
                    if let controller = controller as? MMRankControllerDelegete {
                        controller.tabDidChanged(from: oldController, to: newController)
                    }
                }
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView {
            return
        }
        var index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if index > controllers.count {
            index = controllers.count - 1
        }
        let oldController = selectedViewController
        selectedIndex = index
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView {
            return
        }
        // 如果不是手势拖动导致的此方法被调用，不处理
        if !(scrollView.isDragging || scrollView.isDecelerating) {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.frame.size.width
        
        // 滑动越界不处理
        if offsetX < 0 {
            return
        }
        if offsetX > scrollView.contentSize.width - scrollViewWidth {
            return
        }
        
        segment.updateSubViewsWhen(scrollView: scrollView)
        for controller in controllers {
            if let controller = controller as? MMRankControllerDelegete {
                controller.tabIsMoving()
            }
        }
        
        scrollViewdidScroll(scrollView)
    }
}
