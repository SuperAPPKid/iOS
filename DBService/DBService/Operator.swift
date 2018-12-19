//
//  Operator.swift
//  DBService
//
//  Created by Hank_Zhong on 2018/12/19.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

func ==<V: Equatable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value == rhs
}

func !=<V: Equatable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value != rhs
}

func <=<V: Comparable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value <= rhs
}

func >=<V: Comparable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value >= rhs
}

func <<V: Comparable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value < rhs
}

func ><V: Comparable> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value > rhs
}

func ===<V: AnyObject> (lhs: GeneralExpression<V>, rhs: V) -> Bool {
    return lhs.value === rhs
}

func %(lhs: SqlColumn, rhs: Int) -> SqlColumn {
    return SqlColumn("\(lhs.sql) % \(rhs)")
}

func /(lhs: SqlColumn, rhs: Int) -> SqlColumn {
    return SqlColumn("\(lhs.sql) / \(rhs)")
}

func ==(lhs: SqlColumn, rhs: Any) -> SqlCompare {
    if let strRhs = rhs as? String {
        return SqlCompare("\(lhs.sql) = '\(strRhs)'")
    }
    return SqlCompare("\(lhs.sql) = \(rhs)")
}

func !=(lhs: SqlColumn, rhs: Any) -> SqlCompare {
    return SqlCompare("\(lhs.sql) != \(rhs)")
}

func <=(lhs: SqlColumn, rhs: Any) -> SqlCompare {
    return SqlCompare("\(lhs.sql) <= \(rhs)")
}

func >=(lhs: SqlColumn, rhs: Any) -> SqlCompare {
    return SqlCompare("\(lhs.sql) >= \(rhs)")
}

func >(lhs: SqlColumn, rhs: Any) -> SqlCompare {
    return SqlCompare("\(lhs.sql) > \(rhs)")
}

func <(lhs: SqlColumn, rhs: Any) -> SqlCompare {
    return SqlCompare("\(lhs.sql) < \(rhs)")
}

func ||(lhs: SqlCompare, rhs: SqlCompare) -> SqlCompare {
    return SqlCompare("\(lhs.sql) OR \(rhs.sql)")
}

func &&(lhs: SqlCompare, rhs: SqlCompare) -> SqlCompare {
    return SqlCompare("\(lhs.sql) AND \(rhs.sql)")
}

