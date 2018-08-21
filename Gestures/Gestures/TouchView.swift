//
//  TouchView.swift
//  Gestures
//
//  Created by Hank_Zhong on 2018/8/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TouchView: UIView {
    var name: String?
    
    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        self.name = name
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(name!) touchesBegan")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(name!) touchesEnded")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(name!) touchesMoved")
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(name!) touchesCancelled")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return super.point(inside: point, with: event)
    }
}
