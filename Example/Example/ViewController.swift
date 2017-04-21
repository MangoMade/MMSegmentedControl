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
        let lineBarHeight: CGFloat = 50
        lineBar.frame = CGRect(x: 70, y: 200, width: Screen.width - 140, height: lineBarHeight)
        lineBar.isScrollEnabled = false
        lineBar.itemMargin = 0
        lineBar.leftMargin = 0
        lineBar.rightMargin = 0
        lineBar.lineHeight = lineBarHeight
        lineBar.underline.layer.cornerRadius = lineBarHeight / 2
        lineBar.layer.cornerRadius = lineBarHeight / 2
        lineBar.clipsToBounds = true
        lineBar.layer.borderColor = UIColor.black.cgColor
        lineBar.layer.borderWidth = 1
        
        lineBar.selectedTextColor = UIColor.white
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
        
        let newsButton = UIButton(type: .system)
        newsButton.setTitle("news", for: .normal)
        newsButton.addTarget(self, action: #selector(goToNewsViewController(_:)), for: .touchUpInside)
        newsButton.frame = CGRect(x: 100, y: 500, width: 100, height: 50)
        view.addSubview(newsButton)
    }
    

    func change(sender: UIButton) {
        if lineBar.itemMargin == 50 {
            lineBar.itemMargin = 100
        } else {
            lineBar.itemMargin = 50
        }
    }
    
    func push(sender: UIButton) {
        navigationController?.pushViewController(SegmentedViewController(), animated: true)
    }
    
    func goToNewsViewController(_ sender: UIButton) {
        navigationController?.pushViewController(NewsViewController(), animated: true)
    }
}
