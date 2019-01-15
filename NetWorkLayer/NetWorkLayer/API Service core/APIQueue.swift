//
//  APIQueue.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/14.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

class APIQueue: OperationQueue {
    static let shared: APIQueue = APIQueue()
    
    private override init() {
        super.init()
//        maxConcurrentOperationCount = 3
        maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
    }
}
