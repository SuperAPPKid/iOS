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
            try FMDBService.shared.insertTable("Animal", ["Name":"tiger"])
            try FMDBService.shared.insertTable("Animal", ["Name":"dog"])
            try FMDBService.shared.insertTable("Animal", ["Name":"cat"])
            try FMDBService.shared.insertTable("Animal", ["Name":"lion"])
        } catch {
            print(error)
        }
        
    }


}

