//
//  ViewController.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/10.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var hashTable:[Int:String] = [1:"1️⃣",
                                  2:"2️⃣",
                                  3:"3️⃣",
                                  4:"4️⃣",
                                  5:"5️⃣",
                                  6:"6️⃣",
                                  7:"7️⃣",
                                  8:"8️⃣",
                                  9:"9️⃣",
                                  0:"0️⃣",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request1 = GeneralRequest(method: .GET, endPoint: "/5c3daae63500006d003e94e2", parameters: ["mocky-delay":"10000ms"])
        let request2 = GeneralRequest(method: .GET, endPoint: "/5c3daae63500006d003e94e2", parameters: ["mocky-delay":"300ms"])
        for i in 0..<3 {
            DefaultAPIService.shared.send(request1)
                .with(priority: 1)
                .retry(times: 3)
                .then { (state) in
                    switch state {
                    case .Success(let data, let code, let header):
                        print("\n🦄\(self.hashTable[i]!) 👍👍👍 \(code) \(header.keys)")
                        if let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) { print(dict) }
                    case .Failure(let error):
                        print("\n🦄\(self.hashTable[i]!) 👎🏻👎🏻👎🏻 \(error.message)")
                    }
            }
            
            DefaultAPIService.shared.send(request2, decode: Account.self)
                .then { (state) in
                switch state {
                case .Success(let data, let code, let header):
                    print("\n🍙\(self.hashTable[i]!) 👍👍👍 \(code) \(header.keys)")
                    if let data = data { print(data) }
                case .Failure(let error):
                    print("\n🍙\(self.hashTable[i]!) 👎🏻👎🏻👎🏻 \(error.message)")
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(APIQueue.shared.operations)
    }
}

struct Account: Decodable {
    var id: String
    var password: String
    var nothing: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case password = "Password"
    }
}

