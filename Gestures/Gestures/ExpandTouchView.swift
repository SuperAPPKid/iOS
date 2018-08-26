//
//  SubTouchView.swift
//  Gestures
//
//  Created by Hank_Zhong on 2018/8/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ExpandTouchView: TouchView {
    let yellowView: TouchView = {
        let view = TouchView(name: "yellow", frame: .init(x: 200, y: 250, width: 50, height: 50))
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return view
    }()
    
    override init(name: String, frame: CGRect) {
        super.init(name: name, frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(oneSingleTap(sender:)))
//        tap.delegate = self
        tap.cancelsTouchesInView = false
//        tap.delaysTouchesBegan = true
//        tap.delaysTouchesEnded = false
        yellowView.addGestureRecognizer(tap)
        addSubview(yellowView)
    }
    
    @objc func oneSingleTap(sender: UITapGestureRecognizer) {
        let view = sender.view as! TouchView
        print("\(view.name!) oneSingleTap")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //擴大
//        let expandRect = bounds.insetBy(dx: -50, dy: -50)
//        if expandRect.contains(point) {
//            for subview in subviews.reversed() {
//                let newpoint = subview.convert(point, from: self)
//                if let hitTestView = subview.hitTest(newpoint, with: event) {
//                    return hitTestView
//                }
//            }
//            return self
//        }
        
        //使點擊子view正確
        let coverPoint = convert(point, to: yellowView)
        if yellowView.point(inside: coverPoint, with: event) {
            return yellowView
        }
        
        return super.hitTest(point, with: event)
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //擴大
        if bounds.insetBy(dx: -20, dy: -20).contains(point) {
            return true
        }
        //會return yellowview
//        coverPoint = convert(point, to: yellowView)
//        if yellowView.point(inside: coverPoint, with: event) {
//            return true
//        }
        return super.point(inside: point, with: event)
    }
}

extension ExpandTouchView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
