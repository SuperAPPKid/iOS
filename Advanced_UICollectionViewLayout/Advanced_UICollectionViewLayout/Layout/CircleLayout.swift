//
//  CircleLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/2.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class CircleLayout: UICollectionViewLayout {
    var radius: CGFloat?
    var size = CGSize(width: 50, height: 50)
    
    private var _count = 0
    private var _center = CGPoint.zero
    private var _radius = CGFloat(0)
    
    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        _count = collectionView.numberOfItems(inSection: 0)
        _center = CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height / 2)
        _radius = self.radius ?? min(collectionView.bounds.width / 2, collectionView.bounds.height / 2)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< _count {
            let index = IndexPath(row: i, section: 0)
            guard let attribute = layoutAttributesForItem(at: index) else { continue }
            attributes.append(attribute)
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.size = size
        attribute.center = CGPoint(x: _center.x + _radius * cos(2 * CGFloat.pi * CGFloat(indexPath.item) / CGFloat(_count)),
                                   y: _center.y + _radius * sin(2 * CGFloat.pi * CGFloat(indexPath.item) / CGFloat(_count)))
        return attribute
    }
}
