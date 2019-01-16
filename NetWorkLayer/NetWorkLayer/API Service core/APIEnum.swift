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

enum HttpResponseCode {
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

enum APIResponseState<T> {
    case Success(data: T?, code: HttpResponseCode, header: [String:String])
    case Failure(error: APICoreError)
}

enum APICoreError: Error {
    case InvalidURL(message: String)
    case DuplicatedRequest(message: String)
    case NotHTTP(message: String)
    case Unhandled(message: String)
    case CannotStartTask(message: String)
    case OperationIsCancelled(message: String)
    case RetryOperation(message: String)
    case URLSessionError(error: Error)
    
    var message: String {
        switch self {
        case .InvalidURL(let message):
            return message
        case .DuplicatedRequest(let message):
            return message
        case .NotHTTP(let message):
            return message
        case .Unhandled(let message):
            return message
        case .CannotStartTask(let message):
            return message
        case .OperationIsCancelled(let message):
            return message
        case .RetryOperation(let message):
            return message
        case .URLSessionError(let error):
            return error.localizedDescription
        }
    }
}
