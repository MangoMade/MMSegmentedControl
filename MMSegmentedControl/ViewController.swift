//
//  ViewController.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/11.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bar = UnderlineSegmentedControl(itemTitles: ["1", "22", "333", "4444", "55555", "666666", "7777777", "88888888", ])
    let lineBar = UnderlineSegmentedControl()
    
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        lineBar.itemTitles = ["111", "222", ]
        lineBar.frame = CGRect(x: 0, y: 200, width: Screen.width, height: 50)
        lineBar.isScrollEnabled = false
        lineBar.textMargin = 50
        lineBar.leftMargin = 50
        lineBar.rightMargin = 50
        view.addSubview(lineBar)
        
        button.setTitle("change", for: .normal)
        button.addTarget(self, action: #selector(change(sender:)), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 300, width: 100, height: 50)
        view.addSubview(button)
    }
    

    func change(sender: UIButton) {
        lineBar.textMargin = 100
    }
}
