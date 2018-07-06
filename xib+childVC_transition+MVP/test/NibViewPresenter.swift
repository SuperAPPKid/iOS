//
//  nibView.swift
//  test
//
//  Created by Hank_Zhong on 2018/7/6.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class NibViewPresenter:NibViewDelegate {
    unowned let view:NibView
    
    init(view:NibView) {
        self.view = view
    }
    
    func changeSquareView(to color: UIColor) {
        view.squareView.backgroundColor = color
    }
}
