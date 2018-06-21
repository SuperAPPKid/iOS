//
//  Model.swift
//  MVP+MVVM
//
//  Created by Hank_Zhong on 2018/6/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class Model: NSObject {
    static let shared = Model()
    let people:[Person]
    
    private override init() {
        self.people = [Person(name: "Hank", age: 25),
                       Person(name: "Tom", age: 18),
                       Person(name: "Amy", age: 50),
                       Person(name: "Gary", age: 25)]
    }
}
struct Person {
    var name:String;
    var age:Int;
}
