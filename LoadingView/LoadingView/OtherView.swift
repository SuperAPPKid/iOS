//
//  OtherLoadingView.swift
//  LoadingView
//
//  Created by user37 on 2018/3/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit

class OtherView: UIView {
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.lineWidth = 20
        
        aPath.move(to: CGPoint(x:200, y:50))
        aPath.addLine(to: CGPoint(x:300, y:50))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        aPath.close()//離筆
        
        //If you want to stroke it with a red color
        UIColor.red.set()
        aPath.stroke()
        //If you want to fill it as well
        
    }
}
