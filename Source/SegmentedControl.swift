//
//  Created by Mango on 16/9/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class ContentSizeWatchingCollectionView: UICollectionView {
    
    weak var segmentedControl: SegmentedControl?
    
    override var contentSize: CGSize {
        didSet {
            segmentedControl?.invalidateIntrinsicContentSize()
        }
    }

}

open class SegmentedControl: UIControl {

    // MARK: - public properties
    
    open var itemTitles: [String] = [] {
        didSet {
            
            //collectionView.setNeedsLayout() // TODO: 考虑是否需要 setNeedsLayout
            collectionView.reloadData()

            if itemTitles.count < selectedIndex + 1 {
                selectedIndex = itemTitles.count - 1
                sendActions(for: .valueChanged)
            } else {
                /// 视图正在显示时，进行动画
                /// 视图若没有显示，则不进行动画
                moveLineToSelectedCellBottom(window?.isKeyWindow ?? false)
            }
        }
    }
    
    open var selectedIndex: Int = 0 {
        willSet {
            let indexPath = IndexPath(row: selectedIndex, section: 0)
            /// if cell is visiable, set old-selected cell.isChoosing to false
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
    
    // MARK: Properties for layout
    
    /* 
     * item是否填满整个视图
     * 默认为false，则item会从左向右紧挨着
     * 如果为true，则itemMargin会被忽略，间距会自动计算，使item均匀分布
     * default is false
     */
    open var shouldFill: Bool {
        set {
            collectionViewLayout.shouldFill = newValue
        }
        get {
            return collectionViewLayout.shouldFill
        }
    }
    
    /*
     * item宽度
     * 如果设置了这个属性，那么每个item将会等宽，并且忽略padding值
     * 如果希望item的宽度根据内容自适应，则设置为 小于或等于0
     * default is -1
     */
    open var itemWidth: CGFloat {
        set {
            collectionViewLayout.itemWidth = newValue
        }
        get {
            return collectionViewLayout.itemWidth
        }
    }
    
    /*
     * item的边界到字体内容的水平距离，可参考盒子模型
     * itemWidth大于0时，该属性会被忽略
     * default is 15
     */
    open var padding: CGFloat {
        set {
            collectionViewLayout.padding = newValue
        }
        get {
            return collectionViewLayout.padding
        }
    }
    
    /*
     * 两个item之间的距离
     * 当设置了下划线时，下划线宽度与item宽度相同
     * 这个属性主要用于控制下划线的显示效果
     * default is 0
     */
    open var itemMargin: CGFloat {
        set {
            collectionViewLayout.itemMargin = newValue
        }
        get {
            return collectionViewLayout.itemMargin
        }
    }
    
    /*
     * 第一个item到控件最左侧的距离
     * default is 12
     */
    open var leftMargin: CGFloat {
        set {
            collectionViewLayout.leftMargin = newValue
        }
        get {
            return collectionViewLayout.leftMargin
        }
    }
    
    /*
     * 最后一个item到控件最右侧的距离
     * default is 12
     */
    open var rightMargin: CGFloat {
        set {
            collectionViewLayout.rightMargin = newValue
        }
        get {
            return collectionViewLayout.rightMargin
        }
    }
    
    // MARK: Properties for style
    
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
    open var selectedFont: UIFont = Const.defaultSelectedFont {
        didSet {
            visibleCellsForEach {
                $0.selectedFont = selectedFont
            }
        }
    }
    
    /*
     * 未选中状态的字体大小
     */
    open var font: UIFont = Const.defaultFont {
        didSet {
            collectionViewLayout.fontSize = font.pointSize
            visibleCellsForEach {
                $0.font = font
            }
        }
    }
    
    /*
     * 视图最底部细线
     */
    public var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.groupTableViewBackground
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    // MARK: - Properties for underline
    
    /*
     * 下划线，会随着选中状态移动
     * itemWidth大于等于0时，其宽度为itemWidth
     * 否则其宽度为字体大小 加 2 * padding
     */
    public var underline: UIView {
        return underlineImageView
    }
    
    public var underlineImage: UIImage? {
        didSet {
            underlineImageView.image = underlineImage
            moveLineToSelectedCellBottom(false)
        }
    }
    
    /*
     * 下划线高度
     */
    open var underlineHeight: CGFloat = 2 {
        didSet {
            moveLineToSelectedCellBottom(false)
        }
    }
    
    /*
     * 下划线高度, 
     * 大于或等于0时生效，否则采用默认逻辑
     * itemWidth大于等于0时，其宽度为itemWidth
     * 否则其宽度为字体大小 加 2 * padding
     */
    open var underlineWidth: CGFloat = 0 {
        didSet {
            moveLineToSelectedCellBottom(false)
        }
    }
    
    /*
     * 下划线离视图底部的偏移量,
     * 与坐标轴相同，负值是向上偏移
     */
    open var underlineBottomOffset: CGFloat = 0 {
        didSet {
            moveLineToSelectedCellBottom(false)
        }
    }

    
    // MARK: - Private properties
    
    private let underlineImageView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = Const.defaultSelectedTextColor
        return lineView
    }()
    
    fileprivate var itemsTotalWidth: CGFloat = 0
    fileprivate static let height: CGFloat = 60
    
    fileprivate struct ReuseIdentifier {
        static let cell = "cellReuseIdentifier"
    }
    
    private var collectionViewLayout: SegmentedControlLayout!
    
    internal let collectionView: ContentSizeWatchingCollectionView = {
        
        let layout = SegmentedControlLayout()
        
        let collectionView = ContentSizeWatchingCollectionView(frame: CGRect.init(x: 0, y: 0, width: 1, height: height), collectionViewLayout: layout)
        collectionView.allowsMultipleSelection          = false
        collectionView.showsHorizontalScrollIndicator   = false
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.backgroundColor                  = UIColor.clear
        collectionView.alwaysBounceHorizontal           = true
        
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
        collectionViewLayout = collectionView.collectionViewLayout as! SegmentedControlLayout
        collectionViewLayout.delegate = self
        
        collectionView.segmentedControl = self
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
        collectionView.reloadData()

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
    
    // FIXME: 暂时可能没用了
    private func updateCollectionViewLayout() {
        collectionView.reloadData()
    }
    
    override open var intrinsicContentSize: CGSize {
        return collectionView.contentSize
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
        
        let duration = animated ? 0.25 : 0
        
        var height: CGFloat = 0.0
        var width: CGFloat  = 0.0
        
        if let image = underlineImage {
            width  = image.size.width
            height = image.size.height
        } else {
            height = underlineHeight
            width  = underlineWidth > 0 ? underlineWidth : layout.bounds.width
        }
        
        var centerY = height < layout.frame.maxY ? layout.frame.maxY - height / 2 : layout.center.y
        centerY += underlineBottomOffset
        
        UIView.animate(withDuration: duration) {

            self.underline.center = CGPoint(x: layout.center.x, y: centerY)
            self.underline.bounds = CGRect(x: 0, y: 0, width: width, height: height)
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
        cell.font = font
        cell.selectedFont = selectedFont
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isChoosing = indexPath.row == selectedIndex
        (cell as? SegmentedControlItemCell)?.set(isChoosing: isChoosing, animated: false, completion: nil)
        if (indexPath.section, indexPath.row) == (0, 0) {
            /// 想把underline放到collectionView的最底层，还没想到什么好办法
            collectionView.sendSubview(toBack: underline)
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

// MARK: - SegmentedControlLayoutDelegate
extension SegmentedControl: SegmentedControlLayoutDelegate {
    
    func getItemTitles(layout: SegmentedControlLayout) -> [String] {
        return itemTitles
    }
}


