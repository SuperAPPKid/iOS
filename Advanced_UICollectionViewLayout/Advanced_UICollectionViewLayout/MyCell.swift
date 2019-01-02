//
//  MyCell.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2019/1/2.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
    private var titleLabel = UILabel()
    var text: String? {
        get {
            return titleLabel.text
        }
        set(new) {
            titleLabel.text = new
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            titleLabel.textColor = backgroundColor
            titleLabel.backgroundColor = backgroundColor?.reversed
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 20
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Noteworthy-Bold", size: 14)!
        addSubview(titleLabel)
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.willTransition(from: oldLayout, to: newLayout)
        UIView.performWithoutAnimation {
            self.titleLabel.alpha = 0
        }
    }
    
    override func didTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        super.didTransition(from: oldLayout, to: newLayout)
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 1
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }
}
