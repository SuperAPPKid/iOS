//
//  RadiusButton.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

@IBDesignable
class RadiusButton: UIButton {
    @IBInspectable var radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}
