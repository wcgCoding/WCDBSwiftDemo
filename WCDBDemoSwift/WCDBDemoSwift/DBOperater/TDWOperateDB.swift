//
//  TDWOperateDB+Manager.swift
//  WCDBDemoSwift
//  对应OC的TDDBOperate操作类
//  Created by John on 2018/1/2.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

class TDWOperateDB {
    // gesture
    /// 是否展示手势轨迹
    static func getIsShowGesturePathFrom(_ userID: String) -> Bool {

        let gestures: [Gesture]? = TDWDBManager.select(TDWTable.gesture, condition: Gesture.Properties.userID == userID) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        guard let isShowGesP = gestures?.first?.isShowGesturePath else {
            return false
        }
        return isShowGesP == 1
    }

    /// 设置是否展示手势轨迹
    static func setIsShowGesturePath(_ isEnable: Bool, userID: String) {

        let ges = Gesture()
        ges.isShowGesturePath = isEnable ? 1 : 0

        let error = TDWDBManager.update(TDWTable.gesture, object: ges, propertys: [Gesture.Properties.isShowGesturePath], condition: Gesture.Properties.userID == userID)
        if let error = error {
            print(error.description)
        }else {
            print("更新成功")
        }
    }

    /// 是否开启手势密码
    static func getIsOpenGes(_ userID: String) -> Bool {

        let gestures: [Gesture]? = TDWDBManager.select(TDWTable.gesture, condition: Gesture.Properties.userID == userID) { (error) in
            if let error = error {
                print(error.description)
            }
        }

        guard let isOpen = gestures?.first?.isEnable else {
            return false
        }
        return isOpen == 1
    }

    /// 设置是否开启手势密码
    static func setIsOpenGes(_ isOpen: Bool, userID: String) {
        let ges = Gesture()
        ges.isEnable = isOpen ? 1 : 0

        let error = TDWDBManager.update(TDWTable.gesture, object: ges, propertys: [Gesture.Properties.isEnable], condition: Gesture.Properties.userID == userID)
        if let error = error {
            print(error.description)
        }else {
            print("更新成功")
        }
    }

    /// 删除某个手势
    static func deleteGesture(_ userID: String) {
        let error = TDWDBManager.delete(TDWTable.gesture, condition: Gesture.Properties.userID == userID)
        if let error = error {
            print(error.description)
        }else {
            print("删除某个手势成功")
        }
    }

    /// 设置手势密码
    static func setGesture(_ gesture: NSNumber, userID: String) {
        /// 设置插入默认值
        let ges = Gesture()
        ges.gesture = gesture.stringValue // 更新字段
        ges.userID = userID
        ges.isShowGesturePath = 1

        let error = TDWDBManager.insertOrReplace(TDWTable.gesture, objects: [ges])
        if let error = error {
            print(error.description)
        }else {
            print("更新成功")
        }
    }

    // userAccount
    /// 添加账号
    static func addUserAccount(_ userAccount: String) {

        let userAcc = UserAccount()
        userAcc.userAccount = userAccount

        let error = TDWDBManager.insert(TDWTable.userAccount, objects: [userAcc])
        if let error = error {
            print(error.description)
        }else {
            print("插入成功")
        }
    }

    /// 删除账号
    static func deleteUserAccount(_ userAccount: String) {
        let error = TDWDBManager.delete(TDWTable.userAccount, condition: UserAccount.Properties.userAccount == userAccount)
        if let error = error {
            print(error.description)
        }else {
            print("删除账号成功")
        }
    }

    /// 获取所有账号
    static func getAllAccount() -> [UserAccount]? {
        let userAccs: [UserAccount]? =  TDWDBManager.select(TDWTable.userAccount) { (error) in
            if let error = error {
                print(error.description)
            }else {
                print("获取账号成功")
            }
        }
        return userAccs
    }

    // 省市县(city、area)
    /// 获取所有的省
    static func getAllProvince() -> [[String:String]] {
        let provinces: [Province]? = TDWDBManager.select(TDWTable.province) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        var dictArr: [[String:String]] = []
        if let provinceValues = provinces {
            for pro in provinceValues {
                let dict = ["ProName": pro.ProName ?? "", "ProID": String(pro.ProID ?? 0)]
                dictArr.append(dict)
            }
        }
        return dictArr
    }

    /// 获取对应省下所有市
    static func getAllCity(_ proID: String) -> [[String:String]] {
        let citys: [City]? = TDWDBManager.select(TDWTable.city, condition: City.Properties.ProID == proID) { (error) in
            if let error = error {
                print(error.description)
            }
        }

        var dictArr: [[String:String]] = []
        if let cityValues = citys {
            for city in cityValues {
                let dict = ["CityName": city.CityName ?? "", "CityID": String(city.CityID ?? 0)]
                dictArr.append(dict)
            }
        }
        return dictArr
    }

    /// 获取对应市下所有县区
    static func getAllDistrict(_ cityID: String) -> [[String:String]] {
        let districts: [District]? = TDWDBManager.select(TDWTable.district, condition: District.Properties.CityID == cityID) { (error) in
            if let error = error {
                print(error.description)
            }
        }

        var dictArr: [[String:String]] = []
        if let districtValues = districts {
            for district in districtValues {
                let dict = ["DisName": district.DisName ?? "", "ID": String(district.Id ?? 0)]
                dictArr.append(dict)
            }
        }
        return dictArr
    }
}
