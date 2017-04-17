//
//  SegmentedControlView.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/17.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

open class SegmentedControlView<SegmentedControlType: SegmentedControl>: UIView {

    // MARK: - Properties
    open var segmentedControl: SegmentedControlType
    
    private var contentView = UIScrollView()
    
    
    // MARK" - init
    private func commonInit() {
        contentView.backgroundColor = UIColor.lightGray
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedControl)
        addSubview(contentView)
        
        let segmentedViews = ["segmentedControl": segmentedControl]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentedControl]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: segmentedViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[segmentedControl]",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: segmentedViews))
        
        let contentViews = ["segmentedControl": segmentedControl,
                            "contentView": contentView] as [String : Any]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: contentViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[segmentedControl]-[contentView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: contentViews))
        
    }
    
    public init() {
        segmentedControl = SegmentedControlType.init()
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
