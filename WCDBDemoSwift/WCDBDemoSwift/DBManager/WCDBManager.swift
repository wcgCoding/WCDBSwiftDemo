//
//  WCDBManager.swift
//  WCDBDemoSwift
//
//  Created by John on 2017/12/26.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

/// 以下扩展给业务层使用
///
protocol TableNameProtocol {
    var name: String {get} // 表名
    var select: Select? {get} // 表查找子
    var dataBase: Database {get} // 表对应的数据库
}

protocol DataBaseProtocol {
    var path: String {get} // 数据库存放路径
    var tag: Int {get} // 数据库tag 对应唯一数据库
    var db: Database {get} // 真实数据库
}

protocol DBManagerProtocol {
    typealias ErrorType = (WCDBSwift.Error?)->Void
    typealias SuccessType = ()->Void

    static func update<Object>(_ table: TableNameProtocol, object: Object, propertys: [PropertyConvertible], conditioin: Condition?, errorClosure: ErrorType?, successClosure: SuccessType?) where Object: TableEncodable // 更新

    static func insert<Object>(_ table: TableNameProtocol, objects: [Object], errorClosure: ErrorType?, successClosure: SuccessType?) where Object: TableEncodable // 插入

    static func select<Object>(_ table: TableNameProtocol, conditioin: Condition?, errorClosure: ErrorType?) -> [Object]? where Object: TableEncodable // 查询

    static func delete(_ table: TableNameProtocol, conditioin: Condition?, errorClosure: ErrorType?) // 删除

    static func insertOrReplace<Object>(_ table: TableNameProtocol, objects: [Object], errorClosure: ErrorType?, successClosure: SuccessType?) where Object: TableEncodable
}

class WCDBManager {

    typealias ErrorType = (WCDBSwift.Error?)->Void
    typealias SuccessType = ()->Void

    static let `default` = WCDBManager()

    /// 插入
    func insert<Object>(_ dataBase: Database, table: String, objects: [Object], errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil) where Object: TableEncodable {
        do {
            try dataBase.insert(objects: objects, intoTable: table)
            successClosure?()
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
        }
    }

    /// 更新（条件）
    func update<Object>(_ dataBase: Database, table: String, object: Object, propertys: [PropertyConvertible], conditioin: Condition? = nil, errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil) where Object: TableEncodable {
        do {
            try dataBase.update(table: table, on: propertys, with: object, where: conditioin, orderBy: nil, limit: nil, offset: nil)
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
        }
    }

    /// 查询
    func select<Object>(_ select: Select?, conditioin: Condition? = nil, errorClosure: ErrorType? = nil) -> [Object]? where Object: TableEncodable {
        do {
            if let conditioin = conditioin {
                select?.where(conditioin)
            }
            let objects: [Object]? = try select?.allObjects() as? [Object]
            return objects
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
            return nil
        }
    }

    /// 删除
    func delete(_ dataBase: Database, table: String, condition: Condition? = nil, errorClosure: ErrorType? = nil) {
        do {
            try dataBase.delete(fromTable: table, where: condition, orderBy: nil, limit: nil, offset: nil)
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
        }
    }

    /// 更新或插入
    func insertOrReplace<Object>(_ dataBase: Database, table: String, objects: [Object], errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil) where Object: TableEncodable {
        do {
            try dataBase.insertOrReplace(objects: objects, intoTable: table)
            successClosure?()
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
        }
    }
}
