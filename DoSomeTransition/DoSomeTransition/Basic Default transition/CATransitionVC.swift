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
        view.isUserInteractionEnabled = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(change)))
//        print(navigationController)
    }
    
    // 因為在viewDidLoad時viewcontroller尚未加入到navigationcontroller中, 故無法取得navigationController, 因此放到viewWillAppear來
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(navigationController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.isUserInteractionEnabled = true
    }
    
    private func addCATransition(type:String, subtype:CATransitionSubtype, duration:CFTimeInterval = 1) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType(rawValue: type)
        transition.subtype = subtype
        navigationController?.view.layer.add(transition, forKey: "transition")
    }
    
    @objc func change() {
        if page == 0 {
            let toVC = CATransitionVC()
            toVC.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            toVC.page = 1
            addCATransition(type: "cube", subtype: .fromRight)
            self.navigationController?.pushViewController(toVC, animated: true)
        } else {
            addCATransition(type: "cube", subtype: .fromLeft)
            navigationController?.popViewController(animated: true)
        }
    }
}
