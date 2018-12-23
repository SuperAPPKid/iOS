//
//  My242FlowLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/22.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class My242FlowLayout: UICollectionViewLayout, HasDefaultLazyLayout {
    
    static func defaultLazy() -> DefaultLazyStructure<My242FlowLayout> {
        return DefaultLazyStructure {
            return My242FlowLayout()
        }
    }
    
    override func prepare() {
        print(#function)
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("\(#function) \(rect)")
        return super.layoutAttributesForElements(in: rect)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("\(#function) \(indexPath)")
        return super.layoutAttributesForItem(at: indexPath)
    }
}
