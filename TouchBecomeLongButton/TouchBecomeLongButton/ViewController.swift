//
//  ViewController.swift
//  TouchBecomeLongButton
//
//  Created by zhong on 2018/4/10.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    var isOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 22.5
        
        let f = DateFormatter()
        f.timeZone = NSTimeZone.local
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
//        let dateStr = f.string(from: Date())
        let date = f.date(from: "2018/04/10 13:06:22")
        
        let calandar = Calendar.current
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] (timer) in
            let components = calandar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date!, to: Date())
//            let components = calandar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
            
            guard let hour = components.hour, let min = components.minute, let sec = components.second else {
                timer.invalidate()
                return
            }
            self.button.setTitle("\(hour):\(min):\(sec)", for: .selected)
        }
    }

    @IBAction func click(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            if !self.isOpen {
                self.buttonWidthConstraint.constant = self.view.frame.width - 40
            } else {
                self.buttonWidthConstraint.constant = 45
                self.button.isSelected = false
            }
            self.view.layoutIfNeeded()
            self.isOpen = !self.isOpen
        }) { (bool) in
            print(bool)
            if self.isOpen {
                self.button.isSelected = true
            }
        }
    }
}

