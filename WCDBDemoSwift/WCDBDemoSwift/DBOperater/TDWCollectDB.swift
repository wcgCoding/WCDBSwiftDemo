//
//  TDWCollectDB.swift
//  WCDBDemoSwift
//  对应OC的TDCollectDB类
//  Created by John on 2018/8/1.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation

class TDWCollectDB {

    // AppStartRecord
    static func deleteAllAppStartRecord() {
        let error = TDWDBManager.delete(TDWTable.appStartRecord, condition: nil)
        if let error = error {
            print(error.description)
        }
    }

    static func getAllAppStartRecord() -> [AppStartRecord]? {
        let records: [AppStartRecord]? = TDWDBManager.select(TDWTable.appStartRecord) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        return records
    }

    // AppEventRecord
    static func deleteAllEventCollectRecord() {
        let error = TDWDBManager.delete(TDWTable.appEventRecord, condition: nil)
        if let error = error {
            print(error.description)
        }
    }

    static func getAllEventCollectRecord() -> [AppEventRecord]? {
        let records: [AppEventRecord]? = TDWDBManager.select(TDWTable.appEventRecord) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        return records
    }

    // AppPageVisitRecord

    static func getAllAppPageVisitRecord() -> [AppPageVisitRecord]? {
        let records: [AppPageVisitRecord]? = TDWDBManager.select(TDWTable.appPageVisitRecord) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        return records
    }
}
