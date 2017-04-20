//
//  UnderlineSegmentedControl.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/12.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

open class UnderlineSegmentedControl: SegmentedControl {
    
    public let underline: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Const.defaultSelectedTextColor
        return lineView
    }()
    
    override open var selectedIndex: Int? {
        didSet {
            let animated = underline.bounds.size != .zero
            moveLineToSelectedCellBottom(animated)
        }
    }
    
    open var lineHeight: CGFloat = 2 {
        didSet {
            moveLineToSelectedCellBottom(false)
        }
    }
    
    public required init(itemTitles: [String] = []) {
        super.init(itemTitles: itemTitles)
        selectedFontSize = fontSize
        collectionView.addSubview(underline)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        moveLineToSelectedCellBottom(false)
    }
    
    private func moveLineToSelectedCellBottom(_ animated: Bool = true) {
        guard let selectedIndex = selectedIndex else { return }
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.underline.center = CGPoint(x: layout.center.x, y: layout.frame.maxY - self.lineHeight / 2)
            self.underline.bounds = CGRect(x: 0, y: 0, width: layout.bounds.width, height: self.lineHeight)
        }
    }
}
