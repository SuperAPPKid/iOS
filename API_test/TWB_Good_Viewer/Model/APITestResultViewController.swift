//
//  APITestResultViewController.swift
//  TWB_Good_Viewer
//
//  Created by Hank_Zhong on 2018/6/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class APITestResultViewController: UIViewController {
    @IBOutlet weak var responseView: UITextView!
    @IBOutlet weak var imageViewContainer: UIStackView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    lazy var imageViews:[UIImageView] = {
        [unowned self] in
        guard let imageViews = self.imageViewContainer.subviews as? [UIImageView] else {
            return []
        }
        return imageViews
        }()
    
    var imageDatas:[Data] = Array(repeating: Data(), count: 3) {
        didSet {
//            DispatchQueue.main.async {
//                var images = Array(repeating: UIImage(), count: 3)
//                for (index,data) in self.imageDatas.enumerated() {
//                    images[index] = UIImage(data: data)?.resizeImage(targetSize:self.imageViews[index].frame.size) ?? UIImage()
//                }
//                var index = 0
//                self.imageViews.forEach { (imageView) in
//                    imageView.image = images[index]
//                    index += 1
//                }
//            }
        }
    }

    var response:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        responseView.text = response
    }
    
    func setImage() {
        var images = Array(repeating: UIImage(), count: 3)
        for (index,data) in imageDatas.enumerated() {
            images[index] = UIImage(data: data)?.resizeImage(targetSize:imageViews[index].frame.size) ?? UIImage()
        }
        var index = 0
        imageViews.forEach { (imageView) in
            imageView.image = images[index]
            index += 1
        }
    }
    
    func setProgressHidden(setHidden:Bool) {
        self.progressBar.isHidden = setHidden ? true:false
    }
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
