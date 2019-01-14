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
        DefaultAPIService.shared.request(LoginRequest(account: "Hank", password: "8787878787"))?.then({ (state) in
            switch state {
            case .Success(let data, let code, let header):
                if let data = data { print(data) }
                print(code)
                print(header)
            case .Failure(let error):
                print(error)
            }
        })
    }

}

