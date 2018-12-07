//
//  ConsoleElement.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

protocol ConsoleActionElement: AnyObject {
    associatedtype Element: UIControl
    var title: String { get }
    var control: Element { get }
}

class ConsoleAction<T: UIControl>: NSObject, ConsoleActionElement {
    let title: String
    let control: T
    let preferColor: UIColor
    
    init(title:String, control: T, preferColor: UIColor) {
        self.title = title
        self.control = control
        self.preferColor = preferColor
    }
}
