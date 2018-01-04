//
//  ViewController.swift
//  WCDBDemoSwift
//
//  Created by John on 2017/12/26.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        queryAllGes()

//        // 测试查找
//        let ges = TDWDBManager.default.getIsOpenGes("inS+GGPEajIh/r7dYavkHMLm0lLUsS9Q+iVJc2t1RdNgmGUTPNZzMw==") ? "打开" : "关闭"
//        print(ges)
//
//        // 测试更新
        TDWDBManager.default.setGesture(312, userID: "inS+GGPEajIh/r7dYavkHMLm0lLUsS9Q+iVJc2t1RdNgmGUTPNZzQQ==")

        // 测试删除
//        TDWDBManager.default.deleteGesture("inS+GGPEajIh/r7dYavkHMLm0lLUsS9Q+iVJc2t1RdNgmGUTPNZzQQ==")

        queryAllGes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 查询测试
    func queryAllGes() {
        let geses: [Gesture]? = TDWDBManager.select(TDWTableName.gesture) { (error) in
            if let error = error {
                print(error.description)
            }
        }

        if let gesValues = geses {
            for ges in gesValues {
                print("userID->\(ges.userID ?? "")  gesture->\(ges.gesture ?? "")")
            }
        }
    }

    func test0() {
        let gestures: [Gesture]? = TDWDBManager.select(TDWTableName.gesture) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        if let gestureValues = gestures {
            for (index, ges) in gestureValues.enumerated() {
                print("Gesture表中数据: 行数:\(index) userID:\(ges.userID ?? "") gesture:\(ges.gesture ?? "") isShowGesturePath:\(ges.isShowGesturePath)")
            }
        }
    }
    func test1() {
        let gestures: [UserAccount]? = TDWDBManager.select(TDWTableName.userAccount) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        if let gestureValues = gestures {
            for (index, ges) in gestureValues.enumerated() {
                print("UserAccount表中数据: 行数:\(index) userAccount:\(ges.userAccount ?? "") ")
            }
        }
    }
    func test2() {
        let gestures: [FingerUnlock]? = TDWDBManager.select(TDWTableName.fingerUnlock) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        if let gestureValues = gestures {
            for (index, ges) in gestureValues.enumerated() {
                print("FingerUnlock表中数据: 行数:\(index) userID:\(ges.userID ?? "") fingerEnable:\(ges.fingerUnlockIsEnable)")
            }
        }
    }

    func test3() {
        let citys: [City]? = TDWDBManager.select(TDWTableName.city) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        if let cityValues = citys {
            for (index, city) in cityValues.enumerated() {
                print("City表中数据: 行数:\(index) proID:\(city.ProID ?? "") cityName:\(city.CityName ?? "") cityID:\(city.CityID ?? "")")
            }
        }
    }
    func test4() {
        let provices: [Province]? = TDWDBManager.select(TDWTableName.province) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        if let proviceValues = provices {
            for (index, province) in proviceValues.enumerated() {
                print("Province表中数据: 行数:\(index) proID:\(province.ProID ?? "") cityName:\(province.ProName ?? "") proRemark:\(province.ProRemark ?? "")")
            }
        }
    }
    func test5() {
        let districts: [District]? = TDWDBManager.select(TDWTableName.district) { (error) in
            if let error = error {
                print(error.description)
            }
        }
        if let districtValues = districts {
            for (index, district) in districtValues.enumerated() {
                print("District表中数据: 行数:\(index) cityID:\(district.CityID ?? "") disName:\(district.DisName ?? "") id:\(district.Id ?? "")")
            }
        }
    }
    // 自建表测试
    func test() {
        let users = select()

        if users.count > 0 {
            for (index, user) in users.enumerated() {
                print("表中数据: 行数:\(index) 人名:\(user.name ?? "")")
            }

            update(users.first!)
            return
        }

        insert()
    }

    func insert() {
        // 插入操作
        let user = User()
        user.name = "a12"
        TDWDBManager.insert(TDWTableName.user, objects: [user], errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        }, successClosure: {
            print("插入成功")
        })
    }

    func select() -> [User] {
        // 查找操作
        let objects: [User]? = TDWDBManager.select(TDWTableName.user, errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        })

        return objects ?? []
    }

    func update(_ user: User) {
        // 更新操作
        TDWDBManager.update(TDWTableName.user, object: user, propertys: [User.Properties.name], errorClosure: { (error) in
            if let error = error {
                print(error.description)
            }
        }, successClosure: {
            print("更新成功")
        })
    }
}

