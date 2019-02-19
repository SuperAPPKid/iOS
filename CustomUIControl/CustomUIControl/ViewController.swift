//
//  ViewController.swift
//  CustomUIControl
//
//  Created by Hank_Zhong on 2019/2/19.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let rangeSlider1: RangeSlider = RangeSlider()
    let rangeSlider2: RangeSlider = RangeSlider()
    let rangeSlider3: RangeSlider = RangeSlider()
    let resultLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont(name: "Thonburi-Bold", size: 18)
        
        view.addSubview(rangeSlider1)
        view.addSubview(rangeSlider2)
        view.addSubview(rangeSlider3)
        view.addSubview(resultLabel)
        
        rangeSlider1.addTarget(self, action: #selector(rangeSliderValueChenged(sender:)), for: .valueChanged)
        rangeSlider2.addTarget(self, action: #selector(rangeSliderValueChenged(sender:)), for: .valueChanged)
        rangeSlider3.addTarget(self, action: #selector(rangeSliderValueChenged(sender:)), for: .valueChanged)
        
        rangeSlider1.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider2.translatesAutoresizingMaskIntoConstraints = false
        rangeSlider3.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [rangeSlider1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           rangeSlider1.heightAnchor.constraint(equalToConstant: 50),
                           rangeSlider1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                           rangeSlider1.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                           rangeSlider2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           rangeSlider2.heightAnchor.constraint(equalToConstant: 50),
                           rangeSlider2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                           rangeSlider2.topAnchor.constraint(equalTo: rangeSlider1.topAnchor, constant: 50),
                           rangeSlider3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           rangeSlider3.heightAnchor.constraint(equalToConstant: 50),
                           rangeSlider3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                           rangeSlider3.topAnchor.constraint(equalTo: rangeSlider2.topAnchor, constant: 50),
                           resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           resultLabel.heightAnchor.constraint(equalToConstant: 50),
                           resultLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                           resultLabel.topAnchor.constraint(equalTo: rangeSlider3.topAnchor, constant: 50)]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func rangeSliderValueChenged(sender: RangeSlider) {
        resultLabel.text = "\(String(format: "%.2f", sender.lowerValue)) ~ \(String(format: "%.2f", sender.upperValue))"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rangeSlider1.trackHighlightTintColor = UIColor.random(alpha: 1)
        self.rangeSlider1.curvaceousness = [0.0, 0.5, 1.0].randomElement() ?? 0.0
        self.rangeSlider2.trackHighlightTintColor = UIColor.random(alpha: 1)
        self.rangeSlider2.curvaceousness = [0.0, 0.5, 1.0].randomElement() ?? 0.0
        self.rangeSlider3.trackHighlightTintColor = UIColor.random(alpha: 1)
        self.rangeSlider3.curvaceousness = [0.0, 0.5, 1.0].randomElement() ?? 0.0
    }
}

extension UIColor {
    static func random(alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0.8...1), green: CGFloat.random(in: 0.8...1), blue: CGFloat.random(in: 0.8...1), alpha: alpha)
    }
}
