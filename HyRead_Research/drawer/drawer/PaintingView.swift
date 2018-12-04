
//  PaintingView.swift
//  drawer
//
//  Created by Hank_Zhong on 2018/12/3.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

fileprivate typealias callback = ((CAShapeLayer)->Void)
fileprivate let Accuracy = 1

enum Shape {
    case 直線, 曲線, 虛線直, 虛線曲, 橡皮擦
}

class PaintingView: UIView {
    private var drawers: [AbstractDrawer] = []
    private var currentDraw: AbstractDrawer?
    private var garbageSet: Set<AbstractDrawer> = []
    
    private var garbageCollectIsOn: Bool {
        return garbageSet.count != 0
    }
    
    var preferWidth: CGFloat = 3 {
        didSet {
            currentDraw?.shapeLayer.lineWidth = preferWidth
        }
    }
    var preferColor: UIColor = .black {
        didSet {
            currentDraw?.shapeLayer.strokeColor = preferColor.withAlphaComponent(preferAlpha).cgColor
        }
    }
    var preferAlpha: CGFloat = 0.8 {
        didSet {
            currentDraw?.shapeLayer.strokeColor = preferColor.withAlphaComponent(preferAlpha).cgColor
        }
    }
    var preferShape: Shape = .曲線
    
    func clear() {
        drawers = []
        layer.sublayers = []
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self), touches.count == 1 else {
            return
        }
        
        switch preferShape {
        case .直線:
            currentDraw = DirectDrawer(origin: touch, color: preferColor.withAlphaComponent(preferAlpha), width: preferWidth)
        case .曲線:
            currentDraw = CurveDrawer(origin: touch, color: preferColor.withAlphaComponent(preferAlpha), width: preferWidth)
        case .虛線直:
            currentDraw = DirectDashedDrawer(origin: touch, color: preferColor.withAlphaComponent(preferAlpha), width: preferWidth)
        case .虛線曲:
            currentDraw = CurveDashedDrawer(origin: touch, color: preferColor.withAlphaComponent(preferAlpha), width: preferWidth)
        case .橡皮擦:
            let drawObject = Eraser(origin: touch)
            currentDraw = drawObject
            garbageSet.insert(drawObject)
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self), touches.count == 1,
            let drawingObj = currentDraw else {
            return
        }
        
        if drawingObj.shapeLayer.superlayer == nil && drawingObj.currentDistance > 10{
            layer.addSublayer(drawingObj.shapeLayer)
        }

        drawingObj.move(point: touch)
        
        guard garbageCollectIsOn else {
            return
        }
        
        let bufferRect = CGRect(origin: touch, size: .zero).insetBy(dx: CGFloat(-Accuracy * 5), dy: CGFloat(-Accuracy * 5))
        drawers.forEach { (drawer) in
            if drawer.currentPath.contains(touch) {
                for pointWraper in drawer.pointBox {
                    let isContains = bufferRect.contains(pointWraper.point)
                    print("\(bufferRect) contain \(pointWraper.point) : \(isContains)")
                    if isContains {
                        garbageSet.insert(drawer)
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let drawObject = currentDraw else {
            return
        }
        
        if garbageCollectIsOn {
            disposeGarbage()
        } else {
            self.drawers.append(drawObject)
        }
        self.currentDraw = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentDraw = nil
        
        if garbageCollectIsOn {
            disposeGarbage()
        }
    }
    
    fileprivate func disposeGarbage() {
        for drawer in garbageSet {
            drawer.shapeLayer.removeFromSuperlayer()
        }
        drawers.removeAll { $0.shapeLayer.superlayer == nil }
        garbageSet.removeAll()
    }
}

fileprivate protocol Drawable {
    var shapeLayer: CAShapeLayer { get }
    var currentPath: UIBezierPath { get }
    var origin: CGPoint { get }
    var current: CGPoint { get }
    var currentDistance: CGFloat { get }
    func move(point: CGPoint)
}

extension Drawable {
    var current: CGPoint {
        return currentPath.currentPoint
    }
    
    var currentDistance: CGFloat {
        return origin.distance(to: currentPath.currentPoint)
    }
}

fileprivate class AbstractDrawer: NSObject, Drawable {
    let shapeLayer: CAShapeLayer = CAShapeLayer()
    
    let currentPath: UIBezierPath
    
    var pointBox: Set<LowAccuracyPoint> = []
    
    var origin: CGPoint
    
    init(point: CGPoint) {
        currentPath = UIBezierPath()
        origin = point
        pointBox.insert(LowAccuracyPoint(point: point))
    }
    
    func move(point: CGPoint) {
        DispatchQueue.global().async {
            if (Int(point.x) % Accuracy == 0) && (Int(point.y) % Accuracy == 0) {
                self.pointBox.insert(LowAccuracyPoint(point: point))
            }
        }
    }
}

fileprivate class CurveDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        
        shapeLayer.path = currentPath.cgPath
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.cyan.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
    }
    
    override func move(point: CGPoint) {
        super.move(point: point)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class CurveDashedDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        
        shapeLayer.path = currentPath.cgPath
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [width * 1.5, width * 1.5] as [NSNumber]
    }
    
    override func move(point: CGPoint) {
        super.move(point: point)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class DirectDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        shapeLayer.path = currentPath.cgPath
        
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        //        layer.fillRule = .evenOdd
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
    }
    
    override func move(point: CGPoint) {
        super.move(point: point)
        currentPath.removeAllPoints()
        currentPath.move(to: origin)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class DirectDashedDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        
        shapeLayer.path = currentPath.cgPath
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        //        layer.fillRule = .evenOdd
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [width * 1.5, width * 1.5] as [NSNumber]
    }
    
    override func move(point: CGPoint) {
        super.move(point: point)
        currentPath.removeAllPoints()
        currentPath.move(to: origin)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class Eraser: AbstractDrawer {
    init(origin point: CGPoint) {
        super.init(point: point)
        
        shapeLayer.path = currentPath.cgPath
        currentPath.move(to: point)
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        //        layer.fillRule = .evenOdd
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [5, 5]
    }
    
    override func move(point: CGPoint) {
        super.move(point: point)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let xDistance = self.x - point.x
        let yDistance = self.y - point.y
        return ((xDistance * xDistance) + (yDistance * yDistance)).squareRoot()
    }
}

struct LowAccuracyPoint: Hashable {
    let point: CGPoint
    
    static func == (lhs: LowAccuracyPoint, rhs: LowAccuracyPoint) -> Bool {
        return lhs.point.x == rhs.point.x && lhs.point.y == rhs.point.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
}
