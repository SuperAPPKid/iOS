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
    @IBInspectable var rippleRadius: Float = 0
    @IBInspectable var canOverBorder: Bool = false {
        didSet {
            layer.masksToBounds = !canOverBorder
        }
    }
    
    var rippleLayer: CAShapeLayer = CAShapeLayer()
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
        layer.masksToBounds = true
        isUserInteractionEnabled = false
    }
    
    //MARK:- trigger ripple anime
    func triggerRipple() {
        triggerRipple(at: CGPoint(x: bounds.width/2, y: bounds.height/2))
    }
    
    func triggerRipple(at point: CGPoint) {
        //這種情況沒加這行也會移除動畫
//        rippleLayer.removeAllAnimations()
        
        let radius = rippleRadius > 0 && canOverBorder ? CGFloat(rippleRadius) : (point.distanceToFarCorner(in: bounds.size) * 1.25)
        let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        rippleLayer.fillColor = rippleColor?.cgColor
        rippleLayer.position = point
        rippleLayer.path = path.cgPath
        CATransaction.commit()
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0.1
        scaleAnim.toValue = 1
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [scaleAnim, opacityAnim]
        animGroup.duration = 0.5
        animGroup.delegate = self
        
        rippleLayer.add(animGroup, forKey: "animGroup")
        rippleLayer.opacity = 0
        
        //如果rippleLayer已經加入，會變更ripple
        layer.addSublayer(rippleLayer)
    }

    //for test
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let point = touches.first?.location(in: self) {
//            triggerRipple(at: point)
//        }
//    }
}

extension HZRippleView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        guard let rippleBackColor = rippleBackgroundColor else { return }
        backgroundColor = rippleBackColor
        let color = finalColor ?? initialBackgroundColor
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.backgroundColor = color
        }, completion: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            rippleLayer.removeFromSuperlayer()
        }
    }
}

extension CGPoint {
    func distanceToFarCorner(in size:CGSize) -> CGFloat {
        let height = size.height
        let width = size.width
        
        let isUp = (self.y - height / 2) < 0
        let isLeft = (self.x -  width / 2 ) < 0
        
        let horizonDistance = isUp ? (height - self.y) : (self.y)
        let verticalDistance = isLeft ? (width - self.x) : (self.x)
        
        return (horizonDistance * horizonDistance + verticalDistance * verticalDistance).squareRoot()
    }
}
