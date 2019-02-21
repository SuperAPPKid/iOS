//
//  BasicDynamicViewController.swift
//  UIDynamicMaster
//
//  Created by Hank_Zhong on 2019/2/21.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

struct BasicDynamicBehavior: OptionSet {
    let rawValue: Int
    
    static let attachment: BasicDynamicBehavior            = BasicDynamicBehavior(rawValue: 1 << 0)
    fileprivate static let collision: BasicDynamicBehavior = BasicDynamicBehavior(rawValue: 1 << 1)
    static let field: BasicDynamicBehavior                 = BasicDynamicBehavior(rawValue: 1 << 2)
    static let gravity: BasicDynamicBehavior               = BasicDynamicBehavior(rawValue: 1 << 3)
    static let push: BasicDynamicBehavior                  = BasicDynamicBehavior(rawValue: 1 << 4)
    static let snap: BasicDynamicBehavior                  = BasicDynamicBehavior(rawValue: 1 << 5)
    
    static let gravityCollision: BasicDynamicBehavior  = [.gravity]
}

class BasicDynamicViewController: MyViewController {
    private enum Scenario {
        case touch_then_drop
        case none
    }
    
    private var preferScenario: Scenario
    private var isMotionMode: Bool
    private var animator: UIDynamicAnimator?
    private var gravity: UIGravityBehavior?
    
    init(preferBehavior: BasicDynamicBehavior, needMotionMode: Bool) {
        
        if preferBehavior.isEmpty {
            preferScenario = .none
        } else if preferBehavior.contains([.gravity, .attachment, .collision]) {
            preferScenario = .none
        } else if preferBehavior.contains([.gravity, .attachment]) {
            preferScenario = .none
        } else if preferBehavior.contains([.gravity, .collision]) {
            preferScenario = .none
        } else if preferBehavior.contains([.gravity]) {
            preferScenario = .touch_then_drop
        } else {
            preferScenario = .none
        }
        
        isMotionMode = needMotionMode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch preferScenario {
        case .touch_then_drop:
            let demoView = DemoView(frame: .init(x: 50, y: 25, width: 50, height: 50))
            demoView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            view.addSubview(demoView)
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapForTouch_Then_Drop(gesture:)))
            view.addGestureRecognizer(singleTap)
            
            let animator = UIDynamicAnimator(referenceView: view)
            let behavior = UIGravityBehavior(items: [demoView])
            behavior.action = { [unowned self, weak demoView] in
                guard let demoView = demoView else { return }
                if !self.view.bounds.contains(demoView.frame.origin) {
                    demoView.removeFromSuperview()
                    behavior.removeItem(demoView)
                }
            }
            behavior.gravityDirection = .init(dx: 0, dy: 1)
            behavior.magnitude = 0.5
            
            self.gravity = behavior
            animator.addBehavior(behavior)
            self.animator = animator
        case .none:
             let alert = UIAlertController(title: "Invalid Behavior Group", message: nil, preferredStyle: .alert)
             alert.addAction(.init(title: "OK", style: .default, handler: { (_) in
                self.navigationController?.popViewController(animated: true)
             }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func singleTapForTouch_Then_Drop(gesture: UITapGestureRecognizer) {
        if case UIGestureRecognizer.State.ended = gesture.state {
            let demoView = DemoView()
            demoView.bounds.size = CGSize(width: 50, height: 50)
            demoView.center = gesture.location(in: view)
            demoView.backgroundColor = UIColor.random(alpha: 1)
            view.addSubview(demoView)
            
            gravity?.addItem(demoView)
        }
    }

    deinit {
        print("🐊🐊🐊🐊")
    }
}

class DemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("🥚🥚🥚🥚")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("🐔🐔🐔🐔")
    }
}

extension UIColor {
    static func random(alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0.8...1), green: CGFloat.random(in: 0.8...1), blue: CGFloat.random(in: 0.8...1), alpha: alpha)
    }
}
