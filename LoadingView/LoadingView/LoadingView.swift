//
//  LoadingView.swift
//  LoadingView
//
//  Created by user37 on 2018/3/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    override var layer: CAShapeLayer {
        get{
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass:AnyClass {
        get {
            return CAShapeLayer.self
        }
    }
    
    struct Pose {
        let secondsSinceLastTime: CFTimeInterval
        let start:CGFloat
        let length:CGFloat
    }
    
    var poses:[Pose]{
        get{
            return [
                Pose.init(secondsSinceLastTime: 0.0, start: 0.000, length: 0.8),
                Pose.init(secondsSinceLastTime: 0.4, start: 0.500, length: 0.5),
                Pose.init(secondsSinceLastTime: 0.2, start: 1.000, length: 0.3),
                Pose.init(secondsSinceLastTime: 0.4, start: 1.500, length: 0.1),
                Pose.init(secondsSinceLastTime: 0.4, start: 1.875, length: 0.3),
                Pose.init(secondsSinceLastTime: 0.2, start: 2.250, length: 0.5),
                Pose.init(secondsSinceLastTime: 0.4, start: 2.625, length: 0.7),
                Pose.init(secondsSinceLastTime: 0.2, start: 3.000, length: 0.8),
            ]
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 30
        layer.strokeColor = UIColor.red.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineCapRound
        layer.path = UIBezierPath.init(ovalIn: bounds.insetBy(dx: layer.lineWidth, dy: layer.lineWidth)).cgPath
    }
    
    override func didMoveToSuperview() {
        animate()
    }
    
    func animate() {
        var time:CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start:CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let totalSeconds = self.poses.reduce(0) { (result, pose) -> CFTimeInterval in
            return result + pose.secondsSinceLastTime
        }
        
        for pose in poses {
            time += pose.secondsSinceLastTime
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * CGFloat.pi)
            strokeEnds.append(pose.length)
        }
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        animateStrokeHueWithDuration(duration: totalSeconds)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = kCAAnimationLinear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration:CFTimeInterval) {
        let count = 144
        let animation = CAKeyframeAnimation.init(keyPath: "strokeColor")
        animation.keyTimes = (0...count).map{ NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 0.9).cgColor
//            if $0 % 2 == 1{
//                return UIColor.yellow.cgColor
//            } else {
//                return UIColor.red.cgColor
//            }
        }
        animation.duration = duration
        animation.calculationMode = kCAAnimationLinear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}



