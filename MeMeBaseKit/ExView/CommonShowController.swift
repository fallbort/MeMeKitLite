//
//  CommonShowController.swift
//  MeMeKit
//
//  Created by xfb on 2023/4/11.
//

import Foundation

import Foundation
import Cartography

class CommonShowController : UIViewController,MeMeShowProtocol {
    
    //MARK: <>外部变量
    var outVC:UIViewController? {
        didSet {
            oldValue?.removeMe()
            if self.isViewLoaded {
                configVC()
            }
        }
    }
    
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    required init() {
        super.init(nibName: nil, bundle: nil)
        self.contentSizeInPopup = CGSize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        configVC()
    }
    
    func configVC() {
        if let outVC = outVC {
            outVC.addTo(self, rect: self.view.frame)
            constrain(outVC.view) {
                $0.left == $0.superview!.left
                $0.right == $0.superview!.right
                $0.top == $0.superview!.top
                $0.bottom == $0.superview!.bottom
            }
        }
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}

