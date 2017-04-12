//
//  UnderlineSegmentedControl.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/12.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class UnderlineSegmentedControl: SegmentedControl {
    
    let underline: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Const.defaultSelectedTextColor
        return lineView
    }()
    
    override var selectedIndex: Int? {
        didSet {
            let animated = underline.bounds.size != .zero
            moveLineToSelectedCellBottom(animated)
        }
    }
    
    fileprivate let lineHeight: CGFloat = 2
    
    override public init(itemTitles: [String] = []) {
        super.init(itemTitles: itemTitles)
        selectedFontSize = fontSize
        collectionView.addSubview(underline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moveLineToSelectedCellBottom()
    }
    
    private func moveLineToSelectedCellBottom(_ animated: Bool = true) {
        guard let selectedIndex = selectedIndex else { return }
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.underline.center = CGPoint(x: cell.center.x, y: cell.frame.maxY - self.lineHeight / 2)
            self.underline.bounds = CGRect(x: 0, y: 0, width: cell.bounds.width, height: self.lineHeight)
        }
    }
}
