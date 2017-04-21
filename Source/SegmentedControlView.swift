//
//  SegmentedControlView.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/17.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

public struct SegmentedControlViewItem {
    
    public let title: String
    public let view: UIView
    
    public init(title: String, view: UIView) {
        self.title = title
        self.view  = view
    }
}

open class SegmentedControlView: UIView {

    // MARK: - Properties
    open let segmentedControl = SegmentedControl()
    
    public var items: [SegmentedControlViewItem] {
        willSet {
            items.map{$0.view}.forEach{ $0.removeFromSuperview() }
        }
        didSet {
            items.map{$0.view}.forEach(contentView.addSubview)
            segmentedControl.itemTitles = items.map{ $0.title }
            layoutIfNeeded()
        }
    }
    
    private var contentView = UIScrollView()
    
    // MARK" - init
    private func commonInit() {
        contentView.backgroundColor = UIColor.lightGray
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.alwaysBounceHorizontal = true
        contentView.isPagingEnabled = true
        contentView.delegate = self
        contentView.alwaysBounceHorizontal = true
        
        addSubview(segmentedControl)
        addSubview(contentView)
        
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }
    
    public init(items: [SegmentedControlViewItem] = []) {
        self.items = items
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        
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
        super.layoutSubviews()
    }

    func indexChanged(_ sender: SegmentedControl) {
//        guard let index = segmentedControl.selectedIndex else { return }
        let index = segmentedControl.selectedIndex
        let contentOffset = CGPoint(x: CGFloat(index) * bounds.width, y: 0)
        contentView.setContentOffset(contentOffset, animated: true)
    }
}

extension SegmentedControlView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedControl.selectedIndex = Int(scrollView.contentOffset.x / bounds.width)
    }
}

