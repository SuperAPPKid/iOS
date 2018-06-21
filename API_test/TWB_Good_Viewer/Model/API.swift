//
//  API.swift
//  TWB_Good_Viewer
//
//  Created by Hank_Zhong on 2018/6/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class API: NSObject {
    static let shared = API()
    
    private override init() {}
    
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
        request.setValue("pplication/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        fetchedDataByDataTask(from: request, completion: completion, errorHandler: errorHandler)
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
        URLSession.shared.getTasksWithCompletionHandler { (dataTask, uploadTask, downloadTask) in
            if (dataTask.isEmpty) {
                return
            }
            for task in dataTask {
                task.cancel()
            }
        }
    }
}
