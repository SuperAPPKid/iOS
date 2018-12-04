//
//  BottomView.swift
//  drawer
//
//  Created by Hank_Zhong on 2018/12/3.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class BottomView: UIImageView {
    lazy var paintView: PaintingView = PaintingView().setBackgroundColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 0.1533069349)).shrink([.flexibleWidth, .flexibleHeight]).fill(self).add(to: self)
    
    convenience init() {
        self.init(frame: .zero)
        paintView.isHidden = true
        contentMode = .scaleAspectFit
    }
    
    func togglePaintBoard(_ complete: (Bool)->(Void)) {
        paintView.isHidden.toggle()
        complete(paintView.isHidden)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            if let touchedSubview = subview.hitTest(point, with: event) {
                return touchedSubview
            }
        }
        if self.point(inside: point, with: event) {
            return self
        } else {
            return nil
        }
    }
}
