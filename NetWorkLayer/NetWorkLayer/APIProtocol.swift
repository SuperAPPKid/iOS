//
//  APIProtocol.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/14.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

protocol APIRequest {
    var method: HttpMethod { get }
    var endPoint: String { get }
    var headers: [String:String] { get }
    var parameters: [String:Any] { get }
}

protocol APIAuth {
    var token: String { get }
}
protocol APIService {
    var session: URLSession? { get }
    func request(_ request: GeneralRequest, auth: APIAuth?) -> APIServiceTask?
}

extension APIService {
    var session: URLSession? { return nil }
    
    func request(_ request: GeneralRequest, auth: APIAuth? = nil) -> APIServiceTask?  {
        guard let apiURL = request.url else { return nil }
        let usedSession = session ?? URLSession.shared
        
        var usedRequest = URLRequest(url: apiURL,
                                     cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                     timeoutInterval: 15)
        
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
        
        let apiTask = APIServiceTask()
        apiTask.task = usedSession.dataTask(with: usedRequest, completionHandler: { (data, response, error) in
            if let error = error {
                apiTask.callback?(.Failure(error: error))
                return
            } else {
                guard let response = response as? HTTPURLResponse else {
                    apiTask.callback?(.Failure(error: NSError(domain: "not http response", code: 9999, userInfo: nil)))
                    return
                }
                apiTask.callback?(.Success(data: data,
                                           code: ResponseCode(code: response.statusCode),
                                           header: (response.allHeaderFields as? [String: String]) ?? [:]))
            }
        })
        return apiTask
    }
}
