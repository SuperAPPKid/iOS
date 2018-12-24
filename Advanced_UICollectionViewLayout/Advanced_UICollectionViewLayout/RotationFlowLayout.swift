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
    
    override func prepare() {
        print(#function)
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        print("\(#function) \(newBounds) \(collectionView!.frame)")
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("\(#function) \(rect)")
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        attributes.forEach{ $0.transform = CGAffineTransform(rotationAngle: .pi * (CGFloat($0.indexPath.row) / 10)) }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("\(#function) \(indexPath)")
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        attribute.transform = CGAffineTransform(rotationAngle: .pi * (CGFloat(attribute.indexPath.row) / 10))
        return attribute
    }
}
