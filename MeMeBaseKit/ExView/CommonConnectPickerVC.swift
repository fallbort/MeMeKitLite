//
//  CommonConnectPickerVC.swift
//  MeMeKit
//
//  Created by xfb on 2023/7/24.
//

import Foundation
import Cartography

protocol internelCommonConnectPickerdataSource : NSObjectProtocol {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
}

public protocol CommonConnectPickerdataSource : NSObjectProtocol {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, preSelection:[Int]) -> String
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int, preSelection:[Int]) -> Int
}

extension CommonConnectPickerdataSource {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, preSelection:[Int]) -> String {
        return ""
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {return 0}
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int, preSelection:[Int]) -> Int {return 0}
}

public class CommonConnectPickerVC : UIViewController,BottomCardProtocol {
    
    //MARK: <>外部变量
    public override var title: String? {
        didSet {
            self.topLabel.text = title
        }
    }
    
    public weak var dataSource:CommonConnectPickerdataSource? {
        didSet {
            
        }
    }
    
    public var selections:[Int] {
        get {
            return _curSelections
        }
        set {
            _curSelections = newValue
            refreshSelection()
        }
    }
    //MARK: <>外部block
    public var didcomfirmBlock:((_ curSelections:[Int],_ curTitles:[String])->())?
    
    //MARK: <>生命周期开始
    public required init() {
        super.init(nibName: nil, bundle: nil)
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: 320)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.pickView.reloadAllComponents()
        refreshSelection()
        
        self.helper.selectionsChangedBlock = { [weak self] (row,section) in
            guard let `self` = self else {return}
            if section < self._curSelections.count {
                self._curSelections[section] = row
                for i in (section+1)..<self._curSelections.count {
                    self._curSelections[i] = 0
                    self.pickView.reloadComponent(section+1)
                    self.pickView.selectRow(0, inComponent: i, animated: false)
                }
            }
        }
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        let comfirmBtn = UIButton()
        comfirmBtn.setTitle(NELocalize.localizedString("确定",bundlePath: MeMeKitBundle), for: .normal)
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
            guard let `self` = self else {return}
            let curSelections = self.selections
            var titles:[String] = []
            for (section,row) in curSelections.enumerated() {
                let preSelection:[Int] = self.getPreSelection(curComponent: section)
                let title = self.dataSource?.pickerView(self.pickView, titleForRow: row, forComponent: section, preSelection: preSelection) ?? ""
                titles.append(title)
            }
            self.didcomfirmBlock?(curSelections,titles)
            self.closeRoot(animate: true)
        }
    }
    
    func refreshSelection() {
        guard self.isViewLoaded == true else {return}
        self.componentsCount = self.helper.numberOfComponents(in: self.pickView)
        for (section,row) in self.selections.enumerated() {
            if self.componentsCount > section+1 {
                self.pickView.reloadComponent(section+1)
            }
            self.pickView.selectRow(row, inComponent: section, animated: false)
        }
    }
    
    func getPreSelection(curComponent:Int) -> [Int] {
        let curSelections = self.selections
        if (curComponent < curSelections.count) {
            var preSelection:[Int] = []
            for i in 0..<curComponent {
                preSelection.append(curSelections[i])
            }
            return preSelection
        }
        return []
    }
    
    //MARK: <>功能性方法
    //MARK: <>内部View
    public lazy var pickView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self.helper
        view.delegate = self.helper
        return view
    }()
    
    public var topLabel: UILabel = {
        let view = UILabel()
        view.font = ThemeLite.Font.medium(size: 16)
        view.textColor =  UIColor.hexString(toColor: "#aa000000")!
        return view
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    fileprivate var _curSelections:[Int] = []
    
    lazy var helper:CommonConnectPickerHelper = {
        let helper = CommonConnectPickerHelper()
        helper.dataSource = self
        return helper
    }()
    
    var componentsCount:Int = 0
    //MARK: <>内部block
    
}

extension CommonConnectPickerVC : internelCommonConnectPickerdataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        let preSelection:[Int] = self.getPreSelection(curComponent: component)
        return self.dataSource?.pickerView(pickerView, titleForRow: row, forComponent: component, preSelection: preSelection) ?? ""
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataSource?.numberOfComponents(in: pickerView) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let preSelection:[Int] = self.getPreSelection(curComponent: component)
        return self.dataSource?.pickerView(pickerView, numberOfRowsInComponent: component, preSelection: preSelection) ?? 0
    }
}

internal class CommonConnectPickerHelper :NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: <>外部变量
    weak var dataSource:internelCommonConnectPickerdataSource?
    
    //MARK: <>外部block
    var selectionsChangedBlock:((_ row:Int,_ component:Int)->())?
    
    
    //MARK: <>生命周期开始
    override init() {
        
    }
    //MARK: <>功能性方法
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let count = dataSource?.numberOfComponents(in: pickerView) ?? 0
        return count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.pickerView(pickerView, numberOfRowsInComponent: component) ?? 0
    }
    
    internal func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let componentCount = self.numberOfComponents(in: pickerView)
        if componentCount > 0 {
            let count = componentCount >= 1 ? componentCount : 1
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
        let title = dataSource?.pickerView(pickerView, titleForRow: row, forComponent: component) ?? ""
        nowLabel?.text = title
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
