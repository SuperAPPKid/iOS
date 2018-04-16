//
//  ViewController.swift
//  keyboardViewUp
//
//  Created by zhong on 2018/3/31.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var someTextField: UITextField!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var aButton_bottomCons: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        print(aButton_bottomCons.constant)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        guard let duration:TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval else {
            return
        }
        let animationCurveRaw = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? (UIViewAnimationOptions.curveEaseInOut.rawValue)
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.init(rawValue: animationCurveRaw), animations: {
//            self.aButton_bottomCons.constant -= keyboardHeight
//            self.view.layoutIfNeeded()
            self.aButton.transform = CGAffineTransform.init(translationX: 0, y: -keyboardHeight)
        }, completion: nil)
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        guard let duration:TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval else {
            return
        }
        
        let animationCurveRaw = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? (UIViewAnimationOptions.curveEaseInOut.rawValue)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.init(rawValue: animationCurveRaw), animations: {
//            self.aButton_bottomCons.constant = 0
//            self.view.layoutIfNeeded()
            self.aButton.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    @IBAction func aButtonClick(_ sender: UIButton) {
        someTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        someTextField.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

