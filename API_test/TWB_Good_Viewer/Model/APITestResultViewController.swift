//
//  APITestResultViewController.swift
//  TWB_Good_Viewer
//
//  Created by Hank_Zhong on 2018/6/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class APITestResultViewController: UIViewController {
    @IBOutlet weak var responseView: UITextView!
    @IBOutlet weak var imageViewContainer: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var response:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        responseView.text = response
    }
    
    func setProgressHidden(setHidden:Bool) {
        self.progressBar.isHidden = setHidden ? true:false
    }
}
