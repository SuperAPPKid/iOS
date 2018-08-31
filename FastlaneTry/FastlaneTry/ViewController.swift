//
//  ViewController.swift
//  FastlaneTry
//
//  Created by Hank_Zhong on 2018/8/30.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: LineLabel!
    @IBOutlet weak var wrapperView: WrapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let labelaaa = UILabel(frame: CGRect(x: 20, y: 20, width: 150, height: 80))
//        labelaaa.text = "8787878787"
//        let labelbbb = UILabel()
//        labelbbb.frame = labelaaa.bounds
//        labelbbb.text = "7878787878"
//        labelaaa.addSubview(labelbbb)
//        self.view.addSubview(labelaaa)
        wrapperView.mask = label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = wrapperView.bounds
    }
    
    @IBAction func redraw(_ sender: UIButton) {
//        label.setNeedsDisplay()
        label.redraw()
    }
}

