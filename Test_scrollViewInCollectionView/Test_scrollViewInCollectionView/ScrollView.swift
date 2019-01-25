//
//  ScrollView.swift
//  Test_scrollViewInCollectionView
//
//  Created by Hank_Zhong on 2019/1/24.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        panGestureRecognizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is UICollectionView {
            if zoomScale != 1.0 {
                return true
            }
        }
        return false
    }
}
