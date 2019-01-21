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
    @IBOutlet weak var IDFVLabel: UILabel!
    @IBOutlet weak var IDFALabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var needInputAnimate: Bool = true
    var accounts: [Account] = [] {
        didSet {
            UIView.performWithoutAnimation {
                collectionView.reloadSections(IndexSet(integer: 0))
            }
            
            let cells = collectionView.visibleCells
            for cell in cells {
                cell.alpha = 0
                cell.transform = CGAffineTransform(translationX: 500, y: 0)
            }
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                for cell in cells {
                    cell.alpha = 1
                    cell.transform = .identity
                }
            }, completion: nil)
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        
        IDFVLabel.text?.append(UIDevice.current.identifierForVendor?.uuidString ?? "")
        IDFALabel.text?.append(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
        let flowLayout = { () -> UICollectionViewFlowLayout in
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = .greatestFiniteMagnitude
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            return layout
        }()
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.identify)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        needInputAnimate = true
        view.endEditing(true)
    }
    
    @IBAction func saveToKeychain(_ sender: UIButton) {
        needInputAnimate = true
        guard let account = save() else { return }
        accounts.append(account)
        collectionView.scrollToItem(at: IndexPath(row: accounts.count - 1, section: 0), at: .centeredHorizontally, animated: false)
        view.endEditing(true)
    }
    
    @IBAction func fetchFromKeychain(_ sender: UIButton) {
        
        accounts = fetch()
        
        guard let firstAccount = accounts.first,
            let account = fetch(account: firstAccount.ID).first else { return }
        print(account)
        
    }
    
    @IBAction func cleanKeychain(_ sender: UIButton) {
        delete()
        accounts = fetch()
    }
    
}

//MARK:UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === accountTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            guard let account = save() else { return false }
            accounts.append(account)
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

//MARK:UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.identify, for: indexPath) as! AccountCell
        cell.account = accounts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: collectionView.bounds.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let firstCell = collectionView.visibleCells.first,
            let firstCellIndex = collectionView.indexPath(for: firstCell) else { return }
        if firstCellIndex.row > indexPath.row {
            cell.transform = CGAffineTransform(translationX: -100, y: 0)
        } else if firstCellIndex.row < indexPath.row {
            cell.transform = CGAffineTransform(translationX: 100, y: 0)
        } else {
            fatalError()
        }
        UIView.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
}

//MARK:🔑🔑🔑 keychain
extension ViewController {
    private func save() -> Account? {
        guard let accountText = accountTextField.text?.replacingOccurrences(of: " ", with: ""),
            let passwordText = passwordTextField.text?.replacingOccurrences(of: " ", with: ""),
            !accountText.isEmpty && !passwordText.isEmpty,
            let passwordData = passwordText.data(using: .utf8) else {
                let alertVC = UIAlertController(title: "Invalid Input", message: "please check again", preferredStyle: .alert)
                alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
                present(alertVC, animated: true, completion: nil)
                return nil
        }
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: accountText,
            kSecAttrService as String: "Hank Service",
            kSecValueData as String: passwordData,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemAdd(query as CFDictionary, $0)
        }
        
        guard let data = result as? Data,
            let pwd = String(data: data, encoding: .utf8) else {
                let alertVC = UIAlertController(title: "Fail", message: (SecCopyErrorMessageString(status, nil) as String?) ?? "", preferredStyle: .alert)
                alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
                present(alertVC, animated: true, completion: nil)
                return nil
        }
        
        return Account(ID: accountText, PWD: pwd)
    }
    
    private func fetch(account: String? = nil, service: String = "Hank Service") -> [Account] {
        var accounts = [Account]()
        
        if let account = account {
            //單帳號查密碼
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
            
            print("🌡 \((SecCopyErrorMessageString(status, nil) as String?) ?? "failure") \(result)")
            accounts.append(Account(ID: account, PWD: pwd))
            
        } else {
            //全部帳號與密碼
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
            
            guard let results = data as? [[String: AnyObject]] else {
                return accounts
            }
            
            print("🌡 \((SecCopyErrorMessageString(status, nil) as String?) ?? "failure") \(results)")
            
            for result in results {
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
    
    private func delete() {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: "Hank Service"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        print((SecCopyErrorMessageString(status, nil) as String?) ?? "failure")
    }
}

struct Account {
    var ID: String
    var PWD: String
}
