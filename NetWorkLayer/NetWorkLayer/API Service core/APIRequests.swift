//
//  APIRequests.swift
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
    var parameters: [String:AnyHashable] { get }
    var urlRequest: URLRequest? { get }
}

func != (lhs: APIRequest, rhs: APIRequest) -> Bool {
    let compare = lhs.method != rhs.method ||
        lhs.headers != rhs.headers ||
        lhs.endPoint != rhs.endPoint ||
        lhs.parameters != rhs.parameters
    return compare
}

class GeneralRequest: APIRequest {
    
    var method: HttpMethod
    
    var endPoint: String
    
    var headers: [String : String] = [
        "Content-Type": "application/json"
    ]
    
    var parameters: [String : AnyHashable]
    
    var url: URL? {
        guard let apiBaseUrl = APIConfiguration.baseURL else { return nil }
        return apiBaseUrl.appendingPathComponent(endPoint)
    }
    
    var urlRequest: URLRequest? {
        guard let apiURL = self.url else { return nil }
        
        var usedRequest = URLRequest(url: apiURL,
                                     cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                     timeoutInterval: 5)
        
        usedRequest.httpMethod = self.method.rawValue
        
        usedRequest.allHTTPHeaderFields = self.headers
        
        switch self.method {
        case .GET, .PUT, .DELETE:
            guard let urlString = usedRequest.url?.absoluteString else { return nil }
            
            var components = URLComponents(string: urlString)
            components?.queryItems = []
            for (key, value) in self.parameters {
                components?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
            }
            
            usedRequest.url = components?.url
        case .POST:
            usedRequest.httpBody = try? JSONSerialization.data(withJSONObject: self.parameters, options: [])
        }
        return usedRequest
    }
    
    init(method: HttpMethod, endPoint: String, parameters: [String:AnyHashable]) {
        self.method = method
        self.endPoint = endPoint
        self.parameters = parameters
    }
}

class LoginRequest: GeneralRequest {
    init(account: String, password: String) {
        super.init(method: .GET, endPoint: "/Login", parameters: ["Account":account,
                                                                  "Password":password])
    }
}
