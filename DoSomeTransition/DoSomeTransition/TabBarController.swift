//
//  TabBarController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private var tabbarDelegate: UITabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarDelegate = TabBarControllerDelegate()
        delegate = tabbarDelegate
    }
}

private class TabBarControllerDelegate:NSObject, UITabBarControllerDelegate {
    let animateController: (UIViewControllerAnimatedTransitioning & UIViewControllerInteractiveTransitioning)?
    
    convenience override init() {
        self.init(animateAPI: nil)
    }
    
    init(animateAPI: (UIViewControllerAnimatedTransitioning & UIViewControllerInteractiveTransitioning)?) {
        self.animateController = animateAPI
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animateController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animateController
    }
}
