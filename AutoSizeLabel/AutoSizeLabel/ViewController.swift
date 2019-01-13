//
//  ViewController.swift
//  AutoSizeLabel
//
//  Created by zhong on 2018/7/10.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ////autolayout法
        let autolayoutLabel = UILabel()
        autolayoutLabel.text = "AutolayoutLabel\nAutolayoutLabel\nAutolayoutLabel\nAutolayoutLabel\nAutolayoutLabel"
        autolayoutLabel.numberOfLines = 0
        autolayoutLabel.font = UIFont.systemFont(ofSize: 24)
        autolayoutLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        view.addSubview(autolayoutLabel)
        autolayoutLabel.translatesAutoresizingMaskIntoConstraints = false
        [autolayoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         autolayoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
         autolayoutLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
         autolayoutLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)].forEach { $0.isActive = true }
        
        ////boundingRect法
        let boundingRectLabel = UILabel()
        boundingRectLabel.text = "BoundingRect\nBoundingRect\nBoundingRect\nBoundingRect\nBoundingRect\nBoundingRect\nBoundingRect"
        boundingRectLabel.numberOfLines = 0
        boundingRectLabel.font = UIFont.systemFont(ofSize: 24)
        boundingRectLabel.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        let boundingRect1:CGRect = (boundingRectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect2:CGRect = (boundingRectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect3:CGRect = (boundingRectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect4:CGRect = (boundingRectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect5:CGRect = (boundingRectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesDeviceMetrics], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect6:CGRect = (boundingRectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.truncatesLastVisibleLine], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        print("NO:\(boundingRect1)")
        print("usesLineFragmentOrigin:\(boundingRect2)")
        print("usesFontLeading:\(boundingRect3)")
        print("usesLineFragmentOrigin+usesFontLeading:\(boundingRect4)")
        print("usesDeviceMetrics:\(boundingRect5)")
        print("truncatesLastVisibleLine:\(boundingRect6)")
        
        boundingRectLabel.frame = CGRect(x: 200, y: 200, width: boundingRect2.width, height: boundingRect2.height)
        view.addSubview(boundingRectLabel)
        
        ///sizeWithAttributes法 效果同boundingRect的usesLineFragmentOrigin option
        let sizeWithAttrLabel = UILabel()
        sizeWithAttrLabel.numberOfLines = 0
        sizeWithAttrLabel.text = "SizeWithAttributes\nSizeWithAttributes\nSizeWithAttributes\nSizeWithAttributes\nSizeWithAttributes"
        sizeWithAttrLabel.numberOfLines = 0
        sizeWithAttrLabel.font = UIFont.systemFont(ofSize: 24)
        sizeWithAttrLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let attrLabelSize = (sizeWithAttrLabel.text! as NSString).size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)])
        sizeWithAttrLabel.frame = CGRect(origin: .init(x: 25, y: 500), size: attrLabelSize)
        print("sizeWithAttrLabel:\(sizeWithAttrLabel.frame)")
        view.addSubview(sizeWithAttrLabel)
        
        ////sizetofit法
        let sizeLabel = UILabel()
        sizeLabel.font = UIFont.systemFont(ofSize: 24)
        sizeLabel.numberOfLines = 0
        sizeLabel.text = "SizeToFitLabel\nSizeToFitLabel\nSizeToFitLabel\nSizeToFitLabel\nSizeToFitLabel"
        sizeLabel.lineBreakMode = .byWordWrapping
        sizeLabel.sizeToFit()
        let sizeToFitLabel = UILabel(frame: CGRect(x: 30, y: 320, width: sizeLabel.frame.width, height: sizeLabel.frame.height))
        sizeToFitLabel.text = "SizeToFitLabel\nSizeToFitLabel\nSizeToFitLabel\nSizeToFitLabel\nSizeToFitLabel"
        sizeToFitLabel.numberOfLines = 0
        sizeToFitLabel.font = UIFont.systemFont(ofSize: 24)
        sizeToFitLabel.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        view.addSubview(sizeToFitLabel)
        
        ///重寫label方法
        let leftTopAlignLabel = LeftTopAlignLabel(frame: .init(x: 225, y: 450, width: 125, height: 200))
        leftTopAlignLabel.text = "LeftTopAlignLabelLeftTopAlignLabel"
        leftTopAlignLabel.numberOfLines = 0
        leftTopAlignLabel.font = UIFont.systemFont(ofSize: 24)
        leftTopAlignLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        view.addSubview(leftTopAlignLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

class LeftTopAlignLabel: UILabel {
    override func drawText(in rect: CGRect) {
        print(#function)
        let labelSize = (self.text! as NSString).size(withAttributes: [NSAttributedStringKey.font:self.font])
        let labelRect = (self.text! as NSString).boundingRect(with: bounds.size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:self.font], context: nil)
        super.drawText(in: labelRect)
//        super.drawText(in: .init(origin: .zero, size: labelSize))
//        super.drawText(in: rect)
    }
}

