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
    
}

class BasicDynamicViewController: MyViewController {
    
    private enum BehaviorKey: String {
        case attachment
        case collision
        case field
        case gravity
        case push
        case snap
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animator = UIDynamicAnimator(referenceView: view)
        
        switch preferScenario {
        case .touch_then_drop(let gravity):
            let tap = UITapGestureRecognizer(target: self, action: #selector(singleTap(gesture:)))
            view.addGestureRecognizer(tap)
            usingBehaviors[.gravity] = gravity.behavior
        }
        
        self.animator = animator
        
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetButtonClick(sender:)))
        let pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButtonClick(sender:)))
        let playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonClick(sender:)))
        let fixWidth = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixWidth.width = 15
        beforeToolbarItems = [resetButton, fixWidth, playButton]
        afterToolbarItems = [resetButton, fixWidth, pauseButton]
        
        executeWhenAppear = { [unowned self] in
            self.setToolbarItems(self.beforeToolbarItems, animated: true)
            
            switch self.preferScenario {
            case .touch_then_drop(_):
                let demoView = DemoView(frame: .init(x: 100, y: 50, width: 50, height: 50))
                self.view.addSubview(demoView)
                (self.usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
            }
        }
    }
    
    @objc func resetButtonClick(sender: UIBarButtonItem) {
        ///here remove subviews and behavior
        setToolbarItems(beforeToolbarItems, animated: false)
        view.subviews.forEach{ $0.removeFromSuperview() }
        animator?.removeAllBehaviors()
        switch preferScenario {
        case .touch_then_drop(let gravity):
            usingBehaviors[.gravity] = gravity.behavior
        }
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
    
    private var executeWhenAppear: (() -> Void)?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        executeWhenAppear?()
        executeWhenAppear = nil
    }
    
    @objc func singleTap(gesture: UITapGestureRecognizer) {
        if case UIGestureRecognizer.State.ended = gesture.state {
            if case Scenario.touch_then_drop(_) = preferScenario {
                let location = gesture.location(in: view)
                let demoView = DemoView()
                demoView.bounds.size = CGSize(width: [50, 100].randomElement() ?? 50, height: [50, 100].randomElement() ?? 50)
                demoView.center = location
                view.addSubview(demoView)
                (usingBehaviors[.gravity] as? UIGravityBehavior)?.addItem(demoView)
            }
        }
    }

    deinit {
        print("🐊🐊🐊🐊")
    }
}

class DemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.random(alpha: 0.8)
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

extension UIColor {
    static func random(alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: alpha)
    }
}

