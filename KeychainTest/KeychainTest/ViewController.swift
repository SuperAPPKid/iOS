//
//  ViewController.swift
//  KeychainTest
//
//  Created by Hank_Zhong on 2019/1/18.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit
import Security
import AdSupport

class ViewController: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var IDFVLabel: UILabel!
    @IBOutlet weak var IDFALabel: UILabel!
    
    var needInputAnimate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tempSet = Set<Int>()
        while tempSet.count < 25 {
            let randNum = Int.random(in: 1...75)
            tempSet.insert(randNum)
        }
        print(tempSet)
        addObservers()
        IDFVLabel.text?.append(UIDevice.current.identifierForVendor?.uuidString ?? "")
        IDFALabel.text?.append(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(fetch())
        needInputAnimate = true
        view.endEditing(true)
    }
    
    @IBAction func safeToKeychain(_ sender: UIButton) {
        save()
    }
    
    @IBAction func fetchFromKeychain(_ sender: UIButton) {
        
        let queryALL: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: "Hank Service",
            kSecReturnData as String: kCFBooleanTrue,
            kSecReturnAttributes as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var data: AnyObject?
        let status = withUnsafeMutablePointer(to: &data) {
            SecItemCopyMatching(queryALL as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard let resultData = data as? [[String: AnyObject]] else { return }
        
        print("\((SecCopyErrorMessageString(status, nil) as String?) ?? "failure") \(resultData)")
        
        for result in resultData {
            guard let accountString = result[kSecAttrAccount as String] as? String,
                  let account = fetch(account: accountString).first else {
                continue
            }
            print(account)
        }
        
    }
    
    func fetch(account: String? = nil, service: String = "Hank Service") -> [Account] {
        var accounts = [Account]()
        
        if let account = account {
            let quertPwd: [String:Any] = [
                kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecReturnData as String: kCFBooleanTrue,
                kSecReturnAttributes as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var pwdResult: AnyObject?
            let status = withUnsafeMutablePointer(to: &pwdResult) { SecItemCopyMatching(quertPwd as CFDictionary, $0) }
            
            guard let result = pwdResult as? [String:AnyObject],
                let pwdData = result[kSecValueData as String] as? Data,
                let pwd = String(data: pwdData, encoding: .utf8) else {
                    return accounts
            }
            
            print("🌡 \((SecCopyErrorMessageString(status, nil) as String?) ?? "failure") \(account) \(pwd)")
            accounts.append(Account(ID: account, PWD: pwd))
            
        } else {
            let queryALL: [String:Any] = [
                kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrService as String: "Hank Service",
                kSecReturnData as String: kCFBooleanFalse,
                kSecReturnAttributes as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitAll
            ]
            
            var data: AnyObject?
            let status = withUnsafeMutablePointer(to: &data) {
                SecItemCopyMatching(queryALL as CFDictionary, UnsafeMutablePointer($0))
            }
            
            guard let resultData = data as? [[String: AnyObject]] else {
                return accounts
            }
            
            print("\((SecCopyErrorMessageString(status, nil) as String?) ?? "failure") \(resultData)")
            
            for result in resultData {
                guard let accountString = result[kSecAttrAccount as String] as? String,
                    let pwdData = result[kSecValueData as String] as? Data,
                    let pwdString = String(data: pwdData, encoding: .utf8) else {
                        return accounts
                }
                accounts.append(Account(ID: accountString, PWD: pwdString))
            }
        }
        
        return accounts
    }
    
    @IBAction func cleanKeychain(_ sender: UIButton) {
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: "Hank Service"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        print((SecCopyErrorMessageString(status, nil) as String?) ?? "failure")
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
    
    private func save() {
        needInputAnimate = true
        guard let accountText = accountTextField.text?.replacingOccurrences(of: " ", with: ""),
              let passwordText = passwordTextField.text?.replacingOccurrences(of: " ", with: ""),
              !accountText.isEmpty && !passwordText.isEmpty,
              let passwordData = passwordText.data(using: .utf8) else {
                let alertVC = UIAlertController(title: "Invalid Input", message: "please check again", preferredStyle: .alert)
                alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
                present(alertVC, animated: true, completion: nil)
                return
        }
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: accountText,
            kSecAttrService as String: "Hank Service",
            kSecValueData as String: passwordData,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        print((SecCopyErrorMessageString(status, nil) as String?) ?? "failure")
    }
}

//MARK:UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            save()
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK:⌨️⌨️⌨️ Keyboard
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
//                       options: .init(rawValue: animateCurveIndex),
//                       animations: { self.view.transform = CGAffineTransform(translationX: 0, y: -50) },
//                       completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🍔 \(value)")
        }
//
//        guard let animateDuration = info["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval,
//            let animateCurveIndex = info["UIKeyboardAnimationCurveUserInfoKey"] as? UInt else { return }
//        UIView.animate(withDuration: animateDuration,
//                       delay: 0,
//                       options: .init(rawValue: animateCurveIndex),
//                       animations: { self.view.transform = .identity },
//                       completion: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🥟 \(value)")
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        
        for (key, value) in info {
            print("\(key) 🍖 \(value)")
        }
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
            if needInputAnimate {
                UIView.animate(withDuration: animateDuration,
                               delay: 0,
                               options: .init(rawValue: animateCurveIndex),
                               animations: { self.view.transform = CGAffineTransform(translationX: 0, y: -50) },
                               completion: { print("-💎\($0)"); self.needInputAnimate = false })
            } else {
                UIView.performWithoutAnimation {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -50)
                }
            }
        } else {
            //關鍵盤
            if needInputAnimate {
                UIView.animate(withDuration: animateDuration,
                               delay: 0,
                               options: .init(rawValue: animateCurveIndex),
                               animations: { self.view.transform = .identity },
                               completion: { print("-🔮\($0)")})
            } else {
                UIView.performWithoutAnimation {
                    self.view.transform = .identity
                }
            }
        }
    }
    
    @objc func keyboardDidChangeFrame(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        for (key, value) in info {
            print("\(key) 🍟 \(value)")
        }
    }
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

struct Account {
    var ID: String
    var PWD: String
}
