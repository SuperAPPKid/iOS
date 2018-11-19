//
//  TabBarController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    private let tabbarDelegate = TabBarControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = tabbarDelegate
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translateX = gesture.translation(in: view).x
        let progress = abs(translateX) / view.frame.width
        switch gesture.state {
        case .began:
            tabbarDelegate.canInteract = true
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
        case .changed:
            tabbarDelegate.interactionController.update(progress)
        case .ended, .cancelled:
            if progress > 0.1 {
                tabbarDelegate.interactionController.finish()
            } else {
                tabbarDelegate.interactionController.cancel()
            }
            tabbarDelegate.canInteract = false
        default: break
        }
    }
}
