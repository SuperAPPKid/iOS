//
//  HZRippleButton.swift
//  Riddle_effect
//
//  Created by Hank_Zhong on 2018/9/4.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//  reference:https://github.com/zoonooz/ZFRippleButton

import UIKit

class HZRippleButton: UIButton {
    @IBInspectable var rippleColor: UIColor? {
        didSet {
            rippleView.rippleColor = rippleColor
        }
    }
    @IBInspectable var rippleRadius: Float = 0 {
        didSet {
            rippleView.rippleRadius = rippleRadius
        }
    }
    @IBInspectable var canOverBorder: Bool = false {
        didSet {
            rippleView.canOverBorder = canOverBorder
        }
    }
    @IBInspectable var finalColor: UIColor?
    private let rippleView = HZRippleView()
    private var cornerRadius:CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = layer.cornerRadius
        rippleView.frame = bounds
        insertSubview(rippleView, at: 0)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        guard path.contains(touchPoint) else {
            return false
        }
        
        if canOverBorder {
            rippleView.triggerRipple()
        } else {
            rippleView.triggerRipple(at: touchPoint)
        }
        
        return super.beginTracking(touch, with: event)
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        guard let finalColor = finalColor else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.backgroundColor = finalColor
        }, completion: nil)
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        guard let finalColor = finalColor else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.backgroundColor = finalColor
        }, completion: nil)
    }
}
