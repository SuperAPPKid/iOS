//
//  RollerLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/3.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class RollerLayout: UICollectionViewLayout {
    var size: CGSize?
    var roteRate: CGFloat = 1.0
    var visualSpace = CGFloat(300)
    
    private var _count = 0
    private var contentHeight = CGFloat(0)
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
}
