//
//  WaterFallLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/2.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

protocol WaterFallLayoutDelegate: AnyObject {
    func waterFall(layout: WaterFallLayout, heightFor indexPath: IndexPath) -> CGFloat
}

class WaterFallLayout: UICollectionViewFlowLayout {
    weak var delegate: WaterFallLayoutDelegate?
    
    var columnCount = 3
    var columnSpace = CGFloat(10)
    var rowSpace = CGFloat(10)
    var edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var columnHeights = [CGFloat]()
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    private var collectionViewWidth: CGFloat {
        guard let width = collectionView?.frame.width else {
            return 0
        }
        return width
    }
    
    override var collectionViewContentSize: CGSize{
        var maxHeight:CGFloat = 0
        for attrs in cachedAttributes {
            if attrs.frame.maxY > maxHeight {
                maxHeight = attrs.frame.maxY
            }
        }
        return CGSize(width: collectionViewWidth, height:maxHeight + edgeInsets.bottom)
    }
    
    override func prepare() {
        super.prepare()
        cachedAttributes.removeAll()
        columnHeights.removeAll()
        
        for _ in 0 ..< columnCount {
            columnHeights.append(edgeInsets.top)
        }
        
        guard let count = collectionView?.numberOfItems(inSection: 0) else { return }
        for row in 0 ..< count {
            let indexPath = IndexPath(row: row, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            //Set Cell Frame
            let cellW = (collectionViewWidth - edgeInsets.left - edgeInsets.right - CGFloat(columnCount - 1) * rowSpace) / CGFloat(columnCount)
            let cellH = delegate?.waterFall(layout: self, heightFor: indexPath) ?? 100
            
            var minColumnIndex = 0
            var minColumnHeight = columnHeights[minColumnIndex]
            
            for i in 0 ..< columnCount {
                if minColumnHeight > columnHeights[i] {
                    minColumnHeight = columnHeights[i]
                    minColumnIndex = i
                }
            }
            
            let cellX = edgeInsets.left + CGFloat(minColumnIndex) * (cellW + columnSpace)
            var cellY = minColumnHeight
            
            if (cellY != edgeInsets.top) {
                cellY += rowSpace;
            }
            attrs.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            
            columnHeights[minColumnIndex] = attrs.frame.maxY
            cachedAttributes.append(attrs)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.row]
    }
}
