//
//  ViewController.swift
//  GoogleAndFacebookLogin
//
//  Created by Hank_Zhong on 2019/1/17.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var googleSigninBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSigninBtn.colorScheme = .dark
        googleSigninBtn.style = .wide
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance()?.signOut()
    }
}

extension ViewController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("🍕WillDispatch")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("🍕Dismiss")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("🍕Present")
    }
}

