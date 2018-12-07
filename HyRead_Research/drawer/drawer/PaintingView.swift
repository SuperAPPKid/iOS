
//  PaintingView.swift
//  drawer
//
//  Created by Hank_Zhong on 2018/12/3.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

fileprivate typealias callback = ((CAShapeLayer)->Void)

enum Shape {
    case 直線, 曲線, 虛線直, 虛線曲, 橡皮擦
}

enum UndoOrRedo {
    case undo, redo
}

protocol PaintingViewDelegate: AnyObject {
    func drawerArrayIsEmpty(_ paintingView: PaintingView, drawerType: UndoOrRedo, isEmpty: Bool)
}

class PaintingView: UIView {
    var debug: Bool = true
    
    private var drawers: [AbstractDrawer] = [] {
        didSet {
            delegate?.drawerArrayIsEmpty(self, drawerType: .undo, isEmpty: drawers.count == 0)
        }
    }
    
    private var tempdrawers: [AbstractDrawer] = [] {
        didSet {
            delegate?.drawerArrayIsEmpty(self, drawerType: .redo, isEmpty: tempdrawers.count == 0)
        }
    }
    
    private var currentDraw: AbstractDrawer?
    private var garbageSet: Set<AbstractDrawer> = []
    private var garbagePoints: [CAShapeLayer] = []
    
    private var garbageCollectIsOn: Bool {
        return garbageSet.count != 0
    }
    
    weak var delegate: PaintingViewDelegate?
    
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
        
        currentDraw?.shapeLayer.fillRule = preferShape == .虛線曲 ? .evenOdd : .nonZero
        
        if debug {
            currentDraw?.shapeLayer.fillColor = UIColor.cyan.withAlphaComponent(0.2).cgColor
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self), touches.count == 1,
            let drawingObj = currentDraw else {
                return
        }
        
        if drawingObj.shapeLayer.superlayer == nil && drawingObj.currentDistance > 5 {
            layer.addSublayer(drawingObj.shapeLayer)
        }
        
        drawingObj.move(point: touch)
        
        guard garbageCollectIsOn else {
            return
        }
        
        drawers.forEach { (drawer) in
            guard (!drawer.deleteMark || debug),
                let intersections:[DKUIBezierPathIntersectionPoint] = drawer.currentPath.findIntersections(withClosedPath: currentDraw?.currentPath, andBeginsInside: nil) as? [DKUIBezierPathIntersectionPoint] else {
                return
            }
            
            for intersect in intersections {
                drawer.deleteMark = true
                garbageSet.insert(drawer)
                if debug {
                    let point = CAShapeLayer()
                    point.cornerRadius = 2.5
                    point.masksToBounds = true
                    point.backgroundColor = UIColor.red.cgColor
                    point.frame.size = CGSize(width: 5, height: 5)
                    point.position = intersect.location1()
                    garbagePoints.append(point)
                    layer.addSublayer(point)
                } else {
                    break
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
            if drawObject.shapeLayer.superlayer != nil {
                drawers.append(drawObject)
                tempdrawers.removeAll()
            }
        }
        self.currentDraw = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentDraw?.shapeLayer.removeFromSuperlayer()
        currentDraw = nil
        if garbageCollectIsOn {
            disposeGarbage()
        }
    }
    
    fileprivate func disposeGarbage() {
        for drawer in garbageSet {
            drawer.shapeLayer.removeFromSuperlayer()
        }
        for point in garbagePoints {
            point.removeFromSuperlayer()
        }
        garbagePoints.removeAll()
        drawers.removeAll { $0.shapeLayer.superlayer == nil }
        garbageSet.removeAll()
    }
    
    func back() {
        guard let latestUndoable = drawers.popLast() else {
            return
        }
        tempdrawers.append(latestUndoable)
        latestUndoable.shapeLayer.removeFromSuperlayer()
    }
    
    func next() {
        guard let latestRedoable = tempdrawers.popLast() else {
            return
        }
        drawers.append(latestRedoable)
        layer.addSublayer(latestRedoable.shapeLayer)
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
    
    var origin: CGPoint
    
    var deleteMark: Bool = false
    
    init(point: CGPoint) {
        currentPath = UIBezierPath()
        origin = point
    }
    
    func move(point: CGPoint) {
        fatalError("Abstract Method. Don't use.")
    }
}

fileprivate class CurveDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        
        currentPath.move(to: point)
        currentPath.lineWidth = width
        currentPath.lineCapStyle = .round
        currentPath.lineJoinStyle = .round
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        shapeLayer.path = currentPath.cgPath
    }
    
    override func move(point: CGPoint) {
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class CurveDashedDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        
        shapeLayer.path = currentPath.cgPath
        currentPath.lineWidth = width
        currentPath.lineCapStyle = .round
        currentPath.lineJoinStyle = .round
        
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [width * 1.5, width * 1.5] as [NSNumber]
    }
    
    override func move(point: CGPoint) {
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class DirectDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        currentPath.lineWidth = width
        currentPath.lineCapStyle = .round
        currentPath.lineJoinStyle = .round
        
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        shapeLayer.path = currentPath.cgPath
    }
    
    override func move(point: CGPoint) {
        
        currentPath.removeAllPoints()
        currentPath.move(to: origin)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class DirectDashedDrawer: AbstractDrawer {
    init(origin point: CGPoint, color: UIColor , width: CGFloat) {
        super.init(point: point)
        
        currentPath.lineWidth = width
        currentPath.lineCapStyle = .round
        currentPath.lineJoinStyle = .round
        
        currentPath.move(to: point)
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [width * 1.5, width * 1.5] as [NSNumber]
        
        shapeLayer.path = currentPath.cgPath
    }
    
    override func move(point: CGPoint) {
        
        currentPath.removeAllPoints()
        currentPath.move(to: origin)
        currentPath.addLine(to: point)
        shapeLayer.path = currentPath.cgPath
    }
}

fileprivate class Eraser: AbstractDrawer {
    init(origin point: CGPoint) {
        super.init(point: point)
        
        currentPath.move(to: point)
        currentPath.lineWidth = 3
        currentPath.lineCapStyle = .round
        currentPath.lineJoinStyle = .round
        
        shapeLayer.strokeColor = UIColor.lightText.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [5, 7]
        
        shapeLayer.path = currentPath.cgPath
    }
    
    override func move(point: CGPoint) {
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

