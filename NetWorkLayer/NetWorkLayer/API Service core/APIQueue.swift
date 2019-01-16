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
//        maxConcurrentOperationCount = 1
        maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
    }
    
    override func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        return
    }
    
    override func addOperation(_ block: @escaping () -> Void) {
        return
    }
}
