//
//  BottomView.swift
//  drawer
//
//  Created by Hank_Zhong on 2018/12/3.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit
class BottomView: UIImageView {
    convenience init() {
        self.init(frame: .zero)
        contentMode = .scaleAspectFit
        image = #imageLiteral(resourceName: "Takin")
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
