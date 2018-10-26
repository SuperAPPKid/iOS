//
//  ViewController.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let consoleVC = ConsoleViewController()
        addChild(consoleVC)
        let containerView = UIView(frame: CGRect(origin: .init(x: 50, y: 50), size: .init(width: 600, height: 300)))
        containerView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        view.addSubview(containerView)
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: UISlider()))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: UISwitch()))
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: UISlider()))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: UISwitch()))
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: UISlider()))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: UISwitch()))
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: UISlider()))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: UISwitch()))
        consoleVC.view.frame = containerView.bounds
        containerView.addSubview(consoleVC.view)
        consoleVC.didMove(toParent: self)
    }
}

