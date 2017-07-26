//
//  SegmentedControlLayout.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/7/22.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

protocol SegmentedControlLayoutDelegate: class {
    func getItemTitles(layout: SegmentedControlLayout) -> [String]
}

class SegmentedControlLayout: UICollectionViewLayout {

    weak var delegate: SegmentedControlLayoutDelegate?
    
    internal var shouldFill: Bool = false {
        didSet {
            invalidateLayout()
        }
    }

    internal var itemWidth: CGFloat     = -1 {
        didSet {
            invalidateLayout()
        }
    }

    internal var padding: CGFloat       = 15 {
        didSet {
            if isWidthAdaptive {
                invalidateLayout()
            }
        }
    }

    internal var itemMargin: CGFloat    = 0 {
        didSet {
            if !shouldFill {
                invalidateLayout()
            }
        }
    }
    
    internal var leftMargin: CGFloat    = 12 {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var rightMargin: CGFloat   = 12 {
        didSet {
            invalidateLayout()
        }
    }
    
    internal var fontSize: CGFloat = Const.defaultFontSize {
        didSet {
            if isWidthAdaptive {
                invalidateLayout()
            }
        }
    }
    
    private var isWidthAdaptive: Bool {
        return itemWidth <= 0
    }
    
    typealias LayoutInfo = (x: CGFloat, width: CGFloat)
    
    private var itemLayoutInfos = [LayoutInfo]()
    
    override var collectionViewContentSize: CGSize {
        var width: CGFloat = 0
        if let lastLayoutInfos = itemLayoutInfos.last {
            width = lastLayoutInfos.x + lastLayoutInfos.width + rightMargin
        }
        return CGSize(width: width, height: 10)
    }
    
    override func prepare() {
        super.prepare()
        /*
        var width: CGFloat = 0
        
        
        if itemWidth > 0 {
            /// 设置了itemWidth时，等宽
            width = itemWidth
        } else {
            let text = itemTitles[indexPath.row]
            let size = text.getTextRectSize(font: UIFont.systemFont(ofSize: fontSize),
                                            size: CGSize(width: CGFloat(Int.max), height: CGFloat(Int.max))) // 先随便写一个
            /// 忽略itemWidth，自适应宽度
            width = 2 * padding + size.width
        }
        
        /// shouldFill = true时，才会用到 itemsTotalWidth
        if shouldFill {
            /// 可能会这个方法循环了多次，才调用 minimumLineSpacingForSectionAt
            /// 所以在第0个的时候重置一下
            if indexPath.row == 0 {
                itemsTotalWidth = 0
            }
            itemsTotalWidth += width
        }
        
        /// It will crush if size is negative.
        return CGSize(width: width, height: bounds.height)
         */
        
        itemLayoutInfos.removeAll()
        let titles = delegate?.getItemTitles(layout: self) ?? []
        
        /// 计算高度
        let itemWidths = titles.map { (text) -> CGFloat in
            var width: CGFloat = 0
            
            if itemWidth > 0 {
                /// 设置了itemWidth时，等宽
                width = itemWidth
            } else {
                let size = text.getTextRectSize(font: UIFont.systemFont(ofSize: fontSize),
                                                size: CGSize(width: CGFloat(Int.max), height: CGFloat(Int.max))) // 先随便写一个
                /// 忽略itemWidth，自适应宽度
                width = 2 * padding + size.width
            }
            return width
        }
        
        /// 计算间距
        var margin: CGFloat = 0
        if shouldFill {
            let totalWidth = itemWidths.reduce(0) { (result, width) -> CGFloat in
                return result + width
            }
            let collectionViewWidth = collectionView?.bounds.width ?? 0
            let itemCountFloat = CGFloat(itemWidths.count)
            print("collectionViewWidth : \(collectionViewWidth)")
            margin = floor((collectionViewWidth - totalWidth - leftMargin - rightMargin) / (itemCountFloat - 1))
        } else {
            margin = itemMargin
        }
        
        /// 计算x坐标，并整合成layout info
        itemWidths.forEach { width in
            var x: CGFloat = 0
            
            if let lastItemLayoutInfo = itemLayoutInfos.last {
                
                x = lastItemLayoutInfo.x + lastItemLayoutInfo.width + margin
            } else {
                /// 第一个item时
                x = leftMargin
            }
            
            itemLayoutInfos.append(LayoutInfo(x: x, width: width))
        }
        
        /*
        titles.forEach { (text) in
            
            var width: CGFloat = 0
            
            if itemWidth > 0 {
                /// 设置了itemWidth时，等宽
                width = itemWidth
            } else {
                let size = text.getTextRectSize(font: UIFont.systemFont(ofSize: fontSize),
                                                size: CGSize(width: CGFloat(Int.max), height: CGFloat(Int.max))) // 先随便写一个
                /// 忽略itemWidth，自适应宽度
                width = 2 * padding + size.width
            }
            
            var x: CGFloat = 0
            if !shouldFill {
                if let lastItemLayoutInfo = itemLayoutInfos.last {
                    
                    x = lastItemLayoutInfo.x + lastItemLayoutInfo.width + itemMargin
                } else {
                    /// 第一个item时
                    x = leftMargin
                }
            }
            itemLayoutInfos.append((x: x, width: width))
        }
        
        if shouldFill {
            let totalWidth = itemLayoutInfos.reduce(0) { (result, layoutInfo) -> CGFloat in
                return result + layoutInfo.width
            }
            let collectionViewWidth = collectionView?.bounds.width ?? 0
            let itemCountFloat = CGFloat(itemLayoutInfos.count)
            print("collectionViewWidth : \(collectionViewWidth)")
            let margin = floor((collectionViewWidth - totalWidth - leftMargin - rightMargin) / (itemCountFloat - 1))
            itemLayoutInfos = itemLayoutInfos.map { (_, width) -> LayoutInfo in
                var newX: CGFloat = 0
         
                if let lastItemLayoutInfo = itemLayoutInfos.last {
                    
                    newX = lastItemLayoutInfo.x + lastItemLayoutInfo.width + margin
                } else {
                    /// 第一个item时
                    newX = leftMargin
                }
                return (newX, width)
            }
        }
         */
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for (index, layoutInfo) in itemLayoutInfos.enumerated() {
            
            if layoutInfo.x <= rect.maxX && layoutInfo.x + layoutInfo.width >= rect.origin.x {
                if let layoutAttribute = layoutAttributesForItem(at: IndexPath(row: index, section: 0)) {
                    layoutAttributes.append(layoutAttribute)
                }
            } else if layoutInfo.x > rect.maxX {
                break
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let layoutInfo = itemLayoutInfos[indexPath.row]
        let height = collectionView?.bounds.height ?? 0
        attribute.frame = CGRect(x: layoutInfo.x, y: 0, width: layoutInfo.width, height: height)
       
        return attribute
    }
    
}
