//
//  TYCache_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

public class TYCache_ty: NSObject {
    
    /// 保存数据到plist文件
    ///
    /// - Parameters:
    ///   - object: 需要保存的属性
    ///   - forKey: 常量值
    static public func set_ty(_ object: Any?, forKey: String) {
        UserDefaults.standard.archive_ty(object: object, forkey: forKey)
    }

    /// 获取之前保存的数据
    ///
    /// - Parameter forKey: 常量值
    /// - Returns: 之前保存的数据,不存在则为nil
    static public func object_ty(forKey: String) -> Any? {
        return UserDefaults.standard.unarchivedObject_ty(forkey: forKey)
    }

    /// 移除保存的数据
    ///
    /// - Parameter forKey: 常量值
    static public func remove_ty(forKey: String) {
        return set_ty(nil, forKey: forKey)
    }
}
