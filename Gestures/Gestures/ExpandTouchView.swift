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
        let view = TouchView(name: "yellow", frame: .init(x: 250, y: 300, width: 50, height: 50))
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        addSubview(yellowView)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let coverPoint = convert(point, to: yellowView)
        if yellowView.point(inside: coverPoint, with: event) {
            return self
        }
        return super.hitTest(point, with: event)
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        coverPoint = convert(point, to: yellowView)
//        if yellowView.point(inside: coverPoint, with: event) {
//            return true
//        }
        return super.point(inside: point, with: event)
    }
}
