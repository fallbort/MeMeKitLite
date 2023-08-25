//
//  BaseCardController.swift
//  MeMe
//
//  Created by FengMengtao on 2018/9/27.
//  Copyright © 2018年 sip. All rights reserved.
//

import UIKit
import Cartography

public protocol BaseCardProtocol where Self:UIViewController {
    var isCornerLandscape:Bool {get set}
}

public class BaseCardController: UIViewController,BaseCardProtocol {
    public var showHideNeedAnimation: Bool = false
    public var willClose: (()->Void)?
    public var beforeWillClose:((_ animated:Bool)->Void)?
    public var cardHeightFromOut:CGFloat? {
        didSet {
            refreshCardSize()
        }
    }
    
    public var isCornerLandscape = false
    public var cornerWidth:CGFloat = 320
    
    public var tapDismiss = true
    
    internal var cardWidth: CGFloat = 0
    internal var cardHeight: CGFloat = 0
    
    @objc public lazy var fadeView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.init(hexStr: "000000", alpha: 0.4)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fadeViewClick)))
        return view
    }()
    
    internal lazy var contentScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.isScrollEnabled = true
        return scrollview
    }()
    
    internal lazy var sheetLayout: UIView = {
        let view = getLayoutView() ?? UIView()
        return view
    }()
    
    internal var isScrollEnable: Bool = false
    internal var sheetLayoutConstraint: ConstraintGroup?
    
    internal var sheetCenter: NSLayoutConstraint?
    internal var sheetRight: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init(scrollEnable: Bool = false, cardSize: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.isScrollEnable = scrollEnable
        self.cardWidth = cardSize.width
        self.cardHeight = cardSize.height
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isCoverMeMeNavAndTabBar = true;
        view.addSubview(fadeView)
        constrain(fadeView) {
            $0.edges == $0.superview!.edges
        }
        
        if isCornerLandscape == false {
            if self.isScrollEnable {
                view.addSubview(contentScrollView)
                contentScrollView.addSubview(sheetLayout)
                
                constrain(contentScrollView) {
                    $0.centerX == $0.superview!.centerX
                    sheetCenter = ($0.centerY == $0.superview!.centerY)
                    ($0.height <= $0.superview!.height).priority = .defaultHigh
                }

                constrain(sheetLayout) {
                    $0.edges == $0.superview!.edges
                    $0.width == $0.superview!.width
                    ($0.height == $0.superview!.height).priority = .defaultLow
                }
            } else {
                view.addSubview(sheetLayout)
                sheetLayoutConstraint = constrain(sheetLayout) {
                    $0.centerX == $0.superview!.centerX
                    sheetCenter = ($0.centerY == $0.superview!.centerY)
                    ($0.height <= $0.superview!.height).priority = .defaultHigh
                }
            }
        }else{
            view.addSubview(sheetLayout)
            sheetLayoutConstraint = constrain(sheetLayout) {
                sheetRight = $0.trailing == $0.superview!.trailing
                $0.width == self.cornerWidth
                $0.top == $0.superview!.top
                $0.bottom == $0.superview!.bottom
            }
        }
        
        
    }
    
    @objc public func hideAndClose(_ button: UIButton? = nil) {
        beforeWillClose?(showHideNeedAnimation)
        if showHideNeedAnimation {
            hide { [weak self] in
                self?.close()
            }
        } else {
            close()
        }
    }
    
    func hide(_ complete: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.fadeView.alpha = 0
            if self?.isCornerLandscape == false {
                self?.sheetCenter?.constant = -UIScreen.main.bounds.height
            }else{
                self?.sheetRight?.constant = self?.cornerWidth ?? 0
            }
            self?.view.layoutIfNeeded()
        }, completion: { _ in
            complete?()
        })
    }
    
    internal func close() {
        clean()
        if let presentingVC = self.presentingViewController,self.parent == presentingVC || self.parent == nil {
            self.dismiss(animated: false, completion: nil)
            
        }else{
            removeMe()
        }
        
        willClose?()
    }
    
    // 在关闭页面时，善后工作，子类可重写，进行回收内存
    internal func clean() {
        
    }
    
    @objc func fadeViewClick() {
        if self.tapDismiss == true {
            hideAndClose()
        }
    }
    
    func getLayoutView() ->UIView? {
        return nil
    }
    
    internal func refreshCardSize() {
        
    }
}

extension BaseCardProtocol {
    @discardableResult
    public static func commonShow(controller:Self? = nil,superController: UIViewController,isCornerLandscape:Bool = false,getParams:((Self?)->())? = nil) -> Self?  {
        var thisController = controller
        if thisController == nil {
            let controller = self.init()
            controller.isCornerLandscape = isCornerLandscape
            thisController = controller
        }
        
        getParams?(thisController)
        
        if let thisController = thisController {
            superController.addChild(thisController)
            thisController.view.frame = superController.view.bounds
            superController.view.addSubview(thisController.view)
            thisController.didMove(toParent: superController)
            thisController.needDidAppear = true
            return thisController
        }
        return nil
    }
    
    @discardableResult
    public static func commonPresent(controller:Self? = nil,superController: UIViewController,isCornerLandscape:Bool = false,getParams:((Self?)->())? = nil) -> Self?  {
        var thisController = controller
        if thisController == nil {
            let controller = self.init()
            controller.isCornerLandscape = isCornerLandscape
            thisController = controller
        }
        
        getParams?(thisController)
        
        if let thisController = thisController {
            thisController.modalPresentationStyle = .custom
            superController.present(thisController, animated: false, completion: nil)
            return thisController
        }
        return nil
    }
}

private var needDidAppearKey = "appear"

extension BaseCardProtocol {
    internal var needDidAppear: Bool {
        get {
            let timer = objc_getAssociatedObject(self, &needDidAppearKey) as? Bool
            return timer ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &needDidAppearKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
