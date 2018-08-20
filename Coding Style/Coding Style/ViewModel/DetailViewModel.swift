//
//  DetailViewModel.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import Foundation
class DetailViewModel {
    let title: String
    let imageName: String
    let detail: String
    var isSelect: Bool = false
    init(title: String, imageName: String, detail: String) {
        self.title = title
        self.imageName = imageName
        self.detail = detail
    }
}
