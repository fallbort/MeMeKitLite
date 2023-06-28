//
//  CommonStringPickerVC.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/10.
//

import Foundation
import Cartography

@objc public class CommonStringPickerVC : UIViewController,BottomCardProtocol {
    
    //MARK: <>外部变量
    @objc public var lists:[[String]] = []  //显示数据
    @objc public var selections:[Int] = []  //当前已选中数据
    //MARK: <>外部block
    @objc public var didcomfirmBlock:((_ curSelections:[Int])->())?
    
    //MARK: <>生命周期开始
    deinit {
        self.isInDeinit = true
    }
    @objc public required init() {
        super.init(nibName: nil, bundle: nil)
        self.contentSizeInPopup = self.pickerVc.contentSizeInPopup
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.pickerVc.datas = (self.lists,self.selections)
    }
    
    func setupViews() {
        self.pickerVc.addTo(self, rect: CGRect())
        constrain(self.pickerVc.view) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    lazy var pickerVc:CommonPickerVC<String> = {
        let vc = CommonPickerVC<String>()
        if self.isInDeinit == false {
            vc.didcomfirmBlock = { [weak self] curSelections in
                self?.didcomfirmBlock?(curSelections)
                self?.closeRoot(animate: true)
            }
        }
        return vc
    }()
    //MARK: <>内部block
    
}

