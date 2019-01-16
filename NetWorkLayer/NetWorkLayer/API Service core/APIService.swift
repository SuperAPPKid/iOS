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
    func send(_ request: GeneralRequest, _ auth: APIAuth?) -> APIGenericTask<Data>
    func send<D: Decodable>(_ request: GeneralRequest, decode: D.Type, _ auth: APIAuth?) -> APIGenericTask<D>
}

extension APIService {
    var session: URLSession? { return nil }
    
    private func generateRequest(_ request: GeneralRequest, _ auth: APIAuth? = nil) -> URLRequest? {
        guard let apiURL = request.url else { return nil }
        var usedRequest = URLRequest(url: apiURL,
                                     cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                     timeoutInterval: 5)
        
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
    
    func send(_ request: GeneralRequest, _ auth: APIAuth? = nil) -> APIGenericTask<Data>  {
        let usedSession = session ?? URLSession.shared
        guard let usedRequest = generateRequest(request, auth) else {
            return APIErrorTask<Data>(request: request, error: APICoreError.InvalidURL(message: "Invalid URL"))
        }
        
        let apiTask = APIDataTask(request: request)
        apiTask.lazyTask = { [unowned apiTask] () -> URLSessionTask in
            usedSession.dataTask(with: usedRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    apiTask.executeCallback(state: .Failure(error: .URLSessionError(error: error)))
                    return
                } else {
                    guard let response = response as? HTTPURLResponse else {
                        apiTask.executeCallback(state: .Failure(error: APICoreError.NotHTTP(message: "Not HTTP Response")))
                        return
                    }
                    apiTask.executeCallback(state: .Success(data: data,
                                              code: HttpResponseCode(code: response.statusCode),
                                              header: (response.allHeaderFields as? [String: String]) ?? [:]))
                }
            })
        }
        return apiTask
    }
    
    func send<D: Decodable>(_ request: GeneralRequest, decode: D.Type, _ auth: APIAuth? = nil) -> APIGenericTask<D> {
        let usedSession = session ?? URLSession.shared
        guard let usedRequest = generateRequest(request, auth) else {
            return APIErrorTask<D>(request: request, error: APICoreError.InvalidURL(message: "Invalid URL"))
        }
        
        let apiTask = APIDecodableTask<D>(request: request)
        apiTask.lazyTask = { [unowned apiTask] () -> URLSessionTask in
            usedSession.dataTask(with: usedRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    apiTask.executeCallback(state: .Failure(error: .URLSessionError(error: error)))
                    return
                } else {
                    guard let response = response as? HTTPURLResponse else {
                        apiTask.executeCallback(state: .Failure(error: APICoreError.NotHTTP(message: "Not HTTP Response")))
                        return
                    }
                    
                    var object: D? = nil
                    if let data = data {
                        object = try? JSONDecoder().decode(decode, from: data)
                    }
                    apiTask.executeCallback(state: .Success(data: object,
                                              code: HttpResponseCode(code: response.statusCode),
                                              header: (response.allHeaderFields as? [String: String]) ?? [:]))
                }
            })
        }
        return apiTask
    }
}

class DefaultAPIService: APIService {
    static let shared = DefaultAPIService()
    private init() { }
}

