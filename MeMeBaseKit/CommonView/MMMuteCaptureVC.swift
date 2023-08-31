//
//  MMMuteCaptureVC.swift
//  MeMeKit
//
//  Created by xfb on 2023/8/31.
//

import Foundation
import Foundation
import Cartography
import MeMeKit

open class MMMuteCaptureVC : UIViewController {
    
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    //MARK: <>生命周期开始
    open override func loadView() {
        self.view = UIView.getMuteCapture()
    }
    required public init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}

