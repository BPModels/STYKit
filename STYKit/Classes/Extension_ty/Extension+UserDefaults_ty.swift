//
//  Extension+UserDefaults_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

public extension UserDefaults {

    /// 下标语法,方便存储和获取 UserDefaults 值对象
    subscript(key: String) -> Data? {
        get {
            guard let data = value(forKey: key) as? Data else {
                return nil
            }
            return data
        }
        
        set {
            if let value = newValue {
                set(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
    
    func setter_ty(_ value: Data?, forKey key: String) {
        self[key] = value
        synchronize()
    }

    /// 归档的数据中,是否有Key对应的数据
    func hasKey_ty(_ key: String) -> Bool {
        return nil != object(forKey: key)
    }

    /// 归档数据
    func archive_ty(object: Any?, forkey key: String) {
        if let value = object {
            var data: Data?
            // 现将数据编码, 然后存档
            if #available(iOS 11, *) {
                do {
                    data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
                } catch {
                    print("archive fail!!\n key: \(key)\n value: \(value)")
                }
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: value)
            }
            setter_ty(data, forKey: key)
        }else{
            removeObject(forKey: key)
        }
    }

    /// 解档数据
    func unarchivedObject_ty(forkey key: String) -> Any? {
        var value: Any?
        guard let data = data(forKey: key) else {
            return nil
        }
        do {
            value = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        } catch {
            print("unarchived fail!!\n key: \(key)\n")
        }
        return value
    }
}
