//
//  ViewController.swift
//  GoogleAndFacebookLogin
//
//  Created by Hank_Zhong on 2019/1/17.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {
    @IBOutlet weak var googleSigninView: UIView!
    @IBOutlet weak var googleInfoTextView: UITextView!
    @IBOutlet weak var fbInfoTextView: UITextView!
    @IBOutlet weak var fbSigninView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        setGoogleTextView(user: GIDSignIn.sharedInstance().currentUser)
        
        setFBTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(googleDidSignIn), name: Google.DidSignIn, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func googleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookSignin(_ sender: UIButton) {
        guard FBSDKAccessToken.current() == nil else {
            return
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            var message = ""
            if let error = error {
                message = error.localizedDescription
            } else if let result = result, result.isCancelled {
                message = "isCancelled"
            } else {
                self.setFBTextView()
                return
            }
            let alertVC = UIAlertController(title: "Sign In", message: message, preferredStyle: .alert)
            alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance().signOut()
        setGoogleTextView(user: GIDSignIn.sharedInstance().currentUser)
        
        deletePermission {
            FBSDKLoginManager().logOut()
            self.setFBTextView()
        }
    }
    
    @objc func googleDidSignIn(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let error = userInfo["error"] as? Error {
            let alertVC = UIAlertController(title: "Sign In", message: error.localizedDescription, preferredStyle: .alert)
            alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        } else {
            setGoogleTextView(user: userInfo["user"] as? GIDGoogleUser)
        }
    }
    
    func setGoogleTextView(user: GIDGoogleUser?) {
        guard let user = user else {
            googleInfoTextView.text = ""
            return
        }
        googleInfoTextView.text = """
        id: \(user.userID ?? "")
        idToken: \(user.authentication.idToken ?? "")
        accessToken: \(user.authentication.accessToken ?? "")
        refreshToken: \(user.authentication.refreshToken ?? "")
        fullname: \(user.profile.name ?? "")
        givenName: \(user.profile.givenName ?? "")
        familyName: \(user.profile.familyName ?? "")
        email: \(user.profile.email ?? "")
        """
    }
    
    func deletePermission(callback: @escaping () -> Void) {
        guard FBSDKAccessToken.current() != nil else {
            return
        }
        FBSDKGraphRequest(graphPath: "/me/permissions", parameters: nil, httpMethod: "DELETE")?.start(completionHandler: { (connection, result, error) in
            if let error = error {
                let alertVC = UIAlertController(title: "Sign In", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                callback()
            }
        })
    }
    
    func setFBTextView() {
        guard FBSDKAccessToken.current() != nil else {
            fbInfoTextView.text = ""
            return
        }
        FBSDKProfile.loadCurrentProfile { (profile, error) in
            if let error = error {
                let alertVC = UIAlertController(title: "Sign In", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])?.start(completionHandler: { (connection, result, error) in
                    if let error = error {
                        let alertVC = UIAlertController(title: "Sign In", message: error.localizedDescription, preferredStyle: .alert)
                        alertVC.addAction(.init(title: "OK", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    } else {
                        self.fbInfoTextView.text = """
                        id: \(FBSDKAccessToken.current()?.userID ?? "")
                        idToken: \(FBSDKAccessToken.current()?.tokenString ?? "")
                        expired: \(FBSDKAccessToken.current()?.expirationDate ?? Date())
                        permissions: \(FBSDKAccessToken.current()?.permissions ?? [])
                        fullname: \(profile?.name ?? "")
                        firstName: \(profile?.firstName ?? "")
                        lastName: \(profile?.lastName ?? "")
                        email: \((result as? [AnyHashable:String])?["email"] ?? "")
                        """
                    }
                })
            }
        }
    }

    deinit {
        print("Log In VC Deinit")
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

