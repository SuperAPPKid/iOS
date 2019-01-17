//
//  APIServiceTaskWrapper.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/17.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

protocol APITaskWrapper {
    associatedtype Target
    func retry(times: UInt) -> Self
    func with(priority: Float) -> Self
    func onComplete(_ complete: @escaping ((APIResponseState<Target>) -> Void)) -> APITask<Target>
}

struct APIDataTaskWrapper: APITaskWrapper {
    private var service: APIService
    private var innerTask: APIGenericTask<Data>
    
    init(task: APIGenericTask<Data>, service: APIService) {
        self.innerTask = task
        self.service = service
    }
    
    func retry(times: UInt) -> APIDataTaskWrapper {
        innerTask.retry(times: times)
        return self
    }
    
    func with(priority: Float) -> APIDataTaskWrapper {
        innerTask.with(priority: priority)
        return self
    }
    
    @discardableResult
    func onComplete(_ complete: @escaping ((APIResponseState<Data>) -> Void)) -> APITask<Data>  {
        self.innerTask.onComplete(complete)
        return APITask(innerTask: innerTask)
    }

    func decode<T>(to targetType: T.Type) -> APIDecodableTaskWrapper<T> where T : Decodable {
        let usedSession = service.session ?? URLSession.shared
        guard let usedRequest = innerTask.request.urlRequest else {
            return APIDecodableTaskWrapper(task: APIErrorTask<T>(request: innerTask.request, error: APICoreError.InvalidURL(message: "Invalid URL")))
        }
        
        let apiInnerTask = APIDecodableTask<T>(request: innerTask.request)
        apiInnerTask.with(priority: innerTask.priority)
        apiInnerTask.retry(times: innerTask.retryTimes)
        apiInnerTask.lazyTask = { [unowned apiInnerTask] () -> URLSessionTask in
            usedSession.dataTask(with: usedRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    apiInnerTask.executeRetryableCallback(state: .Failure(error: .URLSessionError(error: error)))
                    return
                } else {
                    guard let response = response as? HTTPURLResponse else {
                        apiInnerTask.executeRetryableCallback(state: .Failure(error: APICoreError.NotHTTP(message: "Not HTTP Response")))
                        return
                    }
                    
                    var object: T? = nil
                    if let data = data {
                        object = try? JSONDecoder().decode(targetType, from: data)
                    }
                    
                    apiInnerTask.executeRetryableCallback(state: .Success(data: object,
                                                                          code: HttpResponseCode(code: response.statusCode),
                                                                          header: (response.allHeaderFields as? [String: String]) ?? [:]))
                }
            })
        }
        
        return APIDecodableTaskWrapper(task: apiInnerTask)
    }
}

struct APIDecodableTaskWrapper<Target: Decodable>: APITaskWrapper {
    var innerTask: APIGenericTask<Target>
    
    init(task: APIGenericTask<Target>) {
        self.innerTask = task
    }
    
    func retry(times: UInt) -> APIDecodableTaskWrapper<Target> {
        innerTask.retry(times: times)
        return self
    }
    
    func with(priority: Float) -> APIDecodableTaskWrapper<Target> {
        innerTask.with(priority: priority)
        return self
    }
    
    @discardableResult
    func onComplete(_ complete: @escaping ((APIResponseState<Target>) -> Void)) -> APITask<Target> {
        self.innerTask.onComplete(complete)
        return APITask(innerTask: innerTask)
    }
    
}

