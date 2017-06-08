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
    public let segmentedControl = SegmentedControl()
    
    public var items: [SegmentedControlViewItem] {
        willSet {
            items.map{$0.view}.forEach{ $0.removeFromSuperview() }
        }
        didSet {
            items.map{$0.view}.forEach(contentView.addSubview)
            updateContentView()
            /// 设置 itemTitles后会触发 indexChanged(_:),并且调整contentView的contentOffset
            /// 而updateContentView 会重置contentSize,会影响contentOffset
            /// 所以先调用updateContentView，再设置itemTitles
            segmentedControl.itemTitles = items.map{ $0.title }
        }
    }
    
    public var segmentedControlHeight: CGFloat = 50 {
        didSet {
            setNeedsLayout()
            segmentedControl.collectionView.reloadData()
        }
    }
    
    private var contentView = UIScrollView()
    
    // MARK" - init
    private func commonInit() {
        contentView.backgroundColor = .white
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.delegate = self

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
        self.items = []
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let contentViewHeight = bounds.height - segmentedControlHeight
        segmentedControl.frame = CGRect(x: 0, y: 0, width: width, height: segmentedControlHeight)
        contentView.frame = CGRect(x: 0, y: segmentedControlHeight, width: width, height: contentViewHeight)
        updateContentView()
    }
    
    private func updateContentView() {
        let width = bounds.width
        contentView.contentSize = CGSize(width: width * CGFloat(items.count), height: contentView.bounds.height)
        
        items.map{$0.view}
            .enumerated()
            .forEach { (index, view) in
                
                view.frame = CGRect(x: CGFloat(index) * width,
                                    y: 0,
                                    width: width,
                                    height: contentView.bounds.height)
        }
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

