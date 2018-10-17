//
//  ViewController.swift
//  teshyh
//
//  Created by Hank_Zhong on 2018/9/7.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var sview: UIView!
    let slayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sview = TestView(frame: CGRect(x: 10, y: 10, width: 500, height: 500))
        sview.backgroundColor = .black
        slayer.strokeColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        slayer.fillColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
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
    }
}

