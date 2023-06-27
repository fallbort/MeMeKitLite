//
//  CommonDatePickerVC.swift
//  ticket
//
//  Created by xfb on 2023/3/24.
//

import Foundation
import Cartography

class CommonDatePickerVC : UIViewController, BottomCardProtocol {
    
    //MARK: <>外部变量
    var time:TimeInterval? {
        didSet {
            guard let time = time else {return}
            let maxTime = datePicker.date.timeIntervalSince1970
            let showTime = time > maxTime ? maxTime : time
            datePicker.date = Date.init(timeIntervalSince1970: showTime)
        }
    }
    
    var minTime:TimeInterval = 0 {  //最小时间
        didSet {
            self.datePicker.minimumDate = Date(timeIntervalSince1970: minTime)
        }
    }
    
    var maxTime:TimeInterval = 0 { //最大时间
        didSet {
            self.datePicker.maximumDate = Date(timeIntervalSince1970: maxTime)
        }
    }
    //MARK: <>外部block
    var didcomfirmBlock:((_ oldTime:TimeInterval?,_ newTime:TimeInterval)->())?
    
    //MARK: <>生命周期开始
    required init() {
        super.init(nibName: nil, bundle: nil)
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: 320)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        
        let comfirmBtn = UIButton()
        comfirmBtn.setTitle(NELocalize.localizedString("确定"), for: .normal)
        comfirmBtn.titleLabel?.font = ThemeLite.Font.regular(size: 14)
        comfirmBtn.setEnlargeEdge(20)
        comfirmBtn.setTitleColor(UIColor.hexString(toColor: "aa000000")!, for: .normal)
        
        self.view.addSubview(datePicker)
        self.view.addSubview(comfirmBtn)
        
        constrain(datePicker) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top + 44
            $0.bottom == $0.superview!.bottom
        }
        
        constrain(comfirmBtn) {
            $0.right == $0.superview!.right - 16
            $0.top == $0.superview!.top + 8
            $0.height == 22
        }
        
        comfirmBtn.handleControlEvent(.touchUpInside) { [weak self] in
            guard let `self` = self else {return}
            let time = self.datePicker.date.timeIntervalSince1970
            self.didcomfirmBlock?(self.time,time)
            self.closeRoot(animate: true)
        }
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    fileprivate lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        picker.datePickerMode = .date
        return picker
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}

