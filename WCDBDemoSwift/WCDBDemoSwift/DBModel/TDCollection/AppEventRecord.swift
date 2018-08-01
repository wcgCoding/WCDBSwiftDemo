//
//  AppEventRecord.swift
//  WCDBDemoSwift
//
//  Created by John on 2018/8/1.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

class AppEventRecord: WCDBSwift.TableCodable {
    //Your own properties
    var ClientSessionId: String? = nil
    var DeviceId: String? = nil // Optional if it would be nil in some WCDB selection
    var UserName: String? = nil // Optional if it would be nil in some WCDB selection
    var EventTime: Date? = nil
    var EventCatagory: String? = nil
    var EventLabel: String? = nil
    var EventValue: String? = nil
    var Status: Int? = nil
    var FAILURE_REASON_TYPE: String? = nil
    var FAILURE_REASON: String? = nil
    var PageId: String? = nil
    var SysNo: String? = nil

    enum CodingKeys: String, CodingTableKey {
        typealias Root = AppEventRecord

        //List the properties which should be bound to table
        case ClientSessionId
        case DeviceId
        case UserName
        case EventTime
        case EventCatagory
        case EventLabel
        case EventValue
        case Status
        case FAILURE_REASON_TYPE
        case FAILURE_REASON
        case PageId
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
