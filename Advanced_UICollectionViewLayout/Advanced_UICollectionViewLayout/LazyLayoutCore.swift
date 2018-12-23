
//
//  LazyLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/22.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

protocol LazyLayout {
    var layout: UICollectionViewLayout { get }
}

fileprivate struct LazyStruct: LazyLayout {
    private var layoutClz: () -> (UICollectionViewLayout)
    
    init(_ clz: @escaping ()->(UICollectionViewLayout)) {
        self.layoutClz = clz
    }
    
    var layout: UICollectionViewLayout {
        return layoutClz()
    }
}

protocol HasLazyLayout {
    associatedtype T: UICollectionViewLayout
    static func lazy(_ clz: @escaping () -> (T)) -> LazyLayout
}

extension HasLazyLayout where Self: UICollectionViewLayout {
    static func lazy(_ clz: @escaping () -> (Self)) -> LazyLayout {
        return LazyStruct(clz)
    }
}

extension UICollectionViewLayout: HasLazyLayout {}

protocol HasDefaultLazyLayout {
    associatedtype CL: UICollectionViewLayout
    static func defaultLazy() -> DefaultLazyStructure<CL>
    static func defaultType() -> DefaultLazyStructure<CL>.Type
}

struct DefaultLazyStructure<CL: UICollectionViewLayout> : LazyLayout {
    
    private var layoutClz: () -> CL
    
    var layout: UICollectionViewLayout {
        return layoutClz()
    }
    
    init(_ clz: @escaping ()->(CL)) {
        self.layoutClz = clz
    }
}

extension HasDefaultLazyLayout where Self: UICollectionViewLayout {
    static func defaultType() -> DefaultLazyStructure<Self>.Type {
        return DefaultLazyStructure<Self>.self
    }
}
