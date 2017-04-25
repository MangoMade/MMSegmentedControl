//
//  TagsCollectionHeaderView.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/25.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class TagsCollectionHeaderView: UICollectionReusableView {
    
    
    let titleLabel = UILabel()
    
    
    private func commonInit() {

        titleLabel.font = UIFont.defaultFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .left,
                           multiplier: 1,
                           constant: 20).isActive = true
        
        NSLayoutConstraint(item: titleLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
