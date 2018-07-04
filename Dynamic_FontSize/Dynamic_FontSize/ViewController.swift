//
//  ViewController.swift
//  Dynamic_FontSize
//
//  Created by zhong on 2018/7/1.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        label.center = view.center
        label.text = "Hello World!!"
        label.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        label.textAlignment = .center
        label.fitTextToBounds()
        view.addSubview(label)
    }

}

extension UIFont {
    
    static func bestFitFontSize(for text: String, in bounds: CGRect, fontName: String) -> CGFloat? {
        var maxFontSize: CGFloat = 32.0 // UIKit best renders with factors of 2
        guard let maxFont = UIFont(name: fontName, size: maxFontSize) else {
            return nil
        }
        
        let textWidth = text.width(withConstraintedHeight: bounds.height, font: maxFont)
        let textHeight = text.height(withConstrainedWidth: bounds.width, font: maxFont)
        
        let scalingFactor = min(bounds.width / textWidth, bounds.height / textHeight)
        
        maxFontSize *= scalingFactor
        
        return floor(maxFontSize)
    }
    
}

fileprivate extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
extension UILabel {
    
    func fitTextToBounds() {
        guard let text = text, let currentFont = font else { return }
        
        if let dynamicFontSize = UIFont.bestFitFontSize(for: text, in: bounds, fontName: currentFont.fontName) {
            font = UIFont(name: currentFont.fontName, size: dynamicFontSize)
        }
    }
    
}
