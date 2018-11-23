//
//  ViewController.swift
//  teshyh
//
//  Created by Hank_Zhong on 2018/9/7.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class Test {
    static var templayers:[CAShapeLayer] = []
}

class ViewController: UIViewController {
    var sview: UIView!
    let slayer = CAShapeLayer()
    var first: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sview = TestView(frame: CGRect(x: 10, y: 10, width: 5000, height: 5000))
        sview.backgroundColor = .black
        slayer.strokeColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        slayer.fillColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        for layer in Test.templayers {
            view.layer.addSublayer(layer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        print(#function)
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
        super.viewDidLayoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !sview.isDescendant(of: view) {
        if first {
            if sview.superview != view {
                view.addSubview(sview)
            }
            
            let bp = UIBezierPath()
            bp.move(to: CGPoint(x: 200, y: 120))
            bp.addLine(to: CGPoint(x: 100, y: 300))
            bp.addArc(withCenter: CGPoint(x: 100, y: 300), radius: 75, startAngle: -0.5, endAngle: 0.5, clockwise: true)
            bp.addLine(to: CGPoint(x: 100, y: 300))
            bp.addCurve(to: CGPoint(x: 300, y: 300), controlPoint1: CGPoint(x: 150, y: 500), controlPoint2: CGPoint(x: 250, y: 300))
            bp.addQuadCurve(to: CGPoint(x: 200, y: 120), controlPoint: CGPoint(x: 120, y: 300))
            
            slayer.path = bp.cgPath
            slayer.lineWidth = 10
            slayer.lineCap = "round"
            slayer.lineJoin = "round"
            
            if slayer.superlayer == nil {
                view.layer.addSublayer(slayer)
            }
            first = false
        } else {
            let nlayer = CAShapeLayer()
            let touch = touches.first!.location(in: view)
            nlayer.frame.size = CGSize(width: 100, height: 100)
            nlayer.position = touch
            
            nlayer.backgroundColor = ([#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)].randomElement()! as UIColor).cgColor
            nlayer.borderColor = ([#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)].randomElement()! as UIColor).cgColor
            nlayer.borderWidth = 3
            nlayer.lineCap = "round"
            nlayer.lineJoin = "round"
            view.layer.addSublayer(nlayer)
            Test.templayers.append(nlayer)
        }
    }
}

