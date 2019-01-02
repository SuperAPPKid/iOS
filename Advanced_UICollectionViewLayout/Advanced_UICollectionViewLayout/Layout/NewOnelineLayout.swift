//
//  NewOnelineLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by zhong on 2018/12/31.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class NewOnelineLayout: UICollectionViewLayout {
    enum Direction {
        case vertical, horizon
    }
    
    var preferDirection: Direction = .vertical
    
    var preferSpace: CGFloat
    var preferSize: CGSize
    
    var maxZoomScale: CGFloat = 0.87
    var minimumZoomScope: CGFloat?
    
    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    init(size: CGSize, space: CGFloat) {
        self.preferSize = size
        self.preferSpace = space
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentSize = .zero
        
        for i in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: .init(row: i, section: 0))
            var rect = CGRect.zero
            rect.size = preferSize
            switch preferDirection {
            case .horizon:
                rect.origin = CGPoint(x: (preferSize.width + preferSpace) * CGFloat(i) + (collectionView.bounds.width - preferSize.width) / 2,
                                      y: (collectionView.bounds.height - preferSize.height) / 2)
                contentSize = CGSize(width: rect.maxX, height: collectionView.bounds.height)
            case .vertical:
                rect.origin = CGPoint(x: (collectionView.bounds.width - preferSize.width) / 2,
                                      y: (preferSize.height + preferSpace) * CGFloat(i) + (collectionView.bounds.height - preferSize.height) / 2)
                contentSize = CGSize(width: collectionView.bounds.width, height: rect.maxY)
            }
            
            attribute.frame = rect
            setTransform(attribute: attribute)
            cachedAttributes.append(attribute)
        }
        
        switch preferDirection {
        case .horizon:
            contentSize.width += (collectionView.bounds.width - preferSize.width) / 2
        case .vertical:
            contentSize.height += (collectionView.bounds.height - preferSize.height) / 2
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[safe: indexPath.row]
    }
    
    func setTransform(attribute: UICollectionViewLayoutAttributes?) {
        guard let collectionView = collectionView, let attribute = attribute else { return }
        var activeDistance = CGFloat(0)
        switch preferDirection {
        case .vertical:
            activeDistance = abs((minimumZoomScope ?? collectionView.bounds.height) / 2)
        case .horizon:
            activeDistance = abs((minimumZoomScope ?? collectionView.bounds.width) / 2)
        }
        
        let triggerRect = CGRect(x: collectionView.bounds.midX,
                                 y: collectionView.bounds.midY,
                                 width: 0,
                                 height: 0).insetBy(dx: -activeDistance, dy: -activeDistance)
        if triggerRect.intersects(attribute.frame) {
            var distance = CGFloat(0)
            switch preferDirection {
            case .vertical:
                distance = (attribute.center.y - triggerRect.midY)
            case .horizon:
                distance = (attribute.center.x - triggerRect.midX)
            }
            
            if abs(distance) < activeDistance {
                let stdDistance = abs(distance / activeDistance)
                let zoom =  1 + (maxZoomScale - 1) * (1 - stdDistance)
                attribute.transform = CGAffineTransform(scaleX: zoom, y: zoom)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
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
        
        switch preferDirection {
        case .vertical:
            fixCenter.x = 0
        case .horizon:
            fixCenter.y = 0
        }
        
        return CGPoint(x: proposedContentOffset.x + fixCenter.x,
                       y: proposedContentOffset.y + fixCenter.y)
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = cachedAttributes[safe: itemIndexPath.row]
        setTransform(attribute: attr)
        return attr
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = cachedAttributes[safe: itemIndexPath.row]
        setTransform(attribute: attr)
        return attr
    }
    
    
}

