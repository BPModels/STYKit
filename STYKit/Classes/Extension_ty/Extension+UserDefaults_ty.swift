//
//  Extension+UserDefaults_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

public extension UserDefaults {

    /// 下标语法,方便存储和获取 UserDefaults 值对象
    subscript(key_ty: String) -> Data? {
        get {
            guard let data_ty = value(forKey: key_ty) as? Data else {
                return nil
            }
            return data_ty
        }
        
        set(newValue_ty) {
            if let value_ty = newValue_ty {
                set(value_ty, forKey: key_ty)
            } else {
                removeObject(forKey: key_ty)
            }
        }
    }
    
    func setter_ty(_ value_ty: Data?, forKey_ty key_ty: String) {
        self[key_ty] = value_ty
        synchronize()
    }

    /// 归档的数据中,是否有Key对应的数据
    func hasKey_ty(_ key_ty: String) -> Bool {
        return nil != object(forKey: key_ty)
    }

    /// 归档数据
    func archive_ty(object_ty: Any?, forkey_ty key_ty: String) {
        if let value_ty = object_ty {
            var data_ty: Data?
            // 现将数据编码, 然后存档
            if #available(iOS 11, *) {
                do {
                    data_ty = try NSKeyedArchiver.archivedData(withRootObject: value_ty, requiringSecureCoding: true)
                } catch {
                    print("archive fail!!\n key: \(key_ty)\n value: \(value_ty)")
                }
            } else {
                data_ty = NSKeyedArchiver.archivedData(withRootObject: value_ty)
            }
            setter_ty(data_ty, forKey_ty: key_ty)
        }else{
            removeObject(forKey: key_ty)
        }
    }

    /// 解档数据
    func unarchivedObject_ty(forkey_ty key_ty: String) -> Any? {
        var value_ty: Any?
        guard let data_ty = data(forKey: key_ty) else {
            return nil
        }
        do {
            value_ty = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data_ty)
        } catch {
            print("unarchived fail!!\n key: \(key_ty)\n")
        }
        return value_ty
    }
}
