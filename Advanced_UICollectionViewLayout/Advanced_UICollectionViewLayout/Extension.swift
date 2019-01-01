//
//  Extension.swift
//  Advanced_UICollectionViewLayout
//
//  Created by zhong on 2018/12/31.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe position: Index) -> Element? {
        if position >= endIndex {
            return nil
        }
        return self[position]
    }
}
