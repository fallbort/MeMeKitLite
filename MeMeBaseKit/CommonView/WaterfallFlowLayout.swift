//
//  WaterfallFlowLayout.swift
//  MeMe
//
//  Created by xfb on 2020/2/8.
//  Copyright © 2020 sip. All rights reserved.
//

import UIKit

public class WaterfallFlowLayout: UICollectionViewFlowLayout {
    /// 数据源对象
    public var layoutSourceClosure:((_ index:Int)->CGSize?)?
    /// 一行显示的item个数
    public var rowItemNum: Int = 0 {
        didSet {
            resetHeightValue()
        }
    }
    /// 单个item最大高度
    public var maxHeight:CGFloat?
    public var minHeight:CGFloat?
    
    /// 布局属性数组
    private lazy var layoutAttributes: [UICollectionViewLayoutAttributes]? = {
        return [UICollectionViewLayoutAttributes]()
        }()
    /// 列高数组
    private var colItemHeightValues: [CGFloat] = [CGFloat]()
    func resetHeightValue() {
        var numbers = [CGFloat]()
        for _ in 0..<rowItemNum {
            numbers.append(sectionInset.top)
        }
        colItemHeightValues = numbers
    }
    
    public override func prepare() {
        super.prepare()
        layoutAttributes?.removeAll()
        resetHeightValue()
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - (CGFloat(rowItemNum - 1) * minimumInteritemSpacing) - sectionInset.left - sectionInset.right) / CGFloat(rowItemNum)
        // 计算所有item的布局属性
        calcAllItemLayoutAttributeByItemWidth(itemWidth: itemWidth)
    }
    
    /// 返回所有item的布局属性
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
    
    /// 设置collectionView的滚动范围
    override open var collectionViewContentSize: CGSize {
        get {
            if colItemHeightValues.count > 0 {
                var maxHeight:CGFloat = 0
                for (_,item) in colItemHeightValues.enumerated() {
                    if item > maxHeight {
                        maxHeight = item
                    }
                }
                let y = maxHeight - minimumInteritemSpacing + sectionInset.bottom;
                return CGSize.init(width: UIScreen.main.bounds.width, height: y)
            }else{
                return CGSize.init(width: UIScreen.main.bounds.width, height: 0)
            }
        }
    }
}

extension WaterfallFlowLayout {
    /**
    计算所有item的布局属性
    */
    private func calcAllItemLayoutAttributeByItemWidth(itemWidth: CGFloat) {
        if layoutSourceClosure == nil {
            return
        }
        
        var index = 0
        while true {
            let attribute = calcItemLayoutAttribute(index: index, itemWidth: itemWidth)
            if let attribute = attribute {
                layoutAttributes?.append(attribute)
                index += 1
            }else{
                break
            }
        }
    }
    
    /**
    计算一个item的布局属性
    */
    private func calcItemLayoutAttribute(index: Int, itemWidth: CGFloat) -> UICollectionViewLayoutAttributes? {
        
        let h = calcItemHeight(index: index, width: itemWidth)
        if let h = h {
            // 创建布局属性
            let attribute = UICollectionViewLayoutAttributes(forCellWith: NSIndexPath(item: index, section: 0) as IndexPath)
            
            // 高度最小的列号和列高
            let colAndHeight = findMinHeightColIndexAndHeight()
            
            let x = sectionInset.left + CGFloat(colAndHeight.col) * (itemWidth + minimumInteritemSpacing)
            let y = colAndHeight.height
            
            // 将item的高度添加到数组进行记录
            colItemHeightValues[colAndHeight.col] += (h + minimumLineSpacing)
            
            // 设置frame
            attribute.frame = CGRect.init(x: x, y: y, width: itemWidth, height: h)
            return attribute
        }else{
            return nil
        }
    }
    
    /**
    根据数据源中的宽高计算等比例的高度
    
    :returns: item的高度
    */
    private func calcItemHeight(index: Int, width: CGFloat) -> CGFloat? {
        if let layoutSouceClosure = layoutSourceClosure,let layoutSource = layoutSouceClosure(index) {
            let h = layoutSource.height
            let w = layoutSource.width
            var curHeight = h / w * width
            if let maxHeight = maxHeight {
                curHeight = maxHeight > curHeight ? curHeight : maxHeight
            }
            if let minHeight = minHeight {
                curHeight = minHeight < curHeight ? curHeight : minHeight
            }
            return curHeight
        }else{
            return nil
        }
    }
    
    /**
    找出高度最小的列
    
    - returns: 列号和列高
    */
    private func findMinHeightColIndexAndHeight() -> (col: Int, height: CGFloat) {
        var minHeight: CGFloat = colItemHeightValues[0]
        var index = 0
        for i in 0..<rowItemNum {
            let h = colItemHeightValues[i]
            if minHeight > h {
                minHeight = h
                index = i
            }
        }
        return (index, minHeight)
    }
}
