//
//  AppDelegate.swift
//  GoogleAndFacebookLogin
//
//  Created by Hank_Zhong on 2019/1/17.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Google
        GIDSignIn.sharedInstance()?.clientID = "1019804717377-rmsvjodr2pspc34fum62umldllduds5o.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        //FaceBook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let fbUrl = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        let googleUrl = GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return fbUrl || googleUrl
    }
    
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            NotificationCenter.default.post(name: Google.DidSignIn, object: nil, userInfo: ["error":error])
        } else {
            guard let user = user else {
                NotificationCenter.default.post(name: Google.DidSignIn, object: nil, userInfo: nil)
                return
            }
            NotificationCenter.default.post(name: Google.DidSignIn, object: nil, userInfo: ["user":user])
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            NotificationCenter.default.post(name: Google.DidDisconnect, object: nil, userInfo: ["error":error])
        } else {
            guard let user = user else {
                NotificationCenter.default.post(name: Google.DidDisconnect, object: nil, userInfo: nil)
                return
            }
            NotificationCenter.default.post(name: Google.DidDisconnect, object: nil, userInfo: ["user":user])
        }
    }
}

struct Google {
    static let DidSignIn = NSNotification.Name("GoogleDidSignInForUser")
    static let DidDisconnect = NSNotification.Name("GoogleDidDisconnectWithUser")
}

