//
//  NewsView.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/20.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

open class NewsView: UIView {
    
    public let segmentedView = SegmentedControlView()
    
    private let addButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addButton.setTitle("+", for: .normal)
        addButton.layer.shadowColor     = UIColor.white.cgColor
        addButton.layer.shadowOffset    = CGSize(width: -8, height: -4)
        addButton.layer.shadowOpacity   = 1
        addButton.layer.shadowRadius    = 5
        addButton.backgroundColor       = UIColor.white
        segmentedView.segmentedControl.rightMargin = 60
        addSubview(segmentedView)
        addSubview(addButton)

    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        segmentedView.frame = bounds
        
        let addButtonHeight = segmentedView.segmentedControl.bounds.height - segmentedView.segmentedControl.bottomLine.bounds.height
        addButton.frame = CGRect(x: bounds.width - addButtonHeight,
                                 y: 0,
                                 width: addButtonHeight,
                                 height: addButtonHeight)
        
    }
}
