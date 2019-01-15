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
    func send(_ request: GeneralRequest, _ auth: APIAuth?) -> APIGenericTask<APIResponseState<Data>>
    func send<D: Decodable>(_ request: GeneralRequest, decode: D.Type, _ auth: APIAuth?) -> APIGenericTask<APIResponseState<D>>
}

extension APIService {
    var session: URLSession? { return nil }
    
    private func generateRequest(_ request: GeneralRequest, _ auth: APIAuth? = nil) -> URLRequest? {
        guard let apiURL = request.url else { return nil }
        var usedRequest = URLRequest(url: apiURL,
                                     cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                     timeoutInterval: 60)
        
        usedRequest.httpMethod = request.method.rawValue
        
        usedRequest.allHTTPHeaderFields = request.headers
        if let auth = auth {
            usedRequest.setValue(auth.token, forHTTPHeaderField: "X-Api-Auth-Token")
        }
        
        switch request.method {
        case .GET, .PUT, .DELETE:
            guard let urlString = usedRequest.url?.absoluteString else { return nil }
            
            var components = URLComponents(string: urlString)
            components?.queryItems = []
            for (key, value) in request.parameters {
                components?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
            }
            
            usedRequest.url = components?.url
        case .POST:
            usedRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.parameters, options: [])
        }
        return usedRequest
    }
    
    func send(_ request: GeneralRequest, _ auth: APIAuth? = nil) -> APIGenericTask<APIResponseState<Data>>  {
        let usedSession = session ?? URLSession.shared
        guard let usedRequest = generateRequest(request, auth) else {
            return APIErrorTask<Data>(error: NSError(domain: "Invalid URL", code: 9999, userInfo: nil))
        }
        
        let apiTask = APIDataTask()
        apiTask.task = usedSession.dataTask(with: usedRequest, completionHandler: { (data, response, error) in
            defer{
                apiTask.finish()
            }
            if let error = error {
                apiTask.callback(.Failure(error: error))
                return
            } else {
                guard let response = response as? HTTPURLResponse else {
                    apiTask.callback(.Failure(error: NSError(domain: "not http response", code: 9999, userInfo: nil)))
                    return
                }
                apiTask.callback(.Success(data: data,
                                          code: ResponseCode(code: response.statusCode),
                                          header: (response.allHeaderFields as? [String: String]) ?? [:]))
            }
        })
        return apiTask
    }
    
    func send<D: Decodable>(_ request: GeneralRequest, decode: D.Type, _ auth: APIAuth? = nil) -> APIGenericTask<APIResponseState<D>> {
        let usedSession = session ?? URLSession.shared
        guard let usedRequest = generateRequest(request, auth) else {
            return APIErrorTask<D>(error: NSError(domain: "Invalid URL", code: 9999, userInfo: nil))
        }
        
        let apiTask = APIDecodableTask<D>()
        apiTask.task = usedSession.dataTask(with: usedRequest, completionHandler: { (data, response, error) in
            defer{
                apiTask.finish()
            }
            if let error = error {
                apiTask.callback(.Failure(error: error))
                return
            } else {
                guard let response = response as? HTTPURLResponse else {
                    apiTask.callback(.Failure(error: NSError(domain: "not http response", code: 9999, userInfo: nil)))
                    return
                }
                
                var object: D? = nil
                if let data = data {
                    object = try? JSONDecoder().decode(decode, from: data)
                }
                apiTask.callback(.Success(data: object,
                                          code: ResponseCode(code: response.statusCode),
                                          header: (response.allHeaderFields as? [String: String]) ?? [:]))
            }
        })
        return apiTask
    }
}

class DefaultAPIService: APIService {
    static let shared = DefaultAPIService()
    private init() { }
}

