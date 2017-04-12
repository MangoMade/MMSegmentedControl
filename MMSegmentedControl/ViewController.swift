//
//  ViewController.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/11.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bar = SegmentedControl()
    let lineBar = UnderLineSegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bar.itemTitles = ["1", "22", "333", "4444", "55555", "666666", "7777777", "88888888", ]
        view.addSubview(bar)
        let barViews = ["bar": bar]
        bar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bar]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: barViews))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[bar(50)]",
                                                           options: [],
                                                           metrics: nil,
                                                           views: barViews))
        
        lineBar.itemTitles = ["111", "222", "333", "444", ]
        lineBar.frame = CGRect(x: 50, y: 200, width: Screen.width - 100, height: 50)
        lineBar.isScrollEnabled = false
        view.addSubview(lineBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(bar.frame)
        print(lineBar.frame)
    }
}
