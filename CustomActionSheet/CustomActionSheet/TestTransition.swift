//
//  File.swift
//  iOS_TWB
//
//  Created by zhong on 2018/7/7.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TestTransitioning:NSObject,UIViewControllerAnimatedTransitioning {
    let viewHeight:CGFloat
    
    init(height:CGFloat) {
        self.viewHeight = height
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) else {return}
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
        
        if toVC.isBeingPresented {
            guard let toView = transitionContext.view(forKey: .to) else {return}
            toView.transform = CGAffineTransform(translationX: 0, y: viewHeight)
            containerView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.transform = .identity
            }) { (complete) in
                transitionContext.completeTransition(true)
            }
        }
        if fromVC.isBeingDismissed {
            guard let fromView = transitionContext.view(forKey: .from) else {return}
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                fromView.transform = CGAffineTransform(translationX: 0, y: self.viewHeight)
            }) { (complete) in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
