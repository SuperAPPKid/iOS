
//
//  Protocol.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/10.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

enum BothSideFixBound {
    case Horizontal(lowerBound: CGFloat, upperBound: CGFloat)
    case Vertical(lowerBound: CGFloat, upperBound: CGFloat)
    case None
}
protocol BothSideScrollable {
    var fixBound: BothSideFixBound { get }
}

protocol CustomLayoutTransition {
    func contentOffset(for: IndexPath) -> CGPoint ///use the function to calculate attribute
    var centerIndexPath: IndexPath { get }
}
