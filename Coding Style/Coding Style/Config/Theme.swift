//
//  Global.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import Foundation
import UIKit
struct Theme {
    private static let theme = Bundle.main.infoDictionary?["App theme"] as? String
    
    //cell 選取色
    static var SELECTED_COLOR: UIColor {
        if let theme = theme, theme == "green" {
            return #colorLiteral(red: 0.6089995114, green: 1, blue: 0.3493120194, alpha: 1)
        }
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //cell highlight色
    static var HIGHTLIGHT_COLOR: (YES: UIColor, NO: UIColor) {
        if let theme = theme, theme == "green" {
            return (#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9086963265, green: 0.9086963265, blue: 0.9086963265, alpha: 1))
        }
        return (#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    //導航列色
    static var NAVIGATIONBAR_COLOR: (TINT: UIColor, TITLE: UIColor) {
        if let theme = theme, theme == "green" {
            return (#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
        return (#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    //狀態列style
    static var STATUSBAR_STYLE: UIStatusBarStyle {
        if let theme = theme, theme == "green" {
            return UIStatusBarStyle.lightContent
        }
        return UIStatusBarStyle.default
    }
}
