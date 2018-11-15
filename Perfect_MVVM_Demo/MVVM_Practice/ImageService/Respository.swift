//
//  Data.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/15.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit
struct AnimalInfo {
    let name: String
    let image: UIImage
}
class Respository {
    static let AnimalInfos: [AnimalInfo] = [AnimalInfo(name: "Giant Panda", image: #imageLiteral(resourceName: "Giant Panda")),
                                            AnimalInfo(name: "Giraffe", image: #imageLiteral(resourceName: "Giraffe")),
                                            AnimalInfo(name: "Hippo", image: #imageLiteral(resourceName: "Hippo")),
                                            AnimalInfo(name: "Jaguar", image: #imageLiteral(resourceName: "Jaguar")),
                                            AnimalInfo(name: "Lion", image: #imageLiteral(resourceName: "Lion")),
                                            AnimalInfo(name: "Tiger", image: #imageLiteral(resourceName: "Tiger")),
                                            AnimalInfo(name: "Zebra", image: #imageLiteral(resourceName: "Zebra"))]
}
