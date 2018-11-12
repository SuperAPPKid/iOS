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
        let consoleVC = ConsoleViewController()
        addChild(consoleVC)
        let containerView = UIView(frame: CGRect(origin: .init(x: 50, y: 50), size: .init(width: 600, height: 300)))
        containerView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        view.addSubview(containerView)
        slider.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        let sw = UISwitch()
        sw.thumbTintColor = .red
        sw.onTintColor = .black
        sw.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: slider))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: sw))
        consoleVC.view.frame = containerView.bounds
        containerView.addSubview(consoleVC.view)
        consoleVC.didMove(toParent: self)
    }
    
    @objc func test(sender: Any) {
        print(sender)
    }
    
    deinit {
        print("disappear")
    }
}

