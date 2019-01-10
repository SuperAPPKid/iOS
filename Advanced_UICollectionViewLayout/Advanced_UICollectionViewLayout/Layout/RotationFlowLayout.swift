//
//  My242FlowLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/22.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class RotationFlowLayout: UICollectionViewFlowLayout, HasDefaultLazyLayout {
    
    static func defaultLazy() -> DefaultLazyStructure<RotationFlowLayout> {
        return DefaultLazyStructure {
            let layout = RotationFlowLayout()
            let itemLength = (layout.collectionView?.bounds.width ?? UIScreen.main.bounds.width - 40) / 3
            layout.itemSize = CGSize(width: itemLength, height: itemLength)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        attributes.forEach { (attribute) in
            let row = attribute.indexPath.row
            attribute.transform = CGAffineTransform(rotationAngle: .pi * (CGFloat(row) / 10))
                .concatenating(.init(scaleX: 0.3 * CGFloat(row % 4 + 1), y: 0.3 * CGFloat(row % 4 + 1)))
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        attribute.transform = CGAffineTransform(rotationAngle: .pi * (CGFloat(attribute.indexPath.row) / 10))
            .concatenating(.init(scaleX: 0.3 * CGFloat(attribute.indexPath.row % 4 + 1), y: 0.3 * CGFloat(attribute.indexPath.row % 4 + 1)))
        
        return attribute
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        print("\(#function) \(context)")
    }
}
