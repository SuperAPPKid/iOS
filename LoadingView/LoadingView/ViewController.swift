//
//  ViewController.swift
//  LoadingView
//
//  Created by user37 on 2018/3/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let loadingView:LoadingView = LoadingView()
        let otherView:OtherView = OtherView()
        let blackLoadingView:BlackLoadingView = BlackLoadingView()
        
        otherView.frame = CGRect(x: 50, y: 50, width: 300, height: 300)
        otherView.backgroundColor = UIColor.clear
        view.addSubview(otherView)
        
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(blackLoadingView)
        blackLoadingView.translatesAutoresizingMaskIntoConstraints = false
        blackLoadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blackLoadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        blackLoadingView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        blackLoadingView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

