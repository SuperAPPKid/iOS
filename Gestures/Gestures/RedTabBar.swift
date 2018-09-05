//
//  RedTabBar.swift
//  Gestures
//
//  Created by Hank_Zhong on 2018/8/22.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class RedTabBar: UITabBar {
    let centerBtn = UIButton(type: .system)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(cgColor: UIColor.red.cgColor)
        tintColor = .white
        unselectedItemTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        isTranslucent = false
        itemPositioning = .centered
        centerBtn.setTitle("HI", for: .normal)
        centerBtn.setTitleColor(UIColor(cgColor: UIColor.red.cgColor), for: .normal)
        centerBtn.backgroundColor = .white
        centerBtn.addTarget(self, action: #selector(clickHI(sender:)), for: .touchUpInside)
        
        addSubview(centerBtn)
    }
    
    //FIXME:- 刪掉draw
    override func draw(_ rect: CGRect) {
        centerBtn.layer.masksToBounds = true
        centerBtn.layer.cornerRadius = 40
        centerBtn.layer.borderColor = UIColor.red.cgColor
        centerBtn.tintAdjustmentMode = .dimmed
        tintAdjustmentMode = .dimmed
        centerBtn.layer.borderWidth = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerBtn.frame.size = .init(width: 80, height: 80)
        centerBtn.center = .init(x: frame.width/2, y: 10)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 75
        return size
    }
    
    @objc func clickHI(sender: UIButton) {
        print("HI")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertPoint = convert(point, to: centerBtn)
        let path = UIBezierPath(roundedRect: centerBtn.bounds.insetBy(dx: 8, dy: 8), cornerRadius: 40)
        if path.contains(convertPoint) {
            return centerBtn
        }
        let view = super.hitTest(point, with: event)
        if view is UIButton {
            return self
        } else {
            return view
        }
    }
}
