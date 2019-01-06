//
//  RingLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/3.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class RingLayout: UICollectionViewLayout {
    var space: CGFloat = 0
    var size = CGSize(width: 50, height: 50)
    
    private var _count = 0
    private var _center = CGPoint.zero
    private var _radius = CGFloat(0)
    private var _contentWidth = CGFloat(0)
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: _contentWidth, height: collectionView?.bounds.height ?? 0)
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        _count = collectionView.numberOfItems(inSection: 0)
        _center = CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height / 2)
        _contentWidth = max(collectionView.bounds.width, (size.width + space) * CGFloat(_count) + space)
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
        attribute.center = CGPoint(x: (size.width + space) * CGFloat(indexPath.row) + size.width / 2 + space, y: _center.y)
        return attribute
    }
}
