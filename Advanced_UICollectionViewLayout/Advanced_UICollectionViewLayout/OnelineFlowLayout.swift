//
//  OnelineFlowLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/25.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class OnelineFlowLayout: UICollectionViewFlowLayout {
    
    override var minimumInteritemSpacing: CGFloat {
        get {
            return .greatestFiniteMagnitude
        }
        set {
            print("Do nothing")
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint.zero
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
}
