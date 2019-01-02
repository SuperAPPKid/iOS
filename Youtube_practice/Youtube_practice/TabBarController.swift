//
//  TabBarController.swift
//  Youtube_practice
//
//  Created by zhong on 2018/7/24.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let myView = UIView()
    let newView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tabBar.isTranslucent = false
        myView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 0.6005993151)
        myView.frame = CGRect(x: 0, y: view.frame.height - tabBar.frame.height - 50, width: view.frame.width, height: 50)
        newView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5976027397)
        newView.frame = CGRect(x: 0, y: view.frame.height - tabBar.frame.height, width: view.frame.width, height: 50)
        view.addSubview(myView)
        view.addSubview(newView)
    }
}
extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
}
