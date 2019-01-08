//
//  RingLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/3.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class RingLayout: UICollectionViewLayout {
    var size: CGSize = CGSize(width: 50, height: 50)
    var roteRate: CGFloat = 1.0
    var radius = CGFloat(200)
    var visualSpace = CGFloat(300)
    
    private var _count = 0
    private var _center = CGPoint.zero
    private var _contentWidth = CGFloat(0)
    
    private var fixNum: CGFloat {
        return CGFloat(_count - 1) / CGFloat(_count)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: _contentWidth, height: collectionView?.bounds.height ?? 0)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        _count = collectionView.numberOfItems(inSection: 0)
        _center = CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height / 2)
        _contentWidth =  .pi * 2.0 * radius * roteRate * fixNum + collectionView.bounds.width
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
        guard let collectionView = collectionView else { return nil }
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.size = size
        
        attribute.center = CGPoint(x: collectionView.bounds.width / 2 + collectionView.bounds.minX, y: _center.y)
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / (radius + visualSpace)
        let perAngle = 2 * CGFloat.pi / CGFloat(_count)
        let fixAngle = 2 * CGFloat.pi * fixNum * collectionView.bounds.minX / (_contentWidth - collectionView.bounds.width)
//        print("\(collectionView.bounds.minX) + \(collectionView.bounds.width) = \(collectionView.bounds.minX + collectionView.bounds.width)")
//        print(_contentWidth)
        let finalAngle = perAngle * CGFloat(indexPath.row) - fixAngle
//        print("修正\(fixAngle / (2 * .pi) * 360)度")
//        print("item:\(indexPath.row)=\(finalAngle / (2 * .pi) * 360)度")
        transform3D = CATransform3DRotate(transform3D, finalAngle, 0, 1, 0)
        transform3D = CATransform3DTranslate(transform3D, 0, 0, radius)
        
//        transform3D = CATransform3DRotate(transform3D, .pi / 6, 1, 0, 0)
//        transform3D = CATransform3DTranslate(transform3D, 0, 0, 20)
        attribute.transform3D = transform3D
        return attribute
    }
}
