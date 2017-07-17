//
//  TestViewController.swift
//  Example
//
//  Created by Aqua on 2017/7/16.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit
import MMSegmentedControl
class TestViewController: UIViewController {

    
    let fixedSegmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        control.itemTitles          = ["推荐", "开庭", "国家情怀"]
        
        control.isScrollEnabled     = false
        //        control.itemWidth   = 50
        control.leftMargin  = 10
        control.rightMargin = 10
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fixedSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fixedSegmentedControl)
//                fixedSegmentedControl.frame = CGRect(x: 50, y: 240, width: Screen.width - 100, height: 64)
        
        NSLayoutConstraint(item: fixedSegmentedControl,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .left,
                           multiplier: 1,
                           constant: 50).isActive = true
        //
        //        NSLayoutConstraint(item: fixedSegmentedControl,
        //                           attribute: .width,
        //                           relatedBy: .equal,
        //                           toItem: nil,
        //                           attribute: .width,
        //                           multiplier: 1,
        //                           constant: Screen.width - 100).isActive = true
        //
        //        NSLayoutConstraint(item: fixedSegmentedControl,
        //                           attribute: .height,
        //                           relatedBy: .equal,
        //                           toItem: nil,
        //                           attribute: .height,
        //                           multiplier: 1,
        //                           constant: Const.barHeight).isActive = true
        //
        NSLayoutConstraint(item: fixedSegmentedControl,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1,
                           constant: 240).isActive = true

    }


}
