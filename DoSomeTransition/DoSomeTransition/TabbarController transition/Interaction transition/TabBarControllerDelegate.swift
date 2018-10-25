//
//  TabbarControllerDelegate.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

enum Direction {
    case up
    case down
    case left
    case right
    case none
    func reverse() -> Direction {
        switch self {
        case .up:
            return Direction.down
        case .down:
            return Direction.up
        case .left:
            return Direction.right
        case .right:
            return Direction.left
        case .none:
            return Direction.none
        }
    }
}

protocol Directionable {
    var direction: Direction { get set }
}

class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    var animateController: (UIViewControllerAnimatedTransitioning & Directionable)? = TabBarInteractAnimation()
    let interactionController = Test()
    var canInteract = false
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return canInteract ? interactionController : nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = tabBarController.children.firstIndex(of: fromVC),
            let toIndex = tabBarController.children.firstIndex(of: toVC) else {
                return nil
        }
        animateController?.direction = fromIndex < toIndex ? .left : .right
        return animateController
    }
}

class Test: UIPercentDrivenInteractiveTransition {
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
    }
}
