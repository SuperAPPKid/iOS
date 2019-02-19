//
//  TestView.swift
//  teshyh
//
//  Created by Hank_Zhong on 2018/9/7.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TestView: UIView {
    override open class var layerClass: AnyClass {
        return TestLayer.self
    }
    
    override func layoutSubviews() {
        print(#function)
        super.layoutSubviews()
    }
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        print("\(#function) \(size)")
//        return super.sizeThatFits(size)
//    }
//    override func draw(_ rect: CGRect) {
//        print("\(#function) \(rect) \(UIGraphicsGetCurrentContext())")
//    }
//    override func draw(_ layer: CALayer, in ctx: CGContext) {
//        print("\(#function) \(layer) \(ctx)")
//        super.draw(layer, in: ctx)
//    }
//    override func display(_ layer: CALayer) {
//        layer.backgroundColor = UIColor.cyan.cgColor
//        print("\(#function) \(layer)")
//    }
}

class TestLayer: CALayer {
    override func draw(in ctx: CGContext) {
        print("\(#function) \(ctx)")
        super.draw(in: ctx)
    }
    override func display() {
        print(#function)
        super.display()
    }
}

/*
Layer
 
 if self.delegate implement draw(_ rect) {
    self.display() -> if self.delegate implement display(_ layer: CALayer) {
                         self.delegate.display(_ layer: CALayer) 56mb
                      } else {
                         create ctx!!! memory need
                         self.draw(in ctx) -> self.delegate.draw(layer in ctx) -> self.delegate.draw(_ rect) 152mb
                      }
 } else {
    **do some private function 56mb
 }
*/
