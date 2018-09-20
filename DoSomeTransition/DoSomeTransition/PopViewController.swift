//
//  PopViewController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    deinit {
        print("pop deinit")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
