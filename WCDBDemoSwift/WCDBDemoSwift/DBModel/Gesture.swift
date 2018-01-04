//
//  Gesture.swift
//  WCDBDemoSwift
//
//  Created by John on 2017/12/27.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

class Gesture: WCDBSwift.TableCodable {
    //Your own properties
    var userID: String? // Optional if it would be nil in some WCDB selection
    var isEnable: Int? // Optional if it would be nil in some WCDB selection
    var isShowGesturePath: Int = 1
    var gesture: String?
    var userAccount: String?
    var fingerUnlockIsEnable: String?

    //It must can be initialized
    required init() {}

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Gesture

        //List the properties which should be bound to table
        case userID
        case isEnable
        case isShowGesturePath
        case gesture
        case userAccount
        case fingerUnlockIsEnable

        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .userID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
            ]
        }

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
