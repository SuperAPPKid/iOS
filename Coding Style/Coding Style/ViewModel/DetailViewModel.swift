//
//  DetailViewModel.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import Foundation
class DetailViewModel {
    let title: String // 子畫面標題
    let imageName: String // 圖片名稱
    let detail: String // 說明文字
    var isSelect: Bool = false //右上switch選取狀態
    init(title: String, imageName: String, detail: String) {
        self.title = title
        self.imageName = imageName
        self.detail = detail
    }
}
