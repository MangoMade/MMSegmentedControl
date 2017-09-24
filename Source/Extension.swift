//
//  Extension.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/25.
//  Copyright © 2017年 Aqua. All rights reserved.
//


internal extension UIImage {
    
    static func image(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

internal extension String {
    
    func getTextRectSize(font:UIFont, size:CGSize) -> CGRect {
        let attributes = [NSAttributedStringKey.font: font]
        let rect:CGRect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect;
    }
}

internal extension UIColor {
    
    convenience init(hex hexValue: Int, alpha: CGFloat = 1) {
        let redValue   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blueValue  = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
}
