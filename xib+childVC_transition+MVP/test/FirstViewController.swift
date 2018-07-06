//
//  FirstViewController.swift
//  test
//
//  Created by Hank_Zhong on 2018/7/6.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    deinit {
        print("F dead")
    }
    override func willMove(toParentViewController parent: UIViewController?) {
        print("F willMove")
    }
    override func didMove(toParentViewController parent: UIViewController?) {
        print("F didMove")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
