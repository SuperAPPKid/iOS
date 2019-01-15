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
    var parameters: [String:Any] { get }
}

class GeneralRequest: APIRequest {
    var method: HttpMethod
    
    var endPoint: String
    
    var headers: [String : String] = [
        "Content-Type": "application/json"
    ]
    
    var parameters: [String : Any]
    
    var url: URL? {
        guard let apiBaseUrl = APIConfiguration.baseURL else { return nil }
        return apiBaseUrl.appendingPathComponent(endPoint)
    }
    
    init(method: HttpMethod, endPoint: String, parameters: [String:Any]) {
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
