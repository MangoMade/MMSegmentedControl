//
//  SegmentedControlItemCell.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/11.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class SegmentedControlItemCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    static let normalFont = UIFont.systemFont(ofSize: 16)
    
    var selectedTextColor = UIColor.red {
        didSet {
            if isSelected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    var normalTextColor   = UIColor.black {
        didSet {
            if !isSelected {
                self.titleLabel.textColor = normalTextColor
            }
        }
    }
    
    var normalTransform = CGAffineTransform(scaleX: 0.9, y: 0.9) {
        didSet {
            if !isSelected {
                self.titleLabel.transform = normalTransform
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUserInterface() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = classForCoder.normalFont
        titleLabel.transform = normalTransform
        addSubview(titleLabel)
        
        self.addConstraint(NSLayoutConstraint(item: titleLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: titleLabel,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
        
        
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, animations: {
                self.titleLabel.transform = self.isSelected ? CGAffineTransform.identity : self.normalTransform
                self.titleLabel.textColor = self.isSelected ? self.selectedTextColor : self.normalTextColor
            })
        }
    }
}
