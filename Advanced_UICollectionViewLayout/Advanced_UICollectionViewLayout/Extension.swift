//
//  Extension.swift
//  Advanced_UICollectionViewLayout
//
//  Created by zhong on 2018/12/31.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

extension Collection {
    subscript(safe position: Index) -> Element? {
        if position >= endIndex {
            return nil
        }
        return self[position]
    }
}

extension CGRect {
    func  dividedIntegral(fraction: CGFloat, space: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.slice.size.width -= (space * 0.5)
            slices.remainder.origin.x += (space * 0.5)
            slices.remainder.size.width -= (space * 0.5)
        case .minYEdge, .maxYEdge:
            slices.slice.size.height -= (space * 0.5)
            slices.remainder.origin.y += (space * 0.5)
            slices.remainder.size.height -= (space * 0.5)
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}

extension UIColor {
    var reversed: UIColor {
        let components = self.cgColor.components
        return UIColor(displayP3Red: 1 - (components?[safe: 0] ?? 0),
                       green: 1 - (components?[safe: 1] ?? 0),
                       blue: 1 - (components?[safe: 2] ?? 0),
                       alpha: components?[safe: 3] ?? 1)
    }
    
    static func random(alpha: CGFloat) -> UIColor {
        return UIColor(displayP3Red: CGFloat.random(in: 0.7...0.9), green: CGFloat.random(in: 0.7...0.9), blue: CGFloat.random(in: 0.7...0.9), alpha: alpha)
    }
}
