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

internal class SegmentedControlLayout: UICollectionViewLayout {

    // MARK: - Properties
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
    
    /// 是否是 宽度自适应
    private var isWidthAdaptive: Bool {
        return itemWidth <= 0
    }
    
    private typealias LayoutInfo = (x: CGFloat, width: CGFloat)
    
    private var itemLayoutInfos = [LayoutInfo]()
    
    // MARK: - Override
    override var collectionViewContentSize: CGSize {
        var width: CGFloat = 0
        if let lastLayoutInfos = itemLayoutInfos.last {
            width = lastLayoutInfos.x + lastLayoutInfos.width + rightMargin
        }
        return CGSize(width: width, height: 10)
    }
    
    override func prepare() {
        super.prepare()
        
        calculateItemLayoutInfos()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for (index, layoutInfo) in itemLayoutInfos.enumerated() {
            
            if layoutInfo.x <= rect.maxX && layoutInfo.x + layoutInfo.width >= rect.origin.x {
                if let layoutAttribute = layoutAttributesForItem(at: IndexPath(row: index, section: 0)) {
                    layoutAttributes.append(layoutAttribute)
                }
            } else if layoutInfo.x > rect.maxX {
                // 超出rect的item直接忽略，循环中断
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
    
    // MARK: - Private Methods
    private func calculateItemLayoutInfos() {
        
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
    }
}
