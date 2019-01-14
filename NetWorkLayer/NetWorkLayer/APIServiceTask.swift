//
//  APIServiceTask.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/14.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

class DefaultAPIService: APIService {
    static let shared = DefaultAPIService()
    
    private init() { }
}

//https://developer.apple.com/documentation/foundation/operation
class AsyncOperation: Operation {
    override func start() {
        
    }
    
    override var isAsynchronous: Bool {
        return true
    }
}

class APIServiceTask: AsyncOperation {
    enum State {
        case Success(data: Data?, code: ResponseCode, header: [String:String])
        case Failure(error: Error)
    }
    
    weak var task: URLSessionTask?
    weak var queue: OperationQueue?
    var callback:((State) -> Void)?
    
    func then(_ callback: @escaping ((State) -> Void)) {
        self.callback = callback
        queue?.addOperation(self)
//        task?.resume()
    }
    
    override func cancel() {
//        task?.cancel()
    }
}
