//
//  API.swift
//  TWB_Good_Viewer
//
//  Created by Hank_Zhong on 2018/6/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class API:NSObject {
    static let shared = API()
    private var sessionManager:URLSession!
    private var downloadCompletion:((Data) -> Void)?
    private var downloadErrorHandler:((Error) -> Void)?
    public private(set) var downloadCount = 0
    
    private override init() {
        super.init()
        print("New Api")
        let config:URLSessionConfiguration = .default
        self.sessionManager = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    func customizeSessionManager(with config:URLSessionConfiguration = .default,delegate:URLSessionTaskDelegate?,delegateQueue:OperationQueue? = nil) {
        self.sessionManager.finishTasksAndInvalidate()
        self.sessionManager = URLSession(configuration: config, delegate: delegate ?? self, delegateQueue: delegateQueue)
    }
    
    func requestWithURL(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = []
        for (key,value) in parameters {
            if let value = value as? String {
                urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value))
            } else {
                continue
            }
        }
        guard let url = urlComponents?.url else { return }
        let request = URLRequest(url: url)
        fetchedDataByDataTask(from: request, completion: completion, errorHandler: errorHandler)
    }
    
    func requestWithHeader(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        for (key,value) in parameters {
            if let value = value as? String {
                request.addValue(key, forHTTPHeaderField: value)
            } else {
                continue
            }
        }
        fetchedDataByDataTask(from: request, completion: completion, errorHandler: errorHandler)
    }
    
    func requestWithJSONBody(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        fetchedDataByDataTask(from: request, completion: completion, errorHandler: errorHandler)
    }
    
    func requestWithUrlencodedBody(urlString: String, parameters: String, completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpBody = parameters.data(using: .utf8)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        fetchedDataByDataTask(from: request, completion: completion, errorHandler: errorHandler)
    }
    
    func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        let boundary = "ABCDEFG"
        var body:Data = Data()
        
        request.setValue("multipart/form-data; boundary = \(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        for (key, value) in dataPath {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpeg\"\r\n")
            body.appendString(string: "Content-Type: image/jpeg\r\n\r\n")
            body.append(value)
            body.appendString(string: "\r\n")
        }
        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        
        fetchedDataByDataTask(from: request, completion: completion, errorHandler: errorHandler)
    }
    
    
    func downloadByDownloadTask(from urlString: String, downloadCompletion: ((Data) -> Void)? = nil, downloadErrorHandler: ((Error) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        let task = self.sessionManager.downloadTask(with:url)
        self.downloadCompletion = downloadCompletion
        self.downloadErrorHandler = downloadErrorHandler
        downloadCount += 1
        task.resume()
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        let task = self.sessionManager.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response)
            }
            if let error = error {
                errorHandler(error)
                return
            } else {
                guard let data = data else { return }
                completion(data)
            }
        }
        task.resume()
    }
    
    func cancelAllTask() {
        self.downloadCount = 0
        self.sessionManager.getTasksWithCompletionHandler { (dataTask, uploadTask, downloadTask) in
            if (dataTask.isEmpty) {
                return
            }
            for task in dataTask {
                task.cancel()
            }
        }
    }
    
}

extension API:URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            guard let completionHandler = self.downloadCompletion else {
                return
            }
            completionHandler(data)
        } catch {
            guard let errorHandler = self.downloadErrorHandler else {
                return
            }
            errorHandler(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let rate = String(format: "%.2f%%", Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)*100)
        print("totalBytesWritten:\(rate)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
}

extension Data{
    mutating func appendString(string: String) {
        guard let data = string.data(using: .utf8, allowLossyConversion: true) else { return }
        append(data)
    }
}
