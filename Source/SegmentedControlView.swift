//
//  SegmentedControlView.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/17.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

public struct SegmentedControlViewItem {
    
    public let title: String
    public let childViewController: UIViewController
    
    public init(title: String, childViewController: UIViewController) {
        self.title = title
        self.childViewController  = childViewController
    }
}

open class SegmentedControlView: UIView {

    // MARK: - Properties
    public let segmentedControl = SegmentedControl()
    
    public var items: [SegmentedControlViewItem] {
        didSet {
            segmentedControl.itemTitles = items.map{ $0.title }
            contentView.reloadData()
        }
    }
    
    public var segmentedControlHeight: CGFloat = 50 {
        didSet {
            setNeedsLayout()
            segmentedControl.collectionView.reloadData()
        }
    }
    
    let contentView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    fileprivate let reuseIdentifier = "reuseIdentifier"
    
    // MARK" - init
    private func commonInit() {
        contentView.backgroundColor = .white
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.delegate = self
        contentView.dataSource = self
        contentView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        addSubview(segmentedControl)
        addSubview(contentView)
        
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }
    
    public init(items: [SegmentedControlViewItem] = []) {
        self.items = items
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.items = []
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let contentViewHeight = bounds.height - segmentedControlHeight
        segmentedControl.frame = CGRect(x: 0, y: 0, width: width, height: segmentedControlHeight)
        contentView.frame = CGRect(x: 0, y: segmentedControlHeight, width: width, height: contentViewHeight)
    }

    @objc func indexChanged(_ sender: SegmentedControl) {

        let index = segmentedControl.selectedIndex
        contentView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension SegmentedControlView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.subviews.forEach{ $0.removeFromSuperview() }
        if let view = items[indexPath.row].childViewController.view {
            view.frame = CGRect(x: 0,
                                y: 0,
                                 width: contentView.bounds.width,
                                 height: contentView.bounds.height)
            cell.contentView.addSubview(view)
        }
        return cell
    }
}

extension SegmentedControlView: UICollectionViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        segmentedControl.selectedIndex = Int(scrollView.contentOffset.x / bounds.width)
    }
}

extension SegmentedControlView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

