//
//  EmptyView.swift
//  LiveStream
//
//  Created by LuanMa on 16/6/24.
//  Copyright © 2016年 sip. All rights reserved.
//

import UIKit
import Cartography
import MeMeKit

public class EmptyView: UIControl {
    
    open var onClicked: ((EmptyView) -> Void)?
    
    /*自动判断是否有网络并在无网环境下使用相应图片时使用该值*/
    open var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    open var textLabelOffset: CGPoint = CGPoint(x: 0, y: 20) {
        didSet {
            guard let iGroup = iGroup else { return }
            guard let labelGroup = labelGroup else { return }
            
            constrain(imageView, replace: iGroup) {
                $0.centerX == $0.superview!.centerX + offset.x
                $0.centerY == $0.superview!.centerY + offset.y
            }
            
            constrain(textLabel, imageView, replace: labelGroup) {
                $0.centerX == $0.superview!.centerX + offset.x
                $0.top == $1.bottom + textLabelOffset.y
            }
            layoutIfNeeded()
        }
    }
    
    open var offset: CGPoint = CGPoint(x: 0, y: -30) {
        didSet {
            guard let iGroup = iGroup else { return }
            guard let labelGroup = labelGroup else { return }
            
            constrain(imageView, replace: iGroup) {
                $0.centerX == $0.superview!.centerX + offset.x
                $0.centerY == $0.superview!.centerY + offset.y
            }
            
            constrain(textLabel, imageView, replace: labelGroup) {
                $0.centerX == $0.superview!.centerX + offset.x
                $0.top ==  $1.bottom + textLabelOffset.y
                $0.left >= $0.superview!.left + 15
            }
            layoutIfNeeded()
        }
    }

    fileprivate var iGroup: ConstraintGroup?
    fileprivate var labelGroup: ConstraintGroup?
    fileprivate var imageIsInCenterY: Bool = false
    fileprivate var upTop: Bool = false
    
    public lazy var imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        constrain(view) {
            ($0.width == 0).priority = UILayoutPriority.init(199)
            ($0.height == 0).priority = UILayoutPriority.init(199)
        }
        return view
    }()
    
    public lazy var textLabel:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = UIColor.hexString(toColor: "000000")
        view.font = ThemeLite.Font.regular(size: 14)
        view.isUserInteractionEnabled = false
        return view
    }()

    public override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
    
    public init(frame: CGRect, imgisInCenterY: Bool = false, upTop: Bool = false) {
        self.imageIsInCenterY = imgisInCenterY
        self.upTop = upTop
        super.init(frame: frame)
        setupViews()
    }
    
    public init(other:EmptyView) {
        self.imageIsInCenterY = other.imageIsInCenterY
        self.upTop = other.upTop
        super.init(frame: other.frame)
        setupViews()
    }

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    public override func awakeFromNib() {
		superview?.awakeFromNib()
		setupViews()
	}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showBtn(_ btn:UIButton) {
        addSubview(btn)
        constrain(btn, textLabel) {
            $0.height == 36
            $0.centerX == $0.superview!.centerX
            $0.top == $1.bottom + 36
        }
    }
}

extension EmptyView {
	fileprivate func setupViews() {
		addSubview(imageView)
		addSubview(textLabel)

        let centerYValue: CGFloat = offset.y - 100
		iGroup = constrain(imageView) {
            $0.centerX == $0.superview!.centerX + offset.x
            // 2.5.6，设计需求不是居中显示。整体偏移100.
            if imageIsInCenterY {
                $0.centerY == $0.superview!.centerY
            } else {
                if upTop == true {
                    $0.top == $0.superview!.top
                }else {
                    $0.centerY == $0.superview!.centerY + centerYValue
                }
                
            }
		}

        labelGroup = constrain(textLabel, imageView) {
            $0.centerX == $0.superview!.centerX + offset.x
            $0.top ==  $1.bottom + textLabelOffset.y
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
        }

		addTarget(self, action: #selector(EmptyView.clickMe(_:)), for: .touchUpInside)
	}

    @objc func clickMe(_ sender: AnyObject) {
        onClicked?(self)
	}
}
