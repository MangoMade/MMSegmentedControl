//
//  Created by Mango on 16/9/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

open class SegmentedControl: UIControl {

    // MARK: - public properties
    
    open var itemTitles: [String] = [] {
        didSet {
            collectionView.layoutIfNeeded()
            collectionView.reloadData()
            
            if itemTitles.count < selectedIndex + 1 {
                selectedIndex = itemTitles.count - 1
                sendActions(for: .valueChanged)
            } else {
                moveLineToSelectedCellBottom()
            }
        }
    }
    
    open var selectedIndex: Int = 0 {
        willSet {
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? SegmentedControlItemCell else {
                return
            }
            cell.set(isChoosing: false, completion: nil)
        }
        
        didSet {
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? SegmentedControlItemCell else {
                return
            }
            cell.set(isChoosing: true) { _ in
                self.isUserInteractionEnabled = true
            }

            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            let animated = underline.bounds.size != .zero
            moveLineToSelectedCellBottom(animated)
            
            isUserInteractionEnabled = false
        }
    }
    
    /* 
     * 这个属性控制 item是否可滑动
     * 如果为false，则计算item宽度的的时候会忽略 padding和itemWidth
     * item宽度为控件宽度减去各个Margin的宽度再平分
     */
    open var isScrollEnabled: Bool {
        set {
            collectionView.isScrollEnabled = newValue
        }
        get {
            return collectionView.isScrollEnabled
        }
    }
    
    /*
     * item宽度
     * 如果设置了这个属性，那么每个item将会等宽，并且忽略padding值
     * 如果希望item的宽度根据内容自适应，则设置为 小于或等于0
     * isScrollEnabled为true时有效
     */
    open var itemWidth: CGFloat     = -1 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    /*
     * item的边界到字体内容的水平距离，可参考盒子模型
     * itemWidth大于0时，该属性会被忽略
     * isScrollEnabled为true时有效
     */
    open var padding: CGFloat       = 15 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    /*
     * 两个item之间的距离
     * 当设置了下划线时，下划线宽度与item宽度相同
     * 这个属性主要用于控制下划线的显示效果
     */
    open var itemMargin: CGFloat    = 0 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    /*
     * 第一个item到控件最左侧的距离
     */
    open var leftMargin: CGFloat    = 12 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    /*
     * 最后一个item到控件最右侧的距离
     */
    open var rightMargin: CGFloat   = 12 {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    /*
     * 选中状态的字体颜色
     */
    open var selectedTextColor = Const.defaultSelectedTextColor {
        didSet {
            visibleCellsForEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }
    
    /*
     * 未选中状态的字体颜色
     */
    open var normalTextColor   = Const.defaultTextColor {
        didSet {
            visibleCellsForEach {
                $0.normalTextColor = normalTextColor
            }
        }
    }
    
    /*
     * 选中状态的字体大小
     */
    open var selectedFontSize: CGFloat = Const.defaultSelectedFontSize {
        didSet {
            visibleCellsForEach {
                $0.selectedFontSize = selectedFontSize
            }
        }
    }
    
    /*
     * 未选中状态的字体大小
     */
    open var fontSize: CGFloat = Const.defaultFontSize {
        didSet {
            visibleCellsForEach {
                $0.fontSize = fontSize
            }
        }
    }
    
    /*
     * 视图最底部细线
     */
    public var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    // MARK: - Properties for underline
    
    /*
     * 下划线，会随着选中状态移动
     * itemWidth大于等于0时，其宽度为itemWidth
     * 否则其宽度为字体大小 加 2 * padding
     */
    public let underline: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = Const.defaultSelectedTextColor
        return lineView
    }()
    
    /*
     * 下划线高度
     */
    open var lineHeight: CGFloat = 2 {
        didSet {
            moveLineToSelectedCellBottom(false)
        }
    }
    
    // MARK: - Private properties
    
    fileprivate var maxWidth: CGFloat = 0
    
    fileprivate struct ReuseIdentifier {
        static let cell = "cellReuseIdentifier"
    }
    
    internal let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceHorizontal = true
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
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(SegmentedControlItemCell.self, forCellWithReuseIdentifier: ReuseIdentifier.cell)
        addSubview(collectionView)

        addSubview(bottomLine)
        collectionView.addSubview(underline)
    }
    
    // MARK: - Override 
    
    override open func layoutSubviews() {
        collectionView.frame = bounds
        let onePX = 1 / UIScreen.main.scale
        bottomLine.frame = CGRect(x: 0, y: bounds.height - onePX, width: bounds.width, height: Const.onePx)
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
        collectionView.reloadData()
    }
}

// MARK: - Private methods for underline
fileprivate extension SegmentedControl {
    
    func moveLineToSelectedCellBottom(_ animated: Bool = true) {
        guard !underline.isHidden && underline.superview != nil else { return }
        guard collectionView.numberOfItems(inSection: 0) > 0 else { return }
        
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            let centerY = self.lineHeight < layout.frame.maxY ? layout.frame.maxY - self.lineHeight / 2 : layout.center.y

            self.underline.center = CGPoint(x: layout.center.x, y: centerY)
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
        cell.set(isChoosing: indexPath.row == selectedIndex, animated: false, completion: nil)

        collectionView.sendSubview(toBack: underline) // 想把underline放到collectionView的最底层，还没想到什么好办法

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
//        if isScrollEnabled {
        
            if itemWidth > 0 {
                // 设置了itemWidth时，等宽
                width = itemWidth
            } else {
                let text = itemTitles[indexPath.row]
                let size = text.getTextRectSize(font: UIFont.systemFont(ofSize: fontSize),
                                                size: CGSize(width: CGFloat(Int.max), height: CGFloat(Int.max))) // 先随便写一个
                // 忽略itemWidth，自适应宽度
                width = 2 * padding + size.width
                
                if !isScrollEnabled {
                    // 不可滑动时，忽略item margin，计算间距时需要使用max width
                    maxWidth = max(width, maxWidth)
                }
            }
//        } else {
//            
//            if itemWidth > 0 {
//                // 设置了itemWidth时，等宽
//                width = itemWidth
//            } else {
//                let countFloat = CGFloat(itemTitles.count)
//                let contentWidth = bounds.width - leftMargin - rightMargin - (countFloat - 1) * itemMargin
//                width = contentWidth / countFloat
//            }
//        }
        
        /// It will crush if size is negative.
        print(CGSize(width: width, height: bounds.height))
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
        if isScrollEnabled {
            return itemMargin
        } else {
            let countFloat = CGFloat(itemTitles.count)
            if itemWidth > 0 {
                let space = (bounds.width - countFloat * itemWidth - leftMargin - rightMargin)/(countFloat - 1)
                return space
            } else {
                let space = floor((bounds.width - countFloat * maxWidth - leftMargin - rightMargin)/(countFloat-1))
                print("total \(space * (countFloat-1) + leftMargin + rightMargin + countFloat * maxWidth)")
                print("bounds.width \(bounds.width)")
                print("contentSize \(collectionView.contentSize)")
                maxWidth = 0
                return space
                return 20
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SegmentedControl: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row {
            selectedIndex = indexPath.row
            sendActions(for: .valueChanged)
        }
    }
}

