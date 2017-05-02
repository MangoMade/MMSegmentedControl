//
//  Const.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/12.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

internal struct Const {
    
    static let defaultFontSize: CGFloat = 15
    static let defaultSelectedFontSize: CGFloat = 18
    static let defaultTextColor = UIColor.black
    static let defaultSelectedTextColor = UIColor(hex: 0xff4f53)
    
    static let onePx = 1 / UIScreen.main.scale
    
    static let tagsWidth: CGFloat = 72
    static let tagsHeight: CGFloat = 40
}

internal extension UIFont {
    static let defaultFont = UIFont.systemFont(ofSize: 14)
}
