//
//  ImplicitTabbarController.swift
//  DoSomeTransition
//
//  Created by zhong on 2018/9/23.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class InterruptibleTabbarController: UITabBarController {
    var animator: InterruptibleAnimation = InterruptibleAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translateX = gesture.translation(in: view).x
        let progress = abs(translateX) / view.frame.width
        switch gesture.state {
        case .began:
            let velocityX = gesture.velocity(in: view).x
            if velocityX < 0 {
                if selectedIndex < children.count {
                    selectedIndex += 1
                }
            } else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }
        case .ended, .cancelled:
            break
        default: break
        }
    }
}

extension InterruptibleTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = tabBarController.children.firstIndex(of: fromVC),
            let toIndex = tabBarController.children.firstIndex(of: toVC) else {
                return nil
        }
        animator.direction = fromIndex < toIndex ? .left : .right
        return animator
    }
}

class InterruptibleAnimation: NSObject, UIViewControllerAnimatedTransitioning, Directionable {
    var direction = Direction.none
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        guard let fromView = fromVC?.view, let toView = toVC?.view else { return }
        let translation = containerView.frame.width
        
        containerView.addSubview(toView)
        
        var fromViewFinalTrans = CGAffineTransform.identity
        switch direction {
        case .left:
            toView.transform = CGAffineTransform(translationX: translation, y: 0)
            fromViewFinalTrans = CGAffineTransform(translationX: -translation, y: 0)
            break
        case .right:
            toView.transform = CGAffineTransform(translationX: -translation, y: 0)
            fromViewFinalTrans = CGAffineTransform(translationX: translation, y: 0)
            break
        default: break
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseInOut], animations: {
            fromView.transform = fromViewFinalTrans
            toView.transform = .identity
        }) { (finish) in
            toView.transform = .identity
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut, animations: nil)
        
        return animator
    }
}
