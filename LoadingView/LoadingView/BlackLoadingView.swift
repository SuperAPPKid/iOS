//
//  BlackLoadingView.swift
//  LoadingView
//
//  Created by user37 on 2018/3/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit

class BlackLoadingView: UIView {
    let shapeLayer = CAShapeLayer()
    let backgroundShapeLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layer.borderColor = UIColor.red.cgColor
//        self.layer.borderWidth = 5
        
        shapeLayer.frame = self.bounds
        shapeLayer.lineWidth = 15
        shapeLayer.path = UIBezierPath.init(ovalIn: bounds.insetBy(dx: shapeLayer.lineWidth, dy: shapeLayer.lineWidth)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor
        
        
//        shapeLayer.strokeEnd = 0.95
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.white.cgColor]
        gradientLayer.mask = shapeLayer
        gradientLayer.startPoint = CGPoint.init(x: 0.025, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.975, y: 0)
        
        self.layer.addSublayer(gradientLayer)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let animation:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation")
        animation.fromValue = NSNumber.init(value: 0)
        animation.toValue = NSNumber.init(value: -2*Float.pi)
        animation.duration = 1
        animation.repeatCount = Float.infinity
        animation.fillMode = kCAFillModeBackwards
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.layer.add(animation, forKey: nil)
    }
}
