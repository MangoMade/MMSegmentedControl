//
//  SegmentedViewController.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/17.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let segmentedView = SegmentedControlView()
        segmentedView.segmentedControl.itemTitles = ["1", "22", "333", "4444", "55555", "666666", "7777777", "88888888", ]
        segmentedView.frame = CGRect(x: 0,
                                     y: Screen.navBarHeight,
                                     width: Screen.width,
                                     height: Screen.height - Screen.navBarHeight)
        
        view.addSubview(segmentedView)
    }



}
