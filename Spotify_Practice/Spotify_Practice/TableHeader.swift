//
//  TableHeader.swift
//  Spotify_Practice
//
//  Created by zhong on 2018/7/4.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class TableHeader: UIView {
    
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbView.clipsToBounds = true
        thumbView.layer.cornerRadius = 75
//        print("awake")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layout")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        print("draw")
    }

    @IBAction func didSlide(_ sender: UISlider) {
        pageControl.currentPage = Int(sender.value * 5.0)
    }
    
    
}
