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
        slider.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        let sw = UISwitch()
        sw.thumbTintColor = .red
        sw.onTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.6043985445)
        sw.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        let seg = UISegmentedControl(items: ["Hello", "World"])
        seg.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18) ], for: .normal)
        seg.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: seg, preferColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.8020922517)))
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: slider, preferColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.4025577911)))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: sw, preferColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.6041309932)))
        consoleVC.addAction(action: ConsoleAction(title: "GOOD", control: UISlider(), preferColor: #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 0.3023062928)))
        consoleVC.addAction(action: ConsoleAction(title: "BAD", control: UISwitch(), preferColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5)))
        
        if let consolView = consoleVC.view {
            view.addSubview(consolView)
            [consolView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             consolView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             consolView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             consolView.topAnchor.constraint(equalTo: view.topAnchor, constant: 350)].forEach{ $0.isActive = true }
        }
        
        addChild(consoleVC)
    }
    
    @objc func test(sender: Any) {
        print(sender)
    }
    
    deinit {
        print("disappear")
    }
}

