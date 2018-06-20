//
//  CATransition.swift
//  DoSomeTransition
//
//  Created by zhong on 2018/6/18.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class CATransitionVC: UIViewController {
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(change)))
    }
    @objc func change() {
        let transition = CATransition()
        transition.duration = 1
        transition.type = "cube"
        transition.subtype = kCATransitionPush
        self.navigationController?.view.layer.add(transition, forKey: "transition")
        if page == 0 {
            let toVC = CATransitionVC()
            toVC.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            toVC.page = 1
            self.navigationController?.pushViewController(toVC, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)        }
    }
}
