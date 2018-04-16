//
//  DetailViewController.swift
//  Jptt
//
//  Created by zhong on 2018/3/31.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detaiTextView: UITextView!
    var detail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        detaiTextView.text = detail
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
