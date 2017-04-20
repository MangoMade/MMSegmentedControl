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
                
                let animated = underline.bounds.size != .zero
                moveLineToSelectedCellBottom(animated)
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
    
    // MARK: - Properties for underline
    
    public let underline: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Const.defaultSelectedTextColor
        return lineView
    }()
    
    open var lineHeight: CGFloat = 2 {
        didSet {
            moveLineToSelectedCellBottom(false)
        }
    }
    
    // MARK: - Private properties
    
    fileprivate struct ReuseIdentifier {
        static let cell = "cellReuseIdentifier"
    }
    
    internal let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear

        return collectionView
    }()
    
    // MARK: - Initlization
    
    public required init(itemTitles: [String] = []) {

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
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views))

        addSubview(bottomLine)
        let lineViews = ["grayLine": bottomLine]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grayLine]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: lineViews))
        
        let onePX = 1 / UIScreen.main.scale
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[grayLine(onePx)]|",
                                                                   options: [],
                                                                   metrics: ["onePx": onePX],
                                                                   views: lineViews))
        collectionView.addSubview(underline)
    }
    
    // MARK: - Override 
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        moveLineToSelectedCellBottom(false)
    }
    
    // MARK: - Private Methods
    
    private func visibleCellsForEach(_ doSomething: (SegmentedControlItemCell) -> Void ) {
        collectionView.visibleCells.forEach {
            guard let cell = $0 as? SegmentedControlItemCell else { return }
            doSomething(cell)
        }
    }
    
    private func updateCollectionViewLayout() {
        let index = selectedIndex
        collectionView.reloadSections(IndexSet(integer: 0))
        selectedIndex = index
    }
}

// MARK: - Private methods for underline
fileprivate extension SegmentedControl {
    
    func moveLineToSelectedCellBottom(_ animated: Bool = true) {
        guard !underline.isHidden && underline.superview != nil else { return }
        
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

