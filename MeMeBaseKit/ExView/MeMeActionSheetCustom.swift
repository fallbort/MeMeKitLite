//
//  MeMeActionSheetCustom.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/10.
//

import Foundation

import Foundation
import Cartography

@objc public class MeMeActionSheetCustom : UIViewController {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    @objc public required init() {
        super.init(nibName: nil, bundle: nil)
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: 50)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    //MARK: <>功能性方法
    @objc public func show(in inView:UIView) {
        if let svc = inView.superController {
            MeMeShowManager.commonBottomShow(superController: svc, rootVC: self)
        }
        
    }
    
    @objc public func addButton(withTitle:String,block:VoidBlock?) {
        
    }
    
    fileprivate func refreshHeight() {
        
    }
    //MARK: <>内部View
    var cancelBtn: UIView = {
        let view = UIView()
        return view
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var btns:[(title:String,block:VoidBlock?)] = []
    //MARK: <>内部block
    
}

