//
//  ViewController.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/11.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit
import MMSegmentedControl

let barHeight: CGFloat = 50

class ViewController: UIViewController {
    
    private struct Const {
        static let barHeight: CGFloat = 50
        static let red = UIColor(hex: 0xFF552E)
    }
    
    let normalSegmentedControl = SegmentedControl(itemTitles: ["推荐", "开庭", "国家情怀", "现场", "315", "财案",  "法老汇", "天下", "北京", "体育", "娱乐" ])
    
    let noUnderlineSegmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        control.itemTitles = ["推荐", "开庭", "国家情怀", "现场", "315", "财案", "法老汇", "天下", "北京", "体育", "娱乐" ]
        control.frame = CGRect(x: 0, y: 160, width: Screen.width, height: Const.barHeight)
        control.underline.isHidden = true
        control.selectedTextColor = Const.red
        control.selectedFontSize = control.fontSize
        return control
    }()
    
    let fixedSegmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        control.itemTitles          = ["推荐", "开庭", "国家情怀"]
        
        control.isScrollEnabled     = false
//        control.itemWidth   = 50
        control.leftMargin  = 10
        control.rightMargin = 10
        return control
    }()
    
    let capsuleSegmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        control.itemTitles = ["默认", "推荐", "现场"]
        control.itemMargin  = 0
        control.leftMargin  = 0
        control.rightMargin = 0
        
        control.layer.borderColor = Const.red.cgColor
        control.layer.borderWidth = 1
        
        control.underline.backgroundColor = Const.red
        control.selectedTextColor = UIColor.white
        control.normalTextColor   = Const.red
        control.selectedFontSize  = 14
        control.fontSize          = 14
        
        control.bottomLine.isHidden = true
        control.isScrollEnabled = false
        
        control.frame = CGRect(x: 70, y: 320, width: Screen.width - 140, height: Const.barHeight)
        control.itemWidth = control.bounds.width / CGFloat(control.itemTitles.count)
        control.lineHeight = Const.barHeight
        control.underline.layer.cornerRadius = Const.barHeight / 2
        control.layer.cornerRadius = Const.barHeight / 2
        return control
    }()
    
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false

        normalSegmentedControl.frame = CGRect(x: 0, y: 80, width: Screen.width, height: Const.barHeight)
        
        view.addSubview(normalSegmentedControl)
        view.addSubview(noUnderlineSegmentedControl)
        
        fixedSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fixedSegmentedControl)
//        fixedSegmentedControl.frame = CGRect(x: 50, y: 240, width: Screen.width - 100, height: Const.barHeight)
        NSLayoutConstraint(item: fixedSegmentedControl,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .left,
                           multiplier: 1,
                           constant: 50).isActive = true
        
        NSLayoutConstraint(item: fixedSegmentedControl,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .width,
                           multiplier: 1,
                           constant: Screen.width - 100).isActive = true
        
        NSLayoutConstraint(item: fixedSegmentedControl,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .height,
                           multiplier: 1,
                           constant: Const.barHeight).isActive = true
        
        NSLayoutConstraint(item: fixedSegmentedControl,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1,
                           constant: 240).isActive = true
        
        view.addSubview(capsuleSegmentedControl)
    
        let pushButton = UIButton(type: .system)
        pushButton.setTitle("Segmented Control View", for: .normal)
        pushButton.addTarget(self, action: #selector(push(sender:)), for: .touchUpInside)
        pushButton.frame = CGRect(x: 80, y: 500, width: 200, height: 50)
        view.addSubview(pushButton)
    }
    
    func push(sender: UIButton) {
        navigationController?.pushViewController(SegmentedViewController(), animated: true)
    }
}

extension UIColor {
    
    /**
     eg. UIColor.hexColor(0x000000)
     
     */
    
    convenience init(hex hexValue: Int, alpha: CGFloat = 1) {
        let redValue   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blueValue  = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
}

