//
//  ViewController.swift
//  jlkj
//
//  Created by Hank_Zhong on 2018/6/8.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.text = UserDefaults.standard.value(forKey: "test") as? String
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "清空並顯示註冊值", style: .plain, target: self, action: #selector(clearUserDefault)), animated: true)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(turnOff)), animated: true)
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: nil, queue: nil) { (notification) in
            UserDefaults.standard.set(self.inputField.text, forKey: "test")
            self.outputLabel.text = UserDefaults.standard.value(forKey: "test") as? String
        }
    }
    
    @IBAction func RegisterDefault(_ sender: UIButton) {
        UserDefaults.standard.register(defaults: ["test":"註冊值\(self.outputLabel.text ?? "不會永久儲存")"])
    }
    
    @objc func clearUserDefault() {
        UserDefaults.standard.removeObject(forKey: "test")
        outputLabel.text = UserDefaults.standard.value(forKey: "test") as? String
        inputField.text = ""
    }
    
    @objc func turnOff() {
        exit(0)
    }
}

