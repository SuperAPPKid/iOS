//
//  ViewController.swift
//  BezierPathShowup
//
//  Created by Hank_Zhong on 2018/12/6.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let consoleVC = ConsoleViewController(parent: self, blurType: .dark)
        view.addSubview(consoleVC.view)
    }

}

class LabelTextfield: UIControl {
    let stackView: UIStackView
    let label: UILabel
    let textfield: UITextField
    
    override init(frame: CGRect) {
        label = UILabel()
        textfield = UITextField()
        stackView = UIStackView(arrangedSubviews: [label, textfield])
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(textfield)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
