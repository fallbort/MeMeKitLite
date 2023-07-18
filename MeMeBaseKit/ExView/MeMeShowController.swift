//
//  MeMeShowController.swift
//  MeMeKit
//
//  Created by xfb on 2023/3/24.
//

import Foundation

fileprivate struct AssociatedKeys {
    static var AssociatedName = "AssociatedName"
}

fileprivate class AssociatedContainer {
    weak var showController:MeMeShowController?
}

public protocol MeMeShowProtocol where Self:UIViewController {
    var closeClickedBlock:((_ animate:Bool)->())? {get set}
    func close(_ animate:Bool) //调用进行关闭
    init()
}

private struct MeMeShowAssociatedKeys {
    static var associatedNameAction = "AssociatedNameAction"
    static var associatedNameDone = "AssociatedNameDone"
    static var associatedNameCancel = "associatedNameCancel"
}

extension MeMeShowProtocol {
    @discardableResult
    static func commonShow(superController:UIViewController,size:CGSize? = nil,offset:CGPoint? = nil,cornerRadius:CGFloat? = nil, clips:Bool = true,isTranslateView:Bool = false,tapDismiss:Bool = true,getParams: ((_ controller:Self)->())? = nil) -> Self {
        let roleVc = self.init()
        getParams?(roleVc)
        if let size = size {
            roleVc.contentSizeInPopup = size
        }
        let controller = MeMeShowController.init(rootViewController: roleVc,offset:offset ?? CGPoint(), cornerRadius: cornerRadius ?? 8.0, clips:clips,isTranslateView:isTranslateView,tapDismiss:tapDismiss)
        
        controller.show(superController)
        return roleVc
    }
    
    func getShowController() -> MeMeShowController? {
        if let container = objc_getAssociatedObject(self as Any, &AssociatedKeys.AssociatedName) as? AssociatedContainer,let pController = container.showController {
            return pController
        }else{
            return nil
        }
    }
    
    public var closeClickedBlock:((_ animate:Bool)->())? {
        get {
            if let function = objc_getAssociatedObject(self, &MeMeShowAssociatedKeys.associatedNameAction) as? ((Bool)->()) {
                return  function
            }else{
                let function:((Bool)->()) = { [weak self] animate in
                    let didCloseFunction = self?.didClosedBlock
                    self?.dismiss(animated: animate) {
                        didCloseFunction?()
                    }
                }
                return function
            }
        }
        set {
            objc_setAssociatedObject(self, &MeMeShowAssociatedKeys.associatedNameAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var didClosedBlock: (()->())? {
        get {
            if let function = objc_getAssociatedObject(self, &MeMeShowAssociatedKeys.associatedNameDone) as? (()->()) {
                return  function
            }else{
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &MeMeShowAssociatedKeys.associatedNameDone, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var didCancelBlock: (()->())? {
        get {
            if let function = objc_getAssociatedObject(self, &MeMeShowAssociatedKeys.associatedNameCancel) as? (()->()) {
                return  function
            }else{
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &MeMeShowAssociatedKeys.associatedNameCancel, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func close(_ animate:Bool) {
        closeClickedBlock?(animate)
    }
}

class MeMeShowController : UIViewController {
    var theRootViewController: (UIViewController&MeMeShowProtocol)?
    
    fileprivate var backTapDismissView:UIView = {
        let backV = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        return backV
    }()
    var tapDismiss = true
    var offset:CGPoint = CGPoint()
    var backgroundColor:UIColor? {
        didSet {
            if let view = self.viewIfLoaded {
                view.backgroundColor = backgroundColor
            }
        }
    }
    
    override func loadView() {
        if isTranslateView == true {
            let view = TranslateHitView()
            self.view = view
        }else{
            self.view = UIView()
        }
    }
    
    convenience init(rootViewController: UIViewController&MeMeShowProtocol,offset:CGPoint = CGPoint(), cornerRadius: CGFloat = 8.0,clips:Bool = true,isTranslateView:Bool = false,tapDismiss:Bool = true) {
        self.init()
        self.isTranslateView = isTranslateView
        self.tapDismiss = tapDismiss
        self.offset = offset;
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.clipsToBounds = clips
        self.theRootViewController = rootViewController
        self.setParentToRootController()
        theRootViewController?.closeClickedBlock = { [weak self] animate in
            guard let strongSelf = self else { return}
            strongSelf.close()
            strongSelf.theRootViewController?.didClosedBlock?()
        }
    }
    
    func setParentToRootController() {
        let container = AssociatedContainer()
        container.showController = self
        objc_setAssociatedObject(theRootViewController as Any, &AssociatedKeys.AssociatedName, container, .OBJC_ASSOCIATION_RETAIN)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundColor = backgroundColor {
            self.view.backgroundColor = backgroundColor
        }else{
            self.view.backgroundColor = UIColor.hexString(toColor:"99000000")
        }
        if tapDismiss == true {
            self.view.addSubview(backTapDismissView)
            self.backTapDismissView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.backClicked(tap:))))
        }
        self.view.addSubview(containerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let controller = theRootViewController {
            var size = controller.contentSizeInPopup
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft,.landscapeRight:
                if controller.landscapeContentSizeInPopup != CGSize() {
                    size = controller.landscapeContentSizeInPopup
                }
            default:
                break
            }
            containerView.frame = CGRect.init(x: self.view.bounds.size.width/2 - size.width/2 + offset.x, y: self.view.bounds.size.height/2 - size.height/2 + offset.y, width: size.width, height: size.height)
            
            self.addChild(controller)
            controller.view.frame = containerView.bounds
            containerView.addSubview(controller.view)
            controller.didMove(toParent: self)
        }
        
    }
    
    @objc func backClicked(tap: UITapGestureRecognizer) {
        let point = tap.location(in: containerView)
        if tapDismiss == true {
            if containerView.bounds.contains(point) == false {
                close()
                theRootViewController?.didClosedBlock?()
                theRootViewController?.didCancelBlock?()
            }
        }
    }
    
    func close() {
        removeMe()
    }
    
    func show(_ superController:UIViewController) {
        superController.addChild(self)
        self.view.frame = superController.view.bounds
        superController.view.addSubview(self.view)
        self.didMove(toParent: superController)
    }
    
    lazy var containerView:UIView = {
        if isTranslateView == true {
            let view = TranslateHitView()
            return view
        }else{
            let view = UIView()
            return view
        }
    }()
    
    fileprivate var isTranslateView = false
    
}
