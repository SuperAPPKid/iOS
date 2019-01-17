//
//  APIService.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/15.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

protocol APIService {
    var session: URLSession? { get }
    func send(_ request: APIRequest) -> APIDataTaskWrapper
}

extension APIService {
    var session: URLSession? { return nil }
    
    func send(_ request: APIRequest) -> APIDataTaskWrapper  {
        let usedSession = session ?? URLSession.shared
        
        guard let usedRequest = request.urlRequest else {
            return APIDataTaskWrapper(task: APIErrorTask<Data>(request: request, error: APICoreError.InvalidURL(message: "Invalid URL")), service: self)
        }
        
        let apiInnerTask = APIDataTask(request: request)
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
                    apiInnerTask.executeRetryableCallback(state: .Success(data: data,
                                              code: HttpResponseCode(code: response.statusCode),
                                              header: (response.allHeaderFields as? [String: String]) ?? [:]))
                }
            })
        }
        return APIDataTaskWrapper(task: apiInnerTask, service: self)
    }
    
}

class DefaultAPIService: APIService {
    static let shared = DefaultAPIService()
    private init() { }
}

