//
//  SegmentedControlView.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/17.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

public struct SegmentedControlViewItem {
    let title: String
    let view: UIView
}

open class SegmentedControlView<SegmentedControlType: SegmentedControl>: UIView {

    // MARK: - Properties
    open var segmentedControl: SegmentedControlType
    
    private var contentView = UIScrollView()
    
    var items: [SegmentedControlViewItem] {
        didSet {
            contentView.subviews.forEach { $0.removeFromSuperview() }
            items.map{$0.view}.forEach(addSubview(_:))
            segmentedControl.itemTitles = items.map{ $0.title }
            layoutIfNeeded()
        }
    }
    
    // MARK" - init
    private func commonInit() {
        contentView.backgroundColor = UIColor.lightGray
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.isScrollEnabled = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1

//        contentView.isPagingEnabled = true
        addSubview(segmentedControl)
        addSubview(contentView)

    }
    
    public init(items: [SegmentedControlViewItem] = []) {
        self.items = items
        segmentedControl = SegmentedControlType.init()
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width
        let segmentedControlHeight: CGFloat = 50
        let contentViewHeight = bounds.height - segmentedControlHeight
        segmentedControl.frame = CGRect(x: 0, y: 0, width: width, height: segmentedControlHeight)
        contentView.frame = CGRect(x: 0, y: segmentedControlHeight, width: width, height: contentViewHeight)
        
        contentView.contentSize = CGSize(width: width * CGFloat(items.count), height: contentViewHeight)
        
        items.map{$0.view}
            .enumerated()
            .forEach { (index, view) in
                
            view.frame = CGRect(x: CGFloat(index) * width,
                                y: segmentedControlHeight,
                                width: width-100,
                                height: contentViewHeight)
        }
        print(self.isUserInteractionEnabled)
        print(contentView.isUserInteractionEnabled)
        print(contentView.isScrollEnabled)
        print(contentView.contentSize)
        print(contentView.frame)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(self.isUserInteractionEnabled)
        print(contentView.isUserInteractionEnabled)
        print(contentView.contentSize)
        print(contentView.frame)
    }

}
