//
//  CommonPickerVC.swift
//  ticket
//
//  Created by xfb on 2023/3/24.
//

import Foundation
import Cartography


class CommonPickerVC<T : CustomStringConvertible> : UIViewController,BottomCardProtocol {
    
    //MARK: <>外部变量
    var datas:(lists:[[T]],selections:[Int]) = ([],[]) {
        didSet {
            let internalDatas:[[String]] = self.datas.lists.compactMap({ list in
                return list.compactMap({ data in
                    return data.description
                })
            })
            self.helper.datas = internalDatas
            
            var selections:[Int] = []
            for (index,list) in self.datas.lists.enumerated() {
                if index < self.datas.selections.count, let selectIndex = Optional(self.datas.selections[index]), selectIndex < list.count {
                    selections.append(selectIndex)
                }else{
                    selections.append(0)
                }
            }
            
            self._curSelections = selections
            
            if self.isViewLoaded == true {
                self.pickView.reloadAllComponents()
                self.refreshSelection()
            }
        }
    }
    
    //MARK: <>外部block
    var didcomfirmBlock:((_ curSelections:[Int])->())?
    
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
        
        self.pickView.reloadAllComponents()
        refreshSelection()
        
        self.helper.selectionsChangedBlock = { [weak self] (row,section) in
            guard let `self` = self else {return}
            if section < self._curSelections.count {
                self._curSelections[section] = row
            }
        }
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        let comfirmBtn = UIButton()
        comfirmBtn.setTitle(NELocalize.localizedString("确定"), for: .normal)
        comfirmBtn.titleLabel?.font = ThemeLite.Font.regular(size: 16)
        comfirmBtn.setEnlargeEdge(20)
        comfirmBtn.setTitleColor(UIColor.hexString(toColor: "aa000000")!, for: .normal)
        
        self.view.addSubview(pickView)
        self.view.addSubview(comfirmBtn)
        self.view.addSubview(topLabel)
        constrain(pickView) {
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
        
        constrain(topLabel,comfirmBtn) {
            $0.centerX == $0.superview!.centerX
            $0.centerY == $1.centerY
        }
        
        comfirmBtn.handleControlEvent(.touchUpInside) { [weak self] in
            if let curSelections = self?.curSelections {
                self?.didcomfirmBlock?(curSelections)
                self?.closeRoot(animate: true)
            }
        }
    }
    
    func refreshSelection() {
        guard self.isViewLoaded == true else {return}
        for (section,row) in self.curSelections.enumerated() {
            self.pickView.selectRow(row, inComponent: section, animated: false)
        }
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    lazy var pickView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self.helper
        view.delegate = self.helper
        return view
    }()
    
    var topLabel: UILabel = {
        let view = UILabel()
        view.font = ThemeLite.Font.medium(size: 16)
        view.textColor =  UIColor.hexString(toColor: "#aa000000")!
        return view
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var _curSelections:[Int] = []
    var curSelections:[Int] {
        get {
            return _curSelections
        }
        set {
            _curSelections = newValue
            refreshSelection()
        }
    }
    
    var helper:CommonPickerHelper = CommonPickerHelper()
    //MARK: <>内部block
    
}

internal class CommonPickerHelper :NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: <>外部变量
    var datas:[[String]] = []
    
    //MARK: <>外部block
    var selectionsChangedBlock:((_ row:Int,_ section:Int)->())?
    
    
    //MARK: <>生命周期开始
    override init() {
        
    }
    //MARK: <>功能性方法
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return datas.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component < datas.count {
            let oneData = datas[component]
            return oneData.count
        }
        return 0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if datas.count > 0 {
            let count = datas.count >= 1 ? datas.count : 1
            return floor(UIScreen.main.bounds.width / CGFloat(count))
        }
        return 0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 37
    }
    
    internal func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var nowLabel:UILabel? = view as? UILabel
        if nowLabel == nil {
            let view = UILabel()
            view.textColor = UIColor.hexString(toColor: "dd000000")
            view.font = ThemeLite.Font.regular(size: 18)
            view.textAlignment = .center
            nowLabel = view
        }
        let list:[String]? = self.datas.count > component ? self.datas[component] : nil
        let data:String? = (list?.count ?? 0) > row ? list?[row] : nil
        nowLabel?.text = data?.description ?? ""
        return nowLabel ?? UILabel()
    }

    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionsChangedBlock?(row,component)
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}
