//
//  LeftRightTableView.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/6.
//

import Foundation
import Cartography

@objc public protocol LeftRightTableViewDelegate {
    @objc func getLeftTableHeaderView(section:NSInteger) -> UIView?
}

class LeftRightTableLCell : UITableViewCell {
    //MARK:<>外部变量
    
    //MARK:<>外部block
    
    //MARK:<>生命周期开始
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == false {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear
        }else{
            self.backgroundColor = .white
            self.contentView.backgroundColor = .clear
        }
    }
    
    fileprivate func setupViews() {
        
    }
    //MARK:<>功能性方法
    
    
    
    
    //MARK:<>内部View
    //MARK:<>内部UI变量
    //MARK:<>内部数据变量
    //MARK:<>内部block
}

@objc public class LeftRightTableView : UIView {
    
    //MARK: <>外部变量
    @objc public var rightDelegate:UITableViewDelegate?
    @objc public var rightDataSource:UITableViewDataSource?
    @objc public var otherDelegate:LeftRightTableViewDelegate?
    
    //MARK: <>外部block
    @objc public var tableviewDidClickedBlock:VoidBlock?
    
    //MARK: <>生命周期开始
    public convenience init() {
        self.init(frame: CGRect())
    }
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect())
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(self.leftTableView)
        self.addSubview(self.rightTableView)
        constrain(self.leftTableView) {
            $0.left == $0.superview!.left
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.width == 90
        }
        constrain(self.rightTableView,self.leftTableView) {
            $0.left == $1.right
            $0.right == $0.superview!.right
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
    }
    
    //MARK: <>功能性方法
    @objc public func reloadLeftData(section:NSInteger) {
        if let num = self.rightDataSource?.numberOfSections?(in: self.rightTableView),num > section {
            let oldSectedPath = self.leftTableView.indexPathForSelectedRow;
            let indexPath = IndexPath(row: 0, section: section)
            self.leftTableView.reloadRows(at: [indexPath], with: .none)
            if (oldSectedPath == indexPath) {
                self.leftTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none);
            }
        }
    }
    
    @objc public func reloadData() {
        self.rightTableView.reloadData()
        self.leftTableView.reloadData()
        if let num = self.rightDataSource?.numberOfSections?(in: self.rightTableView),num > 0 {
            let moveToIndexPath = IndexPath(row: 0, section: 0)
            self.leftTableView.selectRow(at: moveToIndexPath, animated: false, scrollPosition: .top)
        }
    }
    
    @objc public func registerRight(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.rightTableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    //MARK: <>内部View
    lazy var leftTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.scrollsToTop = false;
        tableView.estimatedRowHeight = 44;
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never;
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
              tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.registerClass(LeftRightTableLCell.self)
        tableView.keyboardDismissMode = .onDrag
        tableView.handleTapGesture { [weak self,weak tableView] in
            tableView?.endEditing(true)
            self?.tableviewDidClickedBlock?()
        }
        return tableView
    }()
    
    @objc public lazy var rightTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.scrollsToTop = true
        tableView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never;
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
              tableView.sectionHeaderTopPadding = 0
        }
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.keyboardDismissMode = .onDrag
        tableView.handleTapGesture { [weak self,weak tableView] in
            tableView?.endEditing(true)
            self?.tableviewDidClickedBlock?()
        }
        return tableView
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}


extension LeftRightTableView : UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.rightDataSource?.numberOfSections?(in: tableView) ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.leftTableView == tableView {
            return 1
        }else{
            let count:Int = self.rightDataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
            return count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTableView == tableView {
            let cell:LeftRightTableLCell = tableView.dequeueReusableCell(LeftRightTableLCell.self, forIndexPath: indexPath)
            var view = cell.viewWithTag(111)
            view?.removeFromSuperview()
            view = nil
            if view == nil {
                let newView:UIView = self.otherDelegate?.getLeftTableHeaderView(section: indexPath.section) ?? UIView()
                cell.addSubview(newView)
                newView.tag = 111
                view = newView
                constrain(newView) {
                    $0.left == $0.superview!.left
                    $0.right == $0.superview!.right
                    $0.top == $0.superview!.top
                    $0.bottom == $0.superview!.bottom
                    $0.height == 44
                }
                
            }
//            if let newView = cell.viewWithTag(111) {
//                newView.handleTapGesture { [weak self] in
//                    self?.leftTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//                    self?.rightTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
//                }
//            }
            
            return cell
        }else{
            return self.rightDataSource?.tableView(tableView, cellForRowAt: indexPath) ?? tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.leftTableView == tableView {
            return 0.0
        }else{
            return self.rightDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? 0.0
        }
        
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.leftTableView == tableView {
            return nil;
        }else{
            return self.rightDelegate?.tableView?(tableView, viewForHeaderInSection: section)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.leftTableView == tableView {
            self.rightTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }else{
            self.rightDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 右侧tableView滚动时, 左侧tableView滚动到相应 Row
        if scrollView == rightTableView {
            // 只有用户拖拽才触发, 点击左侧不触发
            if scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating {
                if let topIndexPath = self.rightTableView.indexPathsForVisibleRows?.first {
                    let moveToIndexPath = IndexPath(row: 0, section: topIndexPath.section)
                    let selectedRow = self.leftTableView.indexPathForSelectedRow
                    if selectedRow != moveToIndexPath {
                        self.leftTableView.selectRow(at: moveToIndexPath, animated: true, scrollPosition: .middle)
                    }
                }
            }
        }
    }
}

