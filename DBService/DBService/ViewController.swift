//
//  ViewController.swift
//  DBService
//
//  Created by Hank_Zhong on 2018/12/17.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try FMDBService.shared.dropTable(name: "Planet")
            try FMDBService.shared.dropTable(name: "Animal")
        } catch {
            print(error)
        }
    }


}

