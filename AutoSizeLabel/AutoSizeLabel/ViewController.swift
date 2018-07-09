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
        let cgrectLabel = UILabel()
        cgrectLabel.text = "CGRectLabel\nCGRectLabel\nCGRectLabel\nCGRectLabel\nCGRectLabel\nCGRectLabel\nCGRectLabel"
        cgrectLabel.numberOfLines = 0
        cgrectLabel.font = UIFont.systemFont(ofSize: 24)
        cgrectLabel.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        let boundingRect1:CGRect = (cgrectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect2:CGRect = (cgrectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect3:CGRect = (cgrectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect4:CGRect = (cgrectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect5:CGRect = (cgrectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesDeviceMetrics], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        let boundingRect6:CGRect = (cgrectLabel.text! as NSString).boundingRect(with: .init(width: 300, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.truncatesLastVisibleLine], attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 24)], context: nil)
        print("NO:\(boundingRect1)")
        print("usesLineFragmentOrigin:\(boundingRect2)")
        print("usesFontLeading:\(boundingRect3)")
        print("usesLineFragmentOrigin+usesFontLeading:\(boundingRect4)")
        print("usesDeviceMetrics:\(boundingRect5)")
        print("truncatesLastVisibleLine:\(boundingRect6)")
        
        cgrectLabel.frame = CGRect(x: 200, y: 200, width: boundingRect2.width, height: boundingRect2.height)
        view.addSubview(cgrectLabel)
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

