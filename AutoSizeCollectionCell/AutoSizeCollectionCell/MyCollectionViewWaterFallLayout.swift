//
//  MyCollectionViewWaterFlowLayout.swift
//  AutoSizeCollectionCell
//
//  Created by zhong on 2018/6/3.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit
protocol MyCollectionViewWaterFallLayoutDelegate {
    func heightForCell(at indexPath:IndexPath) -> CGFloat
}
class MyCollectionViewWaterFallLayout: UICollectionViewLayout {
    var delegate:MyCollectionViewWaterFallLayoutDelegate!
    var columnCount = 3
    var columnMargin:CGFloat = 10
    var rowMargin:CGFloat = 10
    var edgeInsets:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var columnHeights:[CGFloat] = [CGFloat]()
    var attrsArray:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var collectionViewWidth:CGFloat {
        guard let width = collectionView?.frame.width else {
            return 0
        }
        return width
    }
    override var collectionViewContentSize: CGSize{
        var maxHeight:CGFloat = 0
        for attrs in attrsArray {
            if attrs.frame.maxY > maxHeight {
                maxHeight = attrs.frame.maxY
            }
        }
       return CGSize(width: collectionViewWidth, height:maxHeight + edgeInsets.bottom)
    }
    
    override func prepare() {
        super.prepare()
        
        columnHeights.removeAll()
        for _ in 0..<columnCount {
            columnHeights.append(edgeInsets.top)
        }
        
        attrsArray.removeAll()
        guard let count = collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        for i in 0..<count{
            guard let attrs = layoutAttributesForItem(at: IndexPath(row: i, section: 0)) else {
                return
            }
            attrsArray.append(attrs)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //Set Cell Frame
        let cellW = (collectionViewWidth - edgeInsets.left - edgeInsets.right - CGFloat(columnCount - 1) * rowMargin) / CGFloat(columnCount)
        let cellH = delegate.heightForCell(at: indexPath)
        var minColumnIndex = 0
        var minColumnHeight = columnHeights[minColumnIndex]
        for i in 0..<columnCount {
            if minColumnHeight > columnHeights[i] {
                minColumnHeight = columnHeights[i]
                minColumnIndex = i
            }
        }
        let cellX = edgeInsets.left + CGFloat(minColumnIndex) * (cellW + columnMargin)
        var cellY = minColumnHeight
        if (cellY != self.edgeInsets.top) {
            cellY += self.rowMargin;
        }
        attrs.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
        
        columnHeights[minColumnIndex] = attrs.frame.maxY
        
        return attrs
    }
}
