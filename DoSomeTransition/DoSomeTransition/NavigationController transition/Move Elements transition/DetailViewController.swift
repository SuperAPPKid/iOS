//
//  DetailViewController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var ImageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageView.image = image
    }

}
