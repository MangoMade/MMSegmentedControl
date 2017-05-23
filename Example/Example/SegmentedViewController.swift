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
    
    private let segmentedView = SegmentedControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false
        
    
        let titles = ["推荐", "开庭"]

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
        
        segmentedView.segmentedControl.isScrollEnabled = false
        segmentedView.segmentedControl.itemMargin  = 50
        segmentedView.segmentedControl.leftMargin  = 30
        segmentedView.segmentedControl.rightMargin = 30
        
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedView)
//        segmentedView.frame = CGRect(x: 0,
//                                     y: Screen.navBarHeight,
//                                     width: Screen.width,
//                                     height: Screen.height - Screen.navBarHeight)
        NSLayoutConstraint(item: segmentedView,
                           attribute: .left,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .left,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: segmentedView,
                           attribute: .right,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .right,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: segmentedView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: segmentedView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .top,
                           multiplier: 1,
                           constant: Screen.navBarHeight).isActive = true
        
        let change = UIBarButtonItem(title: "change", style: .plain, target: self, action: #selector(change(_:)))
        
        let pop = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(pop(_:)))
        navigationItem.rightBarButtonItems = [pop, change]
    }

    func change(_ sender: UIBarButtonItem) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
        children.append(viewController)
        
        let label = UILabel()
        label.text = title
        label.bounds = CGRect(x: 0, y: 0, width: 100, height: 50)
        label.center = CGPoint(x: Screen.width / 2, y: 100)
        label.textAlignment = .center
        viewController.view.addSubview(label)
        
        segmentedView.items.append(SegmentedControlViewItem(title: "New", view: viewController.view))
    }
    
    func pop(_ sender: UIBarButtonItem) {
        let _ = segmentedView.items.popLast()
    }
}
