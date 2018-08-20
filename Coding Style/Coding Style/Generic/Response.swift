//
//  Generic.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import Foundation

struct Response<Element: Decodable>: Decodable {
    let ApiName:String
    let ErrorMsg:String?
    let Data:Element
}
