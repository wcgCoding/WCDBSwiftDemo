//
//  TDWDBManager.swift
//  WCDBDemoSwift
//
//  Created by John on 2018/1/2.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift


/// 以下扩展给业务层使用
///
protocol TableProtocol {
    var name: String {get} // 表名
    var select: Select? {get} // 表查找子
    var dataBase: Database {get} // 表对应的数据库
}

/// 数据库
protocol DataBaseProtocol {
    var path: String {get} // 数据库存放路径
    var tag: Int {get} // 数据库tag 对应唯一数据库
    var db: Database {get} // 真实数据库
}


/// 数据库
enum TDWDataBase: String, DataBaseProtocol {
    /// 沙盒document路径
    static let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                        FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    case main = "WCDBDemoDB.db"
    case gesture = "Gesture.db"
    case collection = "TDCollection.db"
    case area = "area.sqlite"

    /// 数据库文件路径
    var path: String {
        switch self {
        case .main, .gesture, .collection:
            return TDWDataBase.documentPath + "/" + self.rawValue
        case .area:
            return Bundle.main.bundlePath + "/" + self.rawValue
        }
    }

    /// 数据库标签
    var tag: Int {
        switch self {
        case .main:
            return 1
        case .gesture:
            return 2
        case .collection:
            return 3
        case .area:
            return 4
        }
    }

    /// 真实数据库
    var db: Database {
        let db = Database(withPath: self.path)
        db.tag = tag
        return db
    }
}

/// 表
enum TDWTable: String, TableProtocol {

    // main
    case user = "UserTable"

    // gesture
    case gesture = "Gesture"
    case userAccount = "UserAccount"
    case fingerUnlock = "FingerUnlock"

    // collection
    case appStartRecord = "AppStartRecord"
    case appPageVisitRecord = "AppPageVisitRecord"
    case appEventRecord = "AppEventRecord"

    // area
    case district = "district" // 区
    case city = "city" // 市
    case province = "province" // 省

    /// 表对应的数据库
    var dataBase: Database {
        switch self {
        case .user:
            return TDWDataBase.main.db
        case .gesture, .userAccount, .fingerUnlock:
            return TDWDataBase.gesture.db
        case .appStartRecord, .appEventRecord, .appPageVisitRecord:
            return TDWDataBase.collection.db
        case .district, .city, .province:
            return TDWDataBase.area.db
        }
    }

    /// 查询子，提前做好查询对象创建
    var select: Select? {
        var select: Select?
        switch self {
        case .user:
            select = try? dataBase.prepareSelect(of: User.self, fromTable: name, isDistinct: true)

        case .gesture:
            select = try? dataBase.prepareSelect(of: Gesture.self, fromTable: name, isDistinct: false)
        case .userAccount:
            select = try? dataBase.prepareSelect(of: UserAccount.self, fromTable: name, isDistinct: true)
        case .fingerUnlock:
            select = try? dataBase.prepareSelect(of: FingerUnlock.self, fromTable: name, isDistinct: true)

        case .appStartRecord:
            select = try? dataBase.prepareSelect(of: AppStartRecord.self, fromTable: name, isDistinct: true)
        case .appEventRecord:
            select = try? dataBase.prepareSelect(of: AppEventRecord.self, fromTable: name, isDistinct: true)
        case .appPageVisitRecord:
            select = try? dataBase.prepareSelect(of: AppPageVisitRecord.self, fromTable: name, isDistinct: true)

        case .city:
            select = try? dataBase.prepareSelect(of: City.self, fromTable: name, isDistinct: true)
        case .province:
            select = try? dataBase.prepareSelect(of: Province.self, fromTable: name, isDistinct: true)
        case .district:
            select = try? dataBase.prepareSelect(of: District.self, fromTable: name, isDistinct: true)
        }
        return select
    }

    /// 具体的表名
    var name: String {
        switch self {
        // main
        case .user:
            return "UserTable"

        // gesture
        case .gesture:
            return  "Gesture"
        case .userAccount:
            return  "UserAccount"
        case .fingerUnlock:
            return "FingerUnlock"

        // collection
        case .appStartRecord:
            return "AppStartRecord"
        case .appPageVisitRecord:
            return "AppPageVisitRecord"
        case .appEventRecord:
            return "AppEventRecord"

        // area
        case .district:
            return "district"
        case .city:
            return "city"
        case .province:
            return "province"
        }
    }
}

class TDWDBManager: NSObject {

    /// 数据库与表的初始化
    /// 文件创建，默认表数据设置
    class func createDB() {
        do {
            try TDWDataBase.gesture.db.run(transaction: {
                try TDWDataBase.gesture.db.create(table: TDWTable.gesture.name, of: Gesture.self)
                try TDWDataBase.gesture.db.create(table: TDWTable.userAccount.name, of: UserAccount.self)
                try TDWDataBase.gesture.db.create(table: TDWTable.fingerUnlock.name, of: FingerUnlock.self)
            })

            try TDWDataBase.area.db.run(transaction: {
                try TDWDataBase.area.db.create(table: TDWTable.district.name, of: District.self)
                try TDWDataBase.area.db.create(table: TDWTable.city.name, of: City.self)
                try TDWDataBase.area.db.create(table: TDWTable.province.name, of: Province.self)
            })

            try TDWDataBase.collection.db.run(transaction: {
                try TDWDataBase.collection.db.create(table: TDWTable.appEventRecord.name, of: AppEventRecord.self)
                try TDWDataBase.collection.db.create(table: TDWTable.appStartRecord.name, of: AppStartRecord.self)
                try TDWDataBase.collection.db.create(table: TDWTable.appPageVisitRecord.name, of: AppPageVisitRecord.self)
            })
        } catch {
            print("初始化数据库及ORM对应关系建立失败")
        }
    }
}

extension TDWDBManager {

    typealias ErrorType = (WCDBSwift.Error?)->Void

    class func insert<Object>(_ table: TableProtocol, objects: [Object]) -> WCDBSwift.Error? where Object: TableEncodable {
        do {
            try table.dataBase.insert(objects: objects, intoTable: table.name)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }

    class func update<Object>(_ table: TableProtocol, object: Object, propertys: [PropertyConvertible], condition: Condition? = nil, orderBy: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> WCDBSwift.Error? where Object: TableEncodable {
        do {
            try table.dataBase.update(table: table.name, on: propertys, with: object, where: condition, orderBy: orderBy, limit: limit, offset: offset)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }

    class func select<Object>(_ table: TableProtocol, condition: Condition? = nil, errorClosure: ErrorType?) -> [Object]? where Object: TableEncodable {
        do {
            if let condition = condition {
                table.select?.where(condition)
            }
            let objects: [Object]? = try table.select?.allObjects() as? [Object]
            return objects
        } catch {
            let errorValue = error as? WCDBSwift.Error
            errorClosure?(errorValue)
            return nil
        }
    }

    class func delete(_ table: TableProtocol, condition: Condition?, orderBy: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> WCDBSwift.Error? {
        do {
            try table.dataBase.delete(fromTable: table.name, where: condition, orderBy: orderBy, limit: limit, offset: offset)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }

    class func insertOrReplace<Object>(_ table: TableProtocol, objects: [Object]) -> WCDBSwift.Error? where Object : TableEncodable {
        do {
            try table.dataBase.insertOrReplace(objects: objects, intoTable: table.name)
            return nil
        } catch {
            let errorValue = error as? WCDBSwift.Error
            return errorValue
        }
    }
}
