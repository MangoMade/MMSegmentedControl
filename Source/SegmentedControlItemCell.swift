//
//  SegmentedControlItemCell.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/11.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

internal class SegmentedControlItemCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    
    var font: UIFont = Const.defaultFont {
        didSet {
            updateTransform()
        }
    }
    
    var selectedFont: UIFont = Const.defaultSelectedFont {
        didSet {
            titleLabel.font = selectedFont
            updateTransform()
        }
    }
    
    var selectedTextColor = Const.defaultSelectedTextColor {
        didSet {
            if isSelected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    var normalTextColor   = Const.defaultTextColor {
        didSet {
            if !isSelected {
                self.titleLabel.textColor = normalTextColor
            }
        }
    }
    
    private var textTransform: CGAffineTransform {
        didSet {
            titleLabel.transform = isSelected ? .identity : textTransform
        }
    }

    var isChoosing: Bool = false 
    
    func set(isChoosing: Bool, animated: Bool = true, completion: ((Bool) -> Void)?) {
        self.isChoosing = isChoosing
        UIView.animate(withDuration: animated ? Const.animationDuration : 0, animations: {
            self.titleLabel.transform = self.isChoosing ? CGAffineTransform.identity : self.textTransform
            
            if self.isChoosing {
                self.titleLabel.font = self.selectedFont
            } else {
                self.titleLabel.font = self.font.withSize(self.selectedFont.pointSize)
            }
        }, completion: completion)
        
        let after = Const.animationDuration / 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after) {
            self.titleLabel.textColor = self.isChoosing ? self.selectedTextColor : self.normalTextColor
        }
    }
    
    override init(frame: CGRect) {
        let scale = self.font.pointSize / self.selectedFont.pointSize
        textTransform = CGAffineTransform(scaleX: scale, y: scale)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let scale = self.font.pointSize / self.selectedFont.pointSize
        textTransform = CGAffineTransform(scaleX: scale, y: scale)
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = selectedFont
        titleLabel.transform = textTransform
        addSubview(titleLabel)
        
        NSLayoutConstraint(item: titleLabel,
                          attribute: .centerX,
                          relatedBy: .equal,
                          toItem: self,
                          attribute: .centerX,
                          multiplier: 1,
                          constant: 0).isActive = true
        
        NSLayoutConstraint(item: titleLabel,
                          attribute: .centerY,
                          relatedBy: .equal,
                          toItem: self,
                          attribute: .centerY,
                          multiplier: 1,
                          constant: 0).isActive = true
        
    }
    
    private func updateTransform() {
        let scale = self.font.pointSize / self.selectedFont.pointSize
        textTransform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
