//
//  CellViewModel.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/16.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class CellViewModel: ViewModel {
    var titleElement: ObserveElement<String>?
    var needFetchElement: ObserveElement<Bool>?
    var progressElement: ObserveElement<Float>?
    var imageElement: ObserveElement<UIImage>?
    
    let imageName: String
    var downloadQueue: OperationQueue?
    
    init(title: String, imageName: String) {
        self.imageName = imageName
        needFetchElement = generateObserveElement(value: false)
        progressElement = generateObserveElement(value: 0.0)
        imageElement = generateObserveElement()
        titleElement = generateObserveElement(value: title)
    }
    
    func fetchImage(size: CGSize, _ callback: @escaping (UIImage?, Error?) -> ()) {
        guard let needFetch = needFetchElement?.value,
              let progress = progressElement?.value,
              imageElement?.value == nil else { return }
        
        if !needFetch {
            if progress != 0.0 && progress != 1.0 {
                ///暫停
                SimulateImageService.shared.stop(queue: downloadQueue)
            }
            return
        }
        
        let reportProgress: ((Float)->()) = { [weak self] (value) in
            guard let self = self else { return }
            self.progressElement?.set(value)
        }
        
        let complete: (Data?, Error?)->() = { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                callback(nil, error)
            } else {
                guard let data = data else {
                    callback(nil,NSError(domain: "No Image Data", code: 999, userInfo: nil))
                    return
                }
                let image = UIImage(data: data)?.scaleTo(size: size, needTrim: true, renderMode: .alwaysOriginal)
                self.imageElement?.set(image)
                callback(image, nil)
            }
        }
        
        if progress == 0.0 {
            ///下載
            downloadQueue = SimulateImageService.shared.download(imageName: imageName, reportProgressCallback: reportProgress, completeCallback: complete)
        } else if progress < 1.0 {
            ///續傳
            downloadQueue = SimulateImageService.shared.resume(imageName: imageName, from: progress, reportProgressCallback: reportProgress, completeCallback: complete)
        } else {
            return
        }
    }
    
    deinit {
        print("CellVM Dead")
    }
}

extension UIImage {
    ///縮圖
    func scaleTo(size: CGSize, needTrim: Bool, renderMode: UIImage.RenderingMode) -> UIImage? {
        //開啟畫布
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        //判斷使用縮放比例
        let imageHeightScale = size.height / self.size.height
        let imageWidthScale = size.width / self.size.width
        let usingScale = needTrim ? max(imageHeightScale, imageWidthScale):min(imageHeightScale, imageWidthScale)
        
        //判斷圖片於畫布上的位置
        let imageNewHeight = self.size.height * usingScale
        let imageNewWidth = self.size.width * usingScale
        let usingTranslateX = size.width - imageNewWidth
        let usingTranslateY = size.height - imageNewHeight
        
        //繪製
        self.draw(in: CGRect(x: usingTranslateX / 2, y: usingTranslateY / 2, width: imageNewWidth, height: imageNewHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderMode)
        
        //關閉畫布回收記憶體
        UIGraphicsEndImageContext()
        
        return image
    }
}
