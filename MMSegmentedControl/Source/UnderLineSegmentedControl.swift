//
//  UnderLineSegmentedControl.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/12.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class UnderLineSegmentedControl: SegmentedControl {
    
    let underLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black
        return lineView
    }()
    
    override var selectedIndex: Int? {
        didSet {
            let animated = underLine.bounds.size != .zero
            moveLineToSelectedCellBottom(animated)
        }
    }
    
    fileprivate let lineHeight: CGFloat = 2
    
    override public init(itemTitles: [String] = []) {
        super.init(itemTitles: itemTitles)
        selectedTextColor = UIColor.black
        normalTransform = CGAffineTransform.identity
        collectionView.addSubview(underLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        moveLineToSelectedCellBottom(false)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        moveLineToSelectedCellBottom(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moveLineToSelectedCellBottom(false)
    }
    
    private func moveLineToSelectedCellBottom(_ animated: Bool = true) {
        guard let selectedIndex = selectedIndex else { return }
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.underLine.center = CGPoint(x: cell.center.x, y: cell.frame.maxY - self.lineHeight / 2)
            self.underLine.bounds = CGRect(x: 0, y: 0, width: cell.bounds.width, height: self.lineHeight)
        }
    }
}
