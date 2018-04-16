//
//  CustomSearchBar.swift
//  SearchController
//
//  Created by zhong on 2018/4/8.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    convenience init(frame: CGRect, font: UIFont, textColor: UIColor) {
        self.init(frame: frame)
        preferredFont = font
        preferredTextColor = textColor
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        
        if let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .black
            
            textFieldInsideSearchBar.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.height - 10.0)
            
            textFieldInsideSearchBar.font = preferredFont
            textFieldInsideSearchBar.textColor = preferredTextColor
            
            textFieldInsideSearchBar.backgroundColor = barTintColor
        }
        
        let searchBarView = subviews[0]
        for subView: UIView in searchBarView.subviews {
            if let cancelButt = subView as? UIButton{
                cancelButt.setTitleColor(UIColor.black, for: .normal)
            }
        }
        
        let startPoint = CGPoint(x: 0, y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = preferredTextColor.cgColor
        shapeLayer.lineWidth = 2.5
        
        layer.addSublayer(shapeLayer)
    }

    
}
