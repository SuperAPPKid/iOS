//
//  MyHeader.swift
//  SearchController
//
//  Created by zhong on 2018/4/7.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class MyHeader: UITableViewHeaderFooterView {
//    @IBOutlet var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var accessory: UILabel!
    
    //nib方法
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var tapHandler:(()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        //file's owner 方法
//        view = Bundle.main.loadNibNamed("MyHeader", owner: self, options: nil)?.first as! UIView
//        view.frame = bounds
//        self.addSubview(view)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        tapHandler()
    }
    
    func setCollapsed(collapsed: Bool) {
        accessory?.rotate(collapsed ?  .pi / 2 : 0.0)
    }
    
}
extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: nil)
    }
}
