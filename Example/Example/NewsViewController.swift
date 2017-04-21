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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(newsView)
        newsView.frame = CGRect(x: 0,
                                y: Screen.navBarHeight,
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height - Screen.navBarHeight)
    }

}
