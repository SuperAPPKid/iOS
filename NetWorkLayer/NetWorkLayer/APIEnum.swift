//
//  APIEnum.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/14.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET, POST, PUT, DELETE
}

enum ResponseCode {
    case Information(Int)
    case Success(Int)
    case Redirection(Int)
    case ClientError(Int)
    case ServerError(Int)
    case None
    
    init(code: Int) {
        switch code {
        case 100...199 :
            self = .Information(code)
        case 200...299 :
            self = .Success(code)
        case 300...399 :
            self = .Redirection(code)
        case 400...499 :
            self = .ClientError(code)
        case 500...599 :
            self = .ServerError(code)
        default:
            self = .None
        }
    }
}
