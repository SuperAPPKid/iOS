//
//  OnelineFlowLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/25.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit
///Deprecated
class OnelineFlowLayout: TestFlowLayout {
    
    var maxZoomScale: CGFloat = 0.5
    var minimumZoomScope: CGFloat?
    
    override var minimumInteritemSpacing: CGFloat {
        get {
            return .greatestFiniteMagnitude
        }
        set {
            print("Do nothing")
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        for attribute in attributes ?? [] {
            setTransform(attribute: attribute)
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        
        setTransform(attribute: attribute)
        
        return attribute
    }
    
    func setTransform(attribute: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else { return }
        var activeDistance = CGFloat(0)
        switch scrollDirection {
        case .vertical:
            activeDistance = abs((minimumZoomScope ?? collectionView.bounds.height) / 2)
        case .horizontal:
            activeDistance = abs((minimumZoomScope ?? collectionView.bounds.width) / 2)
        }
        
        let triggerRect = CGRect(x: collectionView.bounds.midX,
                                 y: collectionView.bounds.midY,
                                 width: 0,
                                 height: 0).insetBy(dx: -activeDistance, dy: -activeDistance)
        if triggerRect.intersects(attribute.frame) {
            var distance = CGFloat(0)
            switch scrollDirection {
            case .vertical:
                distance = (attribute.center.y - triggerRect.midY)
            case .horizontal:
                distance = (attribute.center.x - triggerRect.midX)
            }
            
            if abs(distance) < activeDistance {
                let stdDistance = abs(distance / activeDistance)
                let zoom =  1 + (maxZoomScale - 1) * (1 - stdDistance)
                attribute.transform = CGAffineTransform(scaleX: zoom, y: zoom)
            }
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint.zero
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let targetCenter = CGPoint(x: proposedContentOffset.x + collectionView.bounds.width / 2,
                                   y: proposedContentOffset.y + collectionView.bounds.height / 2)
        
        let targetRect = CGRect(origin: proposedContentOffset,
                                size: collectionView.bounds.size).insetBy(dx: -collectionView.bounds.width,
                                                                          dy: -collectionView.bounds.height)
        
        var fixCenter = CGPoint(x: CGFloat.greatestFiniteMagnitude,
                                y: CGFloat.greatestFiniteMagnitude)
        
        for attribute in layoutAttributesForElements(in: targetRect) ?? [] {
            if abs(attribute.center.x - targetCenter.x) < abs(fixCenter.x)  {
                fixCenter.x = attribute.center.x - targetCenter.x
            }
            if abs(attribute.center.y - targetCenter.y) < abs(fixCenter.y)  {
                fixCenter.y = attribute.center.y - targetCenter.y
            }
        }
        
        switch scrollDirection {
        case .vertical:
            fixCenter.x = 0
        case .horizontal:
            fixCenter.y = 0
        }
        
        return CGPoint(x: proposedContentOffset.x + fixCenter.x,
                       y: proposedContentOffset.y + fixCenter.y)
    }
}
