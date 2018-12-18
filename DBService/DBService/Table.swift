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
    var db: FMDatabase
    
    private init() {
        db = FMDatabase(path: "\(dbPath)/\(dbName)")
        if db.open() {
            print("DB Open")
        }
    }
    
    func createTable(_ name: String, _ columns: ColumnBuilder...) throws {
        guard !db.tableExists(name) else { throw FMDBServiceException.TableAlreadyExist }
        
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
                break
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
    }
    
    func dropTable(name: String) throws {
        try db.executeUpdate("DROP TABLE IF EXISTS \(name)", values: nil)
    }
    
    func insertTable(_ name: String, _ dictionary: [String:Any]) throws {
        let keys = dictionary.keys
        let placeHolders = Array(repeating: "?", count: keys.count).joined(separator: ", ")
        let values = dictionary.values.map{ $0 }
        try db.executeUpdate("INSERT INTO \(name) (\(keys.joined(separator: ", "))) VALUES (\(placeHolders))", values: values)
    }
    
    func deleteTable(_ name: String) {
        
    }
}

protocol ColumnExpressible {
    associatedtype T
    var name: SqlColumnString { get }
    var value: T { get}
}

struct GeneralExpression<T>: ColumnExpressible {
    let name: SqlColumnString
    var value: T
    
    init(_ name: SqlColumnString, value: T) {
        self.name = name
        self.value = value
    }
}

protocol SqlSubString {
    var sql: String { get }
}

struct SqlCompareStirng: SqlSubString {
    let sql: String
}

struct SqlColumnString: SqlSubString {
    let sql: String
}

func ==<V: Equatable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value == rhs
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
    case TableAlreadyExist
}

//extension FMDBServiceException: CustomDebugStringConvertible {
//    var debugDescription: String {
//        print("test")
//    }
//}


