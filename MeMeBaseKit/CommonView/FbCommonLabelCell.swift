//
//  FbCommonLabelCell.swift
//  MeMe
//
//  Created by fabo on 2021/4/15.
//  Copyright © 2021 sip. All rights reserved.
//

import Foundation
import Cartography

public class FbCommonLabelCell : UITableViewCell {
    
    //MARK:<>外部变量
    public var contentEdgeInset:UIEdgeInsets? {
        didSet {
            if let contentEdgeInset = contentEdgeInset {
                leadingLayout?.constant = contentEdgeInset.left
                trailingLayout?.constant = 0 - contentEdgeInset.right
                topLayout?.constant = contentEdgeInset.top
                bottomLayout?.constant = 0 - contentEdgeInset.bottom
            }
        }
    }
    //MARK:<>外部block
    
    //MARK:<>生命周期开始
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    fileprivate func setupViews() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(contentLabel)
        constrain(contentLabel) {
            leadingLayout = ($0.leading == $0.superview!.leading)
            trailingLayout = ($0.trailing == $0.superview!.trailing)
            topLayout = ($0.top == $0.superview!.top)
            bottomLayout = ($0.bottom == $0.superview!.bottom)
        }
    }
    //MARK:<>功能性方法
    
    //MARK:<>内部View
    public var contentLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    //MARK:<>内部UI变量
    fileprivate var leadingLayout:NSLayoutConstraint?
    fileprivate var trailingLayout:NSLayoutConstraint?
    fileprivate var topLayout:NSLayoutConstraint?
    fileprivate var bottomLayout:NSLayoutConstraint?
    
    //MARK:<>内部数据变量
    //MARK:<>内部block
}
