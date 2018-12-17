//
//  Table.swift
//  DBService
//
//  Created by Hank_Zhong on 2018/12/17.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import Foundation
import FMDB

class FMDBService {
    static var shared: FMDBService = FMDBService()
    
    private let dbName: String = "Test.sqlite"
    private let dbPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "\(NSHomeDirectory())/Library/Caches/Airiti"
    private var db: FMDatabase
    
    private init() {
        db = FMDatabase(path: "\(dbPath)/\(dbName)")
        
        if db.open() {
            print("DB Open")
        }
    }
    
    func createTable(name: String, columns: Column...) throws  {
        guard !db.tableExists(name) else {
            return
        }
        
        let aiFields = columns.filter({ (column) -> Bool in
            column.option.contains(.AutoIncrement)
        })
        guard aiFields.count <= 1 else {
            throw FMDBServiceException.MultiAutoIncrement
        }
        
        var fields = [String]()
        
        if aiFields.count == 1 {
            for column in columns {
                let nn = column.option.contains(.NotNull) ? " NOT NULL" : ""
                let ai = column.option.contains(.AutoIncrement) ? " PRIMARY KEY AUTOINCREMENT" : ""
                let un = column.option.contains(.Unique) ? " UNIQUE" : ""
                fields.append("`\(column.name)` \(column.type) \(nn)\(ai)\(un)")
            }
        } else {
            let pkFields = columns.filter { (column) -> Bool in
                column.option.contains(.PrimaryKey)
            }
            
            guard pkFields.count > 0 else {
                throw FMDBServiceException.NoPrimaryKey
            }
            
            for column in columns {
                let nn = column.option.contains(.NotNull) ? " NOT NULL" : ""
                let un = column.option.contains(.Unique) ? " UNIQUE" : ""
                fields.append("`\(column.name)` \(column.type) \(nn)\(un)")
            }
            let pk = pkFields.map{ "`\($0.name)`" }.joined(separator: ", ")
            fields.append("PRIMARY KEY\(pk)")
        }
        
        let sql = "CREATE TABLE `\(name)` ( \(fields.joined(separator: ", ")) )"
        try db.executeUpdate(sql, values: nil)
    }
    
    func dropTable(name: String) throws {
        try db.executeUpdate("DROP TABLE IF EXISTS \(name)", values: nil)
    }
}

struct Column {
    var name: String
    var type: ColumnType
    var option: ColumnOptions
}

enum ColumnType: String {
    case Integer
    case Text
    case Blob
    case Real
    case Numeric
}

struct ColumnOptions: OptionSet {
    let rawValue: Int
    static let NotNull = ColumnOptions(rawValue: 1)
    static let PrimaryKey = ColumnOptions(rawValue: 2)
    static let AutoIncrement = ColumnOptions(rawValue: 4)
    static let Unique = ColumnOptions(rawValue: 8)
}

enum FMDBServiceException: Error {
    case MultiAutoIncrement
    case NoPrimaryKey
}

//extension FMDBServiceException: CustomDebugStringConvertible {
//    var debugDescription: String {
//        print("test")
//    }
//}
