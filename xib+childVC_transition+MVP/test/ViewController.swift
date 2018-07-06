//
//  ViewController.swift
//  test
//
//  Created by Hank_Zhong on 2018/7/6.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let containerView:UIView = {
        let containerView = UINib(nibName:"NibView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        containerView.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
        return containerView
    }()
    
//    override func viewDidLoad()  {
//        let sview = UIView()
//        view.addSubview(sview)
//        sview.backgroundColor = .orange
//        sview.translatesAutoresizingMaskIntoConstraints = false
//        [sview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
//         sview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
//         sview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
//         sview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)].forEach({$0.isActive = true})
//    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(containerView)
            let FVC = FirstViewController()
            let SVC = SecondViewController()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.addChildViewController(FVC)
                FVC.view.frame = self.containerView.bounds
                self.containerView.addSubview(FVC.view)
                FVC.didMove(toParentViewController: self)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                //沒動畫
                self.addChildViewController(SVC)
                SVC.view.translatesAutoresizingMaskIntoConstraints = false
                SVC.view.frame = self.containerView.bounds
                self.containerView.addSubview(SVC.view)
                self.containerView.frame = CGRect(x: 50, y: 50, width: 320, height: 500)
                SVC.didMove(toParentViewController: self)
                FVC.willMove(toParentViewController: nil)
                FVC.view.removeFromSuperview()
                FVC.removeFromParentViewController()
    
                //有動畫
//                self.addChildViewController(SVC)
//                SVC.view.translatesAutoresizingMaskIntoConstraints = false
//                SVC.view.frame = self.containerView.bounds
//                FVC.willMove(toParentViewController: nil)
//                self.transition(from: FVC, to: SVC, duration: 0.5, options: .curveEaseIn, animations: {
//                    self.containerView.frame = CGRect(x: 50, y: 50, width: 320, height: 500)
//                }, completion: { (complete) in
//                    SVC.didMove(toParentViewController: self)
//                    FVC.removeFromParentViewController()
//                })
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

