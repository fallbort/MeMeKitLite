//
//  BottomCardController.swift
//  MeMe
//
//  Created by fabo on 2021/11/1.
//  Copyright © 2021 sip. All rights reserved.
//

import Foundation
import Cartography
import UIKit

public protocol BottomCardProtocol where Self:UIViewController {
    func rootBeforeWillClose(_ animate:Bool)  //关闭前被调用
}

private var BottomCardVarControllerkey = "BottomCardVarControllerkey"
extension BottomCardProtocol {
    public var parentController: BottomCardController? {
        get {
            let weakArray = objc_getAssociatedObject(self, &BottomCardVarControllerkey) as? WeakReferenceArray<BottomCardController>
            if let contrtoller = weakArray?.allObjects().first as? BottomCardController {
                return contrtoller
            } else {
                return nil
            }
        }
        
        set {
            let weakArray = WeakReferenceArray<BottomCardController>()
            if let controller = newValue {
                weakArray.addObject(controller)
            }
            objc_setAssociatedObject(self, &BottomCardVarControllerkey, weakArray, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension BottomCardProtocol {
    @discardableResult
    public static func commonShowCard(controller:BottomCardController? = nil,superController: UIViewController,isCornerLandscape:Bool = false,fadeColor:UIColor? = nil,topRadius:CGFloat = 8,needClip:Bool = true,tapDismiss:Bool = true,getParams:((Self?)->())? = nil) -> Self? {
        var thisController:Self? = controller?.attachViewController as? Self
        if thisController == nil {
            let controller = self.init()
            thisController = controller
        }
        
        let cardController = BottomCardController.commonShow(controller: controller, superController: superController, isCornerLandscape: isCornerLandscape) { controller in
            controller?.attachViewController = thisController
            controller?.topRadius = topRadius
            controller?.needClipView = needClip
            controller?.tapDismiss = tapDismiss
            if let fadeColor = fadeColor {
                controller?.fadeView.backgroundColor = fadeColor
            }
            getParams?(thisController)
            _ = thisController?.view  //载入viewdidload
            controller?.baseHeight = thisController?.contentSizeInPopup.height ?? 0.0
        }
        return thisController
    }
    
    public func extraHeightChange(extraHeight:CGFloat,animate:Bool = false) {
        parentController?.extraHeightChange(extraHeight: extraHeight, animate: animate)
    }
    
    public func closeRoot(animate:Bool = true) {
        parentController?.hideAndClose()
    }
    
    public func hideAndClose() {
        parentController?.hideAndClose()
    }
    
    public func rootBeforeWillClose(_ animate:Bool) {}
}

public class BottomCardController : BaseCardController {
    //MARK:<>外部变量
    public var attachViewController:BottomCardProtocol? {
        didSet {
            oldValue?.parentController = nil
            self.extraHeight = 0
            attachViewController?.parentController = self
            self.beforeWillCloseInternal = { [weak self] animate in
                self?.attachViewController?.rootBeforeWillClose(animate)
            }
        }
    }
    public var topRadius:CGFloat = 0
    public var baseHeight:CGFloat = 0 {
        didSet {
            autoAdjustSize()
        }
    }
    
    public var needClipView = true
    
    //MARK:<>外部block
    
    //MARK:<>生命周期开始
    deinit {
        self.animateShowDelay?.cancel()
        self.animateShowDelay = nil
    }
    public required init() {
        super.init(nibName: nil, bundle: nil)
        autoAdjustSize()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        showHideNeedAnimation = true
        setupViews()
        resetFrameView()
        
        self.sheetCenter?.constant = self.view.bounds.size.height + self.cardHeight/2
        
        resetData()
        
        self.animateShowDelay?.cancel()
        self.animateShowDelay = nil
        self.animateShowDelay = delay(0.1) { [weak self] in
            if self?.needDidAppear == true {
                self?.needDidAppear = false
                self?.animateShow()
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateShow()
    }
    
    func animateShow() {
        if self.fadeView.alpha == 0.0 {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.fadeView.alpha = 1
                
                guard let wself = self else {
                    return
                }
                if self?.isCornerLandscape == false {
                    let centerYPos: CGFloat = wself.view.bounds.size.height/2 - wself.cardHeight/2
                    self?.sheetCenter?.constant = centerYPos
                }else{
                    self?.sheetRight?.constant = 0
                }
                
                self?.view.layoutIfNeeded()
            }
            
            sheetLayout.clipsToBounds = needClipView
        }
    }
    
    func setupViews() {
        sheetLayout.backgroundColor = .clear
        
        self.fadeView.alpha = 0
        if self.isCornerLandscape == false {
            self.sheetCenter?.constant = self.view.bounds.size.height + self.cardHeight/2
            constrain(sheetLayout) {
                $0.width == self.cardWidth
                sheetHeight = $0.height == self.cardHeight
            }
        }else{
            self.sheetRight?.constant = self.cornerWidth
        }
        
        //        let extraHeight = UIWindow.keyWindowSafeAreaInsets().bottom
        
        let backFrameView = TranslateHitView()
        backFrameView.layer.cornerRadius = topRadius
        
        backFrameView.clipsToBounds = needClipView
        sheetLayout.addSubview(backFrameView)
        constrain(backFrameView) {
            $0.leading == $0.superview!.leading
            $0.trailing == $0.superview!.trailing
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom + topRadius
        }
        
        let containView = TranslateHitView()
        backFrameView.addSubview(containView)
        constrain(containView) {
            $0.leading == $0.superview!.leading
            $0.trailing == $0.superview!.trailing
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom - topRadius
        }
        
        if let controller = attachViewController {
            controller.willMove(toParent: self)
            self.addChild(controller)
            containView.addSubview(controller.view)
            controller.didMove(toParent: self)
            constrain(controller.view) {
                $0.edges == $0.superview!.edges
            }
        }
        
    }
        
    fileprivate func resetFrameView() {
        autoAdjustSize()
        if self.hiding == false {
            sheetHeight?.constant = self.cardHeight
            let centerYPos: CGFloat = self.view.bounds.size.height/2 - cardHeight/2
            sheetCenter?.constant = centerYPos
        }
    }
    
    override func hide(_ complete: (() -> Void)? = nil) {
        self.hiding = true
        self.needDidAppear = false
        self.animateShowDelay?.cancel()
        self.animateShowDelay = nil
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let wself = self else {
                return
            }
            self?.fadeView.alpha = 0
            if self?.isCornerLandscape == false {
                if let theHeight = self?.cardHeight {
                    self?.sheetCenter?.constant = wself.view.bounds.size.height + theHeight/2
                }
            }else{
                self?.sheetRight?.constant = self?.cornerWidth ?? 0
            }
            
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.hiding = false
            complete?()
        })
    }
    
    //MARK:<>功能性方法
    func autoAdjustSize() {
        let width = UIScreen.main.bounds.width
        self.cardWidth = width
        let extraHeight = UIWindow.keyWindowSafeAreaInsets().bottom
        self.cardHeight = CGFloat(ceil(extraHeight + baseHeight + self.extraHeight))
    }
    
    func resetData() {
        
    }
    
    override func clean() {
        super.clean()
    }
    
    fileprivate func extraHeightChange(extraHeight:CGFloat,animate:Bool = false) {
        self.extraHeight = extraHeight
        if self.isViewLoaded == true {
            self.resetFrameView()
        }else{
            self.autoAdjustSize()
        }
    }
    
    public override func hideAndClose(_ button: UIButton? = nil) {
        beforeWillCloseInternal?(showHideNeedAnimation)
        super.hideAndClose(button)
    }
    
    override func getLayoutView() ->UIView? {
        return TranslateHitView()
    }
    
    //MARK:<>内部View
    
    //MARK:<>内部UI变量
    var sheetHeight:NSLayoutConstraint?
    
    //MARK:<>内部数据变量
    fileprivate var extraHeight:CGFloat = 0
    var hiding = false //隐藏中
    
    var animateShowDelay:DispatchWorkItem?
    
    //MARK:<>内部block
    fileprivate var beforeWillCloseInternal:((_ animate:Bool)->())?
}

