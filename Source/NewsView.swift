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
        //        addButton.setImage(UIImage(named: "add"), for: .normal)
//        addButton.setTitle("+", for: .normal)
//        addButton.layer.shadowColor     = UIColor.white.cgColor
//        addButton.layer.shadowOffset    = CGSize(width: -8, height: -4)
//        addButton.layer.shadowOpacity   = 1
//        addButton.layer.shadowRadius    = 5
//        addButton.backgroundColor       = UIColor.white
//        
//        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedView)
//        addSubview(addButton)
        
//        NSLayoutConstraint(item: addButton,
//                           attribute: .top,
//                           relatedBy: .equal,
//                           toItem: segmentedView.segmentedControl,
//                           attribute: .top,
//                           multiplier: 1,
//                           constant: 0).isActive = true
//        NSLayoutConstraint(item: addButton,
//                           attribute: .right,
//                           relatedBy: .equal,
//                           toItem: segmentedView.segmentedControl,
//                           attribute: .right,
//                           multiplier: 1,
//                           constant: 0).isActive = true
//        NSLayoutConstraint(item: addButton,
//                           attribute: .bottom,
//                           relatedBy: .equal,
//                           toItem: segmentedView.segmentedControl.bottomLine,
//                           attribute: .top,
//                           multiplier: 1,
//                           constant: 0).isActive = true
//        NSLayoutConstraint(item: addButton,
//                           attribute: .width,
//                           relatedBy: .equal,
//                           toItem: addButton,
//                           attribute: .height,
//                           multiplier: 1,
//                           constant: 0).isActive = true
    }
    
    open override func layoutSubviews() {
        segmentedView.frame = bounds
        super.layoutSubviews()
    }
}
