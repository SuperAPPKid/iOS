//
//  ChildVC_transition.swift
//  DoSomeTransition
//
//  Created by zhong on 2018/6/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ChildVC_transition: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    let childVC1 = UIViewController()
    let childVC2 = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        childVC1.view.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        childVC2.view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        childVC1.view.frame = containerView.bounds
        childVC2.view.frame = containerView.bounds
        
        self.addChildViewController(childVC1)
        containerView.addSubview(childVC1.view)
        
    }
    
    @IBAction func toogle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.addChildViewController(childVC1)
            self.transition(from: childVC2,
                            to: childVC1,
                            duration: 1.0,
                            options: .transitionFlipFromLeft, animations: {
                                
            }) { (complete) in
                if complete {
                    self.childVC1.didMove(toParentViewController: self)
                    self.childVC2.willMove(toParentViewController: nil)
                    self.childVC2.removeFromParentViewController()
                }
            }
        } else {
            self.addChildViewController(childVC2)
            self.transition(from: childVC1,
                            to: childVC2,
                            duration: 1.0,
                            options: .transitionFlipFromRight, animations: {
                                
            }) { (complete) in
                if complete {
                    self.childVC2.didMove(toParentViewController: self)
                    self.childVC1.willMove(toParentViewController: nil)
                    self.childVC1.removeFromParentViewController()
                }
            }
        }
    }
    
    
}
