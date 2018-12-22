
//
//  LazyLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/22.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

struct LazyLayout {
    var layoutClz: () -> (UICollectionViewLayout)
    
    init(_ clz: @escaping ()->(UICollectionViewLayout)) {
        self.layoutClz = clz
    }
    
    func wake() -> UICollectionViewLayout {
        return layoutClz()
    }
}

protocol HasLazyLayout where Self: UICollectionViewLayout {
    static var defaultLazy: LazyLayout { get }
}

extension HasLazyLayout where Self: UICollectionViewLayout {
    static func customLazy(_ clz: @escaping () -> (Self)) -> LazyLayout {
        return LazyLayout(clz)
    }
}

extension HasLazyLayout where Self: UICollectionViewFlowLayout {
    static var defaultLazy: LazyLayout {
        return LazyLayout{ UICollectionViewFlowLayout() }
    }
}

extension UICollectionViewFlowLayout: HasLazyLayout {}
