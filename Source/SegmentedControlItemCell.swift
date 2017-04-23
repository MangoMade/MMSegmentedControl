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
    
    var fontSize: CGFloat = Const.defaultFontSize {
        didSet {
            updateTransform()
        }
    }
    
    var selectedFontSize: CGFloat = Const.defaultSelectedFontSize {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: selectedFontSize)
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
        UIView.animate(withDuration: animated ? 0.15 : 0, animations: { 
            self.titleLabel.transform = self.isChoosing ? CGAffineTransform.identity : self.textTransform
            self.titleLabel.textColor = self.isChoosing ? self.selectedTextColor : self.normalTextColor
        }, completion: completion)
    }
    
    
    override init(frame: CGRect) {
        let scale = self.selectedFontSize / self.fontSize
        textTransform = CGAffineTransform(scaleX: scale, y: scale)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: selectedFontSize)
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
        let scale = fontSize / selectedFontSize
        textTransform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
