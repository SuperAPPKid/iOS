//
//  TestFlowLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by zhong on 2018/12/31.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class TestFlowLayout: UICollectionViewFlowLayout {
    override init() {
        print("---\(type(of: self)) Born")
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        print("---\(type(of: self)) \(#function)")
        let size = super.collectionViewContentSize
        //        print(size)
        return size
    }
    
    override func prepare() {
        print("---\(type(of: self)) \(#function)")
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("---\(type(of: self)) \(#function) \(rect)")
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        //        print(attributes)
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("---\(type(of: self)) \(#function) \(indexPath)")
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        //        print(attribute)
        return attribute
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("---\(type(of: self)) \(#function) \(itemIndexPath)")
        guard let attribute = super.layoutAttributesForItem(at: itemIndexPath) else { return nil }
        //        print(attribute)
        return attribute
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("---\(type(of: self)) \(#function) \(itemIndexPath)")
        guard let attribute = super.layoutAttributesForItem(at: itemIndexPath) else { return nil }
        //        print(attribute)
        return attribute
    }
    
    override func finalizeCollectionViewUpdates() {
        print("---\(type(of: self)) \(#function)")
        super.finalizeCollectionViewUpdates()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        print("---\(type(of: self)) \(#function) \(newBounds) \(collectionView!.frame)")
        let should = super.shouldInvalidateLayout(forBoundsChange: newBounds)
        //        print(should)
        return should
    }
    
    override func invalidateLayout() {
        print("---\(type(of: self)) \(#function)")
        super.invalidateLayout()
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        print("---\(type(of: self)) \(#function) \(context)")
        super.invalidateLayout(with: context)
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        print("---\(type(of: self)) \(#function) \(preferredAttributes) \(originalAttributes)")
        let should = super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        //        print(should)
        return should
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        print("---\(type(of: self)) \(#function) \(proposedContentOffset)")
        let target = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        //        print(target)
        return target
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        print("---\(type(of: self)) \(#function) \(proposedContentOffset) \(velocity)")
        let target = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        //        print(target)
        return target
    }
    
    override func targetIndexPath(forInteractivelyMovingItem previousIndexPath: IndexPath, withPosition position: CGPoint) -> IndexPath {
        print("---\(type(of: self)) \(#function) \(previousIndexPath) \(position)")
        let target = super.targetIndexPath(forInteractivelyMovingItem: previousIndexPath, withPosition: position)
        //        print(target)
        return target
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        print("---\(type(of: self)) \(#function) \(updateItems)")
        super.prepare(forCollectionViewUpdates: updateItems)
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        print("---\(type(of: self)) \(#function) \(oldBounds)")
        super.prepare(forAnimatedBoundsChange: oldBounds)
    }
    
    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        print("---\(type(of: self)) \(#function) \(oldLayout)")
        super.prepareForTransition(from: oldLayout)
    }
    
    override func prepareForTransition(to newLayout: UICollectionViewLayout) {
        print("---\(type(of: self)) \(#function) \(newLayout)")
        super.prepareForTransition(to: newLayout)
    }
    
    override func finalizeAnimatedBoundsChange() {
        print("---\(type(of: self)) \(#function)")
        super.finalizeAnimatedBoundsChange()
    }
    
    override func finalizeLayoutTransition() {
        print("---\(type(of: self)) \(#function)")
        super.finalizeLayoutTransition()
    }
    
    deinit {
        print("---\(type(of: self)) Dead")
    }
}
