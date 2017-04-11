//
//  Created by Mango on 16/9/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

private extension String {
    
    func getTextRectSize(font:UIFont, size:CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let rect:CGRect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect;
    }
}

open class SegmentedControl: UIControl {
    
    // MARK: - public properties
    
    open var itemTitles: [String] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            if itemTitles.count > 0 {
                selectedIndex = 0
//                didSelectItem?(0)
            }
        }
    }
    
    open var selectedIndex: Int? {
        get {
            let selectedIndexPaths = collectionView.indexPathsForSelectedItems
            if selectedIndexPaths?.count ?? 0 > 0 {
                return selectedIndexPaths![0].row
            }
            return nil
        }
        set {
            if let index = newValue {
                let indexPath = IndexPath(row: index, section: 0)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    open var countOfItems: Int {
        return itemTitles.count
    }
    
    open var isScrollEnabled: Bool {
        set {
            collectionView.isScrollEnabled = newValue
        }
        get {
            return collectionView.isScrollEnabled
        }
    }
    
    open var itemWidth: CGFloat = -1
    
    open var textMargin: CGFloat = 30
    
    open var selectedTextColor = UIColor.red {
        didSet {
            visibleCellsForEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }
    
    open var normalTextColor   = UIColor.black {
        didSet {
            visibleCellsForEach {
                $0.normalTextColor = normalTextColor
            }
        }
    }
    
    open var normalTransform = CGAffineTransform(scaleX: 0.9, y: 0.9) {
        didSet {
            visibleCellsForEach {
                $0.normalTransform = normalTransform
            }
        }
    }
    
    open var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    
    
    // MARK: - private properties
    
    fileprivate struct ReuseIdentifier {
        static let cell = "cellReuseIdentifier"
    }
    
    fileprivate let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }()
    
    
    // MARK: - initlization
    
    public init(itemTitles: [String]) {
        self.itemTitles = itemTitles
        super.init(frame: CGRect.zero)
        initUserInterface()
    }
    
    public convenience init() {
        self.init(itemTitles: [])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUserInterface() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(SegmentedControlItemCell.self, forCellWithReuseIdentifier: ReuseIdentifier.cell)
        addSubview(collectionView)
 
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["collectionView": collectionView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: views))

        addSubview(bottomLine)
        let lineViews = ["grayLine": bottomLine]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grayLine]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: lineViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[grayLine(onePx)]|",
                                                           options: [],
                                                           metrics: ["onePx": Screen.onePX],
                                                           views: lineViews))
    }
    
    // MARK: - Private Methods
    
    private func visibleCellsForEach(_ doSomething: (SegmentedControlItemCell) -> Void ) {
        collectionView.visibleCells.forEach {
            guard let cell = $0 as? SegmentedControlItemCell else { return }
            doSomething(cell)
        }
    }
}

extension SegmentedControl: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemTitles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cell, for: indexPath) as! SegmentedControlItemCell
        cell.titleLabel.text = itemTitles[indexPath.row]
        cell.normalTextColor = normalTextColor
        cell.selectedTextColor = selectedTextColor
        cell.normalTransform = normalTransform
        return cell
    }
}

extension SegmentedControl: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        if itemWidth > 0 {
            width = itemWidth
        } else {
            let text = itemTitles[indexPath.row]
            let size = text.getTextRectSize(font: SegmentedControlItemCell.normalFont, size: CGSize(width: 100, height: 100))
            width = textMargin + size.width
        }
        return CGSize(width: width, height: bounds.height)
    }
}

extension SegmentedControl: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedIndex = indexPath.row
        sendActions(for: .valueChanged)
    }
}


class LineSlideTabBar: SegmentedControl {
    
    fileprivate let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black
        
        return lineView
    }()
    
    override var selectedIndex: Int? {
        didSet {
            let animated = lineView.bounds.size != .zero
            moveLineToSelectedCellBottom(animated)
        }
    }
    
    fileprivate let lineHeight: CGFloat = 2
    
    override init(itemTitles: [String]) {
        super.init(itemTitles: itemTitles)
        selectedTextColor = UIColor.black
        normalTransform = CGAffineTransform.identity
        itemWidth = 150
        collectionView.addSubview(lineView)
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
    
    fileprivate func moveLineToSelectedCellBottom(_ animated: Bool = true) {
        guard let selectedIndex = selectedIndex else { return }
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
                self.lineView.center = CGPoint(x: cell.center.x, y: cell.frame.maxY - self.lineHeight / 2)
                self.lineView.bounds = CGRect(x: 0, y: 0, width: cell.bounds.width, height: self.lineHeight)
            }) 
        }
    }
}
