//
//  MyCollectionViewLineLayout.swift
//  AutoSizeCollectionCell
//
//  Created by zhong on 2018/6/3.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class MyCollectionViewLineLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        self.itemSize = CGSize(width: 200, height: 200)
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
        self.minimumLineSpacing = 100
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let array:[UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let visibleRect:CGRect = CGRect(origin: self.collectionView?.contentOffset ?? CGPoint.zero,
                                        size: self.collectionView?.bounds.size ?? CGSize.zero)
        
        for attributes in array {
            if rect.intersects(attributes.frame) {
                let distance = visibleRect.midY - attributes.center.y
                if abs(distance) < 300 {
                    let zoom = 2 - abs(distance / 300)
                    attributes.size = CGSize(width: 200 * zoom, height: 200 * zoom)
                }
            }
        }
        
        return array
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else {
            return CGPoint.zero
        }
        
        let finalVisibleRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        let array:[UICollectionViewLayoutAttributes] = self	.layoutAttributesForElements(in: finalVisibleRect) ?? []
        
        let oldY = proposedContentOffset.y
        var adjustY:CGFloat = CGFloat.infinity
        
        let ScrollViewCenterYinMiddle = proposedContentOffset.y + collectionView.bounds.height / 2
        for attributes in array {
            let perCellCenterY = attributes.center.y
            if abs(perCellCenterY - ScrollViewCenterYinMiddle) < abs(adjustY){
                adjustY =  perCellCenterY - ScrollViewCenterYinMiddle
            }
        }
        
        return CGPoint(x: proposedContentOffset.x, y: oldY + adjustY)
    }
}
