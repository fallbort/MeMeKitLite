//
//  ImageCollectionCell.swift
//  MeMe
//
//  Created by LuanMa on 2017/1/9.
//  Copyright © 2017年 sip. All rights reserved.
//

import Cartography

public protocol SimpleNamedImage {
	var imageName: String { get }
}

open class ImageCollectionCell: UICollectionViewCell {
    public let badgeView = UIButton()
    public var imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
	}()
    
    public lazy var label:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        view.textColor = UIColor.hexString(toColor: "0xa0a0a0")
        return view
    }()
    
    public var simpleImage: SimpleNamedImage? {
		didSet {
			guard let simpleImage = simpleImage else {
				return
			}
			
			update(simpleImage: simpleImage)
		}
	}
    
    public var imgName: String? {
        didSet {
            guard let imgName = imgName else {
                return
            }
            
            imageView.image = UIImage(named: imgName)
        }
    }
    
    public var text: String? {
        didSet {
            label.text = text
            label.sizeToFit()
        }
    }
	
    public override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
    public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    open override func awakeFromNib() {
		super.awakeFromNib()
		setupViews()
	}
	
    open override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
    
    open func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.clipsToBounds = false
        contentView.backgroundColor = UIColor.clear
        
        constrain(imageView) {
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top
            $0.width == 44
            $0.height == 44
        }
        
        label.sizeToFit()
        constrain(label,imageView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $1.bottom + 12
        }
       
    }
}

extension ImageCollectionCell {
	fileprivate func update(simpleImage: SimpleNamedImage) {
        imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: simpleImage.imageName)
	}
}

class ProfileImageCollectionCell: ImageCollectionCell {
    open override func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.clipsToBounds = false
        contentView.addSubview(badgeView)
        constrain(label, imageView) {
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
            $0.top == $1.bottom + 10
            $0.bottom == $0.superview!.bottom
            $0.height == 13
            
            $1.top == $0.superview!.top
            $1.left == $0.superview!.left
            $1.right == $0.superview!.right
        }
        
        self.badgeView.backgroundColor = UIColor.red
        self.badgeView.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.badgeView.layer.cornerRadius = 6
        self.badgeView.layer.masksToBounds = true
        self.badgeView.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: UIFont.Weight.bold)
        constrain(self.badgeView, block: {
            $0.left    == $0.superview!.centerX + 10
            $0.width   == 12
            $0.height  == 12
            $0.centerY == $0.superview!.centerY - 20
        })
    }
    
    open func badge(string: String) {
        let badgeLabel = UILabel()
        badgeLabel.backgroundColor = UIColor.hexString(toColor: "0xff1e76")
        badgeLabel.textColor = UIColor.hexString(toColor: "0xFFFFFF")
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        badgeLabel.textAlignment = .center
        badgeLabel.text = string
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.clipsToBounds = true
        badgeLabel.sizeToFit()
        
        let badgeView = UIView()
        badgeView.backgroundColor = UIColor.hexString(toColor: "0xFFFFFF")
        badgeView.layer.cornerRadius = 9
        badgeView.clipsToBounds = true
        
        imageView.addSubview(badgeView)
        imageView.addSubview(badgeLabel)
        constrain(badgeLabel, badgeView) {
            $0.left == $0.superview!.centerX + 3
            $0.width >= 16
            $0.bottom == $0.superview!.bottom
            $0.height == 16
            
            $1.top == $0.top - 1
            $1.bottom == $0.bottom + 1
            $1.left == $0.left - 1
            $1.right == $0.right + 1
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
    }
}
