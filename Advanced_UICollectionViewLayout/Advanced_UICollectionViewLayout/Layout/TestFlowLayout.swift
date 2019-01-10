//
//  TestFlowLayout.swift
//  Advanced_UICollectionViewLayout
//
//  Created by zhong on 2018/12/31.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class TestFlowLayout: UICollectionViewFlowLayout {
    var name: String
    
    init(name: String) {
        print("---\(name) Born")
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        print("---\(name) \(#function)")
        let size = super.collectionViewContentSize
        //        print(size)
        return size
    }
    
    override func prepare() {
        print("---\(name) \(#function)")
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("---\(name) \(#function) \(rect)")
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        //        print(attributes)
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("---\(name) \(#function) \(indexPath)")
        guard let attribute = super.layoutAttributesForItem(at: indexPath) else { return nil }
        //        print(attribute)
        return attribute
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("---\(name) \(#function) \(itemIndexPath)")
        guard let attribute = super.layoutAttributesForItem(at: itemIndexPath) else { return nil }
        //        print(attribute)
        return attribute
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("---\(name) \(#function) \(itemIndexPath)")
        guard let attribute = super.layoutAttributesForItem(at: itemIndexPath) else { return nil }
        //        print(attribute)
        return attribute
    }
    
    override func finalizeCollectionViewUpdates() {
        print("---\(name) \(#function)")
        super.finalizeCollectionViewUpdates()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        print("---\(name) \(#function) \(newBounds) \(collectionView!.frame)")
        let should = super.shouldInvalidateLayout(forBoundsChange: newBounds)
        //        print(should)
        return should
    }
    
    override func invalidateLayout() {
        print("---\(name) \(#function)")
        super.invalidateLayout()
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        print("---\(name) \(#function) \(context)")
        
        ///this line cause crash
//        super.invalidateLayout(with: context)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        print("---\(name) \(#function) \(newBounds)")
        let context = super.invalidationContext(forBoundsChange: newBounds)
        return context
    }
    
    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        print("---\(name) \(#function) \(preferredAttributes) \(originalAttributes)")
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        return context
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        print("---\(name) \(#function) \(preferredAttributes) \(originalAttributes)")
        let should = super.shouldInvalidateLayout(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        //        print(should)
        return should
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        print("---\(name) \(#function) \(proposedContentOffset)")
        let target = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        //        print(target)
        return target
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        print("---\(name) \(#function) \(proposedContentOffset) \(velocity)")
        let target = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        //        print(target)
        return target
    }
    
    override func targetIndexPath(forInteractivelyMovingItem previousIndexPath: IndexPath, withPosition position: CGPoint) -> IndexPath {
        print("---\(name) \(#function) \(previousIndexPath) \(position)")
        let target = super.targetIndexPath(forInteractivelyMovingItem: previousIndexPath, withPosition: position)
        //        print(target)
        return target
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        print("---\(name) \(#function) \(updateItems)")
        super.prepare(forCollectionViewUpdates: updateItems)
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        print("---\(name) \(#function) \(oldBounds)")
        super.prepare(forAnimatedBoundsChange: oldBounds)
    }
    
    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        print("---\(name) \(#function) \(oldLayout)")
        super.prepareForTransition(from: oldLayout)
    }
    
    override func prepareForTransition(to newLayout: UICollectionViewLayout) {
        print("---\(name) \(#function) \(newLayout)")
        super.prepareForTransition(to: newLayout)
    }
    
    override func finalizeAnimatedBoundsChange() {
        print("---\(name) \(#function)")
        super.finalizeAnimatedBoundsChange()
    }
    
    override func finalizeLayoutTransition() {
        print("---\(name) \(#function)")
        super.finalizeLayoutTransition()
    }
    
    deinit {
        print("---\(name) Dead")
    }
}
