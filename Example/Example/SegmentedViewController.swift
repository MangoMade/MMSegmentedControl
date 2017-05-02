//
//  SegmentedViewController.swift
//  MMSegmentedControl
//
//  Created by Aqua on 2017/4/17.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit
import MMSegmentedControl
class SegmentedViewController: UIViewController {

    private var children = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false
        let segmentedView = SegmentedControlView()
        
        segmentedView.frame = CGRect(x: 0,
                                     y: Screen.navBarHeight,
                                     width: Screen.width,
                                     height: Screen.height - Screen.navBarHeight)
        
        let titles = ["推荐", "开庭", "国家情怀", "现场", "315", "财案",  "法老汇",]

        let items = titles.enumerated().map { (index, title) -> SegmentedControlViewItem in
            let viewController = UIViewController()
            viewController.view.backgroundColor = index % 2 == 0 ? UIColor.white : UIColor.lightGray
            addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
            children.append(viewController)
            
            let label = UILabel()
            label.text = title
            label.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
            label.center = CGPoint(x: Screen.width / 2, y: 100)
            label.textAlignment = .center
            viewController.view.addSubview(label)
            
            return SegmentedControlViewItem(title: title, view: viewController.view)
        }
        segmentedView.items = items
        
        view.addSubview(segmentedView)
    }



}
