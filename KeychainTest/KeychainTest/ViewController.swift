//
//  ViewController.swift
//  KeychainTest
//
//  Created by Hank_Zhong on 2019/1/18.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit
import Security

class ViewController: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func SafeToKeychain(_ sender: Any) {
    }
    
    @IBAction func fetchFromKeychain(_ sender: UIButton) {
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: UIWindow.keyboardDidChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIWindow.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIWindow.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: UIWindow.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK:🎹🎹🎹 Keyboard
extension ViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🍕 \(value)")
        }
        
        //        guard let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
        //            let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
        //        UIView.animate(withDuration: animateDuration,
        //                       delay: 0,
        //                       usingSpringWithDamping: 1,
        //                       initialSpringVelocity: 0,
        //                       options: .init(rawValue: animateCurveIndex),
        //                       animations: {
        //                        self.view.transform = CGAffineTransform(translationX: 0, y: -80) },
        //                       completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🍔 \(value)")
        }
        
        //        guard let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
        //            let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
        //        UIView.animate(withDuration: animateDuration,
        //                       delay: 0,
        //                       usingSpringWithDamping: 0,
        //                       initialSpringVelocity: 0,
        //                       options: .init(rawValue: animateCurveIndex),
        //                       animations: {
        //                        self.view.transform = CGAffineTransform(translationX: 0, y: -80) },
        //                       completion: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🥟 \(value)")
        }
        
        //        guard let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
        //              let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
        //        UIView.animate(withDuration: animateDuration,
        //                       delay: 0,
        //                       usingSpringWithDamping: 0,
        //                       initialSpringVelocity: 0,
        //                       options: .init(rawValue: animateCurveIndex),
        //                       animations: {
        //                        self.view.transform = CGAffineTransform(translationX: 0, y: -80) },
        //                       completion: nil)
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🍖 \(value)")
        }
        
        //        guard let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
        //            let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
        //
        //        UIView.animate(withDuration: animateDuration,
        //                       delay: 0,
        //                       usingSpringWithDamping: 0,
        //                       initialSpringVelocity: 0,
        //                       options: .init(rawValue: animateCurveIndex),
        //                       animations: {
        //                        self.view.transform = .identity },
        //                       completion: nil)
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        for (key, value) in info {
            print("\(key) 🍙 \(value)")
        }
        guard let beginCenter = info["UIKeyboardCenterBeginUserInfoKey"] as? CGPoint,
            let endCenter = info["UIKeyboardCenterEndUserInfoKey"] as? CGPoint,
            let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
            let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
        
        if beginCenter.y > endCenter.y {
            //開鍵盤
            UIView.animate(withDuration: animateDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .init(rawValue: animateCurveIndex),
                           animations: {
                            self.view.transform = CGAffineTransform(translationX: 0, y: -50) },
                           completion: nil)
        } else {
            //關鍵盤
            UIView.animate(withDuration: animateDuration,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .init(rawValue: animateCurveIndex),
                           animations: { self.view.transform = .identity },
                           completion: nil)
        }
    }
    
    @objc func keyboardDidChangeFrame(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        for (key, value) in info {
            print("\(key) 🍟 \(value)")
        }
        //        guard let beginCenter = info["UIKeyboardCenterBeginUserInfoKey"] as? CGPoint,
        //            let endCenter = info["UIKeyboardCenterEndUserInfoKey"] as? CGPoint,
        //            let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
        //            let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
        //
        //
        //        if beginCenter.y > endCenter.y {
        //            //開鍵盤
        //            UIView.animate(withDuration: animateDuration,
        //                           delay: 0,
        //                           usingSpringWithDamping: 1,
        //                           initialSpringVelocity: 0,
        //                           options: .init(rawValue: animateCurveIndex),
        //                           animations: {
        //                            self.view.transform = CGAffineTransform(translationX: 0, y: -80) },
        //                           completion: nil)
        //        } else {
        //            //關鍵盤
        //            UIView.animate(withDuration: animateDuration,
        //                           delay: 0,
        //                           usingSpringWithDamping: 1,
        //                           initialSpringVelocity: 0,
        //                           options: .init(rawValue: animateCurveIndex),
        //                           animations: { self.view.transform = .identity },
        //                           completion: nil)
        //        }
    }
}
