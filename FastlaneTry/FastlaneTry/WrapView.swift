//
//  wrapperView.swift
//  FastlaneTry
//
//  Created by Hank_Zhong on 2018/8/30.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class WrapView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.colors = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor, #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor]
        gradientLayer?.locations = [0, 0, 0.4]
        gradientLayer?.startPoint = .init(x: 0, y: 0.45)
        gradientLayer?.endPoint = .init(x: 1, y: 0.55)

        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0, 0, 0.4]
        gradientAnimation.toValue = [0.6, 1, 1]
        gradientAnimation.duration = 10
        
        gradientAnimation.repeatCount = .infinity
        gradientAnimation.autoreverses = true
        gradientLayer?.add(gradientAnimation, forKey: nil)
        print("\(#function)")
    }
    
//    複寫draw則gradientLayer失敗
//    override func draw(_ rect: CGRect) {
//    }
}
