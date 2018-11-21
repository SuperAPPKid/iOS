//
//  ViewController.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let slider: UISlider = {
        var slider = UISlider()
        slider.thumbTintColor = .red
        slider.tintColor = .black
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let consoleVC = ConsoleViewController(parent: self, blurType: .dark)
        slider.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        let sw = UISwitch()
        sw.thumbTintColor = .red
        sw.onTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.6043985445)
        sw.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        let seg = UISegmentedControl(items: ["Hello", "World"])
        seg.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18) ], for: .normal)
        seg.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: seg, preferColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: slider, preferColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: sw, preferColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "GOOD", control: UISlider(), preferColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: UISwitch(), preferColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "GOOD", control: UISlider(), preferColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: UISwitch(), preferColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "GOOD", control: UISlider(), preferColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: UISwitch(), preferColor: #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "GOOD", control: UISlider(), preferColor: #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: UISwitch(), preferColor: #colorLiteral(red: 0.6642242074, green: 0.4689105308, blue: 0.6642315388, alpha: 1)))
        
        view.addSubview(consoleVC.view)
    }
    
    @objc func test(sender: Any) {
        print(sender)
    }
    
    deinit {
        print("disappear")
    }
}

