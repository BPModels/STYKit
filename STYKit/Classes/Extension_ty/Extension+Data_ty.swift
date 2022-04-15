//
//  Extension+Data.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension Data {
    var sizeKB_ty: CGFloat {
        get {
            return CGFloat(self.count) / 1024.0
        }
    }
    
    var sizeMB_ty: CGFloat {
        get {
            return CGFloat(self.sizeKB_ty) / 1024.0
        }
    }
    
    /// 转换成对应类型的数据
    func toJson<T>(type: T.Type) -> T? {
        do {
            let value = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers) as? T
            return value
        } catch let error {
            print("Dict to json error: \(error)")
            return nil
        }
    }
}
