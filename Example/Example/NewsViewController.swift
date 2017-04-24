//
//  NewsViewController.swift
//  Example
//
//  Created by Aqua on 2017/4/20.
//  Copyright © 2017年 Aqua. All rights reserved.
//

import UIKit
import MMSegmentedControl

class NewsViewController: UIViewController {
    
    let newsView = NewsView()
    
    private var children = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(newsView)
        newsView.frame = CGRect(x: 0,
                                y: Screen.navBarHeight,
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height - Screen.navBarHeight)
        
        let titles = ["1", "22", "333", "4444", "55555", "123", "11233"]
        
        let colors = [UIColor.red,
                      UIColor.blue,
                      UIColor.green,
                      UIColor.lightGray,
                      UIColor.yellow,
                      UIColor.green,
                      UIColor.lightGray,
                      UIColor.yellow]
        
        let items = titles.enumerated().map { (index, title) -> SegmentedControlViewItem in
            let viewController = UIViewController()
            viewController.view.backgroundColor = colors[index]
            addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
            children.append(viewController)
            return SegmentedControlViewItem(title: title, view: viewController.view)
        }
        newsView.segmentedView.items = items
    }

}
