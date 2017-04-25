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
    
    private lazy var editBar: UIView = {
        let editBar = UIView()
        editBar.backgroundColor = UIColor.white
        editBar.addSubview(self.titleLabel)
        editBar.addSubview(self.editButton)
        
        NSLayoutConstraint(item: self.titleLabel,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: editBar,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleLabel,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: editBar,
                           attribute: .left,
                           multiplier: 1,
                           constant: 20).isActive = true
        
        let addButtonHeight = self.addButton.bounds.height
        editBar.frame = CGRect(x: 0,
                               y: 0,
                               width: self.bounds.width - addButtonHeight,
                               height: addButtonHeight)
        return editBar
    }()
    
    public lazy var editButton: UIButton = {
        let editButton = UIButton(type: .custom)
        editButton.clipsToBounds = true
        editButton.layer.borderColor = Setting.selectedEditButtonColor.cgColor
        editButton.layer.borderWidth = 1
        editButton.setTitleColor(Setting.selectedEditButtonColor, for: .normal)
        editButton.setTitleColor(Setting.defaultEditButtonColor, for: .selected)
        editButton.setBackgroundImage(UIImage.image(color: Setting.defaultEditButtonColor), for: .normal)
        editButton.setBackgroundImage(UIImage.image(color: Setting.selectedEditButtonColor), for: .selected)
        
        editButton.setTitle("编辑", for: .normal)
        editButton.layer.cornerRadius = Setting.editButtonHeight / 2
        editButton.titleLabel?.font = UIFont.defaultFont
        editButton.addTarget(self, action: #selector(responds(toEdit:)), for: .touchUpInside)
        
        let segmentedControlHeight = self.segmentedView.segmentedControl.bounds.height
        let segmentedControlWidth  = self.segmentedView.segmentedControl.bounds.width
        let editButtonWidth: CGFloat  = 45
        let margin: CGFloat = 10
        let editButtonX  = segmentedControlWidth - margin - editButtonWidth - self.addButton.bounds.width
        editButton.frame = CGRect(x: editButtonX,
                                  y: (segmentedControlHeight - Setting.editButtonHeight) / 2,
                                  width: editButtonWidth,
                                  height: Setting.editButtonHeight)
        
        return editButton
    }()
    
    private var isTagViewShowing = false
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.defaultFont
        titleLabel.text = "我的频道"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var tagsView: TagsView = {
        let view = TagsView()
        let segmentedControlHeight = self.segmentedView.segmentedControl.bounds.height
        var frame = CGRect(x: 0,
                           y: segmentedControlHeight,
                           width: self.bounds.width,
                           height: self.bounds.height - segmentedControlHeight)
        view.frame = frame
        return view
    }()
    
    private struct Setting {
        static let selectedEditButtonColor = UIColor(hex: 0xff4f53)
        static let defaultEditButtonColor  = UIColor.white
        static let editButtonHeight: CGFloat = 25
        static let animationDuration: TimeInterval = 0.25
    }
    
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
        addButton.addTarget(self, action: #selector(responds(toAdd:)), for: .touchUpInside)
        
        segmentedView.segmentedControl.rightMargin = 60
        
        addSubview(segmentedView)
        addSubview(addButton)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        segmentedView.frame = bounds
        
        let segmentedControlHeight = segmentedView.segmentedControl.bounds.height
        
        let addButtonHeight = segmentedControlHeight - segmentedView.segmentedControl.bottomLine.bounds.height
        addButton.frame = CGRect(x: bounds.width - addButtonHeight,
                                 y: 0,
                                 width: addButtonHeight,
                                 height: addButtonHeight)


    }
    
    // MARK: - Action / Callback
    
    func responds(toAdd sender: UIButton) {
        
        if isTagViewShowing {
            UIView.animate(withDuration: Setting.animationDuration, animations: {
                self.tagsView.transform = CGAffineTransform(translationX: 0, y: -self.tagsView.bounds.height)
            }, completion: { (_) in
                self.editBar.removeFromSuperview()
                self.tagsView.removeFromSuperview()
            })
            
        } else {

            tagsView.transform = CGAffineTransform(translationX: 0, y: -self.tagsView.bounds.height)
            insertSubview(tagsView, belowSubview: addButton)
            addSubview(editBar)
            UIView.animate(withDuration: Setting.animationDuration, animations: {
                self.tagsView.transform = .identity
            })
        }
        isTagViewShowing = !isTagViewShowing
    }
    
    func responds(toEdit sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}


