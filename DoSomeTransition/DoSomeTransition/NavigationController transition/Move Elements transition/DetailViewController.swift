//
//  DetailViewController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.layer.cornerRadius = 150
        imageView.transform = CGAffineTransform(rotationAngle: .pi / 6)
        let anim = CABasicAnimation(keyPath: "transform.rotation.y")
        anim.duration = 0.5
        anim.fromValue = 0
        anim.toValue = -2 * Float.pi
        anim.isCumulative = true
        anim.repeatCount = .infinity
        imageView.layer.add(anim, forKey: "rotate")
    }

}
