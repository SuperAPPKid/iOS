//
//  ViewController.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/10.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = GeneralRequest(method: .GET, endPoint: "/5c3daae63500006d003e94e2", parameters: ["mocky-delay":"100ms"])
        for i in 0..<10 {
            DefaultAPIService.shared.send(request)
                .with(priority: Float(i / 8))
                .then{ (state) in
                    switch state {
                    case .Success(let data, let code, let header):
                        if let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) { print(dict) }
                        print("0\(i) complete \(code) \(header.keys)")
                    case .Failure(let error):
                        print("0\(i) complete \(error.localizedDescription)")
                    }
            }
            
            DefaultAPIService.shared.send(request)
                .then { (state) in
                switch state {
                case .Success(let data, let code, let header):
                    if let data = data { print(data) }
                    print("1\(i) complete \(code) \(header.keys)")
                case .Failure(let error):
                    print("1\(i) complete \(error.localizedDescription)")
                }
            }
        }
    }
}

struct Account: Decodable {
    var id: String
    var password: String
    var null: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case password = "Password"
    }
}

