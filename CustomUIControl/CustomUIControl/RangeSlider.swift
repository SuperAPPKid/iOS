//
//  RangeSlider.swift
//  CustomUIControl
//
//  Created by Hank_Zhong on 2019/2/19.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {
    var minimumValue: CGFloat = 0.0 {
        didSet {
            updateSublayers()
        }
    }
    var maximumValue: CGFloat = 1.0 {
        didSet {
            updateSublayers()
        }
    }
    var lowerValue: CGFloat = 0.2 {
        didSet {
            updateSublayers()
        }
    }
    var upperValue: CGFloat = 0.8 {
        didSet {
            updateSublayers()
        }
    }
    
    //appearance
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var thumbTintColor: UIColor = .white{
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    var curvaceousness : CGFloat = 1.0 {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
            trackLayer.setNeedsDisplay()
        }
    }
    
    //layers
    private let trackLayer: TrackLayer = TrackLayer()
    private let lowerThumbLayer: ThumbLayer = ThumbLayer()
    private let upperThumbLayer: ThumbLayer = ThumbLayer()
    
    private var thumbWidth: CGFloat {
        return bounds.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        trackLayer.contentsScale = UIScreen.main.scale
        trackLayer.rangeSlider = self
        trackLayer.setNeedsDisplay()
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.setNeedsDisplay()
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.contentsScale = UIScreen.main.scale
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.setNeedsDisplay()
        layer.addSublayer(upperThumbLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        print("\(#function) \(frame)")
        super.layoutSubviews()
    }
    
    private func updateSublayers() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let lowerThumbCenter = center(for: lowerValue)
        let upperThumbCenter = center(for: upperValue)
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter.x - thumbWidth / 2, y: 0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.frame = CGRect(x: upperThumbCenter.x - thumbWidth / 2, y: 0, width: thumbWidth, height: thumbWidth)
        
        trackLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        print("\(#function) \(layer) \(layer.frame)")
        super.layoutSublayers(of: layer)
        
        trackLayer.frame = bounds.insetBy(dx: 0, dy: bounds.height / 3)
        
        updateSublayers()
    }
    
    fileprivate func center(for value: CGFloat) -> CGPoint {
        let x = (bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + thumbWidth / 2
        let y = thumbWidth / 2
        return CGPoint(x: x, y: y)
    }
    
    //MARK: UIControl Override
    private var latestLocation: CGPoint = .zero
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print("Begin")
        latestLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(latestLocation) {
            lowerThumbLayer.isHighlighted = true
        }
        
        if upperThumbLayer.frame.contains(latestLocation) {
            upperThumbLayer.isHighlighted = true
        }
        
        needDelay = upperThumbLayer.isHighlighted  && lowerThumbLayer.isHighlighted
        
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    var needDelay: Bool = false
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        print("Continue")
        
        let location = touch.location(in: self)
        let deltaDistance = location.x - latestLocation.x
        
        let deltaValue = (maximumValue - minimumValue) * deltaDistance / (bounds.width - thumbWidth)
        latestLocation = location
        
        if needDelay {
            if deltaValue != 0 {
                needDelay = false
                lowerThumbLayer.isHighlighted = deltaValue < 0
                upperThumbLayer.isHighlighted = deltaValue > 0
            }
        } else {
            if lowerThumbLayer.isHighlighted {
                lowerValue = min(max(minimumValue, lowerValue + deltaValue), upperValue)
                lowerThumbLayer.setNeedsLayout()
            }
            if upperThumbLayer.isHighlighted {
                upperValue = min(max(lowerValue, upperValue + deltaValue), maximumValue)
                upperThumbLayer.setNeedsLayout()
            }
            
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
        print("End")
    }
    
    override func cancelTracking(with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
        print("Cancel")
    }
}

fileprivate class TrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 10, dy: 0), cornerRadius: cornerRadius)
            
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            let lowerCenter = slider.center(for: slider.lowerValue)
            let upperCenter = slider.center(for: slider.upperValue)
            let rect = CGRect(x: lowerCenter.x, y: 0, width: upperCenter.x - lowerCenter.x, height: bounds.height)
            ctx.fill(rect)
        }
    }
}

fileprivate class ThumbLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    var isHighlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            let thumbFrame = bounds.insetBy(dx: 10, dy: 10)
            let cornerRadius = thumbFrame.height * slider.curvaceousness / 2
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            
            ctx.setShadow(offset: .init(width: 0.2, height: 0.2), blur: 2, color: UIColor.darkGray.cgColor)
            ctx.setFillColor(slider.thumbTintColor.cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
            
            ctx.setStrokeColor(UIColor.darkGray.cgColor)
            ctx.setLineWidth(1)
            ctx.addPath(thumbPath.cgPath)
            ctx.strokePath()
            
            if isHighlighted {
                ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
                ctx.addPath(thumbPath.cgPath)
                ctx.fillPath()
            }
        }
    }
//    override func action(forKey event: String) -> CAAction? {
//        return nil
//    }
}
