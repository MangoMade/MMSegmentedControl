//
//  ViewController.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/11.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit
import MMSegmentedControl

class ViewController: UIViewController {
    
    let bar = SegmentedControl(itemTitles: ["1", "22", "333", "4444", "55555", "666666", "7777777", "88888888", ])
    let lineBar = SegmentedControl()
    
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        let barViews = ["bar": bar]
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.underline.isHidden = true
        view.addSubview(bar)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bar]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: barViews))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[bar(50)]",
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
        
        let pushButton = UIButton(type: .system)
        pushButton.setTitle("push", for: .normal)
        pushButton.addTarget(self, action: #selector(push(sender:)), for: .touchUpInside)
        pushButton.frame = CGRect(x: 100, y: 400, width: 100, height: 50)
        view.addSubview(pushButton)
    }
    

    func change(sender: UIButton) {
        if lineBar.textMargin == 50 {
            lineBar.textMargin = 100
        } else {
            lineBar.textMargin = 50
        }
    }
    
    func push(sender: UIButton) {
        navigationController?.pushViewController(SegmentedViewController(), animated: true)
    }
}
