//
//  NibView.swift
//  test
//
//  Created by Hank_Zhong on 2018/7/6.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit
protocol NibViewDelegate {
    func changeSquareView(to color:UIColor)
}

class NibView: UIView {
    lazy var presenter:NibViewDelegate = NibViewPresenter(view: self)
    @IBOutlet weak var squareView: UIView!
    
    @IBAction func click(_ sender: UIButton) {
        presenter.changeSquareView(to: .black)
    }
}
