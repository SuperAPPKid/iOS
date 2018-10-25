//
//  TabBarAnimation.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TabBarInteractAnimation: NSObject, UIViewControllerAnimatedTransitioning, Directionable {
    var direction = Direction.none
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
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
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut], animations: {
            fromView.transform = fromViewFinalTrans
            toView.transform = .identity
        }) { (finish) in
            toView.transform = .identity
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
