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
            try FMDBService.shared.insert(into: "Animal", set: ["Name":"tiger"])
            try FMDBService.shared.insert(into: "Animal", set: ["Name":"dog"])
            try FMDBService.shared.insert(into: "Animal", set: ["Name":"cat"])
            try FMDBService.shared.insert(into: "Animal", set: ["Name":"lion"])
            try FMDBService.shared.insert(into: "Animal", set: ["Name":"rabbit"])
        } catch {
            print(error)
        }
        
        do {
            try FMDBService.shared.delete(from: "Animal", where: (SqlColumn("Name") == "rabbit" || SqlColumn("ID") % 3 == 0))
            try FMDBService.shared.update("Animal", set: ["Sex":"Boy"], where: SqlColumn("Sex").isNull)
        } catch {
            print(error)
        }
        
        do {
            try FMDBService.shared.select(all: "Animal", where: SqlColumn("Name") == "lion", { $0.forEach{ print($0) }})
            try FMDBService.shared.select(count: "Animal", where: nil, { print($0) })
        } catch {
            print(error)
        }
        
        let cond1 = SQLWrapper("name", op: "==", "rabbit")
        let cond2 = SQLWrapper("ID", op: "%", 3)
        let cond2ex = SQLWrapper(cond2, op: "==", 0)
        let multiCond = SQLWrapper(cond1, op: "||", cond2ex)
        print(multiCond.left.left.left.left.left)
        
        do {
            try FMDBService.shared.truncate("Animal")
        } catch {
            print(error)
        }
    }

}

extension UnitWrapable {
    var left: SQLWrapable {
        print("!!")
        return self
    }
    
    var right: SQLWrapable? {
        return nil
    }
    var op: String? {
        return nil
    }
}

protocol SQLWrapable {
    var left: SQLWrapable { get }
    var right: SQLWrapable? { get }
    var op: String? { get }
}

protocol UnitWrapable: SQLWrapable {}

struct SQLWrapper<L: SQLWrapable, R: SQLWrapable> : SQLWrapable {
    var left: SQLWrapable
    var right: SQLWrapable?
    var op: String?
    
    init (_ left: L, op: String, _ right: R) {
        self.left = left
        self.op = op
        self.right = right
    }
}

extension String: UnitWrapable{}
extension Int: UnitWrapable{}
