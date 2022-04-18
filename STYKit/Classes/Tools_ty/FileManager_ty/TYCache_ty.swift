//
//  TYCache_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

/// 缓存
public class TYCache_ty: NSObject {
    
    /// 保存数据到plist文件
    ///
    /// - Parameters:
    ///   - object: 需要保存的属性
    ///   - forKey: 常量值
    static public func set_ty(_ object_ty: Any?, forKey_ty: String) {
        UserDefaults.standard.archive_ty(object_ty: object_ty, forkey_ty: forKey_ty)
    }

    /// 获取之前保存的数据
    ///
    /// - Parameter forKey: 常量值
    /// - Returns: 之前保存的数据,不存在则为nil
    static public func object_ty(forKey_ty: String) -> Any? {
        return UserDefaults.standard.unarchivedObject_ty(forkey_ty: forKey_ty)
    }

    /// 移除保存的数据
    ///
    /// - Parameter forKey: 常量值
    static public func remove_ty(forKey_ty: String) {
        return set_ty(nil, forKey_ty: forKey_ty)
    }
}
