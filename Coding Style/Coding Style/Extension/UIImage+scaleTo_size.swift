//
//  UIImage+scaleTo_size.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

extension UIImage {
    func scaleTo(size: CGSize, needTrim: Bool, renderMode: UIImageRenderingMode) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let imageHeightScale = size.height / self.size.height
        let imageWidthScale = size.width / self.size.width
        let usingScale = needTrim ? max(imageHeightScale, imageWidthScale):min(imageHeightScale, imageWidthScale)
        let imageNewHeight = self.size.height * usingScale
        let imageNewWidth = self.size.width * usingScale
        let usingTranslateX = size.width - imageNewWidth
        let usingTranslateY = size.height - imageNewHeight
        self.draw(in: CGRect(x: usingTranslateX / 2, y: usingTranslateY / 2, width: imageNewWidth, height: imageNewHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderMode)
        UIGraphicsEndImageContext()
        return image
    }
}
