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
        willSet {
            items.map{$0.view}.forEach{ $0.removeFromSuperview() }
        }
        didSet {
            items.map{$0.view}.forEach(contentView.addSubview)
            segmentedControl.itemTitles = items.map{ $0.title }
            layoutIfNeeded()
        }
    }
    
    // MARK" - init
    private func commonInit() {
        contentView.backgroundColor = UIColor.lightGray
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.alwaysBounceHorizontal = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1

        contentView.isPagingEnabled = true
        addSubview(segmentedControl)
        addSubview(contentView)
        
        segmentedControl.addTarget(self, action: #selector(valueChange), for: .valueChanged)
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
                                y: 0,
                                width: width,
                                height: contentViewHeight)
        }

    }

    func valueChange() {
        print(contentView)
    }
}