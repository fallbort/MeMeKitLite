//
//  LeftRightTableView.swift
//  MeMeKit
//
//  Created by xfb on 2023/6/6.
//

import Foundation
import Cartography

@objc public protocol LeftRightTableViewDelegate {
    
}

@objc public class LeftRightTableView : UIView {
    
    //MARK: <>外部变量
    @objc public var delegate:UITableViewDelegate?
    @objc public var dataSource:UITableViewDataSource?
    @objc public var otherDelegate:LeftRightTableViewDelegate?
    
    //MARK: <>外部block
    
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
    }
    
    //MARK: <>功能性方法
    @objc public func reloadData() {
        
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
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never;
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
              tableView.sectionHeaderTopPadding = 0
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    //MARK: <>内部block
    
}


extension LeftRightTableView : UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.dataSource?.numberOfSections?(in: tableView) ?? 0
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.leftTableView == tableView {
            return 1
        }else{
            let count:Int = self.dataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
            return count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.leftTableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            return cell
        }else{
            return self.dataSource?.tableView(tableView, cellForRowAt: indexPath) ?? tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        }
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // 右侧tableView滚动时, 左侧tableView滚动到相应 Row
            if scrollView == rightTableView {
                // 只有用户拖拽才触发, 点击左侧不触发
                if scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating {
                    if let topIndexPath = self.rightTableView.indexPathsForVisibleRows?.first {
                        let moveToIndexPath = IndexPath(row: 0, section: topIndexPath.section)
                        self.leftTableView.selectRow(at: moveToIndexPath, animated: true, scrollPosition: .middle)
                    }
                }
            }
        }
}
