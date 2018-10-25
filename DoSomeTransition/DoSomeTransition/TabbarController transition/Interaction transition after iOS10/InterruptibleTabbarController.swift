//
//  ImplicitTabbarController.swift
//  DoSomeTransition
//
//  Created by zhong on 2018/9/23.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class InterruptibleTabbarController: UITabBarController {
    var slider: UISlider!
    var startTransButton: UIBarButtonItem!
    var rewindTransButton: UIBarButtonItem!
    var isForward = true
    var animator: UIViewPropertyAnimator?
    var displaylink: CADisplayLink?
    
    override func viewDidLoad() {
        startTransButton = UIBarButtonItem(title: "開始", style: .plain, target: self, action: #selector(startTrans(sender:)))
        slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        slider.value = 0
        navigationItem.titleView = slider
        navigationItem.rightBarButtonItems = [startTransButton]
        delegate = self
    }
    
    @objc func tick(sender: CADisplayLink) {
        if let animator = animator, animator.isRunning {
            slider.value  = Float(animator.fractionComplete)
        }
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        if let animator = animator {
            animator.fractionComplete = CGFloat(sender.value)
            print("\(slider.value)  \(animator.fractionComplete)")
        }
    }
    
    @objc func startTrans(sender: UIBarButtonItem) {
        if let animator = animator{
            if animator.isRunning {
                animator.pauseAnimation()
            } else {
                animator.startAnimation()
            }
        }
    }
    
    func setupAnimator(context: UIViewControllerContextTransitioning) {
        let containerView = context.containerView
        let fromVC = context.viewController(forKey: .from)
        let toVC = context.viewController(forKey: .to)
        guard let fromView = fromVC?.view, let toView = toVC?.view else { return }
        let translation = containerView.frame.width
        toView.frame.origin.x = translation
        containerView.addSubview(toView)
        displaylink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
        displaylink?.add(to: .current, forMode: .default)
        animator = UIViewPropertyAnimator(duration: 3, timingParameters: UICubicTimingParameters(animationCurve: .easeOut))
        animator?.addAnimations {
            fromView.frame.origin.x -= translation
            toView.frame.origin.x -= translation
        }
        animator?.addCompletion { (position) in
            context.completeTransition(position == .end)
        }
        if !context.isInteractive {
            animator?.startAnimation()
        }
    }
}

extension InterruptibleTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension InterruptibleTabbarController: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        setupAnimator(context: transitionContext)
    }
    var wantsInteractiveStart: Bool {
        return true
    }
}

extension InterruptibleTabbarController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        setupAnimator(context: transitionContext)
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return animator!
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        animator = nil
        displaylink?.invalidate()
        displaylink = nil
    }
}
