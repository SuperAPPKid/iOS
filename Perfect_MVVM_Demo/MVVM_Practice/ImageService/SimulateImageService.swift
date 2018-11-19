//
//  ImageService.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/15.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class SimulateImageService {
    static let shared = SimulateImageService()
    
    func download(imageName: String, reportProgressCallback: ((Float)->())?, completeCallback: @escaping (Data?, Error?)->()) -> OperationQueue? {
        if let image = Respository.AnimalInfos.first(where: {$0.name == imageName})?.image {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            for i in 1...8 {
                queue.addOperation {
                    reportProgressCallback?(Float(i) / 8)
                    if i == 8 {
                        completeCallback(image.jpegData(compressionQuality: 1), nil)
                    } else {
                        sleep(1)
                    }
                }
            }
            return queue
        } else {
            completeCallback(nil, NSError(domain: "No Image", code: 999, userInfo: nil))
        }
        return nil
    }
    
    func resume(imageName: String, from value: Float, reportProgressCallback: ((Float)->())?, completeCallback: @escaping (Data?, Error?)->()) -> OperationQueue? {
        let intValue = Int(value * 8)
        if let image = Respository.AnimalInfos.first(where: {$0.name == imageName})?.image {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            for i in intValue...8 {
                queue.addOperation {
                    reportProgressCallback?(Float(i) / 8)
                    if i == 8 {
                        completeCallback(image.jpegData(compressionQuality: 1), nil)
                    } else {
                        sleep(1)
                    }
                }
            }
            return queue
        } else {
            completeCallback(nil, NSError(domain: "No Image", code: 999, userInfo: nil))
        }
        return nil
    }
    
    func stop(queue: OperationQueue?) {
        queue?.cancelAllOperations()
    }
}
