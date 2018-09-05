//
//  ViewController.swift
//  Riddle_effect
//
//  Created by Hank_Zhong on 2018/9/4.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var hzSBView: HZRippleView!
    let hzView = HZRippleView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
    @IBOutlet weak var hzSBButton: HZRippleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hzSBButton.layer.cornerRadius = 37
        
        hzView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        hzView.rippleColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        hzView.finalColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        hzView.canOverBorder = true
        hzView.rippleRadius = 300
        hzView.layer.cornerRadius = 50
        view.addSubview(hzView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hzView.triggerRipple()
        let rand = CGFloat(arc4random_uniform(320))
        hzSBView.triggerRipple(at: CGPoint(x: rand, y: rand))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

