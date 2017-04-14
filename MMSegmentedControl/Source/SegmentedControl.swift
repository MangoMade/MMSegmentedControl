//
//  Created by Mango on 16/9/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

open class SegmentedControl: UIControl {
    
    // MARK: - public properties
    
    open var itemTitles: [String] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            if itemTitles.count > 0 {
                selectedIndex = 0
                sendActions(for: .valueChanged)
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
    
    open var isScrollEnabled: Bool {
        set {
            collectionView.isScrollEnabled = newValue
        }
        get {
            return collectionView.isScrollEnabled
        }
    }
    
    open var itemWidth: CGFloat     = -1 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    open var textMargin: CGFloat    = 0 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    open var leftMargin: CGFloat    = 12 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    open var rightMargin: CGFloat   = 12 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    open var padding: CGFloat       = 15 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    open var selectedTextColor = Const.defaultSelectedTextColor {
        didSet {
            visibleCellsForEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }
    
    open var normalTextColor   = Const.defaultTextColor {
        didSet {
            visibleCellsForEach {
                $0.normalTextColor = normalTextColor
            }
        }
    }
    
    open var fontSize: CGFloat = Const.defaultFontSize {
        didSet {
            visibleCellsForEach {
                $0.fontSize = fontSize
            }
        }
    }
    
    open var selectedFontSize: CGFloat = Const.defaultSelectedFontSize {
        didSet {
            visibleCellsForEach {
                $0.selectedFontSize = selectedFontSize
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
    
    let collectionView: UICollectionView = {
        
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
    
    public init(itemTitles: [String] = []) {

        super.init(frame: CGRect.zero)
        commonInit()
        self.itemTitles = itemTitles
        if self.itemTitles.count > 0 {
            selectedIndex = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
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
    
    private func updateCollectionViewLayout() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}


// MARK: - UICollectionViewDataSource
extension SegmentedControl: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemTitles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.cell,
                                                      for: indexPath) as! SegmentedControlItemCell
        
        cell.titleLabel.text = itemTitles[indexPath.row]
        cell.normalTextColor = normalTextColor
        cell.selectedTextColor = selectedTextColor
        cell.fontSize = fontSize
        cell.selectedFontSize = selectedFontSize
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SegmentedControl: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var width: CGFloat = 0
        if isScrollEnabled {
            
            if itemWidth > 0 {
                width = itemWidth
            } else {
                let text = itemTitles[indexPath.row]
                let size = text.getTextRectSize(font: UIFont.systemFont(ofSize: fontSize),
                                                size: CGSize(width: 100, height: 100)) // 先随便写一个
                width = 2 * padding + size.width
            }
            
        } else {
            let countFloat = CGFloat(itemTitles.count)
            let contentWidth = bounds.width - leftMargin - rightMargin - (countFloat - 1) * textMargin
            width = contentWidth / countFloat
        }
        return CGSize(width: width, height: bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: rightMargin)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return textMargin
    }
}

// MARK: - UICollectionViewDelegate
extension SegmentedControl: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedIndex = indexPath.row
        sendActions(for: .valueChanged)
    }
}

private extension String {
    
    func getTextRectSize(font:UIFont, size:CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let rect:CGRect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect;
    }
}

