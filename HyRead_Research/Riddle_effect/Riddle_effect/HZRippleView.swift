//
//  HZRippleView.swift
//  Riddle_effect
//
//  Created by Hank_Zhong on 2018/9/4.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class HZRippleView: UIView {
    @IBInspectable var rippleBackgroundColor: UIColor?
    @IBInspectable var rippleColor: UIColor?
    @IBInspectable var finalColor: UIColor?
    @IBInspectable var rippleLayer: CAShapeLayer = CAShapeLayer()
    @IBInspectable var rippleDiameter: Float = 0
    @IBInspectable var canOverBorder: Bool = true
    private var initialBackgroundColor: UIColor?
    
    //MARK:- initiallizer
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK:- setup
    func setup() {
        initialBackgroundColor = backgroundColor
        if canOverBorder {
            layer.masksToBounds = false
        } else {
            layer.masksToBounds = true
        }
    }
    
    //MARK:- trigger ripple anime
    func triggerRipple() {
        triggerRipple(at: CGPoint(x: bounds.width/2, y: bounds.height/2))
    }
    
    func triggerRipple(at point: CGPoint) {
        backgroundColor = rippleBackgroundColor
        rippleLayer.removeAllAnimations()
        
        let radius = rippleDiameter > 0 && canOverBorder ? CGFloat(rippleDiameter):point.distanceToFarCorner()
        let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        rippleLayer.fillColor = rippleColor?.cgColor
        rippleLayer.position = point
        rippleLayer.path = path.cgPath
        CATransaction.commit()
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.speed = 0.5
        scaleAnim.fromValue = 0
        scaleAnim.toValue = 1
        scaleAnim.delegate = self
        rippleLayer.add(scaleAnim, forKey: "scaleAnim")
        layer.addSublayer(rippleLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            triggerRipple(at: point)
        }
    }
}

extension HZRippleView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            rippleLayer.removeFromSuperlayer()
            if let finalColor = finalColor {
                backgroundColor = finalColor
            } else {
                backgroundColor = initialBackgroundColor
            }
        }
    }
}

extension CGPoint {
    
    func distanceToFarCorner() -> CGFloat {
        return 123
    }
}
