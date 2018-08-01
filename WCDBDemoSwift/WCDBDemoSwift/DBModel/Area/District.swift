//
//  District.swift
//  WCDBDemoSwift
//
//  Created by John on 2017/12/28.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

class District: WCDBSwift.TableCodable {
    //Your own properties
    var DisName: String?
    var Id: Int? // Optional if it would be nil in some WCDB selection
    var CityID: Int? // Optional if it would be nil in some WCDB selection

    //It must can be initialized
    required init() {}

    enum CodingKeys: String, CodingTableKey {
        typealias Root = District

        //List the properties which should be bound to table
        case DisName
        case Id
        case CityID

        static let objectRelationalMapping = TableBinding(CodingKeys.self)

        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
//        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
//            return [
//                .ID: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
//            ]
//        }

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
