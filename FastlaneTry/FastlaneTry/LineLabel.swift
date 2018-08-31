//
//  GradientLabel.swift
//  FastlaneTry
//
//  Created by Hank_Zhong on 2018/8/30.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class LineLabel: UILabel {
    var subLabel:UILabel!
    var shapeLayer: CAShapeLayer!
    var count = 2
    var path: CGPath {
        let start:CGFloat = CGFloat(count * 10)
        //UIBezierPath
        let path = UIBezierPath()
        path.move(to: CGPoint(x: start, y: 0))
        path.addLine(to: CGPoint(x: start, y: bounds.height))
        return path.cgPath
        //CGMutablePath
//        let path = CGMutablePath()
//        path.addLines(between: [CGPoint(x: start, y: 0),CGPoint(x: start, y: bounds.height)])
//        path.addRect(CGRect(x: start, y: 0, width: 20, height: 20))
//        return path
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addShapeLayer()
    }
    
    private func addShapeLayer() {
        shapeLayer = CAShapeLayer()
        shapeLayer.borderWidth = 3
        shapeLayer.lineWidth = 5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineDashPhase = 5
        shapeLayer.strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [5, 10]
        let strokeAni = CABasicAnimation(keyPath: "strokeEnd")
        strokeAni.autoreverses = true
        strokeAni.repeatCount = HUGE
        strokeAni.duration = 1.5
        strokeAni.fromValue = 0
        strokeAni.toValue = 1
        let shakeAni = CASpringAnimation(keyPath: "transform.translation.x")
        shakeAni.autoreverses = true
        shakeAni.repeatCount = HUGE
        shakeAni.duration = 0.1
        shakeAni.beginTime = 1.5
        shakeAni.damping = 0
        shakeAni.mass = 1
        shakeAni.initialVelocity = 5
        shakeAni.byValue = 10
//        let shakeAni = CABasicAnimation(keyPath: "transform.translation.x")
//        shakeAni.autoreverses = true
//        shakeAni.repeatCount = HUGE
//        shakeAni.duration = 0.05
//        shakeAni.beginTime = 1.5
//        shakeAni.byValue = -5
//        shakeAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let aniGroup = CAAnimationGroup()
        aniGroup.animations = [strokeAni, shakeAni]
        aniGroup.duration = 3
        aniGroup.repeatCount = HUGE
        shapeLayer.add(strokeAni, forKey: "strokeAni")
        shapeLayer.add(shakeAni, forKey: "shakeAni")
//        shapeLayer.add(aniGroup, forKey: "aniGroup")
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = path
    }
    
    //耗費記憶體，盡量不要用
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        shapeLayer.path = path
//        layer.addSublayer(shapeLayer)
//        count += 1
//    }
    
    func redraw() {
        count += 1
        shapeLayer.path = path
    }
}
