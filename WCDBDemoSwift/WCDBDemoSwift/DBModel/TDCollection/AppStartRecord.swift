//
//  AppStartRecord.swift
//  WCDBDemoSwift
//
//  Created by John on 2018/8/1.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

class AppStartRecord: WCDBSwift.TableCodable {
    //Your own properties
    var ClientSessionId: String? = nil
    var StartTime: Date? = nil // Optional if it would be nil in some WCDB selection
    var DeviceId: String? = nil // Optional if it would be nil in some WCDB selection
    var UserName: String? = nil
    var Version: String? = nil
    var SourceId: String? = nil
    var Location: String? = nil
    var Ip: String? = nil
    var Os: String? = nil
    var OSVer: String? = nil
    var Resolution: String? = nil
    var DeviceLanguage: String? = nil
    var DeviceBrand: String? = nil
    var ModelNumber: String? = nil
    var NetworkType: String? = nil
    var NetworkProvider: String? = nil
    var SysNo: String? = nil

    enum CodingKeys: String, CodingTableKey {
        typealias Root = AppStartRecord

        //List the properties which should be bound to table
        case ClientSessionId
        case StartTime
        case DeviceId
        case UserName
        case Version
        case SourceId
        case Location
        case Ip
        case Os
        case OSVer
        case Resolution
        case DeviceLanguage
        case DeviceBrand
        case ModelNumber
        case NetworkType
        case NetworkProvider
        case SysNo

        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        //static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
        //    return [
        //        .variable: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
        //        .variable2: ColumnConstraintBinding(isUnique: true)
        //    ]
        //}

        //Index bindings. It is optional.
        //static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
        //    return [
        //        "_index": IndexBinding(indexesBy: CodingKeys.variable2)
        //    ]
        //}

        //Table constraints for multi-primary, multi-unique and so on. It is optional.
        //static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
        //    return [
        //        "MultiPrimaryConstraint": MultiPrimaryBinding(indexesBy: variable2.asIndex(orderBy: .descending), variable3.primaryKeyPart2)
        //    ]
        //}

        //Virtual table binding for FTS and so on. It is optional.
        //static var virtualTableBinding: VirtualTableBinding? {
        //    return VirtualTableBinding(with: .fts3, and: ModuleArgument(with: .WCDB))
        //}
    }

    //Properties below are needed only the primary key is auto-incremental
    //var isAutoIncrement: Bool = false
    //var lastInsertedRowID: Int64 = 0
}
