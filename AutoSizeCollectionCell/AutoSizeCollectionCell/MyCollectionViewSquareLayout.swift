//
//  MyCollectionViewLayout.swift
//  AutoSizeCollectionCell
//
//  Created by zhong on 2018/6/3.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit
protocol MyCollectionViewSquareLayoutDelegate {
    func sizeForCell(at indexPath:IndexPath,with padding:CGFloat,and insets:CGFloat) -> CGSize
    func checkVertical(by indexPath:IndexPath) -> Bool
}
class MyCollectionViewSquareLayout: UICollectionViewLayout {
    var delegate:MyCollectionViewSquareLayoutDelegate!
    var attrsArray:[UICollectionViewLayoutAttributes] = []
    var padding:CGFloat = 10
    var edgeInsets:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var columnCount:CGFloat = 0
    
    var collectionViewContentW:CGFloat {
        if let width = self.collectionView?.frame.width {
            return width
        } else {
            return 0
        }
    }
    var collectionViewContentH:CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewContentW, height:collectionViewContentH)
    }
    
    init(columnCount:CGFloat) {
        super.init()
        self.columnCount = columnCount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        //Init CollectionViewContentHeight
        collectionViewContentH = edgeInsets.top
        
        //Get Big Row
        guard let itemCount = collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        var bigGroup = 0
        var bigIndexPath = IndexPath(row: 0, section: 0)
        out: for i in stride(from: 0, to: Float(itemCount) / Float(columnCount), by: 1.0) {
            for j in Int(i) * Int(columnCount) ..< min(Int(i + 1) * Int(columnCount), itemCount)  {
                if delegate.checkVertical(by: IndexPath(row: j, section: 0)) {
                    bigGroup = Int(i)
                    bigIndexPath = IndexPath(row: j, section: 0)
                    break out
                }
            }
        }
        
        //Setup Cell
        attrsArray.removeAll()
        collectionViewContentH = 0
        for i in 0 ... itemCount / Int(columnCount) {
            let oldCollectionViewContentH = collectionViewContentH
            for j in i * Int(columnCount) ..< min((i + 1) * Int(columnCount), itemCount)  {
                let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: j, section: 0))
                let cellSize = delegate.sizeForCell(at: IndexPath(row: j, section: 0), with: padding, and: edgeInsets.left)
                var cellX:CGFloat = 0
                var cellY:CGFloat = 0
                if i == bigGroup {
                    if j == bigIndexPath.row {
                        if bigIndexPath.row % Int(columnCount) <= Int(columnCount) / 2 {
                            cellX = edgeInsets.left
                        } else {
                            cellX = collectionViewContentW - edgeInsets.right - cellSize.width
                        }
                        cellY = oldCollectionViewContentH
                    } else {
                        if bigIndexPath.row % Int(columnCount) <= Int(columnCount) / 2 {
                            cellX = collectionViewContentW - edgeInsets.right - cellSize.width
                        } else {
                            cellX = edgeInsets.left
                        }
                        cellY = collectionViewContentH
                        collectionViewContentH = collectionViewContentH + cellSize.height + padding
                    }
                } else {
                    cellX = edgeInsets.left + (cellSize.width + padding) * CGFloat(j % Int(columnCount))
                    cellY = collectionViewContentH
                }
                attrs.frame = CGRect(origin: CGPoint(x: cellX, y: cellY), size: cellSize)
                attrsArray.append(attrs)
            }
            if i != bigGroup {
                collectionViewContentH += (collectionViewContentW - edgeInsets.left - edgeInsets.right - padding * (columnCount - 1)) / columnCount
                collectionViewContentH += padding
            }
        }
        collectionViewContentH = attrsArray.last?.frame.maxY ?? collectionViewContentH
        collectionViewContentH += edgeInsets.bottom
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
