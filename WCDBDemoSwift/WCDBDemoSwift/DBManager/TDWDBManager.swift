//
//  TDWDBManager.swift
//  WCDBDemoSwift
//
//  Created by John on 2018/1/2.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

/// 数据库
enum TDWDataBase: String, DataBaseProtocol {
    /// 沙盒document路径
    fileprivate static let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                                        FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    case main = "WCDBDemoDB.db"
    case gesture = "Gesture.db"
    case collection = "TDCollection.db"
    case invitation = "TDInvitationScore.db"
    case city = "city.sqlite"
    case area = "area.sqlite"

    /// 数据库文件路径
    var path: String {
        switch self {
        case .main, .gesture, .collection, .invitation:
            return TDWDataBase.documentPath + "/" + self.rawValue
        case .city, .area:
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
        case .invitation:
            return 4
        case .city:
            return 5
        case .area:
            return 6
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
enum TDWTableName: String, TableNameProtocol {

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

    // invitation
    case inviteScoreTable = "TDInvitationScoreTable"

    // city
    case city = "city"
    case province = "province"

    // area
    case district = "district"

    /// 表对应的数据库
    var dataBase: Database {
        switch self {
        case .user:
            return TDWDataBase.main.db
        case .gesture, .userAccount, .fingerUnlock:
            return TDWDataBase.gesture.db
        case .appStartRecord, .appEventRecord, .appPageVisitRecord:
            return TDWDataBase.collection.db
        case .inviteScoreTable:
            return TDWDataBase.invitation.db
//        case .city, .province:
//            return TDWDataBase.city.db
        case .district,.city, .province:
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
            select = try? dataBase.prepareSelect(of: User.self, fromTable: name, isDistinct: true)
        case .appEventRecord:
            select = try? dataBase.prepareSelect(of: User.self, fromTable: name, isDistinct: true)
        case .appPageVisitRecord:
            select = try? dataBase.prepareSelect(of: User.self, fromTable: name, isDistinct: true)

        case .inviteScoreTable:
            select = try? dataBase.prepareSelect(of: User.self, fromTable: name, isDistinct: true)

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
        return rawValue
    }
}

class TDWDBManager: NSObject {

    static let `default` = TDWDBManager()
    /// 数据库与表的初始化
    /// 文件创建，默认表数据设置
    override init() {
        super.init()
        do {
            // create if not exit
            try TDWDataBase.main.db.create(table: TDWTableName.user.name, of: User.self)

            try TDWDataBase.gesture.db.run(transaction: {
                try TDWDataBase.gesture.db.create(table: TDWTableName.gesture.name, of: Gesture.self)
                try TDWDataBase.gesture.db.create(table: TDWTableName.userAccount.name, of: UserAccount.self)
                try TDWDataBase.gesture.db.create(table: TDWTableName.fingerUnlock.name, of: FingerUnlock.self)
            })

            //            try TDWDataBase.city.db.run(transaction: {
            //                try TDWDataBase.city.db.create(table: TDWTableName.city.name, of: City.self)
            //                try TDWDataBase.city.db.create(table: TDWTableName.province.name, of: Province.self)
            //            })

            try TDWDataBase.area.db.run(transaction: {
                try TDWDataBase.area.db.create(table: TDWTableName.district.name, of: Province.self)
                try TDWDataBase.area.db.create(table: TDWTableName.city.name, of: City.self)
                try TDWDataBase.area.db.create(table: TDWTableName.province.name, of: Province.self)
            })

        } catch {
            print("初始化数据库及ORM对应关系建立失败")
        }
    }
}

extension TDWDBManager: DBManagerProtocol {

    typealias ErrorType = (WCDBSwift.Error?)->Void
    typealias SuccessType = ()->Void

    class func update<Object>(_ table: TableNameProtocol, object: Object, propertys: [PropertyConvertible], conditioin: Condition? = nil , errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil ) where Object: TableEncodable {
        WCDBManager.default.update(table.dataBase, table: table.name, object: object, propertys: propertys, conditioin: conditioin, errorClosure: errorClosure, successClosure: successClosure)
    }

    class func insert<Object>(_ table: TableNameProtocol, objects: [Object], errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil) where Object: TableEncodable {
        WCDBManager.default.insert(table.dataBase, table: table.name, objects: objects, errorClosure: errorClosure, successClosure: successClosure)
    }

    class func select<Object>(_ table: TableNameProtocol, conditioin: Condition? = nil, errorClosure: ErrorType?) -> [Object]? where Object: TableEncodable {
        return WCDBManager.default.select(table.select, conditioin: conditioin, errorClosure: errorClosure)
    }

    class func delete(_ table: TableNameProtocol, conditioin: Condition?, errorClosure: DBManagerProtocol.ErrorType?) {
        WCDBManager.default.delete(table.dataBase, table: table.name, condition: conditioin, errorClosure: errorClosure)
    }

    class func insertOrReplace<Object>(_ table: TableNameProtocol, objects: [Object], errorClosure: DBManagerProtocol.ErrorType?, successClosure: DBManagerProtocol.SuccessType?) where Object : TableEncodable {
        WCDBManager.default.insertOrReplace(table.dataBase, table: table.name, objects: objects, errorClosure: errorClosure, successClosure: successClosure)
    }
}
