//
//  BasicDynamicViewController.swift
//  UIDynamicMaster
//
//  Created by Hank_Zhong on 2019/2/21.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

enum Scenario {
    case touch_then_drop(gravity: LazyBehavior<UIGravityBehavior>)
    case touch_then_drop_and_collision(gravity: LazyBehavior<UIGravityBehavior>, collision: LazyBehavior<UICollisionBehavior>)
    case touch_then_drop_and_collision_withBarrier(gravity: LazyBehavior<UIGravityBehavior>, collision: LazyBehavior<UICollisionBehavior>, barrierSize: CGSize)
}

class GravityDynamicViewController: MyViewController {
    
    private enum BehaviorKey: Hashable {
        case attachment
        case collision
        case field
        case gravity
        case push
        case snap
        case item(identifier: Int)
    }
    
    private var preferScenario: Scenario
    private var animator: UIDynamicAnimator?
    private var beforeToolbarItems:[UIBarButtonItem] = []
    private var afterToolbarItems:[UIBarButtonItem] = []
    private var usingBehaviors:[BehaviorKey: UIDynamicBehavior] = [:]
    
    init(preferScenario: Scenario) {
        self.preferScenario = preferScenario
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portraitUpsideDown, .portrait]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animator = UIDynamicAnimator(referenceView: view)
        self.animator = animator
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTap(gesture:)))
        view.addGestureRecognizer(tap)
        
        initilizeBehaviors()
        
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetButtonClick(sender:)))
        let pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButtonClick(sender:)))
        let playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonClick(sender:)))
        let fixWidth = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixWidth.width = 15
        beforeToolbarItems = [resetButton, fixWidth, playButton]
        afterToolbarItems = [resetButton, fixWidth, pauseButton]
        
        executeOnceWhenAppear = { [unowned self] in
            self.setToolbarItems(self.beforeToolbarItems, animated: true)
            let demoView = DemoView(frame: .init(x: 135, y: 20, width: 50, height: 50))
            self.view.addSubview(demoView)
            
            switch self.preferScenario {
            case .touch_then_drop(_):
                (self.usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
                
            case .touch_then_drop_and_collision(_, _):
                (self.usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
                (self.usingBehaviors[.collision] as? UICollisionBehavior)?.addItem(demoView)
                
            case .touch_then_drop_and_collision_withBarrier(_, _, _):
                (self.usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
                (self.usingBehaviors[.collision] as? UICollisionBehavior)?.addItem(demoView)
                var updateCount = 0
                (self.usingBehaviors[.collision] as? UICollisionBehavior)?.action =  {
                    if (updateCount % 3 == 0) {
                        let outline = UIView(frame: demoView.bounds);
                        outline.transform = demoView.transform
                        outline.center = demoView.center
                        outline.alpha = 0.5
                        outline.backgroundColor = .clear
                        outline.layer.borderColor = demoView.layer.presentation()?.backgroundColor
                        outline.layer.borderWidth = 1.0;
                        self.view.addSubview(outline);
                    }
                    updateCount += 1
                }
            }
        }
    }
    
    private func initilizeBehaviors() {
        switch preferScenario {
        case .touch_then_drop(let gravity):
            usingBehaviors[.gravity] = gravity.behavior
            
        case .touch_then_drop_and_collision(let gravity, let collision):
            usingBehaviors[.gravity] = gravity.behavior
            let collisionBehavior = collision.behavior
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            collisionBehavior.collisionDelegate = self
            usingBehaviors[.collision] = collisionBehavior
            
        case .touch_then_drop_and_collision_withBarrier(let gravity, let collision, let barrierSize):
            usingBehaviors[.gravity] = gravity.behavior
            let barrier = UIView()
            barrier.frame.origin = CGPoint(x: 0, y: 200)
            barrier.frame.size = barrierSize
            barrier.backgroundColor = .black
            view.addSubview(barrier)
            let collisionBehavior = collision.behavior
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            collisionBehavior.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame.insetBy(dx: 0, dy: 1)))
            collisionBehavior.collisionDelegate = self
            usingBehaviors[.collision] = collisionBehavior
        }
    }
    
    @objc func resetButtonClick(sender: UIBarButtonItem) {
        ///here remove subviews and behavior
        setToolbarItems(beforeToolbarItems, animated: false)
        view.subviews.forEach{ $0.removeFromSuperview() }
        animator?.removeAllBehaviors()
        initilizeBehaviors()
        executeOnceWhenAppear?()
    }
    
    @objc func pauseButtonClick(sender: UIBarButtonItem) {
        ///here remove behavior
        setToolbarItems(beforeToolbarItems, animated: false)
        animator?.removeAllBehaviors()
    }
    
    @objc func playButtonClick(sender: UIBarButtonItem) {
        ///here add
        setToolbarItems(afterToolbarItems, animated: false)
        for behavior in usingBehaviors.values {
            animator?.addBehavior(behavior)
        }
    }
    
    private var executeOnceWhenAppear: (() -> Void)?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        executeOnceWhenAppear?()
    }
    
    @objc func singleTap(gesture: UITapGestureRecognizer) {
        if case UIGestureRecognizer.State.ended = gesture.state {
            
            let location = gesture.location(in: view)
            let demoView = DemoView()
            demoView.bounds.size = CGSize(width: [25, 50].randomElement() ?? 50, height: [25, 50].randomElement() ?? 50)
            demoView.transform = .init(rotationAngle: CGFloat.random(in: 0..<CGFloat.pi/2))
            demoView.center = location
            view.addSubview(demoView)
            
            switch preferScenario {
            case .touch_then_drop(_):
                (usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
            case .touch_then_drop_and_collision(_, _), .touch_then_drop_and_collision_withBarrier(_, _, _):
                (usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
                (usingBehaviors[.collision] as? UICollisionBehavior)?.addItem(demoView)
            }
        }
    }

    deinit {
        print("🐊🐊🐊🐊")
    }
}

extension MyViewController: UICollisionBehaviorDelegate {
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        guard let demoViewInitiative = item1 as? DemoView, let oldColor1 = demoViewInitiative.backgroundColor else { return }
        guard let demoViewPassive = item2 as? DemoView, let oldColor2 = demoViewPassive.backgroundColor else { return }
        demoViewInitiative.backgroundColor = oldColor1.withAlphaComponent(0.5)
        demoViewPassive.backgroundColor = oldColor2.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.2) {
            demoViewInitiative.backgroundColor = oldColor1
            demoViewPassive.backgroundColor = oldColor2
        }
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        guard let demoView = item as? DemoView, let oldColor = demoView.backgroundColor else { return }
        demoView.backgroundColor = oldColor.reversed
        UIView.animate(withDuration: 0.2) {
            demoView.backgroundColor = oldColor
        }
    }
}

class DemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.random(alpha: 0.95 )
        layer.allowsEdgeAntialiasing = true
        print("🥚🥚🥚🥚")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("🐔🐔🐔🐔")
    }
}

struct LazyBehavior<Behavior: UIDynamicBehavior> {
    var behavior: Behavior {
        return insideClz()
    }
    private var insideClz: () -> (Behavior)
    
    init(clz: @escaping () -> (Behavior)) {
        self.insideClz = clz
    }
}

protocol HasLazyBehavior {
    associatedtype Behavior: UIDynamicBehavior
    static func lazy(_ clz: @escaping () -> (Behavior)) -> LazyBehavior<Behavior>
}

extension HasLazyBehavior where Self: UIDynamicBehavior {
    static func lazy(_ clz: @escaping () -> (Self)) -> LazyBehavior<Self> {
        return LazyBehavior(clz: clz)
    }
}

extension UIDynamicBehavior: HasLazyBehavior {}

extension Collection {
    subscript(safe position: Index) -> Element? {
        if position >= endIndex {
            return nil
        }
        return self[position]
    }
}

extension UIColor {
    var reversed: UIColor {
        let components = self.cgColor.components
        return UIColor(displayP3Red: 1 - (components?[safe: 0] ?? 0),
                       green: 1 - (components?[safe: 1] ?? 0),
                       blue: 1 - (components?[safe: 2] ?? 0),
                       alpha: components?[safe: 3] ?? 1)
    }
    
    static func random(alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: alpha)
    }
}

