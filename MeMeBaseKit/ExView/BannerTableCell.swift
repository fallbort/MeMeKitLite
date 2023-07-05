//
//  BannerTableCell.swift
//  MeMe
//
//  Created by fabo on 2021/6/25.
//  Copyright © 2021 sip. All rights reserved.
//

import UIKit

public class BannerTableCell : UITableViewCell {
    //MARK:<>外部变量
    public var contentInsets:UIEdgeInsets?{
        didSet {
            layoutSubviews()
        }
    }
    public var bannerClickItem: String?
    public var bannerInfoList: [NewScrollBannerContent]? {
        didSet {
            if let bannerInfoList = bannerInfoList {
                scrollBanner.bannerInfoList = bannerInfoList
            }
        }
    }
    
    //MARK:<>外部block
    public var didSelectBanner: ((NewScrollBannerContent, Int) -> Void)?
    
    //MARK:<>生命周期开始
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        scrollBanner.stopScrollAnimation()
    }
    
    fileprivate func setupViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(scrollBanner)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let contentInsets = contentInsets {
            let width = self.bounds.size.width - contentInsets.left - contentInsets.right
            let height = CGFloat(width * 78.0 / 351.0)
            scrollBanner.frame = CGRect(x: contentInsets.left, y: contentInsets.top, width: width, height: height)
        }
    }
    //MARK:<>功能性方法
    
    
    
    
    //MARK:<>内部View
    lazy var scrollBanner: NewScrollBanner = {
        let width = UIScreen.main.bounds.width - 24
        let height = CGFloat(width * 78.0 / 351.0)
        let banner = NewScrollBanner(frame: CGRect(x: 12, y: 0, width: width, height: height))
        banner.clipsToBounds = true
        banner.layer.cornerRadius = 8
        banner.didSelectBanner = { [weak self] element, index in
            guard let `self` = self else { return }
            
            if let didSelectBanner = self.didSelectBanner {
                didSelectBanner(element, index)
                return
            }
        }
        return banner
    }()
    //MARK:<>内部UI变量
    //MARK:<>内部数据变量
    //MARK:<>内部block
}
