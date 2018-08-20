//
//  Cell_Protocl.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import Foundation
import UIKit

protocol XibCell {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension XibCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
