//
//  Table.swift
//  DBService
//
//  Created by Hank_Zhong on 2018/12/17.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import Foundation
import FMDB

typealias Row = [String:Any]

class FMDBService {
    static var shared: FMDBService = FMDBService()
    
    private let dbName: String = "Test.sqlite"
    private let dbPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? "\(NSHomeDirectory())/Library/Caches/Airiti"
    let db: FMDatabase
    let queue: FMDatabaseQueue?
    
    private init() {
        db = FMDatabase(path: "\(dbPath)/\(dbName)")
        queue = FMDatabaseQueue(path: "\(dbPath)/\(dbName)")
    }
    
    func createTable(_ name: String, _ columns: ColumnBuilder...) throws {
        guard let queue = queue else {
            throw FMDBServiceException.NoQueue
        }
        
        queue.inDatabase { (db) in
            guard !db.tableExists(name) else { return }
            
            queue.inTransaction({ (db, rollback) in
                do {
                    var fields = [String]()
                    var fkFields = [(column: ColumnBuilder, target: ColumnBuilder.Reference)]()
                    
                    //Check AutoIncrement
                    let aiFields = columns.filter({ (column) -> Bool in
                        column.options.contains(.AutoIncrement)
                    })
                    guard aiFields.count <= 1 else { throw FMDBServiceException.MultiAutoIncrement }
                    if aiFields.count == 1 {
                        for column in columns {
                            let nn = column.options.contains(.NotNull) ? " NOT NULL" : ""
                            let ai = column.options.contains(.AutoIncrement) ? " PRIMARY KEY AUTOINCREMENT" : ""
                            let un = column.options.contains(.Unique) ? " UNIQUE" : ""
                            if let df = column.default {
                                let dfStr = " Default \(df)"
                                fields.append("`\(column.name)` \(column.type) \(nn)\(dfStr)\(ai)\(un)")
                            } else {
                                fields.append("`\(column.name)` \(column.type) \(nn)\(ai)\(un)")
                            }
                            
                            if let reference = column.reference {
                                fkFields.append((column, reference))
                            }
                        }
                    } else {
                        let pkFields = columns.filter { (column) -> Bool in
                            column.options.contains(.PrimaryKey)
                        }
                        guard pkFields.count > 0 else { throw FMDBServiceException.NoPrimaryKey }
                        
                        for column in columns {
                            let nn = column.options.contains(.NotNull) ? " NOT NULL" : ""
                            let un = column.options.contains(.Unique) ? " UNIQUE" : ""
                            if let df = column.default {
                                let dfStr = " Default \(df)"
                                fields.append("`\(column.name)` \(column.type) \(nn)\(dfStr)\(un)")
                            } else {
                                fields.append("`\(column.name)` \(column.type) \(nn)\(un)")
                            }
                            
                            if let reference = column.reference {
                                fkFields.append((column, reference))
                            }
                        }
                        //Handle Primary Key
                        let pk = pkFields.map{ "`\($0.name)`" }.joined(separator: ", ")
                        fields.append("PRIMARY KEY\(pk)")
                    }
                    
                    //Handle Foreign Key
                    let groupingFk = Dictionary(grouping: fkFields) { (element) -> String in
                        return element.target.table
                    }
                    for key in groupingFk.keys {
                        guard let values = groupingFk[key] else {
                            continue
                        }
                        
                        let column  = values.map{ "'\($0.column.name)'" }.joined(separator: " ,")
                        let target = values.map{ "'\($0.target.column)'" }.joined(separator: " ,")
                        let actions:[ColumnBuilder.Reference.ActionTuple] = values.map{ (element) -> ColumnBuilder.Reference.ActionTuple in
                            return element.target.action
                            }.sorted { (action1, action2) -> Bool in
                                action1 == action2
                        }
                        
                        if let fAction = actions.first, let lAction = actions.last {
                            guard fAction == lAction else { throw FMDBServiceException.ForeignKeyActionError }
                            let table = "'\(key)'"
                            let onUpdateAction = " ON UPDATE \(fAction.update)"
                            let onDeleteAction = " ON DELETE \(fAction.delete)"
                            fields.append("FOREIGN KEY(\(column)) REFERENCES \(table)(\(target))\(onUpdateAction)\(onDeleteAction)")
                        }
                    }
                    
                    let sql = "CREATE TABLE `\(name)` ( \(fields.joined(separator: ", ")) )"
                    try db.executeUpdate(sql, values: nil)
                } catch {
                    rollback.pointee = true
                    print(error)
                }
            })
        }
        
    }
    
    func dropTable(name: String) throws {
        guard let queue = queue else { throw FMDBServiceException.NoQueue }
        queue.inTransaction { (db, rollback) in
            do {
                try db.executeUpdate("DROP TABLE IF EXISTS \(name)", values: nil)
            } catch {
                rollback.pointee = true
                print(error)
            }
        }
    }
    
    func insert(into table: String, set dictionary: [String:Any]) throws {
        guard let queue = queue else { throw FMDBServiceException.NoQueue }
        queue.inTransaction { (db, rollback) in
            do {
                let keys = dictionary.keys
                let values = dictionary.values.map{ $0 }
                let placeHolder = Array(repeating: "?", count: keys.count).joined(separator: ", ")
                try db.executeUpdate("INSERT INTO \(table) (\(keys.joined(separator: ", "))) VALUES (\(placeHolder))", values: values)
            } catch {
                rollback.pointee = true
                print(error)
            }
        }
    }
    
    func delete(from table: String, where condition: SqlCompare) throws {
        guard let queue = queue else { throw FMDBServiceException.NoQueue }
        queue.inTransaction { (db, rollback) in
            do {
                print("DELETE FROM \(table) WHERE \(condition.sql)")
                try db.executeUpdate("DELETE FROM \(table) WHERE \(condition.sql)", values: nil)
            } catch {
                rollback.pointee = true
                print(error)
            }
        }
    }
    
    func truncate(_ table: String) throws  {
        guard let queue = queue else { throw FMDBServiceException.NoQueue }
        queue.inTransaction { (db, rollback) in
            do {
                try db.executeUpdate("DELETE FROM \(table)", values: nil)
                try db.executeUpdate("UPDATE sqlite_sequence SET seq = 0 WHERE name = '\(table)';", values: nil)
            } catch {
                rollback.pointee = true
                print(error)
            }
        }
    }
    
    func update(_ table: String, set dictionary: [String:Any], where condition: SqlCompare?) throws {
        guard let queue = queue else { throw FMDBServiceException.NoQueue }
        queue.inTransaction { (db, rollback) in
            do {
                let keys = dictionary.keys
                let values = dictionary.values.map{ $0 }
                let setter = keys.map{ "\($0) = ?" }
                if let condition = condition {
                    print("UPDATE \(table) SET \(setter.joined(separator: ", ")) WHERE \(condition.sql)")
                    try db.executeUpdate("UPDATE \(table) SET \(setter.joined(separator: ", ")) WHERE \(condition.sql)", values: values)
                } else {
                    try db.executeUpdate("UPDATE \(table) SET \(setter.joined(separator: ", "))", values: values)
                }
            } catch {
                rollback.pointee = true
                print(error)
            }
        }
    }
    
    func select(all table: String, where condition: SqlCompare?, _ callback: (([Row]) -> ())) throws {
        if db.open() {
            print("DB Open")
        } else {
            throw FMDBServiceException.DBClose
        }
        
        defer {
            if db.close() {
                print("DB Close")
            }
        }
        
        var result: FMResultSet
        if let condition = condition {
            result = try db.executeQuery("SELECT * FROM \(table) WHERE \(condition.sql)", values: nil)
        } else {
            result = try db.executeQuery("SELECT * FROM \(table)", values: nil)
        }
        
        var keys = [String]()
        for column in result.columnNameToIndexMap.keyEnumerator() {
            if let key = column as? String {
                keys.append(key)
            }
        }
        
        var rows = [Row]()
        while result.next() {
            var row = Row()
            for key in keys {
                if let value = result.object(forColumn: key) {
                    row[key] = value
                }
            }
            rows.append(row)
        }
        
        callback(rows)
        
        db.close()
    }
    
    func select(count table: String, where condition: SqlCompare?, _ callback: ((Int) -> ())) throws {
        if db.open() {
            print("DB Open")
        } else {
            throw FMDBServiceException.DBClose
        }
        
        defer {
            if db.close() {
                print("DB Close")
            }
        }
        
        var result: FMResultSet
        if let condition = condition {
            result = try db.executeQuery("SELECT COUNT(*) FROM \(table) WHERE \(condition.sql)", values: nil)
        } else {
            result = try db.executeQuery("SELECT COUNT(*) FROM \(table)", values: nil)
        }
        
        if result.next() {
            callback(Int(result.int(forColumnIndex: 0)))
        }
        
        db.close()
    }
}

protocol ColumnExpressible {
    associatedtype T
    var name: SqlColumn { get }
    var value: T { get}
}

struct GeneralExpression<T>: ColumnExpressible {
    let name: SqlColumn
    var value: T
    
    init(_ name: SqlColumn, value: T) {
        self.name = name
        self.value = value
    }
}

protocol SqlSubString {
    var sql: String { get }
}

struct SqlCompare: SqlSubString {
    let sql: String
    init(_ name: String) {
        self.sql = name
    }
}

struct SqlColumn: SqlSubString {
    let sql: String
    
    var isNull: SqlCompare {
        return SqlCompare("\(sql) IS NULL")
    }
    
    var notNull: SqlCompare {
        return SqlCompare("\(sql) NOT NULL")
    }
    
    init(_ compare: String) {
        self.sql = compare
    }
}

struct ColumnBuilder {
    enum `Type` {
        case Integer
        case Text
        case Blob
        case Real
        case Numeric
    }
    
    struct Options: OptionSet {
        let rawValue: Int
        static let NotNull = Options(rawValue: 1)
        static let PrimaryKey = Options(rawValue: 2)
        static let AutoIncrement = Options(rawValue: 4)
        static let Unique = Options(rawValue: 8)
    }
    
    struct Reference {
        typealias ActionTuple = (update: Action, delete: Action)
        enum Action: String {
            case NoAction = "NO ACTION"
            case Restrict = "RESTRICT"
            case SetNull = "SET NULL"
            case SetDefault = "SET DEFAULT"
            case Cascade = "CASCADE"
        }
        
        let table: String
        let column: String
        let action: ActionTuple
    }
    
    fileprivate let name: String
    fileprivate let type: Type
    fileprivate let `default`: Any?
    fileprivate let options: Options
    fileprivate var reference: Reference? = nil
    
    init(_ name: String, type: Type, default: Any? = nil, option: Options) {
        self.name = name
        self.type = type
        self.default = `default`
        self.options = option
    }
    
    func reference(to table: String,
                   column: String ,
                   action: (update: Reference.Action, delete: Reference.Action) = (update: Reference.Action.Cascade, delete: Reference.Action.Cascade))
        -> ColumnBuilder {
            var copyColumn = self
            copyColumn.reference = Reference(table: table, column: column, action: action)
        return copyColumn
    }
}

enum FMDBServiceException: Error {
    case MultiAutoIncrement
    case NoPrimaryKey
    case ForeignKeyActionError
    case NoQueue
    case DBClose
}

//extension FMDBServiceException: CustomDebugStringConvertible {
//    var debugDescription: String {
//        print("test")
//    }
//}


