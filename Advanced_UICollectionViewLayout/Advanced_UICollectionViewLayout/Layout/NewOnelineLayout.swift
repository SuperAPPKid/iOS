//
//  NewOnelineLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by zhong on 2018/12/31.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class NewOnelineLayout: UICollectionViewLayout {
    typealias Scale = (x: CGFloat, y: CGFloat)
    enum Direction {
        case vertical, horizontal
    }
    
    var preferDirection: Direction = .vertical
    var preferSpace: CGFloat
    var preferSize: CGSize
    var maxZoomScale: Scale = (0.87, 0.87)
    var minimumZoomScope: CGFloat?
    
    private var _count: Int = 0
    private var _contentSize: CGSize = .zero
    private var _collectionViewBounds: CGRect = .zero
    private var cachedAttributes: [UICollectionViewLayoutAttributes?] = []
    
    override var collectionViewContentSize: CGSize {
        return _contentSize
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
        cachedAttributes.removeAll()
        guard let collectionView = collectionView else {
            _contentSize = .zero
            _collectionViewBounds = .zero
            return
        }
        
        _count = collectionView.numberOfItems(inSection: 0)
        cachedAttributes = Array(repeating: nil, count: _count)
        _collectionViewBounds = collectionView.bounds
        
        switch preferDirection {
        case .horizontal:
            _contentSize.width = (preferSize.width + preferSpace) * CGFloat(_count) - preferSpace + _collectionViewBounds.width - preferSize.width
            _contentSize.height = _collectionViewBounds.height
        case .vertical:
            _contentSize.width = _collectionViewBounds.width
            _contentSize.height = (preferSize.height + preferSpace) * CGFloat(_count) - preferSpace + _collectionViewBounds.height - preferSize.height
        }
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
        if let cached = cachedAttributes[indexPath.row] { return cached }
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var rect = CGRect.zero
        rect.size = preferSize
        switch preferDirection {
        case .horizontal:
            rect.origin = CGPoint(x: (preferSize.width + preferSpace) * CGFloat(indexPath.row) + (_collectionViewBounds.width - preferSize.width) / 2,
                                  y: (_collectionViewBounds.height - preferSize.height) / 2)
        case .vertical:
            rect.origin = CGPoint(x: (_collectionViewBounds.width - preferSize.width) / 2,
                                  y: (preferSize.height + preferSpace) * CGFloat(indexPath.row) + (_collectionViewBounds.height - preferSize.height) / 2)
        }
        attribute.frame = rect
        transform(attribute: attribute)
        cachedAttributes[indexPath.row] = attribute
        if attribute.indexPath.row == 2 {
            print("notcached \(attribute)")
        }
        return attribute
    }
    
    func transform(attribute: UICollectionViewLayoutAttributes?) {
        guard let attribute = attribute else { return }
        if attribute.indexPath.row == 2 {
            print("transform \(attribute)")
            print("\(_collectionViewBounds) \(_contentSize)")
        }
        var activeDistance = CGFloat(0)
        switch preferDirection {
        case .vertical:
            activeDistance = abs((minimumZoomScope ?? _collectionViewBounds.height) / 2)
        case .horizontal:
            activeDistance = abs((minimumZoomScope ?? _collectionViewBounds.width) / 2)
        }
        
        let triggerRect = CGRect(x: _collectionViewBounds.midX,
                                 y: _collectionViewBounds.midY,
                                 width: 0,
                                 height: 0).insetBy(dx: -activeDistance, dy: -activeDistance)
        if triggerRect.intersects(attribute.frame) {
            var distance = CGFloat(0)
            switch preferDirection {
            case .vertical:
                distance = (attribute.center.y - triggerRect.midY)
            case .horizontal:
                distance = (attribute.center.x - triggerRect.midX)
            }
            
            if abs(distance) < activeDistance {
                let stdDistance = abs(distance / activeDistance)
                let zoomX =  1 + (maxZoomScale.x - 1) * (1 - stdDistance)
                let zoomY =  1 + (maxZoomScale.y - 1) * (1 - stdDistance)
                attribute.transform = CGAffineTransform(scaleX: zoomX, y: zoomY)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let targetCenter = CGPoint(x: proposedContentOffset.x + _collectionViewBounds.width / 2,
                                   y: proposedContentOffset.y + _collectionViewBounds.height / 2)

        let targetRect = CGRect(origin: proposedContentOffset,
                                size: _collectionViewBounds.size)

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
        case .horizontal:
            fixCenter.y = 0
        }

        return CGPoint(x: proposedContentOffset.x + fixCenter.x,
                       y: proposedContentOffset.y + fixCenter.y)
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = layoutAttributesForItem(at: itemIndexPath)
        return attribute
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = layoutAttributesForItem(at: itemIndexPath)
        return attribute
    }
}

