//
//  BannerCCell.swift
//  MeMe
//
//  Created by fabo on 2021/6/29.
//  Copyright © 2021 sip. All rights reserved.
//

import UIKit

class BannerCCell: UICollectionViewCell {
    
    var contentInsets:UIEdgeInsets? {
        didSet {
            layoutSubviews()
        }
    }
    
    var bannerClickItem: String?
    var didSelectBanner: ((NewScrollBannerContent, Int) -> Void)?
    var bannerInfoList: [NewScrollBannerContent]? {
        didSet {
            if let bannerInfoList = bannerInfoList {
                scrollBanner.bannerInfoList = bannerInfoList
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollBanner.stopScrollAnimation()
    }
    
    fileprivate func setupViews() {
        contentView.backgroundColor = .clear
        addSubview(scrollBanner)
    }
    
    lazy var scrollBanner: NewScrollBanner = {
        let width = UIScreen.main.bounds.width - 16
        let height = CGFloat(width * 78.0 / 351.0)
        let banner = NewScrollBanner(frame: CGRect(x: 8, y: 0, width: width, height: height))
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let contentInsets = contentInsets {
            let width = self.bounds.size.width - contentInsets.left - contentInsets.right
            let height = CGFloat(width * 78.0 / 351.0)
            scrollBanner.frame = CGRect(x: contentInsets.left, y: contentInsets.top, width: width, height: height)
        }
    }
}
