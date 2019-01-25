//
//  CollectionViewCell.swift
//  Test_scrollViewInCollectionView
//
//  Created by Hank_Zhong on 2019/1/24.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    let scrollView = ScrollView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "when-should-give-child-phone-kid-using-smart-phone"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.bounces = false
        
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.frame = contentView.bounds
        contentView.addSubview(scrollView)
        
        imageView.frame = scrollView.bounds
        scrollView.addSubview(imageView)
        
        scrollView.delegate = self
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let top = (scrollView.frame.height - imageView.frame.height) / 2
        let left = (scrollView.frame.width - imageView.frame.width) / 2
        scrollView.contentInset = UIEdgeInsets(top: max(0, top), left: max(0, left), bottom: 0, right: 0)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale,
                                                 center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
