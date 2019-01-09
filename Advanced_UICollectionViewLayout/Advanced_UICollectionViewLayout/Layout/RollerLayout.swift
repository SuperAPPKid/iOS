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
    var roteRate: CGFloat = 2.0
    
    private var _count: Int = 0
    private var _contentHeight: CGFloat = 0
    private var _collectionViewBounds: CGRect = .zero
    private var _size: CGSize = .zero
    private var _radius: CGFloat = 0
    
    private var fixNum: CGFloat {
        return CGFloat(_count - 1) / CGFloat(_count)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: _contentHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            _collectionViewBounds = .zero
            return
        }
        _count = collectionView.numberOfItems(inSection: 0)
        _collectionViewBounds = collectionView.bounds
        _size = self.size ?? CGSize(width: _collectionViewBounds.width / 2, height: _collectionViewBounds.height / 4)
        _radius = (_size.height * 0.5) / tan(.twoPi / CGFloat(_count) / 2)
        _contentHeight =  .pi * 2.0 * _radius * roteRate * fixNum + collectionView.bounds.height
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
        attribute.center = CGPoint(x: _collectionViewBounds.width / 2, y: _collectionViewBounds.height / 2 + _collectionViewBounds.minY)
        attribute.size = _size
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / 500
        
        let perAngle = -.twoPi / CGFloat(_count)
        let fixAngle = .twoPi * fixNum * _collectionViewBounds.minY / (_contentHeight - _collectionViewBounds.height)
        let finalAngle = perAngle * CGFloat(indexPath.row) + fixAngle
        transform3D = CATransform3DTranslate(transform3D, 0, 0, -CGFloat(_count) * 15)
        transform3D = CATransform3DRotate(transform3D, finalAngle, 1, 0, 0)
        transform3D = CATransform3DTranslate(transform3D, 0, 0, _radius)
        
        attribute.transform3D = transform3D
        return attribute
    }
}

