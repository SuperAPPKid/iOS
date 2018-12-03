//
//  PaintingView.swift
//  drawer
//
//  Created by Hank_Zhong on 2018/12/3.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class PaintingView: UIView {
    private var layers: [CAShapeLayer] = []
    private var currentDraw: NormalDrawStruct?
    
    func clear() {
        layers = []
        layer.sublayers = []
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self), touches.count == 1 else {
            return
        }
        let drawObj = NormalDrawStruct(initial: touch)
        currentDraw = drawObj
        layer.addSublayer(drawObj.layer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self), touches.count == 1 else {
            return
        }
        currentDraw?.move(point: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let layer = currentDraw?.layer else {
            return
        }
        layers.append(layer)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let layer = currentDraw?.layer else {
            return
        }
        layers.append(layer)
    }
}

struct NormalDrawStruct {
    let layer: CAShapeLayer = CAShapeLayer()
    private let currentPath: UIBezierPath
    
    init(initial point: CGPoint, color: UIColor = .black) {
        currentPath = UIBezierPath()
        layer.path = currentPath.cgPath
        currentPath.move(to: point)
        layer.strokeColor = color.cgColor
        layer.lineWidth = 3
        layer.lineCap = .round
        layer.lineJoin = .round
    }
    
    func move(point: CGPoint) {
        currentPath.addLine(to: point)
        currentPath.move(to: point)
        layer.path = currentPath.cgPath
    }
}
