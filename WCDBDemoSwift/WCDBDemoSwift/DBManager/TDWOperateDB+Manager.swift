//
//  TDWOperateDB+Manager.swift
//  WCDBDemoSwift
//  对应OC的TDDBOperate操作类
//  Created by John on 2018/1/2.
//  Copyright © 2018年 吴朝刚. All rights reserved.
//

import Foundation
import WCDBSwift

extension TDWDBManager {
    // gesture
    /// 是否展示手势轨迹
    func getIsShowGesturePathFrom(_ userID: String) -> Bool {

        let gestures: [Gesture]? = TDWDBManager.select(TDWTableName.gesture, conditioin: Gesture.Properties.userID == userID) { (error) in
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
    func setIsShowGesturePath(_ isEnable: Bool, userID: String) {
        let ges = Gesture()
        ges.isShowGesturePath = isEnable ? 1 : 0

        TDWDBManager.update(TDWTableName.gesture, object: ges, propertys: [Gesture.Properties.isShowGesturePath], conditioin: Gesture.Properties.userID == userID, errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        }, successClosure: {
            print("更新成功")
        })
    }

    /// 是否开启手势密码
    func getIsOpenGes(_ userID: String) -> Bool {
        let gestures: [Gesture]? = TDWDBManager.select(TDWTableName.gesture, conditioin: Gesture.Properties.userID == userID) { (error) in
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
    func setIsOpenGes(_ isOpen: Bool, userID: String) {
        let ges = Gesture()
        ges.isEnable = isOpen ? 1 : 0

        TDWDBManager.update(TDWTableName.gesture, object: ges, propertys: [Gesture.Properties.isEnable], conditioin: Gesture.Properties.userID == userID, errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        }, successClosure: {
            print("更新成功")
        })
    }

    /// 删除某个手势
    func deleteGesture(_ userID: String) {
        TDWDBManager.delete(TDWTableName.gesture, conditioin: Gesture.Properties.userID == userID) { (error) in
            if let error = error {
                print(error.description)
            }
        }
    }

    /// 设置手势密码
    func setGesture(_ gesture: NSNumber, userID: String) {
        /// 设置插入默认值
        let ges = Gesture()
        ges.gesture = gesture.stringValue // 更新字段
        ges.userID = userID
        ges.isShowGesturePath = 1

        TDWDBManager.insertOrReplace(TDWTableName.gesture, objects: [ges], errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        }, successClosure: {
            print("更新成功")
        })
    }

    // userAccount
    /// 添加账号
    func addUserAccount(_ userAccount: String) {
        let userAcc = UserAccount()
        userAcc.userAccount = userAccount
        TDWDBManager.insert(TDWTableName.userAccount, objects: [userAcc], errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        }, successClosure: {
            print("插入成功")
        })
    }

    /// 删除账号
    func deleteUserAccount(_ userAccount: String) {
        TDWDBManager.delete(TDWTableName.userAccount, conditioin: UserAccount.Properties.userAccount == userAccount) { (error) in
            if let error = error {
                print(error.description)
            }
        }
    }

    /// 获取所有账号
    func getAllAccount() -> [UserAccount]? {
        let userAccs: [UserAccount]? =  TDWDBManager.select(TDWTableName.userAccount) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        return userAccs
    }

    // 省市县(city、area)
    /// 获取所有的省
    func getAllProvince() -> [[String:String]] {
        let provinces: [Province]? = TDWDBManager.select(TDWTableName.province) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        var dictArr: [[String:String]] = []
        if let provinceValues = provinces {
            for pro in provinceValues {
                let dict = ["ProName": pro.ProName ?? "", "ProID": pro.ProID ?? ""]
                dictArr.append(dict)
            }
        }
        return dictArr
    }

    /// 获取对应省下所有市
    func getAllCity(_ proID: String) -> [[String:String]] {
        let citys: [City]? = TDWDBManager.select(TDWTableName.city
        , conditioin: City.Properties.ProID == proID) { (error) in
            if let error = error {
                print(error.description)
            }
        }

        var dictArr: [[String:String]] = []
        if let cityValues = citys {
            for city in cityValues {
                let dict = ["CityName": city.CityName ?? "", "CityID": city.CityID ?? ""]
                dictArr.append(dict)
            }
        }
        return dictArr
    }

    /// 获取对应市下所有县区
    func getAllDistrict(_ cityID: String) -> [[String:String]] {
        let districts: [District]? = TDWDBManager.select(TDWTableName.district, conditioin: District.Properties.CityID == cityID) { (error) in
            if let error = error {
                print(error.description)
            }
        }

        var dictArr: [[String:String]] = []
        if let districtValues = districts {
            for district in districtValues {
                let dict = ["DisName": district.DisName ?? "", "ID": district.Id ?? ""]
                dictArr.append(dict)
            }
        }
        return dictArr
    }
}
