//
//  StackLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/2.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class StackLayout: UICollectionViewLayout {
    var height: CGFloat = 150
    var overlapSpace: CGFloat = 0
    
    private var cachedAttributes:[UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
        cachedAttributes.removeAll()
        contentSize = .zero
        
        guard let collectionView = collectionView else { return }
        contentSize.width = collectionView.bounds.width
        
        for i in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: .init(row: i, section: 0))
            attribute.frame = CGRect(x: 0, y: max(CGFloat(i) * (height - overlapSpace), collectionView.contentOffset.y), width: collectionView.bounds.width, height: height)
            attribute.zIndex = i
            
            cachedAttributes.append(attribute)
            contentSize.height += (height - overlapSpace)
        }
        
        contentSize.height += overlapSpace
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[safe: indexPath.row]
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
}
