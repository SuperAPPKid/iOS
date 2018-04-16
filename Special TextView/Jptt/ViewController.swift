//
//  ViewController.swift
//  Jptt
//
//  Created by zhong on 2018/3/30.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate {

    
    
    @IBOutlet weak var myViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var myViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var textField: UITextView!
    var openScrollLocation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.isHidden = true
        myView.layer.cornerRadius = 20
        myView.layer.borderWidth = 3
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        myViewBottomConstraint.constant = 20 + keyboardHeight
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        myViewBottomConstraint.constant = 20
    }

    @IBAction func add(_ sender: UIBarButtonItem) {
        myView.isHidden = false
        textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        textField.resignFirstResponder()
        myView.isHidden = true
    }
    @IBAction func ok(_ sender: UIButton) {
        textField.resignFirstResponder()
        myView.isHidden = true
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if myView.frame.origin.y < 50 && !textView.isScrollEnabled {
            textView.isScrollEnabled = true
            openScrollLocation = range.location
        }
        if range.location < openScrollLocation {
            textView.isScrollEnabled = false
        }
        print(myView.frame.origin.y)
        print(range)
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toVC = segue.destination as? DetailViewController {
            toVC.detail += textField.text
        }
    }
 

}
